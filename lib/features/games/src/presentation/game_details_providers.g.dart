// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_details_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gameDetailsRepository)
final gameDetailsRepositoryProvider = GameDetailsRepositoryProvider._();

final class GameDetailsRepositoryProvider
    extends
        $FunctionalProvider<
          GameDetailsRepository,
          GameDetailsRepository,
          GameDetailsRepository
        >
    with $Provider<GameDetailsRepository> {
  GameDetailsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameDetailsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameDetailsRepositoryHash();

  @$internal
  @override
  $ProviderElement<GameDetailsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GameDetailsRepository create(Ref ref) {
    return gameDetailsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameDetailsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameDetailsRepository>(value),
    );
  }
}

String _$gameDetailsRepositoryHash() =>
    r'57ff72cded115cded7efd3b2f2acde8c06c0baae';

@ProviderFor(gameBookmarkStore)
final gameBookmarkStoreProvider = GameBookmarkStoreProvider._();

final class GameBookmarkStoreProvider
    extends
        $FunctionalProvider<
          GameBookmarkStore,
          GameBookmarkStore,
          GameBookmarkStore
        >
    with $Provider<GameBookmarkStore> {
  GameBookmarkStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameBookmarkStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameBookmarkStoreHash();

  @$internal
  @override
  $ProviderElement<GameBookmarkStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GameBookmarkStore create(Ref ref) {
    return gameBookmarkStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameBookmarkStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameBookmarkStore>(value),
    );
  }
}

String _$gameBookmarkStoreHash() => r'd4595a8789917aa36def5263408eb711a3b0ba71';

/// Deletes cached details and bookmarks when the session ends (D-123).

@ProviderFor(gameDetailsSession)
final gameDetailsSessionProvider = GameDetailsSessionProvider._();

/// Deletes cached details and bookmarks when the session ends (D-123).

final class GameDetailsSessionProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Deletes cached details and bookmarks when the session ends (D-123).
  GameDetailsSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameDetailsSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameDetailsSessionHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return gameDetailsSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$gameDetailsSessionHash() =>
    r'1f86687982a22bd187d057138282afc046f10c49';

@ProviderFor(gameDetails)
final gameDetailsProvider = GameDetailsFamily._();

final class GameDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<GameDetailsSnapshot>,
          GameDetailsSnapshot,
          FutureOr<GameDetailsSnapshot>
        >
    with
        $FutureModifier<GameDetailsSnapshot>,
        $FutureProvider<GameDetailsSnapshot> {
  GameDetailsProvider._({
    required GameDetailsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: retryTransient,
         name: r'gameDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameDetailsHash();

  @override
  String toString() {
    return r'gameDetailsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GameDetailsSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GameDetailsSnapshot> create(Ref ref) {
    final argument = this.argument as (String, String);
    return gameDetails(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is GameDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameDetailsHash() => r'ac000a28c304efd63fbd89ab72810ed6c15d6e04';

final class GameDetailsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<GameDetailsSnapshot>,
          (String, String)
        > {
  GameDetailsFamily._()
    : super(
        retry: retryTransient,
        name: r'gameDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GameDetailsProvider call(String id, String languageCode) =>
      GameDetailsProvider._(argument: (id, languageCode), from: this);

  @override
  String toString() => r'gameDetailsProvider';
}

@ProviderFor(GameBookmarks)
final gameBookmarksProvider = GameBookmarksProvider._();

final class GameBookmarksProvider
    extends $AsyncNotifierProvider<GameBookmarks, Set<String>> {
  GameBookmarksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameBookmarksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameBookmarksHash();

  @$internal
  @override
  GameBookmarks create() => GameBookmarks();
}

String _$gameBookmarksHash() => r'2cd13a18e010bd1e4e1438fc734bb8535cfb8901';

abstract class _$GameBookmarks extends $AsyncNotifier<Set<String>> {
  FutureOr<Set<String>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<String>>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<String>>, Set<String>>,
              AsyncValue<Set<String>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
