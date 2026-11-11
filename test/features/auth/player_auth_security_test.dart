import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/config/app_config.dart';
import 'package:mygame_p2e/app/platform/json_http_transport.dart';
import 'package:mygame_p2e/core/diagnostics/app_logger.dart';

void main() {
  test('password fields are redacted when a login body is logged', () {
    const secret = 'secret-pass';
    final login = {
      'method': 1,
      'identifier': 'ada@example.com',
      'password': secret,
      'remember': true,
    };
    final complete = {'challengeId': 'ch-1', 'password': secret};
    for (final body in [login, complete]) {
      final redacted = PiiRedactor.value(body);
      expect(redacted, isA<Map>());
      expect((redacted as Map)['password'], '[REDACTED]');
      final text = PiiRedactor.text(jsonEncode(body));
      expect(text, isNot(contains(secret)));
      expect(text, contains('[REDACTED]'));
    }
  });

  test('transport failure logs keep the type and drop secrets', () {
    final lines = <String>[];
    final logger = AppLogger(minimumLevel: LogLevel.warning, sink: lines.add);
    logTransportFailure(
      logger,
      FormatException('password=secret-pass Cookie: AuthToken=session-a'),
    );
    expect(lines, hasLength(1));
    expect(lines.single, isNot(contains('secret-pass')));
    expect(lines.single, isNot(contains('AuthToken')));
    expect(lines.single, isNot(contains('Cookie')));
    expect(lines.single, contains('FormatException'));
  });

  test('production fake mode is rejected and a trailing base is invalid', () {
    expect(
      () => AppConfig.fromValues({'APP_ENV': 'prod', 'BACKEND_MODE': 'fake'}),
      throwsFormatException,
    );
    expect(
      () => AppConfig.fromValues({
        'REMOTE_API_BASE': 'https://player.example/api/users/',
      }),
      throwsFormatException,
    );
  });

  test('auth presentation does not store cookies or passwords', () {
    final root = Directory('lib/features/auth/src/presentation');
    final files = root
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    expect(files, isNotEmpty);
    for (final file in files) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('FlutterSecureStorage')));
      expect(source, isNot(contains('AuthToken')));
      expect(source, isNot(contains('PlayerPreAuth')));
    }
  });
}
