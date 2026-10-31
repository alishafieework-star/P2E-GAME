import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/core/time/clock.dart';
import 'package:mygame_p2e/features/games/games.dart';
import 'package:mygame_p2e/features/games/games_data.dart';
import 'package:mygame_p2e/features/home/home.dart';
import 'package:mygame_p2e/features/missions/missions.dart';
import 'package:mygame_p2e/features/missions/missions_data.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/balance/balance.dart';
import 'package:mygame_p2e/shared/balance/fake_balance.dart';
import 'package:mygame_p2e/shared/profile/fake_profile.dart';
import 'package:mygame_p2e/shared/profile/profile.dart';
import 'package:mygame_p2e/shared/widgets/collection_section.dart';
import 'package:mygame_p2e/shared/widgets/game_info_row.dart';
import 'package:p2e_design_system/design_system.dart';

final _now = DateTime.utc(2026, 10, 24, 12);
final _media = Uri.parse('http://media.test/');

final class _FixedClock implements Clock {
  const _FixedClock(this.value);
  final DateTime value;
  @override
  DateTime now() => value;
}

/// Figma Home Expand frames are 402 wide with a 55 status bar; the body is
/// 1674 high, so a 1729 view builds every section without scrolling.
Future<StreamController<DateTime>> _pumpHome(
  WidgetTester tester, {
  String locale = 'en',
  Brightness brightness = Brightness.dark,
  double scale = 1,
  double width = 402,
  double height = 1729,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.reset);
  final ticks = StreamController<DateTime>.broadcast();
  addTearDown(ticks.close);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        clockProvider.overrideWithValue(_FixedClock(_now)),
        secondTickerProvider.overrideWith((_) => ticks.stream),
        gamesRepositoryProvider.overrideWithValue(FakeGamesRepository(_media)),
        questsRepositoryProvider.overrideWithValue(
          FakeQuestsRepository(_media, now: () => _now),
        ),
        balanceRepositoryProvider.overrideWithValue(
          const FakeBalanceRepository(),
        ),
        profileRepositoryProvider.overrideWithValue(
          const FakeProfileRepository(),
        ),
      ],
      child: MaterialApp(
        theme: AppThemeFactory.build(brightness: brightness, skin: productSkin),
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: const EdgeInsets.only(top: 55),
            viewPadding: const EdgeInsets.only(top: 55),
            textScaler: TextScaler.linear(scale),
            disableAnimations: true,
          ),
          child: child!,
        ),
        home: const UiIdentityScope(
          routeName: 'home',
          child: Scaffold(body: HomeScreen()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return ticks;
}

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('Home follows the Figma Home Expand frame at 402 ($brightness)', (
      tester,
    ) async {
      await _pumpHome(tester, brightness: brightness);
      expect(tester.takeException(), isNull);

      final banner = tester.getRect(find.byType(HomeHeroBanner));
      expect(banner.top, 0);
      expect(banner.height, 55 + 64 + 224);
      final appBar = tester.getRect(find.byType(AppBarContent));
      expect(appBar.top, 55);
      expect(appBar.height, 64);
      final featured = tester.getRect(
        find.byWidgetPredicate(
          (widget) =>
              widget is GameInfoRow && widget.layout == GameInfoLayout.featured,
        ),
      );
      expect(featured.top, banner.bottom);
      expect(featured.height, 78);
      expect(featured.left, 16);

      Rect section(int index) =>
          tester.getRect(find.byType(CollectionSection).at(index));
      // Body offsets 366, 650, 975.5 and 1259.5 in Figma, plus the status bar.
      expect(section(0).top, 55 + 366);
      expect(section(0).height, 284);
      expect(section(1).top, 55 + 650);
      // E-110: the source CTA frame is fixed at 48 for 53 of content; the card
      // keeps its content, so this section is about 5 taller than 325.5.
      expect(section(1).height, closeTo(325.5 + 5, 1));
      expect(section(2).height, 284);
      expect(section(3).height, 414.5);
      expect(section(3).bottom, closeTo(55 + 1674 + 5, 1));

      expect(
        tester.getSize(find.byType(GameCompactCard).first),
        const Size(120, 204),
      );
      expect(
        tester.getSize(find.byType(QuestCard).first),
        const Size(370, 315),
      );
      expect(tester.getSize(find.byType(GameExpandCard).first).width, 370);
      expect(tester.getRect(find.byType(GameCompactCard).first).left, 16);
    });
  }

  testWidgets('Home shows the source content and live countdown', (
    tester,
  ) async {
    final ticks = await _pumpHome(tester);
    for (final text in [
      'Recommended for You',
      'Multiplayer Games',
      'Competition Games',
      'Mission and Quest',
      'Clash of Clans',
      'Sifu',
      'MONOPOLY',
      'Clash Royal',
      '8 Ball Pool',
      'Not Started Yet!',
      'Completed',
      'Continue',
      'Start Quest',
      '5,325',
      '150',
    ]) {
      expect(find.text(text), findsWidgets, reason: text);
    }
    expect(find.bySemanticsLabel('750 / 1,750 pts'), findsOneWidget);
    expect(find.bySemanticsLabel('0 / 1,750 pts'), findsOneWidget);
    final sifu = tester.getSemantics(find.text('Sifu')).getSemanticsData();
    expect(sifu.label, startsWith('Sifu\nKepler Interactive'));
    expect(sifu.label, contains('Rated 4.4 out of 5'));
    expect(sifu.label, contains('+520 pts'));
    expect(sifu.flagsCollection.isButton, isTrue);
    expect(find.bySemanticsLabel('+1,500 pts'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'Time left: 0 days, 6 hours, 47 minutes, 49 seconds',
      ),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('2 of 3 steps completed'), findsOneWidget);
    ticks.add(_now.add(const Duration(seconds: 1)));
    await tester.pumpAndSettle();
    expect(
      find.bySemanticsLabel(
        'Time left: 0 days, 6 hours, 47 minutes, 48 seconds',
      ),
      findsOneWidget,
    );

    // The second quest is the next page; paging snaps to it.
    await tester.fling(
      find.byType(QuestCard).first,
      const Offset(-300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(QuestCard).last).left, 16);
    expect(find.bySemanticsLabel('Page 2 of 2'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'Time left: 1 day, 10 hours, 27 minutes, 53 seconds',
      ),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('0 of 3 steps completed'), findsOneWidget);
  });

  testWidgets('Persian Home mirrors and uses Persian digits', (tester) async {
    await _pumpHome(tester, locale: 'fa');
    expect(tester.takeException(), isNull);
    expect(find.text('پیشنهاد برای شما'), findsOneWidget);
    expect(find.text('۵٬۳۲۵'), findsOneWidget);
    expect(find.text('هنوز شروع نشده!'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'زمان باقی‌مانده: ۰ روز، ۶ ساعت، ۴۷ دقیقه، ۴۹ ثانیه',
      ),
      findsOneWidget,
    );
    expect(tester.getRect(find.byType(GameCompactCard).first).right, 402 - 16);
  });

  for (final brightness in Brightness.values) {
    testWidgets('Home lays out at text scale 2.0 ($brightness)', (
      tester,
    ) async {
      await _pumpHome(tester, brightness: brightness, scale: 2, height: 2600);
      expect(tester.takeException(), isNull);
      expect(find.byType(QuestCard), findsNWidgets(2));
      expect(
        tester.getSize(find.byType(GameCompactCard).first).height,
        greaterThan(204),
      );
    });
  }

  testWidgets('a failed feed shows a retry inside its section', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(402, 1729);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(_now)),
          secondTickerProvider.overrideWith((_) => const Stream.empty()),
          gamesRepositoryProvider.overrideWithValue(
            const RemoteGamesRepository(),
          ),
          questsRepositoryProvider.overrideWithValue(
            const RemoteQuestsRepository(),
          ),
          balanceRepositoryProvider.overrideWithValue(
            const RemoteBalanceRepository(),
          ),
          profileRepositoryProvider.overrideWithValue(
            const RemoteProfileRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppThemeFactory.build(
            brightness: Brightness.dark,
            skin: productSkin,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const UiIdentityScope(
            routeName: 'home',
            child: Scaffold(body: HomeScreen()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text("This section couldn't load."), findsNWidgets(5));
    expect(find.text('Try again'), findsNWidgets(5));
    expect(find.text('—'), findsWidgets);
  });

  testWidgets('status scrim appears only after the page scrolls', (
    tester,
  ) async {
    await _pumpHome(tester, height: 874);
    expect(find.byKey(const ValueKey('home.status-scrim')), findsNothing);
    await tester.drag(
      find.byKey(const ValueKey('home.page')),
      const Offset(0, -240),
    );
    await tester.pumpAndSettle();
    final scrim = tester.getRect(
      find.byKey(const ValueKey('home.status-scrim')),
    );
    expect(scrim.top, 0);
    expect(scrim.height, 55);
    expect(scrim.width, 402);
    expect(
      tester
          .widget<ColoredBox>(find.byKey(const ValueKey('home.status-scrim')))
          .color,
      productSkin.valuesFor(Brightness.dark).color('Surface/Base'),
    );
  });

  testWidgets('Home centers a 600 column from Medium upward', (tester) async {
    await _pumpHome(tester, width: 800, height: 874);
    final page = tester.getRect(find.byKey(const ValueKey('home.page')));
    expect(page.width, AdaptiveTokens.contentMaxWidth);
    expect(page.left, (800 - AdaptiveTokens.contentMaxWidth) / 2);
  });

  testWidgets('hero foreground lags with scroll and stays still when reduced', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(402, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_bannerHost(0));
    final rest = tester
        .getRect(find.byKey(const ValueKey('probe.banner.foreground')))
        .top;
    await tester.pumpWidget(_bannerHost(100));
    expect(
      tester
              .getRect(find.byKey(const ValueKey('probe.banner.foreground')))
              .top -
          rest,
      CollectionMotion.heroParallaxMax,
    );
    await tester.pumpWidget(_bannerHost(0));
    final backgroundRest = tester
        .getRect(find.byKey(const ValueKey('probe.banner.background')))
        .top;
    await tester.pumpWidget(_bannerHost(100));
    expect(
      tester
              .getRect(find.byKey(const ValueKey('probe.banner.background')))
              .top -
          backgroundRest,
      100 * CollectionMotion.heroParallaxBackground,
    );
    await tester.pumpWidget(_bannerHost(100, reduced: true));
    expect(
      tester.getRect(find.byKey(const ValueKey('probe.banner.foreground'))).top,
      rest,
    );
    expect(
      tester.getRect(find.byKey(const ValueKey('probe.banner.background'))).top,
      backgroundRest,
    );
  });
}

Widget _bannerHost(double offset, {bool reduced = false}) => MaterialApp(
  theme: AppThemeFactory.build(brightness: Brightness.dark, skin: productSkin),
  home: MediaQuery(
    data: MediaQueryData(
      size: const Size(402, 800),
      padding: const EdgeInsets.only(top: 55),
      disableAnimations: reduced,
    ),
    child: UiIdentityScope(
      routeName: 'probe',
      child: Scaffold(
        body: HomeHeroBanner(
          elementId: 'probe.banner',
          background: _pixel,
          foreground: _pixel,
          foregroundBox: const HeroArtworkBox(
            left: 106,
            top: 121,
            width: 246,
            height: 248,
          ),
          overlap: 55 + 64,
          parallaxOffset: offset,
        ),
      ),
    ),
  ),
);

/// A 1×1 image, so the parallax test does not fetch sample artwork.
final _pixel = MemoryImage(
  Uint8List.fromList(const [
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ]),
);
