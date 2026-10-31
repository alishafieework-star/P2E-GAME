import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/router/game_detail_transition.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;
import 'package:mygame_p2e/features/games/games.dart';
import 'package:mygame_p2e/features/games/src/presentation/details/widgets/game_media_tile.dart';
import 'package:mygame_p2e/features/games/games_data.dart';
import 'package:mygame_p2e/features/missions/missions.dart';
import 'package:mygame_p2e/features/missions/missions_data.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/platform/external_links.dart';
import 'package:mygame_p2e/shared/profile/fake_profile.dart';
import 'package:mygame_p2e/shared/profile/profile.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    final binding = TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.views.first.physicalSize = const Size(402, 1200);
    binding.platformDispatcher.views.first.devicePixelRatio = 1;
  });
  tearDown(() {
    final binding = TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();
  });
  final clash = parseGameDetails(
    File('tool/fake_backend/fixtures/games/clash_of_clans.json')
        .readAsStringSync()
        .replaceAll('{{media}}', 'https://example.test'),
  );
  final minimal = parseGameDetails(
    File('tool/fake_backend/fixtures/games/minimal_sample.json')
        .readAsStringSync()
        .replaceAll('{{media}}', 'https://example.test'),
  );

  testWidgets('the entrance finishes before a late payload replaces loading', (
    tester,
  ) async {
    final pending = _PendingDetails(clash);
    await tester.pumpWidget(_app(clash, repository: pending, navigated: true));
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.bySemanticsLabel('Loading game'), findsOneWidget);
    expect(find.text('About'), findsNothing);

    pending.release();
    await tester.pump();
    expect(find.text('About'), findsNothing);

    await tester.pump(GameDetailTransition.duration);
    await tester.pump();
    expect(find.text('About'), findsWidgets);
    _drainImages(tester);
  });

  testWidgets('success shows the source sections and a local bookmark', (
    tester,
  ) async {
    final bookmarks = HostMemoryBookmarks();
    await tester.pumpWidget(_app(clash, bookmarks: bookmarks));
    await tester.pump();
    await tester.pump();
    _drainImages(tester);
    expect(find.text('Clash of Clans'), findsWidgets);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Events & Offers'), findsWidgets);
    expect(find.text('Win the Crown'), findsNothing);
    await tester.tap(find.bySemanticsLabel('Bookmark').last);
    await tester.pump();
    expect(bookmarks.ids, contains('clash_of_clans'));
    _drainImages(tester);
  });

  testWidgets('a linked quest is the first event and empty sections hide', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        minimal,
        screenId: 'clash_royal',
        quests: FakeQuestsRepository(
          Uri.parse('https://example.test/'),
          now: () => DateTime.utc(2026, 10, 25),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    _drainImages(tester);
    expect(find.text('Win the Crown'), findsWidgets);

    await tester.pumpWidget(_app(minimal));
    await tester.pump();
    await tester.pump();
    _drainImages(tester);
    expect(find.text('Events & Offers'), findsNothing);
    expect(find.text('Ratings & Reviews'), findsNothing);
  });

  testWidgets('missing and offline states stay on the page', (tester) async {
    await tester.pumpWidget(_app(clash, missing: true));
    await tester.pump();
    await tester.pump();
    _drainImages(tester);
    expect(find.text('This game is not available.'), findsOneWidget);

    await tester.pumpWidget(_app(clash, offline: true));
    await tester.pump();
    await tester.pump();
    _drainImages(tester);
    expect(find.text('Showing saved information.'), findsOneWidget);
  });

  testWidgets('See More Comments appears only when comments remain', (
    tester,
  ) async {
    await tester.pumpWidget(_app(clash));
    await tester.pump();
    await tester.pump();
    _drainImages(tester);
    await _scrollTo(tester, find.text('Ratings & Reviews'));
    expect(find.text('See More Comments'), findsNothing);

    final more = parseGameDetails(
      File('tool/fake_backend/fixtures/games/clash_of_clans.json')
          .readAsStringSync()
          .replaceAll('{{media}}', 'https://example.test')
          .replaceFirst('"total": 3', '"total": 4'),
    );
    await tester.pumpWidget(_app(more));
    await tester.pump();
    await tester.pump();
    _drainImages(tester);
    await _scrollTo(tester, find.text('See More Comments'));
    expect(find.text('See More Comments'), findsOneWidget);
    _drainImages(tester);
  });

  testWidgets('a media picture opens a viewer and back closes it', (
    tester,
  ) async {
    await tester.pumpWidget(_app(clash));
    await tester.pump();
    await tester.pump();
    _drainImages(tester);
    await tester.tap(find.byType(GameMediaTile).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    _drainImages(tester);
    expect(
      find.byKey(const ValueKey('game.details.media.viewer')),
      findsOneWidget,
    );
    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('game.details.media.viewer.back')),
    );
    await tester.pump();
    await tester.pump(GameDetailsEngineering.viewerTransition);
    expect(
      find.byKey(const ValueKey('game.details.media.viewer')),
      findsNothing,
    );
    _drainImages(tester);
  });

  testWidgets('fa digits and text scale 2 do not clip the page', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(clash, locale: const Locale('fa'), textScale: 2),
    );
    await tester.pump();
    await tester.pump();
    _drainImages(tester);
    expect(find.textContaining('۴۰'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

void _drainImages(WidgetTester tester) {
  while (tester.takeException() != null) {}
}

Future<void> _scrollTo(WidgetTester tester, Finder target) {
  return tester.scrollUntilVisible(
    target,
    400,
    scrollable: find.byType(Scrollable).first,
  );
}

class HostMemoryBookmarks implements GameBookmarkStore {
  final ids = <String>{};
  @override
  Future<Set<String>> read() async => ids;
  @override
  Future<void> write(Set<String> next) async {
    ids
      ..clear()
      ..addAll(next);
  }

  @override
  Future<void> clear() async => ids.clear();
}

class _PendingDetails implements GameDetailsRepository {
  _PendingDetails(this.payload);
  final GameDetails payload;
  final _ready = Completer<void>();

  void release() {
    if (!_ready.isCompleted) _ready.complete();
  }

  @override
  Future<void> clear() async {}

  @override
  Future<Result<GameDetailsSnapshot>> details(
    String id, {
    required String languageCode,
  }) async {
    await _ready.future;
    return Success(GameDetailsSnapshot(details: payload, offline: false));
  }
}

class _Details implements GameDetailsRepository {
  _Details(this.payload, {this.offline = false, this.missing = false});
  final GameDetails payload;
  final bool offline, missing;
  @override
  Future<void> clear() async {}
  @override
  Future<Result<GameDetailsSnapshot>> details(
    String id, {
    required String languageCode,
  }) async => missing
      ? const Failure(NotFoundFailure())
      : Success(GameDetailsSnapshot(details: payload, offline: offline));
}

class _Links implements ExternalLinkPort {
  @override
  Future<Result<void>> open(ExternalLink link) async => const Success(null);
  @override
  Future<Result<void>> openUri(Uri uri) async => const Success(null);
}

Widget _app(
  GameDetails details, {
  HostMemoryBookmarks? bookmarks,
  FakeQuestsRepository? quests,
  GameDetailsRepository? repository,
  bool offline = false,
  bool missing = false,
  bool navigated = false,
  Locale locale = const Locale('en'),
  double textScale = 1,
  String? screenId,
}) {
  // Built outside the ProviderScope literal, matching production composeApp:
  // these are root composition seams, not nested-scope overrides.
  final overrides = <Override>[
    gameDetailsRepositoryProvider.overrideWithValue(
      repository ?? _Details(details, offline: offline, missing: missing),
    ),
    gameBookmarkStoreProvider.overrideWithValue(
      bookmarks ?? HostMemoryBookmarks(),
    ),
    profileRepositoryProvider.overrideWithValue(const FakeProfileRepository()),
    if (quests != null) questsRepositoryProvider.overrideWithValue(quests),
    externalLinkPortProvider.overrideWithValue(_Links()),
  ];
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppThemeFactory.build(
        brightness: Brightness.dark,
        skin: productSkin,
      ),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: navigated
          ? Builder(
              builder: (context) => TextButton(
                onPressed: () => Navigator.of(context).push<void>(
                  GameDetailTransitionPage(
                    child: UiIdentityScope(
                      routeName: 'game.detail',
                      child: GameDetailsScreen(id: screenId ?? details.id),
                    ),
                  ).createRoute(context),
                ),
                child: const Text('Open'),
              ),
            )
          : UiIdentityScope(
              routeName: 'game.detail',
              child: GameDetailsScreen(id: screenId ?? details.id),
            ),
    ),
  );
}
