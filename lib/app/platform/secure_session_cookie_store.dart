import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'session_cookie_store.dart';

/// Android Keystore / iOS Keychain via the platform secure store (D-154).
///
/// Android uses EncryptedSharedPreferences. This class does not log values.
final class SecureSessionCookieStore implements SessionCookieStore {
  const SecureSessionCookieStore([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
          );

  static const _key = 'p2e.player.session.cookies';

  final FlutterSecureStorage _storage;

  @override
  Future<Map<String, Map<String, String>>> readAll() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return {};
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      return {};
    }
    if (decoded is! Map) return {};
    return {
      for (final host in decoded.entries)
        if (host.key is String && host.value is Map)
          host.key as String: {
            for (final cookie in (host.value as Map).entries)
              if (cookie.key is String &&
                  cookie.value is String &&
                  sessionCookieNames.contains(cookie.key))
                cookie.key as String: cookie.value as String,
          },
    };
  }

  @override
  Future<void> writeAll(Map<String, Map<String, String>> cookies) async {
    final kept = {
      for (final host in cookies.entries)
        host.key: {
          for (final name in sessionCookieNames)
            if (host.value[name] != null) name: host.value[name]!,
        },
    }..removeWhere((_, value) => value.isEmpty);
    if (kept.isEmpty) {
      await clear();
      return;
    }
    await _storage.write(key: _key, value: jsonEncode(kept));
  }

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
