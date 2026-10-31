import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mygame_p2e/shared/platform/one_time_code.dart';

/// Maps one platform event without retaining it beyond the parser.
OneTimeCodeEvent mapOtpSmsEvent(Object? event) {
  if (event == 'timeout') return const OneTimeCodeTimeout();
  if (event is String && event.isNotEmpty && event != 'unavailable') {
    return OneTimeCodeMessage(event);
  }
  return const OneTimeCodeUnavailable();
}

/// D-071 / PE-003: Android SMS Retriever. Other platforms do not read SMS.
final class PlatformOneTimeCode implements OneTimeCodePort {
  const PlatformOneTimeCode();
  static const channel = EventChannel('ir.mci.mygame.p2e/otp_sms');
  static const access = MethodChannel('ir.mci.mygame.p2e/otp_sms_access');

  @override
  Stream<OneTimeCodeEvent> listen() {
    // PLATFORM(PE-003): iOS keeps the oneTimeCode keyboard suggestion.
    if (!Platform.isAndroid) return const Stream.empty();
    return _open();
  }

  Stream<OneTimeCodeEvent> _open() async* {
    yield* channel.receiveBroadcastStream().map(mapOtpSmsEvent);
  }
}

/// PLATFORM(PE-003): asks for RECEIVE_SMS only where the build declares it.
final class PlatformOneTimeCodeAccess implements OneTimeCodeAccess {
  const PlatformOneTimeCodeAccess();

  Future<bool> _call(String method) async {
    if (!Platform.isAndroid) return true;
    try {
      return await PlatformOneTimeCode.access.invokeMethod<bool>(method) ??
          false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> granted() => _call('status');

  @override
  Future<bool> request() => _call('ensure');
}
