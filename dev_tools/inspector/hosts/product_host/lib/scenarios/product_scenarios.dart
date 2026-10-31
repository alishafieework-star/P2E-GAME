import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;
import 'package:mygame_p2e/app/config/app_config.dart';
import 'package:mygame_p2e/app/router/app_router.dart';
import 'package:mygame_p2e/app/startup/startup_controller.dart';
import 'package:mygame_p2e/core/time/clock.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/features/games/games.dart';
import 'package:mygame_p2e/features/missions/missions.dart';
import 'package:mygame_p2e/shared/balance/balance.dart';
import 'package:mygame_p2e/shared/navigation/app_locations.dart';
import 'package:mygame_p2e/shared/profile/profile.dart';
import 'package:mygame_p2e/shared/session/session.dart';

import 'game_details_fixtures.dart';
import 'home_fixtures.dart';

/// Stable product routes and in-process fixtures. This module is imported only
/// by the removable product host.
class ProductScenario {
  const ProductScenario({
    required this.id,
    required this.label,
    this.path,
    this.signedIn = false,
    this.fixtures = false,
    this.freezeStartup,
    this.flow,
    this.home,
    this.details,
  });
  final String id, label;
  final String? path;
  final bool signedIn, fixtures;
  final StartupState? freezeStartup;
  final AuthFlowResult Function()? flow;
  final HomeFixture? home;
  final GameDetailsFixture? details;

  List<Override> overrides(AppConfig config) {
    final rows = <Override>[
      if (freezeStartup != null)
        startupControllerProvider.overrideWithValue(freezeStartup!),
    ];
    final fixture = home;
    if (fixture == null) return rows;
    final now = DateTime.utc(2026, 10, 24, 12);
    final media = Uri.parse(
      fixture == HomeFixture.brokenMedia
          ? 'http://127.0.0.1:9/'
          : config.fakeMediaBase,
    );
    rows.addAll([
      clockProvider.overrideWith((ref) => _FixedClock(now)),
      secondTickerProvider.overrideWith((ref) => Stream<DateTime>.value(now)),
      gamesRepositoryProvider.overrideWithValue(gamesFor(fixture, media)),
      questsRepositoryProvider.overrideWithValue(
        questsFor(fixture, media, now),
      ),
      balanceRepositoryProvider.overrideWithValue(balanceFor(fixture)),
      profileRepositoryProvider.overrideWithValue(profileFor(fixture)),
      gameDetailsRepositoryProvider.overrideWithValue(
        HostGameDetailsRepository(details ?? GameDetailsFixture.success),
      ),
      gameBookmarkStoreProvider.overrideWithValue(HostBookmarks()),
    ]);
    return rows;
  }
}

final class _FixedClock implements Clock {
  const _FixedClock(this.value);
  final DateTime value;
  @override
  DateTime now() => value;
}

