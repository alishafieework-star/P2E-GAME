import 'dart:async';
import 'dart:convert';

import '../../domain/models.dart';
import '../sources.dart';
import 'otp_api.dart';

enum FakeAuthScenario {
  success,
  slow,
  offline,
  serverError,
  rateLimited,
  notConfigured,
}

/// Unique marker must survive only the const-selected fake composition.
const fakeAuthMarker = 'P2E_AUTH_FAKE_ONLY_20261023';

final class FakeAuthEnvironment {
  FakeAuthEnvironment({
    required this.scenario,
    DateTime Function()? clock,
    this.log,
  }) : clock = clock ?? DateTime.now;
  final FakeAuthScenario Function() scenario;
  final DateTime Function() clock;
  final void Function(String scenario)? log;
  Future<void> wait(AuthCancellation? cancellation) async {
    final selected = scenario();
    log?.call(selected.name);
    if (cancellation?.isCancelled ?? false) {
      throw const AuthDataException(AuthDataFault.cancelled);
    }
    final done = Completer<void>();
    final timer = Timer(
      Duration(milliseconds: selected == FakeAuthScenario.slow ? 3000 : 600),
      done.complete,
    );
    void cancel() {
      timer.cancel();
      if (!done.isCompleted) {
        done.completeError(const AuthDataException(AuthDataFault.cancelled));
      }
    }

    cancellation?.onCancel(cancel);
    try {
      await done.future;
    } finally {
      cancellation?.removeListener(cancel);
      timer.cancel();
    }
    final fault = switch (selected) {
      FakeAuthScenario.offline => AuthDataFault.offline,
      FakeAuthScenario.serverError => AuthDataFault.server,
      FakeAuthScenario.rateLimited => AuthDataFault.rateLimited,
      FakeAuthScenario.notConfigured => AuthDataFault.notConfigured,
      _ => null,
    };
    if (fault != null) throw AuthDataException(fault);
  }
}

final class FakeWelcomeOfferSource implements WelcomeOfferSource {
  const FakeWelcomeOfferSource(this.environment);
  final FakeAuthEnvironment environment;
  @override
  Future<WelcomeOfferDto> load(AuthCancellation? cancellation) async {
    await environment.wait(cancellation);
    return const WelcomeOfferDto(3500);
  }
}

final class FakePhoneSignInSource implements PhoneSignInSource {
  const FakePhoneSignInSource(this.environment);
  final FakeAuthEnvironment environment;
  @override
  Future<OtpChallengeDto> requestOtp(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    if (e164.endsWith('0000')) {
      throw const AuthDataException(AuthDataFault.blocked);
    }
    return OtpChallengeDto(
      id: 'dev-challenge-1',
      length: 6,
      resendSeconds: 60,
      expires: environment.clock().add(const Duration(minutes: 5)),
      destination: '+98 ••• ••• ${e164.substring(e164.length - 4)}',
    );
  }

  @override
  Future<OtpChallengeDto> resendOtp(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => requestOtp(e164, rememberDevice, cancellation);

  @override
  Future<void> verifyOtp(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    DevOtpApi.requireVerified(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/otp/verify',
          body: jsonEncode({'challengeId': challengeId, 'code': code}),
        ),
      ),
    );
  }

  @override
  Future<PhoneStatusDto> checkPhone(
    String e164,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    final response = DevOtpApi.handle(
      OtpApiRequest(
        method: 'POST',
        path: '/auth/phone/status',
        body: jsonEncode({'phone': e164}),
      ),
    );
    final decoded = jsonDecode(response.body);
    final name = decoded is Map ? decoded['status'] : null;
    return PhoneStatusDto(
      PhoneAccountStatus.values.byName(name is String ? name : 'registered'),
    );
  }

  @override
  Future<void> signIn(
    String e164,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    DevOtpApi.requireVerified(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/phone/password',
          body: jsonEncode({
            'phone': e164,
            'password': password,
            'rememberDevice': rememberDevice,
          }),
        ),
      ),
    );
  }

  @override
  Future<OtpChallengeDto> requestReset(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    return DevOtpApi.challengeFrom(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/phone/reset/request',
          body: jsonEncode({
            'destination': e164,
            'rememberDevice': rememberDevice,
          }),
        ),
        clock: environment.clock,
      ),
    );
  }

  @override
  Future<OtpChallengeDto> resendReset(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => requestReset(e164, rememberDevice, cancellation);

  @override
  Future<void> verifyReset(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    DevOtpApi.requireVerified(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/phone/reset/verify',
          body: jsonEncode({'challengeId': challengeId, 'code': code}),
        ),
      ),
    );
  }

  @override
  Future<void> createPassword(
    String e164,
    String password,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    DevOtpApi.requireVerified(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/phone/password/create',
          body: jsonEncode({'phone': e164, 'password': password}),
        ),
      ),
    );
  }
}

