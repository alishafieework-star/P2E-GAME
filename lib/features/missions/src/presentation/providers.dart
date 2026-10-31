import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/core/errors/retry_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/models.dart';
import '../domain/repositories.dart';

part 'providers.g.dart';

@riverpod
QuestsRepository questsRepository(Ref ref) =>
    throw StateError('Missions composition missing');

@Riverpod(retry: retryTransient)
Future<QuestBoard> questBoard(Ref ref) async =>
    switch (await ref.watch(questsRepositoryProvider).board()) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };

/// Quests whose [gameId] is this game, in board order (D-124).
@riverpod
List<Quest> gameQuests(Ref ref, String gameId) {
  final quests = ref.watch(questBoardProvider).value?.quests;
  if (quests == null || gameId.isEmpty) return const [];
  return [
    for (final quest in quests)
      if (quest.game.gameId == gameId) quest,
  ];
}

/// Mission tab badge; null while unknown or when nothing needs attention.
@riverpod
int? missionBadgeCount(Ref ref) {
  final count = ref.watch(questBoardProvider).value?.attentionCount ?? 0;
  return count > 0 ? count : null;
}
