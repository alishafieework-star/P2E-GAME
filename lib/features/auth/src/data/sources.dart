import '../domain/models.dart';

enum AuthDataFault {
  blocked,
  rateLimited,
  invalidCode,
  invalidPassword,
  offline,
  server,
  notConfigured,
  unavailable,
  cancelled,
}

final class AuthDataException implements Exception {
  const AuthDataException(this.fault);
  final AuthDataFault fault;
}

final class WelcomeOfferDto {
  const WelcomeOfferDto(this.points);
  final int points;
  WelcomeOffer toDomain() => WelcomeOffer(points);
}

final class OtpChallengeDto {
  const OtpChallengeDto({
    required this.id,
    required this.length,
    required this.resendSeconds,
    required this.expires,
    required this.destination,
  });
  final String id, destination;
  final int length, resendSeconds;
  final DateTime expires;
  OtpChallenge toDomain() => OtpChallenge(
    challengeId: id,
    codeLength: length,
    resendAfter: Duration(seconds: resendSeconds),
    expiresAt: expires,
    maskedDestination: destination,
  );
}

final class EmailStatusDto {
  const EmailStatusDto(this.registered);
  final bool registered;
  EmailAccountStatus toDomain() => registered
      ? EmailAccountStatus.registered
      : EmailAccountStatus.notRegistered;
}

final class PhoneStatusDto {
  const PhoneStatusDto(this.status);
  final PhoneAccountStatus status;
  PhoneAccountStatus toDomain() => status;
}

final class UsernameCheckDto {
  const UsernameCheckDto({
    required this.available,
    this.suggestions = const [],
  });
  final bool available;
  final List<String> suggestions;
  UsernameCheck toDomain() =>
      UsernameCheck(available: available, suggestions: suggestions);
}

final class SocialStartDto {
  const SocialStartDto();
}

abstract interface class WelcomeOfferSource {
  Future<WelcomeOfferDto> load(AuthCancellation? cancellation);
}

abstract interface class PhoneSignInSource {
  Future<PhoneStatusDto> checkPhone(
    String e164,
    AuthCancellation? cancellation,
  );
  Future<void> signIn(
    String e164,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  );
  Future<OtpChallengeDto> requestReset(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  );
  Future<OtpChallengeDto> resendReset(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  );
  Future<void> verifyReset(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  );
  Future<void> createPassword(
    String e164,
    String password,
    AuthCancellation? cancellation,
  );
  Future<OtpChallengeDto> requestOtp(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  );
  Future<OtpChallengeDto> resendOtp(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  );
  Future<void> verifyOtp(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  );
}

abstract interface class EmailSignInSource {
  Future<EmailStatusDto> checkEmail(
    String email,
    AuthCancellation? cancellation,
  );
  Future<void> signIn(
    String email,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  );
  Future<OtpChallengeDto> requestReset(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  );
  Future<OtpChallengeDto> resendReset(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  );
  Future<void> verifyReset(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  );
  Future<void> createPassword(
    String email,
    String password,
    AuthCancellation? cancellation,
  );
  Future<OtpChallengeDto> requestVerification(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  );
  Future<void> verifyRegistration(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  );
}

abstract interface class AccountSetupSource {
  Future<UsernameCheckDto> checkUsername(
    String username,
    AuthCancellation? cancellation,
  );
  Future<List<String>> usernameIdeas(
    String base,
    AuthCancellation? cancellation,
  );
  Future<void> complete(
    Map<String, Object?> body,
    AuthCancellation? cancellation,
  );
}

abstract interface class SocialSignInSource {
  Future<SocialStartDto> start(
    SocialProvider provider,
    AuthCancellation? cancellation,
  );
}
