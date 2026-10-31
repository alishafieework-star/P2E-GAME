import 'dart:async';

import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/core/errors/retry_policy.dart';
import 'package:mygame_p2e/shared/session/session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/game_details.dart';
import '../domain/game_details_repository.dart';

part 'game_details_providers.g.dart';

@riverpod
GameDetailsRepository gameDetailsRepository(Ref ref) =>
    throw StateError('Game details composition missing');

@Riverpod(keepAlive: true)
GameBookmarkStore gameBookmarkStore(Ref ref) =>
    throw StateError('Bookmark store composition missing');

/// Deletes cached details and bookmarks when the session ends (D-123).
@riverpod
void gameDetailsSession(Ref ref) {
  ref.listen(sessionControllerProvider, (previous, next) {
    if (next == SessionStatus.signedIn) return;
    unawaited(ref.read(gameDetailsRepositoryProvider).clear());
    unawaited(ref.read(gameBookmarksProvider.notifier).clear());
  });
}

@Riverpod(retry: retryTransient)
Future<GameDetailsSnapshot> gameDetails(
  Ref ref,
  String id,
  String languageCode,
) async {
  final result = await ref
      .watch(gameDetailsRepositoryProvider)
      .details(id, languageCode: languageCode);
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}

@Riverpod(keepAlive: true)
class GameBookmarks extends _$GameBookmarks {
  Future<void> _pending = Future.value();

  @override
  Future<Set<String>> build() => ref.watch(gameBookmarkStoreProvider).read();

  /// Serializes read-modify-write cycles so overlapping toggles accumulate
  /// instead of overwriting each other. Caller futures keep their own errors;
  /// the chain itself survives a failed write.
  Future<void> toggle(String id) {
    final operation = _pending.then((_) => _toggleNow(id));
    _pending = operation.catchError((_) {});
    return operation;
  }

  Future<void> _toggleNow(String id) async {
    final store = ref.read(gameBookmarkStoreProvider);
    // The initial store read may still be running; deriving the set from a
    // null value would persist a partial set and lose the stored bookmarks.
    final previous = state.value ?? await store.read();
    final next = {...previous};
    if (!next.add(id)) next.remove(id);
    state = AsyncData(next);
    try {
      await store.write(next);
    } catch (_) {
      // The store keeps the last persisted set; match memory to it instead of
      // leaving the optimistic state on disk that never happened (D-123).
      if (ref.mounted) state = AsyncData(previous);
    }
  }

  Future<void> clear() async {
    await ref.read(gameBookmarkStoreProvider).clear();
    state = const AsyncData({});
  }
}