final class FakeEmailSignInSource implements EmailSignInSource {
  const FakeEmailSignInSource(this.environment);
  final FakeAuthEnvironment environment;
  @override
  Future<EmailStatusDto> checkEmail(
    String email,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    return EmailStatusDto(
      !email.split('@').first.toLowerCase().startsWith('new'),
    );
  }

  @override
  Future<void> signIn(
    String email,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    DevOtpApi.requireVerified(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/email/password',
          body: jsonEncode({
            'email': email,
            'password': password,
            'rememberDevice': rememberDevice,
          }),
        ),
      ),
    );
  }

  @override
  Future<OtpChallengeDto> requestReset(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    return DevOtpApi.challengeFrom(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/email/reset/request',
          body: jsonEncode({
            'destination': email,
            'rememberDevice': rememberDevice,
          }),
        ),
        clock: environment.clock,
      ),
    );
  }

  @override
  Future<OtpChallengeDto> resendReset(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => requestReset(email, rememberDevice, cancellation);

  @override
  Future<void> verifyReset(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    DevOtpApi.requireVerified(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/email/reset/verify',
          body: jsonEncode({'challengeId': challengeId, 'code': code}),
        ),
      ),
    );
  }

  @override
  Future<void> createPassword(
    String email,
    String password,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    DevOtpApi.requireVerified(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/email/password/create',
          body: jsonEncode({'email': email, 'password': password}),
        ),
      ),
    );
  }

  @override
  Future<OtpChallengeDto> requestVerification(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    return DevOtpApi.challengeFrom(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/email/verify/request',
          body: jsonEncode({
            'destination': email,
            'rememberDevice': rememberDevice,
          }),
        ),
        clock: environment.clock,
      ),
    );
  }

  @override
  Future<void> verifyRegistration(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    DevOtpApi.requireVerified(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/email/verify/confirm',
          body: jsonEncode({'challengeId': challengeId, 'code': code}),
        ),
      ),
    );
  }
}

final class LocalAccountSetupSource implements AccountSetupSource {
  const LocalAccountSetupSource();

  @override
  Future<UsernameCheckDto> checkUsername(
    String username,
    AuthCancellation? cancellation,
  ) async {
    final response = DevOtpApi.handle(
      OtpApiRequest(
        method: 'POST',
        path: '/auth/account/username',
        body: jsonEncode({'username': username}),
      ),
    );
    if (response.status != 200) {
      throw const AuthDataException(AuthDataFault.server);
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw const AuthDataException(AuthDataFault.server);
    }
    final suggestions = decoded['suggestions'];
    return UsernameCheckDto(
      available: decoded['available'] == true,
      suggestions: suggestions is List
          ? [
              for (final item in suggestions)
                if (item is String) item,
            ]
          : const [],
    );
  }

  @override
  Future<List<String>> usernameIdeas(
    String base,
    AuthCancellation? cancellation,
  ) async {
    final response = DevOtpApi.handle(
      OtpApiRequest(
        method: 'POST',
        path: '/auth/account/username/ideas',
        body: jsonEncode({'base': base}),
      ),
    );
    if (response.status != 200) {
      throw const AuthDataException(AuthDataFault.server);
    }
    final decoded = jsonDecode(response.body);
    final names = decoded is Map ? decoded['suggestions'] : null;
    return [
      if (names is List)
        for (final item in names)
          if (item is String) item,
    ];
  }

  @override
  Future<void> complete(
    Map<String, Object?> body,
    AuthCancellation? cancellation,
  ) async {
    DevOtpApi.requireVerified(
      DevOtpApi.handle(
        OtpApiRequest(
          method: 'POST',
          path: '/auth/account/complete',
          body: jsonEncode(body),
        ),
      ),
    );
  }
}

final class FakeSocialSignInSource implements SocialSignInSource {
  const FakeSocialSignInSource(this.environment);
  final FakeAuthEnvironment environment;
  @override
  Future<SocialStartDto> start(
    SocialProvider provider,
    AuthCancellation? cancellation,
  ) async {
    await environment.wait(cancellation);
    throw const AuthDataException(AuthDataFault.unavailable);
  }
}
