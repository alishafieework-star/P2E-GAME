import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mygame_p2e/shared/platform/one_time_code.dart';

/// Maps one platform event without retaining it beyond the parser.
OneTimeCodeEvent mapOtpSmsEvent(Object? event) {
  if (event == 'timeout') return const OneTimeCodeTimeout();
  if (event == 'consent_denied') return const OneTimeCodeConsentDenied();
  if (event is String && event.isNotEmpty && event != 'unavailable') {
    return OneTimeCodeMessage(event);
  }
  return const OneTimeCodeUnavailable();
}

/// D-156 / PE-005: Android SMS User Consent. Other platforms do not read SMS.
final class PlatformOneTimeCode implements OneTimeCodePort {
  const PlatformOneTimeCode();
  static const channel = EventChannel('ir.mci.mygame.p2e/otp_sms');
  static const access = MethodChannel('ir.mci.mygame.p2e/otp_sms_access');

  @override
  Stream<OneTimeCodeEvent> listen({String? sender}) {
    // PLATFORM(PE-005): iOS keeps the oneTimeCode keyboard suggestion.
    if (!Platform.isAndroid) return const Stream.empty();
    return channel.receiveBroadcastStream(sender).map(mapOtpSmsEvent);
  }
}

/// PLATFORM(PE-005): SMS User Consent needs no inbox permission.
final class PlatformOneTimeCodeAccess implements OneTimeCodeAccess {
  const PlatformOneTimeCodeAccess();

  @override
  Future<bool> granted() async => true;

  @override
  Future<bool> request() async => true;
}
