/// Price model shown under the quest's primary action.
enum QuestGameAccess { freeToPlay, inAppPurchases }

final class QuestGame {
  const QuestGame({
    required this.name,
    required this.creator,
    required this.icon,
    required this.access,
    this.gameId = '',
    this.offerTitle,
    this.offerSummary,
    this.banner,
    this.registeredMark = true,
  });

  /// Details page that should list this quest. Empty when the quest is not
  /// tied to a game id (D-124).
  final String gameId;
  final String name, creator;
  final Uri icon;
  final Uri? banner;
  final String? offerTitle, offerSummary;
  final QuestGameAccess access;
  final bool registeredMark;
}

final class QuestStep {
  const QuestStep({required this.rewardPoints, required this.completed});
  final int rewardPoints;
  final bool completed;
}

/// A stepped quest. Completed steps come first; [deadline] is server time.
final class Quest {
  Quest({
    required this.id,
    required this.game,
    required List<QuestStep> steps,
    required this.started,
    required this.deadline,
  }) : steps = List.unmodifiable(steps),
       assert(steps.isNotEmpty) {
    final done = completedSteps;
    if (steps.take(done).any((step) => !step.completed) ||
        (done > 0 && !started)) {
      throw ArgumentError('Completed steps must lead a started quest');
    }
  }

  final String id;
  final QuestGame game;
  final List<QuestStep> steps;
  final bool started;
  final DateTime deadline;

  int get completedSteps => steps.where((step) => step.completed).length;
  int get earnedPoints => steps
      .where((step) => step.completed)
      .fold(0, (sum, step) => sum + step.rewardPoints);
  int get possiblePoints =>
      steps.fold(0, (sum, step) => sum + step.rewardPoints);
}

final class QuestBoard {
  const QuestBoard({required this.quests, required this.attentionCount});
  final List<Quest> quests;

  /// Items that need the player's attention; drives the Mission tab badge.
  final int attentionCount;
}
