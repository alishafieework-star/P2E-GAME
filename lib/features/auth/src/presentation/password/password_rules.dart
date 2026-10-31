import 'dart:math' as math;

/// Rules shown on Set a New Password. Figma 18707:15598.
abstract final class PasswordRules {
  static bool longEnough(String value) => value.length >= 8;
  static bool hasNumber(String value) => RegExp('[0-9]').hasMatch(value);
  static bool hasMixedCase(String value) =>
      RegExp('[a-z]').hasMatch(value) && RegExp('[A-Z]').hasMatch(value);
  static bool hasSymbol(String value) => RegExp('[^A-Za-z0-9]').hasMatch(value);

  static int score(String value) => [
    longEnough(value),
    hasNumber(value),
    hasMixedCase(value),
    hasSymbol(value),
  ].where((met) => met).length;

  /// Meter level (HTML prototype): empty is 0, any non-empty password is at
  /// least 1 (Weak).
  static int level(String value) =>
      value.isEmpty ? 0 : math.max(1, score(value));

  static bool acceptable(String value, String confirm) =>
      value.isNotEmpty && value == confirm && score(value) == 4;
}
