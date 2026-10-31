import '../../domain/otp_sms.dart';

/// Development SMS shape. It is not the production pattern.
final class DevOtpSmsFormat implements OtpSmsFormat {
  const DevOtpSmsFormat();
  static final _code = RegExp(r'MyGame code: ([A-Za-z0-9]{6})(?=\s|$)');

  @override
  String? read(String message) {
    final matches = _code.allMatches(message).toList();
    if (matches.length != 1) return null;
    return matches.single.group(1);
  }
}
