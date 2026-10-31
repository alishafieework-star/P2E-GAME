import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/shared/formatting/dates.dart';
import 'package:mygame_p2e/shared/formatting/initials.dart';
import 'package:mygame_p2e/shared/formatting/quantities.dart';

void main() {
  test('compact counts and byte sizes follow the source units', () {
    final millions = formatCompact(40000000, languageCode: 'en');
    expect(millions.amount, '40');
    expect(millions.unit, 'M');
    final thousands = formatCompact(500000, languageCode: 'en');
    expect(thousands.amount, '500');
    expect(thousands.unit, 'K');
    expect(formatCompact(40, languageCode: 'fa').amount, '۴۰');
    final size = formatBytes(600833088, languageCode: 'en');
    expect(size.amount, '573');
    expect(size.unit, 'MB');
    expect(
      formatMediumDate(DateTime.utc(2026, 11, 14), languageCode: 'en'),
      'Nov 14, 2026',
    );
    expect(
      formatMediumDate(DateTime.utc(2026, 11, 14), languageCode: 'fa'),
      contains('۲۰۲۶'),
    );
    expect(profileInitial('Alex'), 'A');
    expect(profileInitial('  '), '');
  });
}
