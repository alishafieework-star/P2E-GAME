import 'dart:convert';

import '../../domain/models.dart';
import '../sources.dart';
import 'otp_api.dart';

/// D-068: phone OTP for the development HTTP fake. Other auth calls stay local.
final class HttpPhoneSignInSource implements PhoneSignInSource {
  const HttpPhoneSignInSource({required this.transport, required this.base});
  final DevOtpTransport transport;
  final Uri base;

  Future<OtpApiResponse> _send(
    String path,
    Map<String, Object?> body,
    AuthCancellation? cancellation,
  ) => transport.post(base.replace(path: path), jsonEncode(body), cancellation);

  @override
  Future<OtpChallengeDto> requestOtp(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => DevOtpApi.challengeFrom(
    await _send('/auth/otp/request', {
      'destination': e164,
      'rememberDevice': rememberDevice,
    }, cancellation),
  );

  @override
  Future<OtpChallengeDto> resendOtp(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => DevOtpApi.challengeFrom(
    await _send('/auth/otp/resend', {
      'destination': e164,
      'rememberDevice': rememberDevice,
    }, cancellation),
  );

  @override
  Future<PhoneStatusDto> checkPhone(
    String e164,
    AuthCancellation? cancellation,
  ) async {
    final response = await _send('/auth/phone/status', {
      'phone': e164,
    }, cancellation);
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
    DevOtpApi.requireVerified(
      await _send('/auth/phone/password', {
        'phone': e164,
        'password': password,
        'rememberDevice': rememberDevice,
      }, cancellation),
    );
  }

  @override
  Future<OtpChallengeDto> requestReset(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => DevOtpApi.challengeFrom(
    await _send('/auth/phone/reset/request', {
      'destination': e164,
      'rememberDevice': rememberDevice,
    }, cancellation),
  );

  @override
  Future<OtpChallengeDto> resendReset(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async => DevOtpApi.challengeFrom(
    await _send('/auth/phone/reset/resend', {
      'destination': e164,
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
      await _send('/auth/phone/reset/verify', {
        'challengeId': challengeId,
        'code': code,
      }, cancellation),
    );
  }

  @override
  Future<void> createPassword(
    String e164,
    String password,
    AuthCancellation? cancellation,
  ) async {
    DevOtpApi.requireVerified(
      await _send('/auth/phone/password/create', {
        'phone': e164,
        'password': password,
      }, cancellation),
    );
  }

  @override
  Future<void> verifyOtp(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async {
    DevOtpApi.requireVerified(
      await _send('/auth/otp/verify', {
        'challengeId': challengeId,
        'code': code,
      }, cancellation),
    );
  }
}
