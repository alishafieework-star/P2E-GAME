/// A small string store. Keys are logical (`game/en/id`), never raw paths.
abstract interface class JsonStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<List<String>> keys();
}

final _key = RegExp(r'^[a-z0-9][a-z0-9_./-]{0,160}$');

String requireStoreKey(String key) {
  if (!_key.hasMatch(key) || key.contains('..')) {
    throw ArgumentError.value(key, 'key', 'Unsafe store key');
  }
  return key;
}
