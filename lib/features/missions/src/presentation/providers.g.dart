// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(questsRepository)
final questsRepositoryProvider = QuestsRepositoryProvider._();

final class QuestsRepositoryProvider
    extends
        $FunctionalProvider<
          QuestsRepository,
          QuestsRepository,
          QuestsRepository
        >
    with $Provider<QuestsRepository> {
  QuestsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questsRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuestsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuestsRepository create(Ref ref) {
    return questsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuestsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuestsRepository>(value),
    );
  }
}

String _$questsRepositoryHash() => r'8527e934e17aecaba8c2a5872c762fb57107b40b';

@ProviderFor(questBoard)
final questBoardProvider = QuestBoardProvider._();

final class QuestBoardProvider
    extends
        $FunctionalProvider<
          AsyncValue<QuestBoard>,
          QuestBoard,
          FutureOr<QuestBoard>
        >
    with $FutureModifier<QuestBoard>, $FutureProvider<QuestBoard> {
  QuestBoardProvider._()
    : super(
        from: null,
        argument: null,
        retry: retryTransient,
        name: r'questBoardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questBoardHash();

  @$internal
  @override
  $FutureProviderElement<QuestBoard> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<QuestBoard> create(Ref ref) {
    return questBoard(ref);
  }
}

String _$questBoardHash() => r'0cf4d2b281a6c5edc904b80246c667d2566ed91d';

/// Quests whose [gameId] is this game, in board order (D-124).

@ProviderFor(gameQuests)
final gameQuestsProvider = GameQuestsFamily._();

/// Quests whose [gameId] is this game, in board order (D-124).

final class GameQuestsProvider
    extends $FunctionalProvider<List<Quest>, List<Quest>, List<Quest>>
    with $Provider<List<Quest>> {
  /// Quests whose [gameId] is this game, in board order (D-124).
  GameQuestsProvider._({
    required GameQuestsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'gameQuestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameQuestsHash();

  @override
  String toString() {
    return r'gameQuestsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Quest>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Quest> create(Ref ref) {
    final argument = this.argument as String;
    return gameQuests(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Quest> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Quest>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GameQuestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameQuestsHash() => r'0bc77ddaa9deea0e0ee19f217f34f0655dd8344b';

/// Quests whose [gameId] is this game, in board order (D-124).

final class GameQuestsFamily extends $Family
    with $FunctionalFamilyOverride<List<Quest>, String> {
  GameQuestsFamily._()
    : super(
        retry: null,
        name: r'gameQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Quests whose [gameId] is this game, in board order (D-124).

  GameQuestsProvider call(String gameId) =>
      GameQuestsProvider._(argument: gameId, from: this);

  @override
  String toString() => r'gameQuestsProvider';
}

/// Mission tab badge; null while unknown or when nothing needs attention.

@ProviderFor(missionBadgeCount)
final missionBadgeCountProvider = MissionBadgeCountProvider._();

/// Mission tab badge; null while unknown or when nothing needs attention.

final class MissionBadgeCountProvider
    extends $FunctionalProvider<int?, int?, int?>
    with $Provider<int?> {
  /// Mission tab badge; null while unknown or when nothing needs attention.
  MissionBadgeCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'missionBadgeCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$missionBadgeCountHash();

  @$internal
  @override
  $ProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    return missionBadgeCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$missionBadgeCountHash() => r'4ab52c08bf3e08a03e88039ea0a0e331187cb0a9';
