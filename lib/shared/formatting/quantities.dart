import 'digits.dart';

/// A scaled amount and its Latin unit (`K`, `M`, `B`), or an empty unit.
final class CompactQuantity {
  const CompactQuantity(this.amount, this.unit);
  final String amount, unit;
}

/// Groups below 1,000 and scales above that. Digits follow [languageCode].
CompactQuantity formatCompact(int value, {required String languageCode}) {
  if (value < 0) {
    throw ArgumentError.value(value, 'value', 'Counts are not negative');
  }
  const units = ['', 'K', 'M', 'B'];
  var scaled = value;
  var unit = 0;
  while (scaled >= 1000 && unit < units.length - 1) {
    final next = scaled ~/ 1000;
    final remainder = scaled % 1000;
    scaled = remainder >= 500 ? next + 1 : next;
    unit++;
  }
  if (scaled >= 1000 && unit < units.length - 1) {
    scaled = 1;
    unit++;
  }
  return CompactQuantity(
    localizedDigits('$scaled', languageCode: languageCode),
    units[unit],
  );
}

/// Binary size. The unit stays the source Latin abbreviation (D-121).
final class ByteSize {
  const ByteSize(this.amount, this.unit);
  final String amount, unit;
}

ByteSize formatBytes(int bytes, {required String languageCode}) {
  if (bytes < 0) {
    throw ArgumentError.value(bytes, 'bytes', 'Sizes are not negative');
  }
  const kb = 1024;
  const mb = kb * 1024;
  const gb = mb * 1024;
  final (amount, unit) = switch (bytes) {
    >= gb => (bytes / gb, 'GB'),
    >= mb => (bytes / mb, 'MB'),
    >= kb => (bytes / kb, 'KB'),
    _ => (bytes.toDouble(), 'B'),
  };
  final rounded = amount.round();
  return ByteSize(
    localizedDigits('$rounded', languageCode: languageCode),
    unit,
  );
}
