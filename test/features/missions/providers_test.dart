import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/features/missions/missions.dart';
import 'package:mygame_p2e/features/missions/missions_data.dart';

final _media = Uri.parse('http://media.test/');
final _now = DateTime.utc(2026, 10, 24, 12);

final class _FailingQuestsRepository implements QuestsRepository {
  const _FailingQuestsRepository();
  @override
  Future<Result<QuestBoard>> board() async =>
      const Failure(BusinessFailure('not_configured'));
}

void main() {
  test('fake board keeps the source order and attention count', () async {
    final repository = FakeQuestsRepository(_media, now: () => _now);
    final result = await repository.board();
    final board = (result as Success<QuestBoard>).value;
    expect(board.attentionCount, 1);
    expect(board.quests.map((quest) => quest.id).toList(), [
      'clash_royal',
      'eight_ball_pool',
    ]);
    // Deadlines hold from the first request, like a server deadline.
    final again = await repository.board();
    expect(
      (again as Success<QuestBoard>).value.quests.first.deadline,
      board.quests.first.deadline,
    );
  });

  test(
    'the unconfigured remote stub surfaces its business failure at once',
    () {
      final container = ProviderContainer(
        overrides: [
          questsRepositoryProvider.overrideWithValue(
            const _FailingQuestsRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      expect(
        container.read(questBoardProvider.future),
        throwsA(isA<BusinessFailure>()),
      );
    },
  );

  test('quest board serves the fake sample', () async {
    final container = ProviderContainer(
      overrides: [
        questsRepositoryProvider.overrideWithValue(
          FakeQuestsRepository(_media, now: () => _now),
        ),
      ],
    );
    addTearDown(container.dispose);
    final board = await container.read(questBoardProvider.future);
    expect(board.quests, hasLength(2));
  });

  test('game quests filter by gameId in board order', () async {
    final container = ProviderContainer(
      overrides: [
        questsRepositoryProvider.overrideWithValue(
          FakeQuestsRepository(_media, now: () => _now),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(questBoardProvider.future);
    expect(container.read(gameQuestsProvider('clash_royal')).map((q) => q.id), [
      'clash_royal',
    ]);
    expect(
      container.read(gameQuestsProvider('eight_ball_pool')).first.id,
      'eight_ball_pool',
    );
    // D-124: an empty gameId lists nothing.
    expect(container.read(gameQuestsProvider('')), isEmpty);
    expect(container.read(gameQuestsProvider('unknown_game')), isEmpty);
  });

  test('mission badge count hides when nothing needs attention', () async {
    final container = ProviderContainer(
      overrides: [
        questsRepositoryProvider.overrideWithValue(
          FakeQuestsRepository(_media, now: () => _now),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(questBoardProvider.future);
    expect(container.read(missionBadgeCountProvider), 1);

    final quiet = ProviderContainer(
      overrides: [
        questBoardProvider.overrideWith(
          (ref) =>
              Future.value(const QuestBoard(quests: [], attentionCount: 0)),
        ),
      ],
    );
    addTearDown(quiet.dispose);
    expect(quiet.read(missionBadgeCountProvider), isNull);
  });

  test('quest reward arithmetic follows completed leading steps', () {
    final quest = Quest(
      id: 'probe',
      game: QuestGame(
        name: 'Probe',
        creator: 'Studio',
        icon: _media,
        access: QuestGameAccess.freeToPlay,
      ),
      started: true,
      steps: const [
        QuestStep(rewardPoints: 250, completed: true),
        QuestStep(rewardPoints: 500, completed: true),
        QuestStep(rewardPoints: 1000, completed: false),
      ],
      deadline: _now.add(const Duration(hours: 1)),
    );
    expect(quest.completedSteps, 2);
    expect(quest.earnedPoints, 750);
    expect(quest.possiblePoints, 1750);
  });

  test('completed steps must lead a started quest', () {
    expect(
      () => Quest(
        id: 'bad',
        game: QuestGame(
          name: 'Bad',
          creator: 'Studio',
          icon: _media,
          access: QuestGameAccess.freeToPlay,
        ),
        started: true,
        steps: const [
          QuestStep(rewardPoints: 250, completed: false),
          QuestStep(rewardPoints: 500, completed: true),
        ],
        deadline: _now,
      ),
      throwsArgumentError,
    );
  });
}
