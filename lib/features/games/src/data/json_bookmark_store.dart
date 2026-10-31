import 'dart:convert';

import 'package:mygame_p2e/core/storage/json_store.dart';

import '../domain/game_details_repository.dart';

/// Bookmark ids in the shared JSON store (D-123).
final class JsonGameBookmarkStore implements GameBookmarkStore {
  const JsonGameBookmarkStore(this.store);
  final JsonStore store;
  static const key = 'bookmark/ids';

  @override
  Future<Set<String>> read() async {
    final raw = await store.read(key);
    if (raw == null) return {};
    final decoded = jsonDecode(raw);
    if (decoded is! List) return {};
    return {
      for (final item in decoded)
        if (item is String && RegExp(r'^[a-z0-9_]+$').hasMatch(item)) item,
    };
  }

  @override
  Future<void> write(Set<String> ids) async {
    final sorted = ids.toList()..sort();
    await store.write(key, jsonEncode(sorted));
  }

  @override
  Future<void> clear() => store.delete(key);
}
