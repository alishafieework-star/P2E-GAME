import 'package:mygame_p2e/core/errors/app_failure.dart';

import '../domain/game_details.dart';
import '../domain/game_details_repository.dart';

/// OD-2 / D-058: no production endpoint is invented here.
final class RemoteGameDetailsRepository implements GameDetailsRepository {
  const RemoteGameDetailsRepository();

  @override
  Future<Result<GameDetailsSnapshot>> details(
    String id, {
    required String languageCode,
  }) async => const Failure(BusinessFailure('not_configured'));

  @override
  Future<void> clear() async {}
}
