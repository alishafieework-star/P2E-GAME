import 'package:flutter/services.dart';

import '../../../../../app/platform/agent_debug_log.dart';
import '../../domain/player_sms_code.dart';

/// Keeps a player SMS code as one letter plus up to five ASCII digits.
final class PlayerOtpInputFormatter extends TextInputFormatter {
  const PlayerOtpInputFormatter(this.prefixLetter);
  final String prefixLetter;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final next = PlayerSmsCode.edit(newValue.text, prefixLetter);
    // #region agent log
    agentDebugLog(
      location: 'player_otp_input.dart:formatEditUpdate',
      message: 'otp edit',
      hypothesisId: 'H5',
      data: {
        'oldLen': oldValue.text.length,
        'incomingLen': newValue.text.length,
        'nextLen': next?.length,
        'keptOld': next == null,
        'prefixSupplied': prefixLetter.length == 1,
      },
    );
    // #endregion
    if (next == null) return oldValue;
    return TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
  }
}
