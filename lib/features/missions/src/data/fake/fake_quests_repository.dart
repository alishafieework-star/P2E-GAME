import 'package:mygame_p2e/core/errors/app_failure.dart';

import '../../domain/models.dart';
import '../../domain/repositories.dart';

/// D-102: in-process sample quests copied from the Home source
/// (docs/snapshots/2026-10-24_home/evidence/details.json). Deadlines keep the
/// source's remaining time from the first request, like a server deadline.
final class FakeQuestsRepository implements QuestsRepository {
  FakeQuestsRepository(this.media, {required this.now});
  final Uri media;
  final DateTime Function() now;
  DateTime? _anchor;

  Uri _art(String file) => media.resolve('home/$file');

  @override
  Future<Result<QuestBoard>> board() async {
    final anchor = _anchor ??= now();
    return Success(
      QuestBoard(
        attentionCount: 1,
        quests: [
          Quest(
            id: 'clash_royal',
            game: QuestGame(
              gameId: 'clash_royal',
              name: 'Clash Royal',
              creator: 'Supercell',
              icon: _art('quest_icon_1.png'),
              banner: _art('hero_background.jpg'),
              offerTitle: 'Win the Crown',
              offerSummary:
                  'Finish the remaining battles and claim the crown reward.',
              access: QuestGameAccess.freeToPlay,
            ),
            started: true,
            steps: const [
              QuestStep(rewardPoints: 250, completed: true),
              QuestStep(rewardPoints: 500, completed: true),
              QuestStep(rewardPoints: 1000, completed: false),
            ],
            deadline: anchor.add(
              const Duration(hours: 6, minutes: 47, seconds: 49),
            ),
          ),
          Quest(
            id: 'eight_ball_pool',
            game: QuestGame(
              gameId: 'eight_ball_pool',
              name: '8 Ball Pool',
              creator: 'Miniclip.com',
              icon: _art('quest_icon_2.png'),
              banner: _art('poker.jpg'),
              offerTitle: 'Clear the table',
              offerSummary: 'Win a match of 8 Ball Pool before the timer ends.',
              access: QuestGameAccess.freeToPlay,
            ),
            started: false,
            steps: const [
              QuestStep(rewardPoints: 250, completed: false),
              QuestStep(rewardPoints: 500, completed: false),
              QuestStep(rewardPoints: 1000, completed: false),
            ],
            deadline: anchor.add(
              const Duration(days: 1, hours: 10, minutes: 27, seconds: 54),
            ),
          ),
        ],
      ),
    );
  }
}
