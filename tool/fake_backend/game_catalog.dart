import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// One catalog request. Headers are matched without case.
final class CatalogRequest {
  const CatalogRequest({
    required this.method,
    required this.path,
    required this.headers,
    required this.mediaBase,
  });

  final String method, path, mediaBase;
  final Map<String, String> headers;

  String? header(String name) {
    final wanted = name.toLowerCase();
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == wanted) return entry.value;
    }
    return null;
  }
}

final class CatalogResponse {
  const CatalogResponse(this.status, this.body, [this.headers = const {}]);
  final int status;
  final String body;
  final Map<String, String> headers;
}

final _gameId = RegExp(r'^[a-z0-9_]+$');

/// GET `/v1/games/{id}` from fixture files (D-122).
CatalogResponse handleGameCatalog(
  CatalogRequest request, {
  required Directory fixtures,
}) {
  const json = {'content-type': 'application/json; charset=utf-8'};
  if (request.method != 'GET') {
    return CatalogResponse(
      HttpStatus.methodNotAllowed,
      '{"error":{"code":"method"}}',
      json,
    );
  }
  final segments = Uri.parse(request.path).pathSegments;
  if (segments.length != 3 ||
      segments[0] != 'v1' ||
      segments[1] != 'games' ||
      !_gameId.hasMatch(segments[2])) {
    return CatalogResponse(
      HttpStatus.notFound,
      '{"error":{"code":"game_not_found"}}',
      json,
    );
  }
  final file = File('${fixtures.path}/${segments[2]}.json');
  if (!file.existsSync()) {
    return CatalogResponse(
      HttpStatus.notFound,
      '{"error":{"code":"game_not_found"}}',
      json,
    );
  }
  final raw = file.readAsStringSync();
  final etag = '"${sha256.convert(utf8.encode(raw))}"';
  final headers = {
    ...json,
    'etag': etag,
    'content-language': 'en',
    'cache-control': 'no-cache',
  };
  if (request.header('if-none-match') == etag) {
    return CatalogResponse(HttpStatus.notModified, '', headers);
  }
  final media = request.mediaBase.replaceAll(RegExp(r'/+$'), '');
  return CatalogResponse(
    HttpStatus.ok,
    raw.replaceAll('{{media}}', media),
    headers,
  );
}

/// FAKE_MEDIA_BASE (when set) wins so tunnels can serve media; otherwise the
/// URL is derived from the request host (loopback dev usage).
String mediaBaseForHost(String? host, {int port = 8788}) {
  final override = Platform.environment['FAKE_MEDIA_BASE'];
  if (override != null && override.isNotEmpty) return override;
  final name = (host == null || host.isEmpty ? '127.0.0.1' : host)
      .split(':')
      .first;
  return 'http://$name:$port';
}
