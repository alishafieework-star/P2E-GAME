import 'dart:io';

import 'json_store.dart';

/// Cache-directory JSON files. One store may hold several key prefixes.
final class FileJsonStore implements JsonStore {
  FileJsonStore(this._directory);
  final Future<Directory> _directory;

  /// Write chains per key: two writes to one key never interleave, so the
  /// rename always publishes a fully written temporary file. Completed tails
  /// are pruned to keep the map bounded.
  final Map<String, Future<void>> _writes = {};

  Future<Directory> _dir() async {
    final directory = await _directory;
    if (!await directory.exists()) await directory.create(recursive: true);
    return directory;
  }

  File _file(Directory directory, String key) => File(
    '${directory.path}${Platform.pathSeparator}${requireStoreKey(key).replaceAll('/', '__')}.json',
  );

  @override
  Future<String?> read(String key) async {
    final file = _file(await _dir(), key);
    if (!await file.exists()) return null;
    return file.readAsString();
  }

  @override
  Future<void> write(String key, String value) {
    final previous = _writes[key] ?? Future.value();
    final operation = previous.then((_) => _writeNow(key, value));
    final tail = operation.catchError((_) {});
    _writes[key] = tail;
    tail.whenComplete(() {
      if (identical(_writes[key], tail)) _writes.remove(key);
    });
    return operation;
  }

  Future<void> _writeNow(String key, String value) async {
    final file = _file(await _dir(), key);
    // A unique temporary name: a concurrent writer of the same key can never
    // clobber another write's temporary file before its rename.
    final temporary = File(
      '${file.path}.${DateTime.now().microsecondsSinceEpoch}.tmp',
    );
    try {
      await temporary.writeAsString(value, flush: true);
      if (await file.exists()) await file.delete();
      await temporary.rename(file.path);
    } on Exception {
      if (await temporary.exists()) await temporary.delete();
      rethrow;
    }
  }

  @override
  Future<void> delete(String key) async {
    final file = _file(await _dir(), key);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<List<String>> keys() async {
    final directory = await _dir();
    if (!await directory.exists()) return const [];
    final names = <String>[];
    await for (final entity in directory.list()) {
      if (entity is File && entity.path.endsWith('.json')) {
        names.add(_decode(entity.uri.pathSegments.last));
      }
    }
    return names..sort();
  }

  String _decode(String filename) =>
      filename.substring(0, filename.length - 5).replaceAll('__', '/');
}
