import 'package:intl/intl.dart' show NumberFormat;

import 'digits.dart';

final NumberFormat _grouped = NumberFormat.decimalPattern('en');

/// Display-only formatting. Wire identifiers are never passed through this.
String formatWelcomeBonus(
  int points, {
  required String languageCode,
}) => localizedDigits(
  '+${_grouped.format(points).replaceAll(',', languageCode == 'fa' ? '٬' : ',')}',
  languageCode: languageCode,
);
