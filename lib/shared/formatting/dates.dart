import 'digits.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Gregorian medium date in the source English shape. Persian keeps that
/// calendar and uses Persian digits (D-049). A Jalali calendar is out of scope.
String formatMediumDate(DateTime date, {required String languageCode}) {
  final formatted = '${_months[date.month - 1]} ${date.day}, ${date.year}';
  return localizedDigits(formatted, languageCode: languageCode);
}
