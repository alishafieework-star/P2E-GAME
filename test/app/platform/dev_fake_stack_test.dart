import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/platform/dev_fake_stack.dart';

final class _RealHttp extends HttpOverrides {}

ByteData _bytes(List<int> data) =>
    ByteData.sublistView(Uint8List.fromList(data));

final Map<String, List<int>> _fixtures = {
  'docs/snapshots/2026-10-24_home/assets/hero_background.jpg': [1, 2, 3, 4],
  'docs/snapshots/2026-10-24_home/assets/featured_icon.png': [5, 6, 7],
  'docs/snapshots/2026-10-25_game-details/assets/media_1.jpg': [8, 9],
  'tool/fake_backend/fixtures/games/chess.json': utf8.encode(
    '{"name":"Chess","hero":"{{media}}/games/media_1.jpg"}',
  ),
};

Future<(int status, String body, String? etag, String? contentType)> _send(
  HttpClient client,
  Uri uri, {
  String method = 'GET',
  String? body,
  Map<String, String> headers = const {},
}) async {
  final request = await client.openUrl(method, uri);
  headers.forEach(request.headers.set);
  if (body != null) request.write(body);
  final response = await request.close();
  final text = await utf8.decoder.bind(response).join();
  return (
    response.statusCode,
    text,
    response.headers.value(HttpHeaders.etagHeader),
    response.headers.value(HttpHeaders.contentTypeHeader),
  );
}

void main() {
  late HttpServer api;
  late HttpServer media;
  late HttpClient client;

  setUp(() async {
    Future<ByteData?> loadAsset(String key) async =>
        _fixtures.containsKey(key) ? _bytes(_fixtures[key]!) : null;
    api = await bindDevApiServer(
      loadAsset: loadAsset,
      mediaBase: 'http://127.0.0.1:8788/',
      port: 0,
    );
    media = await bindDevMediaServer(loadAsset: loadAsset, port: 0);
    client = HttpOverrides.runWithHttpOverrides(HttpClient.new, _RealHttp());
  });

  tearDown(() async {
    client.close(force: true);
    await api.close(force: true);
    await media.close(force: true);
  });

  test('media serves the bundled home and game-details artwork', () async {
    final home = await _send(
      client,
      Uri.parse('http://127.0.0.1:${media.port}/home/hero_background.jpg'),
    );
    expect(home.$1, 200);
    expect(
      home.$2,
      String.fromCharCodes(
        _fixtures['docs/snapshots/2026-10-24_home/assets/hero_background.jpg']!,
      ),
    );
    expect(home.$4, startsWith('image/jpeg'));

    final icon = await _send(
      client,
      Uri.parse('http://127.0.0.1:${media.port}/home/featured_icon.png'),
    );
    expect(icon.$1, 200);
    expect(icon.$4, startsWith('image/png'));

    final details = await _send(
      client,
      Uri.parse('http://127.0.0.1:${media.port}/games/media_1.jpg'),
    );
    expect(details.$1, 200);
  });

  test('media rejects unknown names and wrong depths', () async {
    final deep = await _send(
      client,
      Uri.parse('http://127.0.0.1:${media.port}/home/deep/hero_background.jpg'),
    );
    expect(deep.$1, 404);
    final unknown = await _send(
      client,
      Uri.parse('http://127.0.0.1:${media.port}/home/nope.jpg'),
    );
    expect(unknown.$1, 404);
  });

  test('api serves the OTP fake endpoints', () async {
    final rejected = await _send(
      client,
      Uri.parse('http://127.0.0.1:${api.port}/auth/otp/verify'),
      method: 'POST',
      body: '{"challengeId":"dev-challenge-1","code":"P00000"}',
    );
    expect(rejected.$1, 422);
    expect(rejected.$2, '{"error":"invalid_code"}');
    final accepted = await _send(
      client,
      Uri.parse('http://127.0.0.1:${api.port}/auth/otp/verify'),
      method: 'POST',
      body: '{"challengeId":"dev-challenge-1","code":"P12345"}',
    );
    expect(accepted.$1, 200);
    expect(accepted.$2, '{"verified":true}');
  });

  test('api serves the game catalog with etag revalidation', () async {
    final base = Uri.parse('http://127.0.0.1:${api.port}');
    final first = await _send(client, base.resolve('v1/games/chess'));
    expect(first.$1, 200);
    expect(first.$2, contains('http://127.0.0.1:8788/games/media_1.jpg'));
    expect(first.$4, startsWith('application/json'));
    expect(first.$3, isNotNull);

    final revalidated = await _send(
      client,
      base.resolve('v1/games/chess'),
      headers: {'if-none-match': first.$3!},
    );
    expect(revalidated.$1, 304);
    expect(revalidated.$2, isEmpty);

    final missing = await _send(client, base.resolve('v1/games/missing'));
    expect(missing.$1, 404);
    expect(missing.$2, '{"error":{"code":"game_not_found"}}');

    final post = await _send(
      client,
      base.resolve('v1/games/chess'),
      method: 'POST',
    );
    expect(post.$1, 405);
  });
}
