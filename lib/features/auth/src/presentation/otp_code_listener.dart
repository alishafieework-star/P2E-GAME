import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/core/diagnostics/app_logger.dart';
import 'package:mygame_p2e/shared/platform/one_time_code.dart';

import '../domain/otp_sms.dart';
import '../domain/player_sms_code.dart';

/// The app supplies the development format only while the fake backend is on.
/// Remote builds use [PlayerSmsCodeFormat] (D-156).
final otpSmsFormatProvider = Provider<OtpSmsFormat?>((_) => null);

/// Keeps the extracted code, never the SMS text.
class OtpCodeListener extends Notifier<String?> {
  StreamSubscription<OneTimeCodeEvent>? _subscription;
  int _attempt = 0;

  @override
  String? build() {
    ref.onDispose(stop);
    return null;
  }

  /// Starts a new attempt. A code from the previous attempt is dropped.
  void arm() {
    final attempt = ++_attempt;
    _subscription?.cancel();
    _subscription = null;
    state = null;
    final format = ref.read(otpSmsFormatProvider);
    if (format == null) return;
    _subscription = ref
        .read(oneTimeCodePortProvider)
        .listen(sender: PlayerSmsCode.androidSender)
        .listen((event) {
          if (attempt != _attempt || !ref.mounted) return;
          switch (event) {
            case OneTimeCodeMessage(:final body):
              final code = format.read(body);
              if (code == null) return;
              state = code;
            case OneTimeCodeTimeout():
              AppLogger().log(
                LogLevel.debug,
                'otp',
                fields: {'event': 'autofill_timeout'},
              );
            case OneTimeCodeConsentDenied():
              AppLogger().log(
                LogLevel.debug,
                'otp',
                fields: {'event': 'consent_denied'},
              );
            case OneTimeCodeUnavailable():
              break;
          }
        });
  }

  /// Drops a code that belongs to a failed, replaced or abandoned attempt.
  void invalidate() {
    stop();
    if (ref.mounted) state = null;
  }

  void stop() {
    _attempt++;
    _subscription?.cancel();
    _subscription = null;
  }
}

final otpCodeListenerProvider = NotifierProvider<OtpCodeListener, String?>(
  OtpCodeListener.new,
);
