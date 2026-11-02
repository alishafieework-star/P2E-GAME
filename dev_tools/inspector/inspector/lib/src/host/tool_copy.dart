import 'generated/tool_copy.g.dart';

String activeToolLocale = 'en';

/// Resolves inspector copy for the active or requested locale.
String toolCopy(
  String key, {
  String? locale,
  Map<String, Object> arguments = const {},
}) {
  final effectiveLocale = locale ?? activeToolLocale;
  final template =
      toolCopyData[effectiveLocale]?[key] ?? toolCopyData['en']![key];
  if (template == null) throw ArgumentError.value(key, 'key');
  var value = template;
  for (final argument in arguments.entries) {
    value = value.replaceAll('{${argument.key}}', argument.value.toString());
  }
  return value;
}
