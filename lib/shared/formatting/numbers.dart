import 'package:intl/intl.dart' show NumberFormat;

import 'digits.dart';

/// Grouping in English digits; reused, because per-call intl allocation is
/// pure waste on every badge and row build.
final NumberFormat _grouped = NumberFormat.decimalPattern('en');

/// Display-only grouped integer in the locale's digits and separator.
String formatCount(int value, {required String languageCode}) =>
    localizedDigits(
      _grouped.format(value).replaceAll(',', languageCode == 'fa' ? '٬' : ','),
      languageCode: languageCode,
    );

/// An earned amount, shown with a leading plus sign.
String formatGain(int value, {required String languageCode}) =>
    '+${formatCount(value, languageCode: languageCode)}';

/// One decimal place, with the locale's decimal separator.
String formatRating(double value, {required String languageCode}) =>
    localizedDigits(
      value
          .toStringAsFixed(1)
          .replaceAll('.', languageCode == 'fa' ? '٫' : '.'),
      languageCode: languageCode,
    );

/// A zero-padded two-digit clock value.
String formatTwoDigits(int value, {required String languageCode}) =>
    localizedDigits(
      value.toString().padLeft(2, '0'),
      languageCode: languageCode,
    );
