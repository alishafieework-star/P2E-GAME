import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/identifier.dart';
import '../domain/models.dart';
part 'auth_flow.g.dart';

enum AuthStep {
  otp,
  password,
  createPassword,
  resetPassword,
  verify,
  username,
  avatar,
  notifications,
  allSet,
  welcomeBack,
}

String authStepPath(AuthStep step) => switch (step) {
  AuthStep.otp => '/entry/otp',
  AuthStep.password => '/entry/password',
  AuthStep.createPassword => '/entry/create-password',
  AuthStep.resetPassword => '/entry/forgot-password',
  AuthStep.verify => '/entry/verify',
  AuthStep.username => '/entry/username',
  AuthStep.avatar => '/entry/avatar',
  AuthStep.notifications => '/entry/notifications',
  AuthStep.allSet => '/entry/all-set',
  AuthStep.welcomeBack => '/entry/welcome-back',
};

sealed class AuthFlowResult {
  const AuthFlowResult(this.rememberDevice);
  final bool rememberDevice;
  AuthStep get step;
}

final class PhoneFlowResult extends AuthFlowResult {
  const PhoneFlowResult(
    this.challenge,
    this.displayDestination,
    super.rememberDevice, {
    this.registration = false,
  });
  final OtpChallenge challenge;

  /// The identifier exactly as typed. The challenge keeps a separate mask.
  final String displayDestination;

  /// A new number verifies, then continues into account setup (D-139).
  final bool registration;
  @override
  AuthStep get step => registration ? AuthStep.verify : AuthStep.otp;
}

/// Registered phone that already has a password (D-139).
final class PhonePasswordFlowResult extends AuthFlowResult {
  const PhonePasswordFlowResult(
    this.phone,
    this.displayDestination,
    super.rememberDevice,
  );
  final Phone phone;
  final String displayDestination;
  @override
  AuthStep get step => AuthStep.password;
}

/// Forgot-password OTP for a phone. Success opens Set a New Password.
final class PhoneResetFlowResult extends AuthFlowResult {
  const PhoneResetFlowResult(
    this.phone,
    this.displayDestination,
    this.challenge,
    super.rememberDevice,
  );
  final Phone phone;
  final String displayDestination;
  final OtpChallenge challenge;
  @override
  AuthStep get step => AuthStep.resetPassword;
}

/// Set a new phone password after reset. Success opens Welcome Back.
final class PhoneNewPasswordResult extends AuthFlowResult {
  const PhoneNewPasswordResult(this.phone, super.rememberDevice);
  final Phone phone;
  @override
  AuthStep get step => AuthStep.createPassword;
}

final class EmailFlowResult extends AuthFlowResult {
  const EmailFlowResult(this.email, this.accountStatus, super.rememberDevice);
  final Email email;
  final EmailAccountStatus accountStatus;
  @override
  AuthStep get step => accountStatus == EmailAccountStatus.registered
      ? AuthStep.password
      : AuthStep.verify;
}

/// Verification code for a new email address (D-139).
final class EmailVerifyFlowResult extends EmailFlowResult {
  const EmailVerifyFlowResult(Email email, this.challenge, bool rememberDevice)
    : super(email, EmailAccountStatus.notRegistered, rememberDevice);
  final OtpChallenge challenge;
}

/// D-075: set a new password after reset, or for an unregistered email.
final class EmailNewPasswordResult extends AuthFlowResult {
  const EmailNewPasswordResult(this.email, super.rememberDevice);
  final Email email;
  @override
  AuthStep get step => AuthStep.createPassword;
}

/// D-072: forgot-password OTP. Success opens Set a New Password.
final class EmailResetFlowResult extends AuthFlowResult {
  const EmailResetFlowResult(this.email, this.challenge, super.rememberDevice);
  final Email email;
  final OtpChallenge challenge;
  @override
  AuthStep get step => AuthStep.resetPassword;
}

/// Auto-dispose: only auth controller/routes listen; no global keepAlive or extra.
@riverpod
class AuthFlow extends _$AuthFlow {
  @override
  AuthFlowResult? build() => null;
  void accept(AuthFlowResult result) => state = result;
  void clear() => state = null;
}

/// A step after the identifier is known (D-139).
final class AccountJourney extends AuthFlowResult {
  const AccountJourney(
    this.journey, {
    this.email,
    this.username = '',
    this.phoneRaw = '',
    this.avatarCharacter = 0,
    this.avatarTheme = 0,
    this.avatarReady = false,
    this.notificationsOn = false,
    this.challenge,
    bool rememberDevice = false,
  }) : super(rememberDevice);

  final AuthStep journey;

  /// Present when a cold start resumes OTP. Other steps leave it null (D-154).
  final OtpChallenge? challenge;
  final Email? email;
  final String username;
  final String phoneRaw;
  final int avatarCharacter;
  final int avatarTheme;
  final bool avatarReady;
  final bool notificationsOn;

  @override
  AuthStep get step => journey;
}
