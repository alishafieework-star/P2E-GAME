import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;
import 'package:mygame_p2e/app/config/app_config.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/app/router/app_router.dart';
import 'package:mygame_p2e/app/startup/startup_controller.dart';
import 'package:mygame_p2e/core/time/clock.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/features/games/games.dart';
import 'package:mygame_p2e/features/missions/missions.dart';
import 'package:mygame_p2e/shared/balance/balance.dart';
import 'package:mygame_p2e/shared/navigation/app_locations.dart';
import 'package:mygame_p2e/shared/platform/one_time_code.dart';
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
    this.tourPending = false,
    this.askSms = false,
    this.rememberedRaw = '',
    this.rememberedLabel = '',
  });
  final String id, label;
  final String? path;
  final bool signedIn, fixtures;
  final StartupState? freezeStartup;
  final AuthFlowResult Function()? flow;
  final HomeFixture? home;
  final GameDetailsFixture? details;
  final bool tourPending, askSms;
  final String rememberedRaw, rememberedLabel;

  /// First scenario menu. States of one area share this id.
  String get sectionId {
    if (id == 'onboarding') return 'onboarding';
    if (id == 'fixtures.ds') return 'designSystem';
    if (id.startsWith('route.') || id.startsWith('startup.')) return 'startup';
    if (id.startsWith('auth.')) return 'auth';
    if (id == 'shell.home' || id.startsWith('home.')) return 'home';
    if (id == 'shell.mission' || id == 'detail.quest') return 'missions';
    if (id == 'shell.games' || id == 'detail.game' || id.startsWith('game.')) {
      return 'games';
    }
    if (id == 'shell.leaderboard') return 'leaderboard';
    if (id == 'shell.shop') return 'shop';
    if (id.startsWith('legal.')) return 'legal';
    throw StateError('No scenario section for $id');
  }

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
            homeTourPending: tourPending,
            notificationsAsked: true,
            smsAccessAsked: !askSms,
            rememberedRaw: rememberedRaw,
            rememberedLabel: rememberedLabel,
          ),
        ),
      ),
      if (askSms)
        oneTimeCodeAccessProvider.overrideWithValue(const _ClosedSmsAccess()),
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
  const ProductScenario(
    id: 'auth.entry.continue-as',
    label: '[Auth] 01b - Continue as',
    path: '/entry',
    rememberedRaw: '09121234567',
    rememberedLabel: '0912 123 4567',
  ),
  ProductScenario(
    id: 'auth.otp',
    label: '[Auth] 02 - Phone OTP (6 digits)',
    path: '/entry/otp',
    flow: _otpFlow,
  ),
  ProductScenario(
    id: 'auth.otp.player',
    label: '[Auth] 02b - Player SMS (letter + 5 digits)',
    path: '/entry/otp',
    flow: _playerLoginFlow,
  ),
  ProductScenario(
    id: 'auth.otp.sms-access',
    label: '[Auth] 02c - SMS access sheet',
    path: '/entry/otp',
    askSms: true,
    flow: _playerLoginFlow,
  ),
  ProductScenario(
    id: 'auth.verify.phone',
    label: '[Auth] 02d - Registration verify (phone)',
    path: '/entry/verify',
    flow: _phoneVerifyFlow,
  ),
  ProductScenario(
    id: 'auth.verify.email',
    label: '[Auth] 02e - Registration verify (email)',
    path: '/entry/verify',
    flow: _emailVerifyFlow,
  ),
  ProductScenario(
    id: 'auth.password',
    label: '[Auth] 03 - Email password',
    path: '/entry/password',
    flow: () =>
        EmailFlowResult(_fixtureEmail(), EmailAccountStatus.registered, false),
  ),
  ProductScenario(
    id: 'auth.password.phone',
    label: '[Auth] 03b - Phone password',
    path: '/entry/password',
    flow: () => PhonePasswordFlowResult(_fixturePhone(), '09121234567', false),
  ),
  ProductScenario(
    id: 'auth.create-password',
    label: '[Auth] 04 - Create password (email)',
    path: '/entry/create-password',
    flow: () => EmailNewPasswordResult(_fixtureEmail(), false),
  ),
  ProductScenario(
    id: 'auth.create-password.phone',
    label: '[Auth] 04b - Create password (phone)',
    path: '/entry/create-password',
    flow: () => PhoneNewPasswordResult(_fixturePhone(), false),
  ),
  ProductScenario(
    id: 'auth.forgot-password',
    label: '[Auth] 05 - Email reset code',
    path: '/entry/forgot-password',
    flow: () => EmailResetFlowResult(_fixtureEmail(), _challenge(), false),
  ),
  ProductScenario(
    id: 'auth.forgot.phone',
    label: '[Auth] 05b - Phone reset code',
    path: '/entry/forgot-password',
    flow: () => PhoneResetFlowResult(
      _fixturePhone(),
      '09121234567',
      _playerChallenge(),
      false,
    ),
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
    'home.tour',
    '[Home] First-run tour',
    AppLocations.home,
    HomeFixture.success,
    tourPending: true,
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
  _home(
    'game.studio',
    '[Game Details] Studio placeholder',
    AppLocations.studioOn(AppLocations.home, 'sample'),
    HomeFixture.success,
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
  HomeFixture fixture, {
  bool tourPending = false,
}) => ProductScenario(
  id: id,
  label: label,
  path: path,
  signedIn: true,
  home: fixture,
  tourPending: tourPending,
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
  // #region agent log
  _scenarioLog('A', 'scenario seeded', {
    'id': scenario.id,
    'section': scenario.sectionId,
    'wanted': path,
    'actual': container.read(appRouterProvider).state.uri.path,
    'startup': container.read(startupControllerProvider).name,
    'splash': container.read(splashGateProvider).name,
    'home': scenario.home?.name,
    'freeze': scenario.freezeStartup?.name,
  });
  if (scenario.home != null || scenario.sectionId == 'home') {
    unawaited(_logHomeFeed(container, scenario.id));
  }
  // #endregion
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

Phone _fixturePhone() {
  final identifier = IdentifierClassifier.classify('09121234567');
  if (identifier is! Phone) throw StateError('Fixture phone was rejected');
  return identifier;
}

/// Live player SMS shape: one letter, a dash, then five digits (D-156).
OtpChallenge _playerChallenge() => OtpChallenge(
  challengeId: 'fixture-player-challenge',
  codeLength: 5,
  codePrefix: 'P-',
  resendAfter: Duration.zero,
  expiresAt: DateTime.utc(2026, 10, 26),
  maskedDestination: '0912***4567',
);

AuthFlowResult _playerLoginFlow() =>
    PhoneFlowResult(_playerChallenge(), '09121234567', false);

AuthFlowResult _phoneVerifyFlow() => PhoneFlowResult(
  _playerChallenge(),
  '09121234567',
  false,
  registration: true,
);

AuthFlowResult _emailVerifyFlow() =>
    EmailVerifyFlowResult(_fixtureEmail(), _challenge(), false);

void _scenarioLog(
  String hypothesisId,
  String message,
  Map<String, Object?> data,
) {
  // #region agent log
  try {
    File(r'd:\projects\My-Game\.cursor\debug-e2ebb3.log').writeAsStringSync(
      '${jsonEncode({
        'sessionId': 'e2ebb3',
        'runId': 'pre-fix',
        'hypothesisId': hypothesisId,
        'location': 'product_scenarios.dart',
        'message': message,
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      })}\n',
      mode: FileMode.append,
    );
  } catch (_) {}
  // #endregion
}

Future<void> _logHomeFeed(ProviderContainer container, String id) async {
  // #region agent log
  try {
    final repo = container.read(gamesRepositoryProvider);
    final result = await repo.homeFeed().timeout(const Duration(seconds: 2));
    final payload = switch (result) {
      Success(:final value) => {
        'ok': true,
        'hero': value.hero != null,
        'shelves': value.shelves.length,
        'games': value.shelves.fold<int>(
          0,
          (count, shelf) => count + shelf.games.length,
        ),
      },
      Failure(:final error) => {
        'ok': false,
        'error': error.runtimeType.toString(),
      },
    };
    _scenarioLog('D', 'home feed', {
      'id': id,
      'repo': repo.runtimeType.toString(),
      ...payload,
    });
  } catch (error) {
    _scenarioLog('D', 'home feed failed', {
      'id': id,
      'error': error.runtimeType.toString(),
    });
  }
  // #endregion
}

final class _ClosedSmsAccess implements OneTimeCodeAccess {
  const _ClosedSmsAccess();

  @override
  Future<bool> granted() async => false;

  @override
  Future<bool> request() async => false;
}
