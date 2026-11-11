/// Cookies this app persists. Anything else stays out of the store (D-154).
const sessionCookieNames = ['AuthToken', 'AuthRemember', 'PlayerPreAuth'];

/// Host-keyed session cookies. Values stay in this object and are never logged.
///
/// D-154: the domain and presentation layers do not see cookie values.
abstract interface class SessionCookieStore {
  Future<Map<String, Map<String, String>>> readAll();

  Future<void> writeAll(Map<String, Map<String, String>> cookies);

  Future<void> clear();
}

/// Process-local stand-in for tests and for a transport that has no store.
final class MemorySessionCookieStore implements SessionCookieStore {
  final Map<String, Map<String, String>> jars = {};

  @override
  Future<Map<String, Map<String, String>>> readAll() async => {
    for (final entry in jars.entries)
      entry.key: Map<String, String>.of(entry.value),
  };

  @override
  Future<void> writeAll(Map<String, Map<String, String>> cookies) async {
    jars
      ..clear()
      ..addAll({
        for (final entry in cookies.entries)
          if (entry.value.isNotEmpty)
            entry.key: Map<String, String>.of(entry.value),
      });
  }

  @override
  Future<void> clear() async => jars.clear();
}
