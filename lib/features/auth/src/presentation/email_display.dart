/// Shortens a long address the way the password and reset frames do.
String compactEmail(String email) {
  const limit = 26;
  if (email.length <= limit) return email;
  return '${email.substring(0, limit - 3)}...';
}

String emailInitial(String email) {
  final trimmed = email.trim();
  if (trimmed.isEmpty) return '';
  return trimmed[0].toUpperCase();
}
