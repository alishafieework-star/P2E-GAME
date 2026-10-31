import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/shared/platform/one_time_code.dart';

import '../domain/otp_sms.dart';

/// The app supplies the development format only while the fake backend is on.
final otpSmsFormatProvider = Provider<OtpSmsFormat?>((_) => null);

/// Keeps the extracted code, never the SMS text.
class OtpCodeListener extends Notifier<String?> {
  StreamSubscription<OneTimeCodeEvent>? _subscription;

  @override
  String? build() {
    ref.onDispose(stop);
    return null;
  }

  void arm() {
    final format = ref.read(otpSmsFormatProvider);
    if (format == null) return;
    stop();
    _subscription = ref.read(oneTimeCodePortProvider).listen().listen((event) {
      if (event is! OneTimeCodeMessage) return;
      final code = format.read(event.body);
      if (code == null || !ref.mounted) return;
      state = code;
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}

final otpCodeListenerProvider = NotifierProvider<OtpCodeListener, String?>(
  OtpCodeListener.new,
);
