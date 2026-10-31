import 'json_store.dart';

/// Process-local store for tests and fixtures.
final class MemoryJsonStore implements JsonStore {
  final _values = <String, String>{};

  @override
  Future<String?> read(String key) async => _values[requireStoreKey(key)];

  @override
  Future<void> write(String key, String value) async {
    _values[requireStoreKey(key)] = value;
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(requireStoreKey(key));
  }

  @override
  Future<List<String>> keys() async => _values.keys.toList()..sort();
}
