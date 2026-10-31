import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../features/auth/auth_data.dart';

/// D-068: loopback development server. Logs the path and status only.
Future<HttpServer> bindDevOtpServer({int port = DevOtpApi.port}) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  server.listen((request) async {
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
  });
  return server;
}
