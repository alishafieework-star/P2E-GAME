import 'dart:convert';
import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error }

abstract final class PiiRedactor {
  static final _sensitiveKey = RegExp(
    r'phone|mobile|email|identifier|otp|token|authorization|password|secret|رمز|تلفن',
    caseSensitive: false,
  );
  // Compiled once; every log line would otherwise rebuild all five.
  static final _email = RegExp(r'''[^\s<>@]+@[^\s<>@]+\.[^\s<>@]+''');
  static final _bearer = RegExp(r'Bearer\s+[^\s,;]+', caseSensitive: false);
  static final _jwt = RegExp(
    r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+',
  );
  static final _assignedSecret = RegExp(
    r'''(?:token|otp|password|secret|authorization|cookie|authtoken|playerpreauth|authremember)\s*[:=]\s*[^\s,;]+''',
    caseSensitive: false,
  );
  static final _jsonSecret = RegExp(
    r'"(?:password|newPassword|token|authorization|cookie|authToken)"\s*:\s*"(?:\\.|[^"\\])*"',
    caseSensitive: false,
  );
  static final _phone = RegExp(r'\+?[0-9۰-۹٠-٩][0-9۰-۹٠-٩ ()-]{2,}[0-9۰-۹٠-٩]');

  static String text(String value) => value
      .replaceAll(_email, '[REDACTED]')
      .replaceAll(_bearer, 'Bearer [REDACTED]')
      .replaceAll(_jwt, '[REDACTED]')
      .replaceAll(_jsonSecret, '"[REDACTED]"')
      .replaceAll(_assignedSecret, '[REDACTED]')
      .replaceAll(_phone, '[REDACTED]');

  static Object? value(Object? input) => switch (input) {
    Map() => {
      for (final entry in input.entries)
        text(entry.key.toString()): _sensitiveKey.hasMatch(entry.key.toString())
            ? '[REDACTED]'
            : value(entry.value),
    },
    Iterable() => input.map(value).toList(),
    String() => text(input),
    num() => text(input.toString()),
    null || bool() => input,
    _ => '[UNSUPPORTED]', // Never invoke arbitrary object's toString on a log path.
  };
}

/// All sinks receive redacted data; no network/crash SDK is installed.
final class AppLogger {
  AppLogger({this.minimumLevel = LogLevel.info, void Function(String)? sink})
    : _sink = sink ?? ((line) => developer.log(line, name: 'p2e'));
  final LogLevel minimumLevel;
  final void Function(String) _sink;
  void log(
    LogLevel level,
    String message, {
    Map<String, Object?> fields = const {},
  }) {
    if (level.index < minimumLevel.index) return;
    _sink(
      jsonEncode({
        'level': level.name,
        'message': PiiRedactor.text(message),
        'fields': PiiRedactor.value(fields),
      }),
    );
  }
}
