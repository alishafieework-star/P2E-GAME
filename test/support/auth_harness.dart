import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/app/app.dart';
import 'package:mygame_p2e/app/config/app_config.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/shared/platform/one_time_code.dart';
import 'package:p2e_design_system/design_system.dart';

class ImmediateRepositories
    implements
        WelcomeOfferRepository,
        PhoneSignInRepository,
        EmailSignInRepository,
        SocialSignInRepository {
  @override
  Future<Result<WelcomeOffer>> load({AuthCancellation? cancellation}) async =>
      const Success(WelcomeOffer(3500));
  @override
  Future<Result<OtpChallenge>> requestOtp(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => Success(
    OtpChallenge(
      challengeId: 'test-challenge',
      codeLength: 6,
      resendAfter: const Duration(seconds: 60),
      expiresAt: DateTime.utc(2026, 10, 23),
      maskedDestination: '••••',
    ),
  );
  @override
  Future<Result<OtpChallenge>> resendOtp(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => requestOtp(
    phone,
    rememberDevice: rememberDevice,
    cancellation: cancellation,
  );
  @override
  Future<Result<void>> verifyOtp(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) async => code == 'P12345'
      ? const Success<void>(null)
      : Failure(ValidationFailure({'otp': 'invalid'}));
  @override
  Future<Result<EmailAccountStatus>> checkEmail(
    Email email, {
    AuthCancellation? cancellation,
  }) async => Success(
    email.normalized.startsWith('new')
        ? EmailAccountStatus.notRegistered
        : EmailAccountStatus.registered,
  );
  @override
  Future<Result<void>> signIn(
    Email email,
    String password, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => password == 'P12345'
      ? const Success<void>(null)
      : Failure(ValidationFailure({'password': 'invalid'}));
  @override
  Future<Result<OtpChallenge>> requestReset(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => Success(
    OtpChallenge(
      challengeId: 'dev-challenge-1',
      codeLength: 6,
      resendAfter: const Duration(seconds: 94),
      expiresAt: DateTime.utc(2026, 10, 24),
      maskedDestination: 'm•••@gmail.com',
    ),
  );
  @override
  Future<Result<OtpChallenge>> resendReset(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => requestReset(
    email,
    rememberDevice: rememberDevice,
    cancellation: cancellation,
  );
  @override
  Future<Result<void>> verifyReset(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) async => code == 'P12345'
      ? const Success<void>(null)
      : Failure(ValidationFailure({'otp': 'invalid'}));
  @override
  Future<Result<void>> createPassword(
    Email email,
    String password, {
    AuthCancellation? cancellation,
  }) async => const Success<void>(null);
  @override
  Future<Result<PhoneAccountStatus>> checkPhone(
    Phone phone, {
    AuthCancellation? cancellation,
  }) async => const Success(PhoneAccountStatus.registered);
  @override
  Future<Result<void>> signInPhone(
    Phone phone,
    String password, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => password == 'Play123!'
      ? const Success<void>(null)
      : Failure(ValidationFailure({'password': 'invalid'}));
  @override
  Future<Result<OtpChallenge>> requestPhoneReset(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => requestOtp(
    phone,
    rememberDevice: rememberDevice,
    cancellation: cancellation,
  );
  @override
  Future<Result<OtpChallenge>> resendPhoneReset(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => requestPhoneReset(
    phone,
    rememberDevice: rememberDevice,
    cancellation: cancellation,
  );
  @override
  Future<Result<void>> verifyPhoneReset(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) => verifyOtp(challenge, code, cancellation: cancellation);
  @override
  Future<Result<void>> createPhonePassword(
    Phone phone,
    String password, {
    AuthCancellation? cancellation,
  }) async => const Success<void>(null);
  @override
  Future<Result<OtpChallenge>> requestVerification(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => Success(
    OtpChallenge(
      challengeId: 'verify-challenge',
      codeLength: 6,
      resendAfter: const Duration(seconds: 94),
      expiresAt: DateTime.utc(2026, 10, 24),
      maskedDestination: 'n•••@example.com',
    ),
  );
  @override
  Future<Result<void>> verifyRegistration(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) => verifyOtp(challenge, code, cancellation: cancellation);
  @override
  Future<Result<void>> start(
    SocialProvider provider, {
    AuthCancellation? cancellation,
  }) async => const Failure(BusinessFailure('social_unavailable'));
}

Future<void> pumpAuth(
  WidgetTester tester, {
  double width = 402,
  double height = 874,
  String locale = 'en',
  Brightness brightness = Brightness.dark,
  double scale = 1,
  bool keyboard = false,
  String raw = '',
  bool focused = false,
  ImmediateRepositories? repositories,
  OneTimeCodePort? smsPort,
  OtpSmsFormat? smsFormat,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  final repos = repositories ?? ImmediateRepositories();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(environment: AppEnvironment.stage),
        ),
        appLocaleProvider.overrideWithValue(Locale(locale)),
        welcomeOfferRepositoryProvider.overrideWith((_) => repos),
        phoneSignInRepositoryProvider.overrideWith((_) => repos),
        emailSignInRepositoryProvider.overrideWith((_) => repos),
        socialSignInRepositoryProvider.overrideWith((_) => repos),
        if (smsPort != null) oneTimeCodePortProvider.overrideWithValue(smsPort),
        if (smsFormat != null)
          otpSmsFormatProvider.overrideWithValue(smsFormat),
      ],
      child: RepaintBoundary(
        key: const ValueKey('auth-boundary'),
        child: MediaQuery(
          data: MediaQueryData(
            size: Size(width, height),
            padding: const EdgeInsets.only(top: 55),
            viewPadding: const EdgeInsets.only(top: 55),
            viewInsets: EdgeInsets.only(bottom: keyboard ? 331 : 0),
            platformBrightness: brightness,
            textScaler: TextScaler.linear(scale),
            disableAnimations: true,
          ),
          child: const P2EApp(),
        ),
      ),
    ),
  );
  // D-135: the splash overlay releases routing after its own timer.
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
  await tester.runAsync(
    () => precacheImage(
      const AssetImage('assets/images/auth/entry_illustration.png'),
      tester.element(find.byType(P2EApp)),
    ),
  );
  await tester.pumpAndSettle();
  if (focused || raw.isNotEmpty) {
    final field = tester.widget<AppTextField>(find.byType(AppTextField));
    field.options.focusNode!.requestFocus();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), raw);
    await tester.pumpAndSettle();
  }
}
