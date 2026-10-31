import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../../features/auth/auth_data.dart';

/// D-150: the development fake stack bound inside the app process, so a
/// standalone build works without host processes or `adb reverse`. Only the
/// compile-time fake gate in bootstrap reaches these binders; remote builds
/// tree-shake them. The injected asset loader keeps this file free of Flutter
/// imports so tests can serve fixtures without a binding.

typedef DevAssetLoader = Future<ByteData?> Function(String key);

const _mediaRoots = {
  'home': 'docs/snapshots/2026-10-24_home/assets/',
  'games': 'docs/snapshots/2026-10-25_game-details/assets/',
};

final _assetName = RegExp(r'^[a-z0-9_]+\.(png|jpg)$');
final _gameId = RegExp(r'^[a-z0-9_]+$');

/// OTP/account fake plus the `/v1/games/{id}` catalog, mirroring
/// tool/fake_backend/server.dart and game_catalog.dart behavior.
Future<HttpServer> bindDevApiServer({
  required DevAssetLoader loadAsset,
  required String mediaBase,
  int port = DevOtpApi.port,
}) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  server.listen((request) async {
    final segments = request.uri.pathSegments;
    if (segments.length == 3 &&
        segments[0] == 'v1' &&
        segments[1] == 'games' &&
        _gameId.hasMatch(segments[2])) {
      await _serveGame(request, loadAsset, segments[2], mediaBase);
      return;
    }
    final body = await utf8.decoder.bind(request).join();
    final response = DevOtpApi.handle(
      OtpApiRequest(method: request.method, path: request.uri.path, body: body),
    );
    request.response.statusCode = response.status;
    request.response.headers.contentType = ContentType.json;
    request.response.write(response.body);
    await request.response.close();
  });
  return server;
}

Future<void> _serveGame(
  HttpRequest request,
  DevAssetLoader loadAsset,
  String id,
  String mediaBase,
) async {
  final response = request.response;
  final headers = {
    'content-type': 'application/json; charset=utf-8',
    'content-language': 'en',
    'cache-control': 'no-cache',
  };
  void finish(int status, [String body = '']) {
    response.statusCode = status;
    headers.forEach(response.headers.set);
    if (body.isNotEmpty) response.write(body);
  }

  if (request.method != 'GET') {
    finish(HttpStatus.methodNotAllowed, '{"error":{"code":"method"}}');
    await response.close();
    return;
  }
  final data = await loadAsset('tool/fake_backend/fixtures/games/$id.json');
  if (data == null) {
    finish(HttpStatus.notFound, '{"error":{"code":"game_not_found"}}');
    await response.close();
    return;
  }
  final raw = utf8.decode(data.buffer.asUint8List(data.offsetInBytes));
  final etag = '"${_fnv1a64(utf8.encode(raw)).toRadixString(16)}"';
  headers['etag'] = etag;
  if (request.headers.value(HttpHeaders.ifNoneMatchHeader) == etag) {
    finish(HttpStatus.notModified);
    await response.close();
    return;
  }
  final media = mediaBase.replaceAll(RegExp(r'/+$'), '');
  finish(HttpStatus.ok, raw.replaceAll('{{media}}', media));
  await response.close();
}

/// Development media origin for the sample Home and Game Details artwork,
/// mirroring tool/fake_media/media_server.dart on the same URL contract.
Future<HttpServer> bindDevMediaServer({
  required DevAssetLoader loadAsset,
  int port = 8788,
}) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  server.listen((request) async {
    final segments = request.uri.pathSegments;
    final root = segments.length == 2 ? _mediaRoots[segments.first] : null;
    final match = root == null ? null : _assetName.firstMatch(segments.last);
    final data = (root == null || match == null)
        ? null
        : await loadAsset('$root${segments.last}');
    final response = request.response;
    if ((request.method != 'GET' && request.method != 'HEAD') || data == null) {
      response.statusCode = HttpStatus.notFound;
      await response.close();
      return;
    }
    response.headers
      ..contentType = segments.last.endsWith('.png')
          ? ContentType('image', 'png')
          : ContentType('image', 'jpeg')
      ..contentLength = data.lengthInBytes
      ..set(HttpHeaders.cacheControlHeader, 'no-store');
    if (request.method == 'GET') {
      response.add(data.buffer.asUint8List(data.offsetInBytes));
    }
    await response.close();
  });
  return server;
}

int _fnv1a64(List<int> bytes) {
  var hash = 0xcbf29ce484222325;
  for (final byte in bytes) {
    hash ^= byte;
    hash = (hash * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
  }
  return hash;
}
