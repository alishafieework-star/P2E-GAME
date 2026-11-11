import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/platform/json_http_transport.dart';
import 'package:mygame_p2e/app/platform/session_cookie_store.dart';
import 'package:mygame_p2e/shared/backend/json_transport.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = _LiveHttp();
  });
  test(
    'restored cookie is sent only to its host and rotates in the store',
    () async {
      const kept = 'session-a';
      const rotated = 'session-b';
      final store = MemorySessionCookieStore();
      await store.writeAll({
        '127.0.0.1': {'AuthToken': kept, 'AuthRemember': '1'},
        'other.test': {'AuthToken': 'other-host'},
      });
      final transport = IoJsonTransport(cookies: store);
      addTearDown(transport.close);
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(server.close);
      final seen = <String?>[];
      var hits = 0;
      server.listen((request) {
        hits++;
        seen.add(request.headers.value(HttpHeaders.cookieHeader));
        request.response.headers.add(
          'set-cookie',
          hits == 1
              ? 'AuthToken=$rotated; Path=/; HttpOnly'
              : 'AuthRemember=0; Path=/',
        );
        request.response.statusCode = 200;
        request.response.write('{"ok":true}');
        request.response.close();
      });

      final uri = Uri.parse(
        'http://127.0.0.1:${server.port}/api/users/general/auth/Me',
      );
      await transport.send(uri: uri, method: JsonMethod.get);
      expect(seen.single, 'AuthToken=$kept; AuthRemember=1');
      expect(seen.single, isNot(contains('other-host')));
      expect(store.jars['127.0.0.1']?['AuthToken'], rotated);
      expect(store.jars['other.test']?['AuthToken'], 'other-host');

      await transport.send(uri: uri, method: JsonMethod.get);
      expect(seen[1], contains('AuthToken=$rotated'));
      expect(seen[1], isNot(contains('other-host')));
    },
  );

  test('logout clears the jar and the store', () async {
    final store = MemorySessionCookieStore();
    await store.writeAll({
      '127.0.0.1': {'AuthToken': 'session-a', 'PlayerPreAuth': 'flow-a'},
    });
    final transport = IoJsonTransport(cookies: store);
    addTearDown(transport.close);
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    final seen = <String?>[];
    server.listen((request) {
      seen.add(request.headers.value(HttpHeaders.cookieHeader));
      request.response.statusCode = 200;
      request.response.close();
    });
    final uri = Uri.parse('http://127.0.0.1:${server.port}/logout');
    await transport.send(uri: uri, method: JsonMethod.post);
    expect(seen.single, contains('AuthToken=session-a'));
    await transport.clearSession();
    expect(store.jars, isEmpty);
    await transport.send(uri: uri, method: JsonMethod.post);
    expect(seen[1], isNull);
  });

  test(
    '401 on a session cookie expires the session and clears the store',
    () async {
      final store = MemorySessionCookieStore();
      await store.writeAll({
        '127.0.0.1': {'AuthToken': 'session-a', 'PlayerPreAuth': 'flow-a'},
      });
      var expired = 0;
      final transport = IoJsonTransport(
        cookies: store,
        onUnauthorized: () => expired++,
      );
      addTearDown(transport.close);
      final server = await _statusServer(401);
      addTearDown(server.close);
      await transport.send(
        uri: Uri.parse('http://127.0.0.1:${server.port}/me'),
        method: JsonMethod.get,
      );
      expect(expired, 1);
      expect(store.jars, isEmpty);
      expect(await store.readAll(), isEmpty);
    },
  );

  test('401 without AuthToken keeps the registration cookie', () async {
    final store = MemorySessionCookieStore();
    await store.writeAll({
      '127.0.0.1': {'PlayerPreAuth': 'flow-a'},
    });
    var expired = 0;
    final transport = IoJsonTransport(
      cookies: store,
      onUnauthorized: () => expired++,
    );
    addTearDown(transport.close);
    final server = await _statusServer(401);
    addTearDown(server.close);
    await transport.send(
      uri: Uri.parse('http://127.0.0.1:${server.port}/current'),
      method: JsonMethod.get,
    );
    expect(expired, 0);
    expect(store.jars['127.0.0.1']?['PlayerPreAuth'], 'flow-a');
  });
}

class _LiveHttp extends HttpOverrides {}

Future<HttpServer> _statusServer(int status) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen((request) {
    request.response.statusCode = status;
    request.response.close();
  });
  return server;
}
