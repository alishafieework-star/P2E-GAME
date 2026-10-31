import 'package:mygame_p2e/core/errors/app_failure.dart';

import 'game_details.dart';

abstract interface class GameDetailsRepository {
  Future<Result<GameDetailsSnapshot>> details(
    String id, {
    required String languageCode,
  });

  /// Drops cached payloads. Bookmarks are a separate store.
  Future<void> clear();
}

/// Device-local bookmark ids. Not a server resource (D-123).
abstract interface class GameBookmarkStore {
  Future<Set<String>> read();
  Future<void> write(Set<String> ids);
  Future<void> clear();
}
