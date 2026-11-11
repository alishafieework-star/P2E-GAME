import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/platform/one_time_code_adapter.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/features/auth/auth_data.dart';
import 'package:mygame_p2e/shared/platform/one_time_code.dart';

import '../../../tool/sms/app_hash.dart';

void main() {
  const format = DevOtpSmsFormat();

  test('SMS Retriever hash is 11 characters from the certificate', () {
    final hash = smsAppHash('ir.mci.mygame.p2e', [1, 2, 3, 4]);
    expect(hash.length, 11);
  });

  test('development SMS parser accepts one code and rejects ambiguity', () {
    expect(format.read('MyGame code: P12345 abcdefghijk'), 'P12345');
    expect(format.read('MyGame code: 123456 abcdefghijk'), '123456');
    expect(format.read('Your code is 123456'), isNull);
    expect(
      format.read('MyGame code: P12345 aa\nMyGame code: P00000 bb'),
      isNull,
    );
    expect(format.read('MyGame code: P1234 abcdefghijk'), isNull);
  });

  test('platform event mapping does not keep a timeout as a message', () {
    expect(mapOtpSmsEvent('timeout'), isA<OneTimeCodeTimeout>());
    expect(mapOtpSmsEvent('consent_denied'), isA<OneTimeCodeConsentDenied>());
    expect(mapOtpSmsEvent('unavailable'), isA<OneTimeCodeUnavailable>());
    expect(mapOtpSmsEvent(''), isA<OneTimeCodeUnavailable>());
    expect(
      (mapOtpSmsEvent('MyGame code: P12345 hash') as OneTimeCodeMessage).body,
      'MyGame code: P12345 hash',
    );
  });

  test('listener fills before request and stops on dispose', () async {
    final port = _ScriptedCode();
    final container = ProviderContainer(
      overrides: [
        oneTimeCodePortProvider.overrideWithValue(port),
        otpSmsFormatProvider.overrideWithValue(const DevOtpSmsFormat()),
      ],
    );
    addTearDown(container.dispose);
    container.read(otpCodeListenerProvider.notifier).arm();
    expect(port.listens, 1);
    port.add('MyGame code: P12345 abcdefghijk');
    await Future<void>.delayed(Duration.zero);
    expect(container.read(otpCodeListenerProvider), 'P12345');
    container.read(otpCodeListenerProvider.notifier).arm();
    expect(port.listens, 2);
    expect(port.cancelled, 1);
    container.read(otpCodeListenerProvider.notifier).stop();
    expect(port.cancelled, 2);
  });
}

final class _ScriptedCode implements OneTimeCodePort {
  final controllers = <StreamController<OneTimeCodeEvent>>[];
  int listens = 0, cancelled = 0;

  void add(String body) => controllers.last.add(OneTimeCodeMessage(body));

  @override
  Stream<OneTimeCodeEvent> listen({String? sender}) {
    listens++;
    final next = StreamController<OneTimeCodeEvent>(
      onCancel: () => cancelled++,
    );
    controllers.add(next);
    return next.stream;
  }
}
