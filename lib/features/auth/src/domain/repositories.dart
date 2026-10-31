import 'package:mygame_p2e/core/errors/app_failure.dart';

import 'identifier.dart';
import 'models.dart';

abstract interface class WelcomeOfferRepository {
  Future<Result<WelcomeOffer>> load({AuthCancellation? cancellation});
}

abstract interface class PhoneSignInRepository {
  Future<Result<PhoneAccountStatus>> checkPhone(
    Phone phone, {
    AuthCancellation? cancellation,
  });
  Future<Result<void>> signInPhone(
    Phone phone,
    String password, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  });
  Future<Result<OtpChallenge>> requestPhoneReset(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  });
  Future<Result<OtpChallenge>> resendPhoneReset(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  });
  Future<Result<void>> verifyPhoneReset(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  });
  Future<Result<void>> createPhonePassword(
    Phone phone,
    String password, {
    AuthCancellation? cancellation,
  });
  Future<Result<OtpChallenge>> requestOtp(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  });
  Future<Result<OtpChallenge>> resendOtp(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  });
  Future<Result<void>> verifyOtp(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  });
}

abstract interface class EmailSignInRepository {
  Future<Result<EmailAccountStatus>> checkEmail(
    Email email, {
    AuthCancellation? cancellation,
  });
  Future<Result<void>> signIn(
    Email email,
    String password, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  });
  Future<Result<OtpChallenge>> requestReset(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  });
  Future<Result<OtpChallenge>> resendReset(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  });
  Future<Result<void>> verifyReset(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  });
  Future<Result<void>> createPassword(
    Email email,
    String password, {
    AuthCancellation? cancellation,
  });
  Future<Result<OtpChallenge>> requestVerification(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  });
  Future<Result<void>> verifyRegistration(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  });
}

/// New-account username check and completion (D-139). Remote stays not_configured.
abstract interface class AccountSetupRepository {
  Future<Result<UsernameCheck>> checkUsername(
    String username, {
    AuthCancellation? cancellation,
  });
  Future<Result<List<String>>> usernameIdeas(
    String base, {
    AuthCancellation? cancellation,
  });
  Future<Result<void>> complete({
    required String username,
    required String password,
    String? email,
    String? phone,
    int avatarCharacter,
    int avatarTheme,
    AuthCancellation? cancellation,
  });
}

abstract interface class SocialSignInRepository {
  Future<Result<void>> start(
    SocialProvider provider, {
    AuthCancellation? cancellation,
  });
}
