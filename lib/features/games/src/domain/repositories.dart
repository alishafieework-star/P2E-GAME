import 'package:mygame_p2e/core/errors/app_failure.dart';

import 'models.dart';

abstract interface class GamesRepository {
  Future<Result<HomeGamesFeed>> homeFeed();
}
