import '../../domain/models.dart';
import '../sources.dart';
import 'users_api_client.dart';

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
  const RemotePhoneSignInSource() : client = null;
  RemotePhoneSignInSource.connected(this.client);
  final UsersApiClient? client;

  UsersApiClient get _client => client ?? _unconfigured();

  @override
  Future<PhoneStatusDto> checkPhone(
    String e164,
    AuthCancellation? cancellation,
  ) => _client.resolvePhone(e164, cancellation);

  @override
  Future<OtpChallengeDto> requestOtp(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => _client.sendPhoneCode(e164, rememberDevice, cancellation);

  @override
  Future<OtpChallengeDto> resendOtp(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => _client.sendPhoneCode(e164, rememberDevice, cancellation);

  @override
  Future<void> verifyOtp(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) => _client.verifyLoginCode(challengeId, code, cancellation);

  @override
  Future<void> signIn(
    String e164,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => _client.signIn(
    UsersApiClient.wirePhone(e164),
    password,
    rememberDevice,
    cancellation,
  );

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
  ) => _client.createPassword(password, cancellation);
}

final class RemoteEmailSignInSource implements EmailSignInSource {
  const RemoteEmailSignInSource() : client = null;
  RemoteEmailSignInSource.connected(this.client);
  final UsersApiClient? client;

  UsersApiClient get _client => client ?? _unconfigured();

  @override
  Future<EmailStatusDto> checkEmail(
    String email,
    AuthCancellation? cancellation,
  ) => _client.resolveEmail(email, cancellation);

  @override
  Future<void> signIn(
    String email,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => _client.signIn(email, password, rememberDevice, cancellation);

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
  ) => _client.createPassword(password, cancellation);

  /// Registration SendCode takes a mobile number. Email has no matching call.
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
  ) => _client.verifyRegistration(challengeId, code, cancellation);
}

final class RemoteAccountSetupSource implements AccountSetupSource {
  const RemoteAccountSetupSource() : client = null;
  RemoteAccountSetupSource.connected(this.client);
  final UsersApiClient? client;

  UsersApiClient get _client => client ?? _unconfigured();

  @override
  Future<UsernameCheckDto> checkUsername(
    String username,
    AuthCancellation? cancellation,
  ) => _client.checkUsername(username, cancellation);

  @override
  Future<List<String>> usernameIdeas(
    String base,
    AuthCancellation? cancellation,
  ) => _client.usernameIdeas(base, cancellation);

  @override
  Future<void> complete(
    Map<String, Object?> body,
    AuthCancellation? cancellation,
  ) => _client.completeRegistration(body, cancellation);
}

final class RemoteSocialSignInSource implements SocialSignInSource {
  const RemoteSocialSignInSource();
  @override
  Future<SocialStartDto> start(
    SocialProvider provider,
    AuthCancellation? cancellation,
  ) async => _unconfigured();
}
