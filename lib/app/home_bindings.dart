import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

import '../core/storage/json_store.dart';
import '../core/time/clock.dart';
import '../features/games/games.dart';
import '../features/games/games_data.dart';
import '../features/missions/missions.dart';
import '../features/missions/missions_data.dart';
import '../shared/balance/balance.dart';
import '../shared/balance/fake_balance.dart';
import '../shared/profile/fake_profile.dart';
import '../shared/profile/profile.dart';
import 'config/app_config.dart';
import 'platform/game_details_store.dart';
import 'platform/transports.dart';

/// Compile-time dead branch in remote builds: fake factories are removed.
const _useFake =
    String.fromEnvironment(
      'BACKEND_MODE',
      defaultValue:
          String.fromEnvironment('APP_ENV', defaultValue: 'dev') == 'dev'
          ? 'fake'
          : 'remote',
    ) ==
    'fake';

/// D-159: a dev build keeps the temporary Home catalog next to remote auth.
const _devCatalog =
    String.fromEnvironment('APP_ENV', defaultValue: 'dev') == 'dev';

/// Home read models. Fake data is in-process; sample artwork comes from the
/// development media origin and is never bundled (D-102).
List<Override> homeBindings(AppConfig config) {
  final store = openGameDetailsStore();
  if (_devCatalog) return _sampleHome(config, store);
  final fake = _useFake && config.backendMode == BackendMode.fake;
  return [
    gamesRepositoryProvider.overrideWith(
      (_) => _useFake && config.backendMode == BackendMode.fake
          ? FakeGamesRepository(Uri.parse(config.fakeMediaBase))
          : const RemoteGamesRepository(),
    ),
    questsRepositoryProvider.overrideWith(
      (ref) => _useFake && config.backendMode == BackendMode.fake
          ? FakeQuestsRepository(
              Uri.parse(config.fakeMediaBase),
              now: ref.read(clockProvider).now,
            )
          : const RemoteQuestsRepository(),
    ),
    balanceRepositoryProvider.overrideWith(
      (_) => _useFake && config.backendMode == BackendMode.fake
          ? const FakeBalanceRepository()
          : const RemoteBalanceRepository(),
    ),
    profileRepositoryProvider.overrideWith(
      (_) => fake
          ? const FakeProfileRepository()
          : const RemoteProfileRepository(),
    ),
    gameDetailsRepositoryProvider.overrideWith(
      (ref) => fake
          ? CachedGameDetailsRepository(
              source: HttpGameDetailsSource(
                transport: ref.read(jsonHttpTransportProvider),
                base: Uri.parse(config.fakeApiBase),
              ),
              store: store,
            )
          : const RemoteGameDetailsRepository(),
    ),
    gameBookmarkStoreProvider.overrideWith((_) => JsonGameBookmarkStore(store)),
  ];
}

List<Override> _sampleHome(AppConfig config, JsonStore store) {
  final media = Uri.parse(config.fakeMediaBase);
  return [
    gamesRepositoryProvider.overrideWith((_) => FakeGamesRepository(media)),
    questsRepositoryProvider.overrideWith(
      (ref) => FakeQuestsRepository(media, now: ref.read(clockProvider).now),
    ),
    balanceRepositoryProvider.overrideWith(
      (_) => const FakeBalanceRepository(),
    ),
    profileRepositoryProvider.overrideWith(
      (_) => const FakeProfileRepository(),
    ),
    gameDetailsRepositoryProvider.overrideWith(
      (ref) => CachedGameDetailsRepository(
        source: HttpGameDetailsSource(
          transport: ref.read(jsonHttpTransportProvider),
          base: Uri.parse(config.fakeApiBase),
        ),
        store: store,
      ),
    ),
    gameBookmarkStoreProvider.overrideWith((_) => JsonGameBookmarkStore(store)),
  ];
}
