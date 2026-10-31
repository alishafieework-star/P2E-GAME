/// The first code point of a display name, uppercased. Empty when [name] is blank.
String profileInitial(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '';
  return String.fromCharCode(trimmed.runes.first).toUpperCase();
}
