import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/router/app_router.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/shared/platform/one_time_code.dart';
import 'package:mygame_p2e/features/auth/auth_data.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../support/auth_harness.dart';

void main() {
  testWidgets('empty OTP shows the countdown and a disabled verify button', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await _showOtp(tester, destination: '09123456789');
    expect(find.text('Check Your Inbox'), findsOneWidget);
    expect(find.textContaining('09123456789'), findsOneWidget);
    expect(find.text('01:34'), findsOneWidget);
    expect(
      tester
          .widget<AppButton>(find.byKey(const ValueKey('auth.otp.verify')))
          .onPressed,
      isNull,
    );
    expect(find.text('Resend code'), findsNothing);
  });

  testWidgets('six characters enable verify; P12345 signs in', (tester) async {
    addTearDown(tester.view.reset);
    await _showOtp(tester, destination: '09123456789', contract: true);
    await tester.enterText(
      find.byKey(const ValueKey('auth.otp.code.editor')),
      'P00000',
    );
    await tester.pump();
    expect(
      tester
          .widget<AppButton>(find.byKey(const ValueKey('auth.otp.verify')))
          .onPressed,
      isNotNull,
    );
    await tester.tap(find.byKey(const ValueKey('auth.otp.verify')));
    await tester.pump();
    expect(
      find.text('That code is not correct. Please try again.'),
      findsOneWidget,
    );
    expect(find.text('P'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('auth.otp.code.editor')),
      'P12345',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('auth.otp.verify')));
    await tester.pump();
    expect(find.text('Check Your Inbox'), findsOneWidget);
    expect(find.byKey(const ValueKey('home.page')), findsNothing);
    expect(find.text('P'), findsNothing);
    await tester.pump(const Duration(milliseconds: 899));
    expect(find.text('Check Your Inbox'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1));
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byKey(const ValueKey('home.page')), findsOneWidget);
  });

  testWidgets('an SMS code fills the field and continues', (tester) async {
    addTearDown(tester.view.reset);
    final sms = _ScriptedSms();
    await _showOtp(
      tester,
      destination: '09123456789',
      contract: true,
      sms: sms,
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(AuthOtpScreen)),
    );
    container.read(otpCodeListenerProvider.notifier).arm();
    sms.add('MyGame code: P12345 sGxh8WblRwI');
    await tester.pump();
    expect(find.text('P'), findsNothing);
    expect(find.byKey(const ValueKey('home.page')), findsNothing);
    await tester.pump(const Duration(milliseconds: 900));
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byKey(const ValueKey('home.page')), findsOneWidget);
  });

  testWidgets('a player code uses one letter and five digits', (tester) async {
    addTearDown(tester.view.reset);
    await _showOtp(
      tester,
      destination: '09123456789',
      prefix: 'P-',
      codeLength: 5,
    );
    expect(find.text('P-'), findsNothing);
    expect(find.text('P'), findsNothing);
    expect(find.text('p'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('auth.otp.code.editor')),
      'p5006',
    );
    await tester.pump();
    expect(find.text('p'), findsNothing);
    expect(find.text('P'), findsWidgets);
    expect(
      tester
          .widget<AppButton>(find.byKey(const ValueKey('auth.otp.verify')))
          .onPressed,
      isNull,
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth.otp.code.editor')),
      'P-50069',
    );
    await tester.pump();
    expect(find.text('5'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(
      tester
          .widget<AppButton>(find.byKey(const ValueKey('auth.otp.verify')))
          .onPressed,
      isNotNull,
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth.otp.code.editor')),
      '۵۰۰۶۹',
    );
    await tester.pump();
    expect(find.text('۵'), findsNothing);
    expect(find.text('5'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('auth.otp.code.editor')),
      'Q50069',
    );
    await tester.pump();
    expect(find.text('That letter does not match this code.'), findsOneWidget);
    expect(
      tester
          .widget<AppButton>(find.byKey(const ValueKey('auth.otp.verify')))
          .onPressed,
      isNull,
    );
  });

  testWidgets('a player SMS fills the field and leaves Verify to the player', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    final sms = _ScriptedSms();
    await _showOtp(
      tester,
      destination: '09123456789',
      prefix: 'P-',
      codeLength: 5,
      sms: sms,
      format: const PlayerSmsCodeFormat(),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(AuthOtpScreen)),
    );
    container.read(otpCodeListenerProvider.notifier).arm();
    sms.add('کد شما\nP-50069\nلغو ۱۱');
    await tester.pump();
    expect(find.text('Check Your Inbox'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.byKey(const ValueKey('home.page')), findsNothing);
    expect(
      tester
          .widget<AppButton>(find.byKey(const ValueKey('auth.otp.verify')))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('the countdown reaches resend and asks for a new code', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await _showOtp(tester, destination: '09123456789', contract: true);
    await tester.pump(const Duration(seconds: 94));
    expect(find.text('Resend code'), findsOneWidget);
    await tester.tap(find.text('Resend code'));
    await tester.pump();
    expect(find.text('01:34'), findsOneWidget);
  });
}

/// Same pure contract the development server executes. Widget tests cannot
/// complete a real socket under the fake-async binding; the loopback server
/// test covers that path.
final class _ContractTransport implements DevOtpTransport {
  @override
  Future<OtpApiResponse> post(
    Uri uri,
    String jsonBody,
    AuthCancellation? cancellation,
  ) async => DevOtpApi.handle(
    OtpApiRequest(method: 'POST', path: uri.path, body: jsonBody),
  );
}

class _OtpRepositories extends ImmediateRepositories {
  @override
  Future<Result<OtpChallenge>> resendOtp(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) =>
      PhoneSignInRepositoryImpl(
        HttpPhoneSignInSource(
          transport: _ContractTransport(),
          base: Uri.parse('http://127.0.0.1'),
        ),
      ).resendOtp(
        phone,
        rememberDevice: rememberDevice,
        cancellation: cancellation,
      );

  @override
  Future<Result<void>> verifyOtp(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) => PhoneSignInRepositoryImpl(
    HttpPhoneSignInSource(
      transport: _ContractTransport(),
      base: Uri.parse('http://127.0.0.1'),
    ),
  ).verifyOtp(challenge, code, cancellation: cancellation);
}

final class _ScriptedSms implements OneTimeCodePort {
  final controllers = <StreamController<OneTimeCodeEvent>>[];

  void add(String body) => controllers.last.add(OneTimeCodeMessage(body));

  @override
  Stream<OneTimeCodeEvent> listen({String? sender}) {
    final next = StreamController<OneTimeCodeEvent>();
    controllers.add(next);
    return next.stream;
  }
}

Future<void> _showOtp(
  WidgetTester tester, {
  required String destination,
  bool contract = false,
  _ScriptedSms? sms,
  String prefix = '',
  int codeLength = 6,
  OtpSmsFormat? format,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(402, 874);
  await pumpAuth(
    tester,
    repositories: contract ? _OtpRepositories() : ImmediateRepositories(),
    smsPort: sms,
    smsFormat: format ?? (sms == null ? null : const DevOtpSmsFormat()),
  );
  final container = ProviderScope.containerOf(
    tester.element(find.byType(AuthEntryScreen)),
  );
  container
      .read(authFlowProvider.notifier)
      .accept(
        PhoneFlowResult(
          OtpChallenge(
            challengeId: 'dev-challenge-1',
            codeLength: codeLength,
            codePrefix: prefix,
            resendAfter: const Duration(seconds: 94),
            expiresAt: DateTime.utc(2026, 10, 24),
            maskedDestination: '+98 ••• ••• 6789',
          ),
          destination,
          false,
        ),
      );
  container.read(appRouterProvider).go('/entry/otp');
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}
