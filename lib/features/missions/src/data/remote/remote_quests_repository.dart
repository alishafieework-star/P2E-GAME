import 'package:mygame_p2e/core/errors/app_failure.dart';

import '../../domain/models.dart';
import '../../domain/repositories.dart';

/// OD-2: no endpoint is invented until the backend contract exists.
final class RemoteQuestsRepository implements QuestsRepository {
  const RemoteQuestsRepository();
  @override
  Future<Result<QuestBoard>> board() async =>
      const Failure(BusinessFailure('not_configured'));
}
