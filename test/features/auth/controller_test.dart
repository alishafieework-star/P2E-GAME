import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/features/auth/src/presentation/auth_password_controller.dart';

class Repositories
    implements
        WelcomeOfferRepository,
        PhoneSignInRepository,
        EmailSignInRepository,
        SocialSignInRepository {
  final pending = Completer<Result<OtpChallenge>>();
  AuthCancellation? cancellation;
  int calls = 0;
  Result<WelcomeOffer> offer = const Success(WelcomeOffer(3500));
  Result<EmailAccountStatus> email = const Success(
    EmailAccountStatus.registered,
  );
  Result<PhoneAccountStatus> phone = const Success(
    PhoneAccountStatus.registered,
  );
  Result<OtpChallenge>? otpResult;
  @override
  Future<Result<WelcomeOffer>> load({AuthCancellation? cancellation}) async =>
      offer;
  @override
  Future<Result<OtpChallenge>> requestOtp(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) {
    calls++;
    this.cancellation = cancellation;
    final r = otpResult;
    if (r != null) return Future.value(r);
    return pending.future;
  }

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
  }) async => Failure(ValidationFailure({'otp': 'invalid'}));

  @override
  Future<Result<EmailAccountStatus>> checkEmail(
    Email email, {
    AuthCancellation? cancellation,
  }) async => this.email;
  @override
  Future<Result<void>> signIn(
    Email email,
    String password, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => const Success<void>(null);
  @override
  Future<Result<OtpChallenge>> requestReset(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => const Failure(UnknownFailure());
  @override
  Future<Result<OtpChallenge>> resendReset(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => const Failure(UnknownFailure());
  @override
  Future<Result<void>> verifyReset(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) async => const Failure(UnknownFailure());
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
  }) async {
    this.cancellation = cancellation;
    return this.phone;
  }

  @override
  Future<Result<void>> signInPhone(
    Phone phone,
    String password, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => const Success<void>(null);
  @override
  Future<Result<OtpChallenge>> requestPhoneReset(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => const Failure(UnknownFailure());
  @override
  Future<Result<OtpChallenge>> resendPhoneReset(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) async => const Failure(UnknownFailure());
  @override
  Future<Result<void>> verifyPhoneReset(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) async => const Failure(UnknownFailure());
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
  }) async => const Success<void>(null);
  @override
  Future<Result<void>> start(
    SocialProvider provider, {
    AuthCancellation? cancellation,
  }) async => const Failure(BusinessFailure('social_unavailable'));
}

