import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mygame_p2e/features/auth/auth_data.dart';

import 'game_catalog.dart';

/// Development OTP process plus game-details fixtures. Not packaged.
Future<void> main() async {
  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    DevOtpApi.port,
  );
  final fixtures = Directory('tool/fake_backend/fixtures/games');
  final mediaPort =
      int.tryParse(Platform.environment['FAKE_MEDIA_PORT'] ?? '') ?? 8788;
  stdout.writeln('dev-api listening on ${server.port}');
  await for (final request in server) {
    if (request.uri.path.startsWith('/v1/games')) {
      final response = handleGameCatalog(
        CatalogRequest(
          method: request.method,
          path: request.uri.path,
          headers: {
            for (final name in ['if-none-match', 'accept-language'])
              if (request.headers.value(name) != null)
                name: request.headers.value(name)!,
          },
          mediaBase: mediaBaseForHost(
            request.headers.value(HttpHeaders.hostHeader),
            port: mediaPort,
          ),
        ),
        fixtures: fixtures,
      );
      stdout.writeln(
        'dev-api ${request.method} ${request.uri.path} ${response.status}',
      );
      request.response.statusCode = response.status;
      response.headers.forEach(request.response.headers.set);
      if (response.body.isNotEmpty) request.response.write(response.body);
      await request.response.close();
      continue;
    }
    final body = await utf8.decoder.bind(request).join();
    final response = DevOtpApi.handle(
      OtpApiRequest(method: request.method, path: request.uri.path, body: body),
    );
    stdout.writeln(
      'dev-otp ${request.method} ${request.uri.path} ${response.status}',
    );
    request.response.statusCode = response.status;
    request.response.headers.contentType = ContentType.json;
    request.response.write(response.body);
    await request.response.close();
  }
}
