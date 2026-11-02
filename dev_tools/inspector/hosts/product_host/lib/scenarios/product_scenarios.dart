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
import 'package:mygame_p2e/shared/preferences/device_preferences.dart';
import 'package:mygame_p2e/shared/profile/profile.dart';
import 'package:mygame_p2e/shared/session/session.dart';

import 'game_details_fixtures.dart';
import 'home_fixtures.dart';

class _PresetSplashGateController extends SplashGateController {
  _PresetSplashGateController(this._initial);
  final SplashGate _initial;

  @override
  SplashGate build() => _initial;
}

class _PresetSessionController extends SessionController {
  _PresetSessionController(this._initial);
  final SessionStatus _initial;

  @override
  SessionStatus build() => _initial;
}

class _PresetAuthFlow extends AuthFlow {
  _PresetAuthFlow(this._initial);
  final AuthFlowResult? _initial;

  @override
  AuthFlowResult? build() => _initial;
}

/// In-memory preferences repository so inspector scenarios never block on disk I/O.
final class HostDevicePreferences implements DevicePreferencesRepository {
  HostDevicePreferences(this.prefs);
  DevicePreferences prefs;

  @override
  Future<DevicePreferences> read() async => prefs;

  @override
  Future<void> save(DevicePreferences value) async {
    prefs = value;
  }
}

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

  StartupState get targetStartupState {
    if (freezeStartup != null) return freezeStartup!;
    if (signedIn) return StartupState.ready;
    if (path == '/entry/onboarding') return StartupState.onboarding;
    return StartupState.entry;
  }

  List<Override> overrides(AppConfig config) {
    final rows = <Override>[
      startupControllerProvider.overrideWithValue(targetStartupState),
      if (freezeStartup != StartupState.initializing)
        splashGateProvider.overrideWith(
          () => _PresetSplashGateController(SplashGate.collapsed),
        ),
      sessionControllerProvider.overrideWith(
        () => _PresetSessionController(
          signedIn ? SessionStatus.signedIn : SessionStatus.signedOut,
        ),
      ),
      if (flow != null)
        authFlowProvider.overrideWith(() => _PresetAuthFlow(flow!())),
      devicePreferencesRepositoryProvider.overrideWithValue(
        HostDevicePreferences(
          DevicePreferences(
            onboardingSeen: path != '/entry/onboarding',
            homeTourPending: false,
            notificationsAsked: true,
            smsAccessAsked: true,
          ),
        ),
      ),
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
        HostGameDetailsRepository(
          details ?? GameDetailsFixture.success,
          mediaBase: media.toString(),
        ),
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
  // 1. Startup & Onboarding
  const ProductScenario(
    id: 'route.startup',
    label: '[Startup] Initializing Blank',
    path: '/startup',
    freezeStartup: StartupState.initializing,
  ),
  const ProductScenario(
    id: 'startup.session',
    label: '[Startup] Session Check',
    path: '/startup',
    freezeStartup: StartupState.sessionCheck,
  ),
  const ProductScenario(
    id: 'onboarding',
    label: '[Onboarding] Welcome & Leaderboard',
    path: '/entry/onboarding',
  ),

  // 2. Complete Auth Journey
  const ProductScenario(
    id: 'auth.entry',
    label: '[Auth] 01 - Entry (Identifier)',
    path: '/entry',
  ),
  ProductScenario(
    id: 'auth.otp',
    label: '[Auth] 02 - Phone OTP Verification',
    path: '/entry/otp',
    flow: _otpFlow,
  ),
  ProductScenario(
    id: 'auth.password',
    label: '[Auth] 03 - Password Login',
    path: '/entry/password',
    flow: () =>
        EmailFlowResult(_fixtureEmail(), EmailAccountStatus.registered, false),
  ),
  ProductScenario(
    id: 'auth.create-password',
    label: '[Auth] 04 - Create Password',
    path: '/entry/create-password',
    flow: () => EmailFlowResult(
      _fixtureEmail(),
      EmailAccountStatus.notRegistered,
      false,
    ),
  ),
  ProductScenario(
    id: 'auth.forgot-password',
    label: '[Auth] 05 - Forgot Password',
    path: '/entry/forgot-password',
    flow: () => EmailResetFlowResult(_fixtureEmail(), _challenge(), false),
  ),
  ProductScenario(
    id: 'auth.username',
    label: '[Auth] 06 - Choose Username',
    path: '/entry/username',
    flow: () => AccountJourney(AuthStep.username, email: _fixtureEmail()),
  ),
  ProductScenario(
    id: 'auth.avatar',
    label: '[Auth] 07 - Select Avatar & Theme',
    path: '/entry/avatar',
    flow: () => AccountJourney(
      AuthStep.avatar,
      email: _fixtureEmail(),
      username: 'gamer_pro',
    ),
  ),
  ProductScenario(
    id: 'auth.notifications',
    label: '[Auth] 08 - Push Notifications',
    path: '/entry/notifications',
    flow: () => AccountJourney(
      AuthStep.notifications,
      email: _fixtureEmail(),
      username: 'gamer_pro',
      avatarCharacter: 1,
      avatarReady: true,
    ),
  ),
  ProductScenario(
    id: 'auth.all-set',
    label: '[Auth] 09 - All Set (Celebration Confetti)',
    path: '/entry/all-set',
    flow: () => AccountJourney(
      AuthStep.allSet,
      email: _fixtureEmail(),
      username: 'gamer_pro',
      avatarCharacter: 1,
      avatarReady: true,
      notificationsOn: true,
    ),
  ),
  ProductScenario(
    id: 'auth.welcome-back',
    label: '[Auth] 10 - Welcome Back (Returning Player)',
    path: '/entry/welcome-back',
    flow: () => AccountJourney(
      AuthStep.welcomeBack,
      email: _fixtureEmail(),
      username: 'gamer_pro',
      avatarCharacter: 1,
      avatarReady: true,
    ),
  ),

  // 3. Main App Shell (Tabs)
  _home(
    'shell.home',
    '[Home] Default (2D Parallax Hero)',
    AppLocations.home,
    HomeFixture.success,
  ),
  _home(
    'home.loading',
    '[Home] Loading Skeletons',
    AppLocations.home,
    HomeFixture.loading,
  ),
  _home(
    'home.empty',
    '[Home] Empty Shelves',
    AppLocations.home,
    HomeFixture.empty,
  ),
  _home(
    'home.error',
    '[Home] Error & Retry Section',
    AppLocations.home,
    HomeFixture.error,
  ),
  _home(
    'home.offline',
    '[Home] Offline Cached Content',
    AppLocations.home,
    HomeFixture.offline,
  ),
  _home(
    'home.long-content',
    '[Home] Long Content Scroll',
    AppLocations.home,
    HomeFixture.long,
  ),
  _home(
    'home.broken-media',
    '[Home] Broken Media Fallback',
    AppLocations.home,
    HomeFixture.brokenMedia,
  ),
  _home(
    'home.quest-expired',
    '[Home] Expired Quest Marker',
    AppLocations.home,
    HomeFixture.expiredQuest,
  ),
  _home(
    'shell.mission',
    '[Missions] Tab',
    AppLocations.missions,
    HomeFixture.success,
  ),
  _home('shell.games', '[Games] Tab', AppLocations.games, HomeFixture.success),
  _home(
    'shell.leaderboard',
    '[Leaderboard] Tab',
    AppLocations.leaderboard,
    HomeFixture.success,
  ),
  _home('shell.shop', '[Shop] Tab', AppLocations.shop, HomeFixture.success),
  _home(
    'detail.game',
    '[Game Details] Sample',
    AppLocations.game('sample'),
    HomeFixture.success,
  ),
  _home(
    'detail.quest',
    '[Quest Details] Sample',
    AppLocations.quest('sample'),
    HomeFixture.success,
  ),

  // 4. Game Details Variants & Reviews
  _game(
    'game.success',
    '[Game Details] Success (Clash of Clans)',
    GameDetailsFixture.success,
  ),
  _game(
    'game.loading',
    '[Game Details] Loading State',
    GameDetailsFixture.loading,
  ),
  _game('game.error', '[Game Details] Error State', GameDetailsFixture.error),
  _game(
    'game.offline',
    '[Game Details] Offline Cache',
    GameDetailsFixture.offline,
  ),
  _game(
    'game.not-found',
    '[Game Details] Not Found',
    GameDetailsFixture.notFound,
  ),
  _game(
    'game.minimal',
    '[Game Details] Minimal Info',
    GameDetailsFixture.minimal,
  ),
  ProductScenario(
    id: 'game.reviews',
    label: '[Game Details] Reviews & Ratings',
    path: '${AppLocations.gameOn(AppLocations.home, 'clash_of_clans')}/reviews',
    signedIn: true,
    home: HomeFixture.success,
    details: GameDetailsFixture.success,
  ),

  // 5. In-App Legal Reader
  const ProductScenario(
    id: 'legal.terms',
    label: '[Legal] Terms of Service',
    path: '/legal/terms',
  ),
  const ProductScenario(
    id: 'legal.privacy',
    label: '[Legal] Privacy Policy',
    path: '/legal/privacy',
  ),

  // 6. Design System Fixtures
  const ProductScenario(
    id: 'fixtures.ds',
    label: '[DS] Component Fixtures',
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
  if (scenario.fixtures) return;

  container
      .read(sessionControllerProvider.notifier)
      .update(
        scenario.signedIn ? SessionStatus.signedIn : SessionStatus.signedOut,
      );
  if (scenario.flow != null) {
    container.read(authFlowProvider.notifier).accept(scenario.flow!());
  } else if (!scenario.signedIn) {
    container.read(authFlowProvider.notifier).clear();
  }

  await Future<void>.delayed(Duration.zero);
  final path = scenario.path;
  if (path != null) {
    container.read(appRouterProvider).go(path);
  }
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
    PhoneFlowResult(_challenge(), '09121234567', false);