void main() {
  late Repositories repos;
  late ProviderContainer container;
  setUp(() {
    repos = Repositories();
    container = ProviderContainer(
      overrides: [
        welcomeOfferRepositoryProvider.overrideWith((_) => repos),
        phoneSignInRepositoryProvider.overrideWith((_) => repos),
        emailSignInRepositoryProvider.overrideWith((_) => repos),
        socialSignInRepositoryProvider.overrideWith((_) => repos),
      ],
    );
    container.listen(authEntryControllerProvider, (_, _) {});
  });
  tearDown(() => container.dispose());
  AuthEntryController controller() =>
      container.read(authEntryControllerProvider.notifier);
  AuthEntryState state() => container.read(authEntryControllerProvider);

  test('typing classifies without error or mutation of editing text', () {
    expect(state().canSubmit, false);
    controller().identifierChanged('۰۹۱۲ ۳۴۵ ۶۷۸۹');
    expect(state().raw, '۰۹۱۲ ۳۴۵ ۶۷۸۹');
    expect(state().identifier, isA<Phone>());
    expect(state().canSubmit, true);
    controller().identifierChanged('bad');
    expect(state().fieldError, isNull);
    expect(state().canSubmit, false);
  });
  test('loading prevents duplicate submit and remember mutation', () async {
    controller().identifierChanged('09123456789');
    controller().rememberToggled();
    final first = controller().submit();
    await controller().submit();
    controller().rememberToggled();
    expect(state().busy, true);
    expect(state().rememberDevice, true);
    expect(repos.calls, 1);
    repos.pending.complete(const Failure(OfflineFailure()));
    await first;
    expect(state().toast, AuthMessage.offline);
    expect(state().rememberDevice, true);
  });
  test('changed input cancels request and ignores stale response', () async {
    controller().identifierChanged('09123456789');
    final first = controller().submit();
    controller().identifierChanged('new@example.com');
    expect(repos.cancellation!.isCancelled, true);
    repos.pending.complete(const Failure(ServerFailure()));
    await first;
    expect(state().raw, 'new@example.com');
    expect(state().toast, isNull);
    expect(state().destination, isNull);
  });
  test('dispose cancels in-flight request', () async {
    controller().identifierChanged('09123456789');
    final first = controller().submit();
    container.dispose();
    expect(repos.cancellation!.isCancelled, true);
    repos.pending.complete(const Failure(ServerFailure()));
    await first;
    // Replace the disposed container so tearDown remains valid.
    container = ProviderContainer();
  });
  for (final status in EmailAccountStatus.values) {
    test('email result retained in flow: $status', () async {
      repos.email = Success(status);
      controller().identifierChanged('new@EXAMPLE.COM');
      controller().rememberToggled();
      await controller().submit();
      final flow = container.read(authFlowProvider) as EmailFlowResult;
      expect(flow.email.normalized, 'new@example.com');
      expect(flow.rememberDevice, true);
      expect(
        state().destination,
        status == EmailAccountStatus.registered
            ? AuthStep.password
            : AuthStep.verify,
      );
      expect(state().raw, 'new@EXAMPLE.COM');
    });
  }
  for (final status in PhoneAccountStatus.values) {
    test('phone result retained in flow: $status', () async {
      repos.phone = Success(status);
      repos.otpResult = Success(
        OtpChallenge(
          challengeId: 'phone-challenge',
          codeLength: 6,
          resendAfter: const Duration(seconds: 94),
          expiresAt: DateTime.utc(2026, 10, 24),
          maskedDestination: '•••••••6789',
        ),
      );
      repos.calls = 0;
      controller().identifierChanged('09123456789');
      controller().rememberToggled();
      await controller().submit();
      if (status == PhoneAccountStatus.registeredWithPassword) {
        final flow =
            container.read(authFlowProvider) as PhonePasswordFlowResult;
        expect(flow.phone.e164, '+989123456789');
        expect(flow.rememberDevice, true);
        expect(state().destination, AuthStep.password);
        expect(repos.calls, 0);
      } else {
        final flow = container.read(authFlowProvider) as PhoneFlowResult;
        expect(flow.displayDestination, '09123456789');
        expect(flow.rememberDevice, true);
        expect(
          state().destination,
          status == PhoneAccountStatus.notRegistered
              ? AuthStep.verify
              : AuthStep.otp,
        );
        expect(repos.calls, 1);
      }
      expect(state().raw, '09123456789');
    });
  }
  test('welcome offer initially absent, loaded asynchronously', () async {
    expect(state().welcomeOffer, isNull);
    await Future<void>.delayed(Duration.zero);
    expect(state().welcomeOffer!.points, 3500);
    repos.offer = const Failure(ServerFailure());
    await controller().retryWelcomeOffer();
    expect(state().welcomeOffer, isNull);
    expect(state().toast, isNull);
  });
  test('social failure becomes toast', () async {
    await controller().socialRequested(SocialProvider.google);
    expect(state().toast, AuthMessage.socialUnavailable);
  });
  for (final entry in <AppFailure, AuthMessage>{
    const OfflineFailure(): AuthMessage.offline,
    const NetworkFailure(): AuthMessage.offline,
    const TimeoutFailure(): AuthMessage.offline,
    const ServerFailure(): AuthMessage.server,
    const BusinessFailure('backend_not_configured'): AuthMessage.notConfigured,
    const BusinessFailure('social_unavailable'): AuthMessage.socialUnavailable,
    const UnknownFailure(): AuthMessage.unknown,
  }.entries) {
    test('failure maps once: ${entry.key.runtimeType} ${entry.value}', () {
      expect(AuthFailureMapper.map(entry.key).toast, entry.value);
      expect(AuthFailureMapper.map(entry.key).field, isNull);
    });
  }
  test('password login stores Mine userName on Welcome Back', () async {
    final box = _passwordBox(repos, const Success('nova'));
    addTearDown(box.dispose);
    await _submitPassword(box);
    final journey = box.read(authFlowProvider) as AccountJourney;
    expect(journey.step, AuthStep.welcomeBack);
    expect(journey.username, 'nova');
    expect(box.read(authPasswordControllerProvider).welcomeSerial, 1);
  });
  test('Mine failure does not open Welcome Back', () async {
    final box = _passwordBox(repos, const Failure(ServerFailure()));
    addTearDown(box.dispose);
    await _submitPassword(box);
    expect(box.read(authFlowProvider), isA<EmailFlowResult>());
    final password = box.read(authPasswordControllerProvider);
    expect(password.welcomeSerial, 0);
    expect(password.toast, AuthMessage.server);
  });
  test('fake login keeps the journey username empty', () async {
    final email = IdentifierClassifier.classify('ada@example.com') as Email;
    container
        .read(authFlowProvider.notifier)
        .accept(EmailFlowResult(email, EmailAccountStatus.registered, false));
    container.listen(authPasswordControllerProvider, (_, _) {});
    await container
        .read(authPasswordControllerProvider.notifier)
        .submit('secret-pass');
    final journey = container.read(authFlowProvider) as AccountJourney;
    expect(journey.step, AuthStep.welcomeBack);
    expect(journey.username, isEmpty);
  });
  for (final code in ['blocked', 'rate_limited']) {
    test('field error $code does not become toast', () async {
      controller().identifierChanged('09123456789');
      final request = controller().submit();
      repos.pending.complete(Failure(ValidationFailure({'identifier': code})));
      await request;
      expect(
        state().fieldError,
        code == 'blocked' ? AuthMessage.blocked : AuthMessage.rateLimited,
      );
      expect(state().toast, isNull);
    });
  }
}

final class _NamedSession implements PlayerSessionCheck {
  const _NamedSession(this.name);
  final Result<String>? name;

  @override
  Future<bool> allowsHome() async => true;

  @override
  Future<Result<String>?> publicName({AuthCancellation? cancellation}) async =>
      name;
}

ProviderContainer _passwordBox(Repositories repos, Result<String>? name) {
  final box = ProviderContainer(
    overrides: [
      emailSignInRepositoryProvider.overrideWith((_) => repos),
      phoneSignInRepositoryProvider.overrideWith((_) => repos),
      playerSessionCheckProvider.overrideWithValue(_NamedSession(name)),
    ],
  );
  final email = IdentifierClassifier.classify('ada@example.com') as Email;
  box
      .read(authFlowProvider.notifier)
      .accept(EmailFlowResult(email, EmailAccountStatus.registered, false));
  box.listen(authPasswordControllerProvider, (_, _) {});
  return box;
}

Future<void> _submitPassword(ProviderContainer box) =>
    box.read(authPasswordControllerProvider.notifier).submit('secret-pass');
