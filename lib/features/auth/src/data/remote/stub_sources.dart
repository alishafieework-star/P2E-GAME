import '../../domain/models.dart';
import '../sources.dart';

/// OD-2: no endpoint/SDK/network is invented. Repositories map this typed fault.
Never _unconfigured() =>
    throw const AuthDataException(AuthDataFault.notConfigured);

final class RemoteWelcomeOfferSource implements WelcomeOfferSource {
  const RemoteWelcomeOfferSource();
  @override
  Future<WelcomeOfferDto> load(AuthCancellation? cancellation) async =>
      _unconfigured();
}

final class RemotePhoneSignInSource implements PhoneSignInSource {
  const RemotePhoneSignInSource();
  @override
  Future<OtpChallengeDto> requestOtp(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<OtpChallengeDto> resendOtp(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<void> verifyOtp(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<PhoneStatusDto> checkPhone(
    String e164,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<void> signIn(
    String e164,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<OtpChallengeDto> requestReset(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<OtpChallengeDto> resendReset(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<void> verifyReset(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<void> createPassword(
    String e164,
    String password,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
}

final class RemoteEmailSignInSource implements EmailSignInSource {
  const RemoteEmailSignInSource();
  @override
  Future<EmailStatusDto> checkEmail(
    String email,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<void> signIn(
    String email,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<OtpChallengeDto> requestReset(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<OtpChallengeDto> resendReset(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<void> verifyReset(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<void> createPassword(
    String email,
    String password,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<OtpChallengeDto> requestVerification(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<void> verifyRegistration(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
}

final class RemoteAccountSetupSource implements AccountSetupSource {
  const RemoteAccountSetupSource();
  @override
  Future<UsernameCheckDto> checkUsername(
    String username,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<List<String>> usernameIdeas(
    String base,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
  @override
  Future<void> complete(
    Map<String, Object?> body,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
}

final class RemoteSocialSignInSource implements SocialSignInSource {
  const RemoteSocialSignInSource();
  @override
  Future<SocialStartDto> start(
    SocialProvider provider,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
}
