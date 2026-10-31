import 'dart:convert';

import '../../domain/models.dart';
import '../sources.dart';
import 'fake_sources.dart';
import 'otp_api.dart';

/// D-072: email password and reset for the development HTTP fake.
/// Checking whether the address is registered stays on [FakeEmailSignInSource].
final class HttpEmailAuthSource implements EmailSignInSource {
  const HttpEmailAuthSource({required this.transport, required this.base});
  final DevOtpTransport transport;
  final Uri base;

  Future<OtpApiResponse> _send(
    String path,
    Map<String, Object?> body,
    AuthCancellation? cancellation,
  ) => transport.post(base.replace(path: path), jsonEncode(body), cancellation);

  @override
  Future<EmailStatusDto> checkEmail(
    String email,
    AuthCancellation? cancellation,
  ) => throw UnsupportedError('checkEmail stays on FakeEmailSignInSource');

  @override
  Future<void> signIn(
    String email,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async {
    DevOtpApi.requireVerified(
      await _send('/auth/email/password', {
        'email': email,
        'password': password,
        'rememberDevice': rememberDevice,
      }, cancellation),
    );
  }

  @override
  Future<OtpChallengeDto> requestReset(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => DevOtpApi.challengeFrom(
    await _send('/auth/email/reset/request', {
      'destination': email,
      'rememberDevice': rememberDevice,
    }, cancellation),
  );

  @override
  Future<OtpChallengeDto> resendReset(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => DevOtpApi.challengeFrom(
    await _send('/auth/email/reset/resend', {
      'destination': email,
      'rememberDevice': rememberDevice,
    }, cancellation),
  );

  @override
  Future<void> verifyReset(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async {
    DevOtpApi.requireVerified(
      await _send('/auth/email/reset/verify', {
        'challengeId': challengeId,
        'code': code,
      }, cancellation),
    );
  }

  @override
  Future<void> createPassword(
    String email,
    String password,
    AuthCancellation? cancellation,
  ) async {
    DevOtpApi.requireVerified(
      await _send('/auth/email/password/create', {
        'email': email,
        'password': password,
      }, cancellation),
    );
  }

  @override
  Future<OtpChallengeDto> requestVerification(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => DevOtpApi.challengeFrom(
    await _send('/auth/email/verify/request', {
      'destination': email,
      'rememberDevice': rememberDevice,
    }, cancellation),
  );

  @override
  Future<void> verifyRegistration(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async {
    DevOtpApi.requireVerified(
      await _send('/auth/email/verify/confirm', {
        'challengeId': challengeId,
        'code': code,
      }, cancellation),
    );
  }
}

/// Registered-email lookup stays in-process. Password and reset use HTTP.
final class DevEmailSignInSource implements EmailSignInSource {
  const DevEmailSignInSource({required this.local, required this.remote});
  final FakeEmailSignInSource local;
  final HttpEmailAuthSource remote;

  @override
  Future<EmailStatusDto> checkEmail(
    String email,
    AuthCancellation? cancellation,
  ) => local.checkEmail(email, cancellation);

  @override
  Future<void> signIn(
    String email,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => remote.signIn(email, password, rememberDevice, cancellation);

  @override
  Future<OtpChallengeDto> requestReset(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => remote.requestReset(email, rememberDevice, cancellation);

  @override
  Future<OtpChallengeDto> resendReset(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => remote.resendReset(email, rememberDevice, cancellation);

  @override
  Future<void> verifyReset(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) => remote.verifyReset(challengeId, code, cancellation);

  @override
  Future<void> createPassword(
    String email,
    String password,
    AuthCancellation? cancellation,
  ) => remote.createPassword(email, password, cancellation);

  @override
  Future<OtpChallengeDto> requestVerification(
    String email,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) => remote.requestVerification(email, rememberDevice, cancellation);

  @override
  Future<void> verifyRegistration(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) => remote.verifyRegistration(challengeId, code, cancellation);
}
