import 'models.dart';

/// Player SMS OTP shape from the Users contract: one letter, a dash, five digits.
///
/// The dash is not stored. The field value is the letter plus the digits (`P50069`).
/// The data layer still prepends `codePrefix`, so verify sends the digits only.
abstract final class PlayerSmsCode {
  static const digitCount = 5;

  /// Android SMS User Consent sender until a challenge carries one (D-156).
  static const androidSender = '+9810000001950';

  static final _prefix = RegExp(r'^[A-Za-z]-$');

  /// A complete code standing on its own. Letter, then five ASCII digits.
  static final _code = RegExp(
    r'(?:^|[^A-Za-z0-9])([A-Za-z])-([0-9]{5})(?![A-Za-z0-9])',
  );

  static bool isSegmented(OtpChallenge challenge) =>
      _prefix.hasMatch(challenge.codePrefix) &&
      challenge.codeLength == digitCount;

  static String letterOf(OtpChallenge challenge) =>
      challenge.codePrefix[0].toUpperCase();

  /// One `P50069` when the message has exactly one distinct code. Otherwise null.
  static String? singleCode(String message) {
    final codes = _codes(_normalize(message));
    if (codes.length != 1) return null;
    return _compact(codes.single);
  }

  /// Field text for a parsed code that matches [challenge]. Null keeps the
  /// player's current value.
  static String? fieldFor(String parsed, OtpChallenge challenge) {
    if (!isSegmented(challenge)) return null;
    final compact = _asCompact(parsed);
    if (compact == null) return null;
    if (compact[0] != letterOf(challenge)) return null;
    return compact;
  }

  /// Typing and paste. Null means the text is ambiguous and must be left as it was.
  static String? edit(String raw, String prefixLetter) {
    final text = _normalize(raw);
    if (text.contains('-')) {
      final codes = _codes(text);
      if (codes.length > 1) return null;
      if (codes.length == 1) return _compact(codes.single);
    }
    if (RegExp(r'^[0-9]{5}$').hasMatch(text) && prefixLetter.length == 1) {
      return '$prefixLetter$text';
    }
    final letter = RegExp('[A-Za-z]').firstMatch(text)?.group(0)?.toUpperCase();
    final digits = text.replaceAll(RegExp('[^0-9]'), '');
    final taken = digits.length > digitCount
        ? digits.substring(0, digitCount)
        : digits;
    if (letter == null) return taken;
    return '$letter$taken';
  }

  static int digitsIn(String value) =>
      _normalize(value).replaceAll(RegExp('[^0-9]'), '').length;

  static bool letterMismatch(String value, OtpChallenge challenge) {
    if (!isSegmented(challenge)) return false;
    final letter = RegExp('[A-Za-z]').firstMatch(_normalize(value))?.group(0);
    if (letter == null) return false;
    return letter.toUpperCase() != letterOf(challenge);
  }

  /// Digits for the data layer, which adds [OtpChallenge.codePrefix] itself.
  /// A non-segmented challenge returns [value] when its length matches.
  static String? wireDigits(String value, OtpChallenge challenge) {
    if (!isSegmented(challenge)) {
      return value.length == challenge.codeLength ? value : null;
    }
    if (letterMismatch(value, challenge)) return null;
    final digits = _normalize(value).replaceAll(RegExp('[^0-9]'), '');
    if (digits.length != challenge.codeLength) return null;
    return digits;
  }

  static String _normalize(String value) => String.fromCharCodes(
    value.runes.map((rune) {
      if (rune >= 0x06f0 && rune <= 0x06f9) return rune - 0x06f0 + 0x30;
      if (rune >= 0x0660 && rune <= 0x0669) return rune - 0x0660 + 0x30;
      return rune;
    }),
  );

  static Set<String> _codes(String text) {
    final found = <String>{};
    for (final match in _code.allMatches(text)) {
      final letter = match.group(1)!.toUpperCase();
      found.add('$letter-${match.group(2)}');
    }
    return found;
  }

  static String _compact(String dashed) => '${dashed[0]}${dashed.substring(2)}';

  static String? _asCompact(String parsed) {
    final text = _normalize(parsed);
    if (RegExp(r'^[A-Za-z][0-9]{5}$').hasMatch(text)) {
      return '${text[0].toUpperCase()}${text.substring(1)}';
    }
    final codes = _codes(text);
    if (codes.length != 1) return null;
    return _compact(codes.single);
  }
}
