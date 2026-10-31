import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/games/games.dart';

/// Store whose reads are gated and whose writes can be made to fail.
class _GatedBookmarks implements GameBookmarkStore {
  final Completer<void> gate = Completer<void>();
  final stored = <String>{'existing'};
  bool failWrite = false;
  int writes = 0;

  @override
  Future<Set<String>> read() async {
    await gate.future;
    return {...stored};
  }

  @override
  Future<void> write(Set<String> next) async {
    writes++;
    if (failWrite) throw StateError('disk failure');
    stored
      ..clear()
      ..addAll(next);
  }

  @override
  Future<void> clear() async => stored.clear();
}

void main() {
  test(
    'toggle during the initial store read preserves the stored set',
    () async {
      final store = _GatedBookmarks();
      final container = ProviderContainer(
        overrides: [gameBookmarkStoreProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);

      // The store read is still gated: state.value is null in this window.
      final toggle = container
          .read(gameBookmarksProvider.notifier)
          .toggle('new');
      store.gate.complete();
      await toggle;

      expect(store.stored, {'existing', 'new'});
      expect(store.writes, 1);
      expect(await container.read(gameBookmarksProvider.future), {
        'existing',
        'new',
      });
    },
  );

  test('overlapping toggles accumulate instead of overwriting', () async {
    final store = _GatedBookmarks();
    store.gate.complete();
    final container = ProviderContainer(
      overrides: [gameBookmarkStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    await container.read(gameBookmarksProvider.future);

    await Future.wait([
      container.read(gameBookmarksProvider.notifier).toggle('a'),
      container.read(gameBookmarksProvider.notifier).toggle('b'),
    ]);

    expect(store.stored, {'existing', 'a', 'b'});
  });

  test('a failed write rolls the optimistic state back to the store', () async {
    final store = _GatedBookmarks();
    store.gate.complete();
    final container = ProviderContainer(
      overrides: [gameBookmarkStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    await container.read(gameBookmarksProvider.future);

    store.failWrite = true;
    await container.read(gameBookmarksProvider.notifier).toggle('lost');

    expect(store.stored, {'existing'});
    expect(await container.read(gameBookmarksProvider.future), {'existing'});
  });
}
