import 'package:mygame_p2e/core/errors/app_failure.dart';

import 'models.dart';

abstract interface class QuestsRepository {
  Future<Result<QuestBoard>> board();
}
