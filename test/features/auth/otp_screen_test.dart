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
  Stream<OneTimeCodeEvent> listen() {
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
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(402, 874);
  await pumpAuth(
    tester,
    repositories: contract ? _OtpRepositories() : ImmediateRepositories(),
    smsPort: sms,
    smsFormat: sms == null ? null : const DevOtpSmsFormat(),
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
            codeLength: 6,
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
