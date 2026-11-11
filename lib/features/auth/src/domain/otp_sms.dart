import 'player_sms_code.dart';

/// D-071: pure SMS code extraction. An ambiguous message returns null.
abstract interface class OtpSmsFormat {
  String? read(String message);
}

/// D-156: one standalone `P-50069` in a player SMS. Anything else is ignored.
final class PlayerSmsCodeFormat implements OtpSmsFormat {
  const PlayerSmsCodeFormat();

  @override
  String? read(String message) => PlayerSmsCode.singleCode(message);
}