final productScenarios = <ProductScenario>[
  ProductScenario(
    id: 'route.startup',
    label: 'Startup',
    path: '/startup',
    freezeStartup: StartupState.initializing,
  ),
  ProductScenario(id: 'auth.entry', label: 'Auth entry', path: '/entry'),
  ProductScenario(
    id: 'auth.otp',
    label: 'Auth OTP',
    path: '/entry/otp',
    flow: _otpFlow,
  ),
  ProductScenario(
    id: 'auth.password',
    label: 'Auth password',
    path: '/entry/password',
    flow: () =>
        EmailFlowResult(_fixtureEmail(), EmailAccountStatus.registered, false),
  ),
  ProductScenario(
    id: 'auth.create-password',
    label: 'Create password',
    path: '/entry/create-password',
    flow: () => EmailFlowResult(
      _fixtureEmail(),
      EmailAccountStatus.notRegistered,
      false,
    ),
  ),
  ProductScenario(
    id: 'auth.forgot-password',
    label: 'Forgot password',
    path: '/entry/forgot-password',
    flow: () => EmailResetFlowResult(_fixtureEmail(), _challenge(), false),
  ),
  _home('shell.home', 'Home', AppLocations.home, HomeFixture.success),
  _home('home.loading', 'Home loading', AppLocations.home, HomeFixture.loading),
  _home('home.empty', 'Home empty', AppLocations.home, HomeFixture.empty),
  _home('home.error', 'Home error', AppLocations.home, HomeFixture.error),
  _home('home.offline', 'Home offline', AppLocations.home, HomeFixture.offline),
  _home(
    'home.long-content',
    'Home long content',
    AppLocations.home,
    HomeFixture.long,
  ),
  _home(
    'home.broken-media',
    'Home broken media',
    AppLocations.home,
    HomeFixture.brokenMedia,
  ),
  _home(
    'home.quest-expired',
    'Home expired quest',
    AppLocations.home,
    HomeFixture.expiredQuest,
  ),
  _home(
    'shell.mission',
    'Missions',
    AppLocations.missions,
    HomeFixture.success,
  ),
  _home('shell.games', 'Games', AppLocations.games, HomeFixture.success),
  _home(
    'shell.leaderboard',
    'Leaderboard',
    AppLocations.leaderboard,
    HomeFixture.success,
  ),
  _home('shell.shop', 'Shop', AppLocations.shop, HomeFixture.success),
  _home(
    'detail.game',
    'Game detail',
    AppLocations.game('sample'),
    HomeFixture.success,
  ),
  _home(
    'detail.quest',
    'Quest detail',
    AppLocations.quest('sample'),
    HomeFixture.success,
  ),
  _game('game.success', 'Game success', GameDetailsFixture.success),
  _game('game.loading', 'Game loading', GameDetailsFixture.loading),
  _game('game.error', 'Game error', GameDetailsFixture.error),
  _game('game.offline', 'Game offline cache', GameDetailsFixture.offline),
  _game('game.not-found', 'Game missing', GameDetailsFixture.notFound),
  _game('game.minimal', 'Game minimal', GameDetailsFixture.minimal),
  const ProductScenario(
    id: 'fixtures.ds',
    label: 'DS fixtures',
    fixtures: true,
  ),
];

ProductScenario productScenarioById(String id) =>
    productScenarios.firstWhere((scenario) => scenario.id == id);

ProductScenario _game(String id, String label, GameDetailsFixture details) =>
    ProductScenario(
      id: id,
      label: label,
      path: AppLocations.gameOn(AppLocations.home, 'clash_of_clans'),
      signedIn: true,
      home: HomeFixture.success,
      details: details,
    );

ProductScenario _home(
  String id,
  String label,
  String path,
  HomeFixture fixture,
) => ProductScenario(
  id: id,
  label: label,
  path: path,
  signedIn: true,
  home: fixture,
);

/// Mounts [scenario] on an already-built product container.
Future<void> seedProductScenario(
  ProviderContainer container,
  ProductScenario scenario,
) async {
  if (scenario.fixtures || scenario.freezeStartup != null) return;
  container
      .read(sessionControllerProvider.notifier)
      .update(
        scenario.signedIn ? SessionStatus.signedIn : SessionStatus.signedOut,
      );
  if (!scenario.signedIn) container.read(authFlowProvider.notifier).clear();
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
  final flow = scenario.flow?.call();
  if (flow != null) container.read(authFlowProvider.notifier).accept(flow);
  final path = scenario.path;
  if (path != null) container.read(appRouterProvider).go(path);
  await Future<void>.delayed(Duration.zero);
}

const fixtureEmailLiteral = 'fixture.player@example.com';

Email _fixtureEmail() {
  final identifier = IdentifierClassifier.classify(fixtureEmailLiteral);
  if (identifier is! Email) throw StateError('Fixture email was rejected');
  return identifier;
}

OtpChallenge _challenge() => OtpChallenge(
  challengeId: 'fixture-challenge',
  codeLength: 6,
  resendAfter: Duration.zero,
  expiresAt: DateTime.utc(2026, 10, 26),
  maskedDestination: 'masked',
);

AuthFlowResult _otpFlow() =>
    PhoneFlowResult(_challenge(), 'masked-destination', false);
