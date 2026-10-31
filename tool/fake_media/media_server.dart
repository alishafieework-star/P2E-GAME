import 'dart:io';

/// Development media origin for the fake Home feed (D-102). It serves the
/// read-only snapshot artwork on loopback and is never packaged into the app.
/// Android emulator: run the app with FAKE_MEDIA_BASE=http://10.0.2.2:8788.
Future<void> main() async {
  final port =
      int.tryParse(Platform.environment['FAKE_MEDIA_PORT'] ?? '') ?? 8788;
  final roots = {
    'home': Directory('docs/snapshots/2026-10-24_home/assets'),
    'games': Directory('docs/snapshots/2026-10-25_game-details/assets'),
  };
  if (!roots['home']!.existsSync()) {
    stderr.writeln('Run from the repository root: home artwork is missing.');
    exitCode = 1;
    return;
  }
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stdout.writeln('fake-media listening on ${server.port}');
  final name = RegExp(r'^[a-z0-9_]+\.(png|jpg)$');
  await for (final request in server) {
    final segments = request.uri.pathSegments;
    final root = segments.length == 2 ? roots[segments.first] : null;
    final match = root == null ? null : name.firstMatch(segments.last);
    final file = root == null || match == null
        ? null
        : File('${root.path}/${segments.last}');
    final response = request.response;
    if ((request.method != 'GET' && request.method != 'HEAD') ||
        file == null ||
        !file.existsSync()) {
      response.statusCode = HttpStatus.notFound;
      await response.close();
      continue;
    }
    response.headers
      ..contentType = match![1] == 'png'
          ? ContentType('image', 'png')
          : ContentType('image', 'jpeg')
      ..contentLength = file.lengthSync()
      ..set(HttpHeaders.cacheControlHeader, 'no-store');
    if (request.method == 'GET') await response.addStream(file.openRead());
    await response.close();
  }
}
