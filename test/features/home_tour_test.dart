import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/tour/src/presentation/home_tour.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/preferences/device_preferences.dart';
import 'package:mygame_p2e/shared/tour/tour_target.dart';
import 'package:p2e_design_system/design_system.dart';

/// Slots on a scrolling page, like Home. [featuredHeight] stands for "today's
/// game is different": the frame must follow the slot, not the content.
class _Page extends StatelessWidget {
  const _Page({required this.featuredHeight});
  final double featuredHeight;

  @override
  Widget build(BuildContext context) {
    Widget box(String id, double h) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: TourTarget(
        id: id,
        child: Container(
          key: ValueKey('slot.$id'),
          height: h,
          color: const Color(0xFF334455),
        ),
      ),
    );
    return Stack(
      children: [
        ListView(
          children: [
            box('featured', featuredHeight),
            const SizedBox(height: 500),
            box('score', 160),
            const SizedBox(height: 700),
            box('quests', 120),
            const SizedBox(height: 900),
          ],
        ),
        const HomeTour(),
      ],
    );
  }
}

/// Like Home: the score slot lives inside a horizontal shelf, the quests
/// slot further down the vertical list. The tour must scroll the page and
/// never the shelf.
class _ShelfPage extends StatelessWidget {
  const _ShelfPage({required this.shelf});
  final ScrollController shelf;

  @override
  Widget build(BuildContext context) {
    Widget box(String id, double h, {double? width}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: TourTarget(
        id: id,
        child: Container(
          key: ValueKey('slot.$id'),
          width: width,
          height: h,
          color: const Color(0xFF334455),
        ),
      ),
    );
    return Stack(
      children: [
        ListView(
          children: [
            box('featured', 200),
            const SizedBox(height: 500),
            SingleChildScrollView(
              controller: shelf,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  box('score', 160, width: 320),
                  const SizedBox(width: 800),
                ],
              ),
            ),
            const SizedBox(height: 700),
            box('quests', 120),
            const SizedBox(height: 900),
          ],
        ),
        const HomeTour(),
      ],
    );
  }
}

Future<void> _pump(WidgetTester tester, Widget page) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(402, 874);
  addTearDown(tester.view.reset);
  addTearDown(TourTarget.contexts.clear);
  final prefs = EphemeralDevicePreferences()
    ..value = const DevicePreferences(
      onboardingSeen: true,
      homeTourPending: true,
    );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [devicePreferencesRepositoryProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppThemeFactory.build(
          brightness: Brightness.dark,
          skin: productSkin,
        ),
        home: Scaffold(body: page),
      ),
    ),
  );
}

Future<void> _host(WidgetTester tester, double featuredHeight) =>
    _pump(tester, _Page(featuredHeight: featuredHeight));

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 60; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Rect _hole(WidgetTester tester) =>
    tester.widget<TourSpotlight>(find.byType(TourSpotlight)).hole!;

Rect _slot(WidgetTester tester, String id) =>
    tester.getRect(find.byKey(ValueKey('slot.$id')));

void main() {
  testWidgets('frame hugs the slot, follows it, and tracks scrolled targets', (
    tester,
  ) async {
    await _host(tester, 200);
    await _settle(tester);

    // Wallet is absent here, so the tour starts at the featured slot.
    var slot = _slot(tester, 'featured');
    var hole = _hole(tester);
    expect(hole.top, closeTo(slot.top - HtmlJourneyTokens.trPad, 1));
    expect(hole.bottom, closeTo(slot.bottom + HtmlJourneyTokens.trPad, 1));
    expect(hole.left, closeTo(slot.left - HtmlJourneyTokens.trPad, 1));

    // Different content in the same slot: the frame follows the live box.
    await tester.pumpWidget(const SizedBox());
    await _host(tester, 320);
    await _settle(tester);
    slot = _slot(tester, 'featured');
    hole = _hole(tester);
    expect(hole.height, closeTo(slot.height + 2 * HtmlJourneyTokens.trPad, 1));

    // Next scrolls the page and the frame lands on the score slot.
    await tester.tap(find.text('Next'));
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    slot = _slot(tester, 'score');
    hole = _hole(tester);
    expect(hole.top, closeTo(slot.top - HtmlJourneyTokens.trPadCard, 1));
    expect(hole.bottom, closeTo(slot.bottom + HtmlJourneyTokens.trPadCard, 1));
    expect(find.text('Points on every game'), findsOneWidget);
  });

  testWidgets(
    'slots inside a horizontal shelf scroll the page, never the shelf',
    (tester) async {
      final shelf = ScrollController();
      addTearDown(shelf.dispose);
      await _pump(tester, _ShelfPage(shelf: shelf));
      await _settle(tester);

      // Next to the score slot: the page scrolls, the shelf stays put.
      await tester.tap(find.text('Next'));
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(shelf.offset, 0);
      var slot = _slot(tester, 'score');
      expect(slot.top, greaterThanOrEqualTo(HtmlJourneyTokens.trScrollMin - 1));
      expect(
        _hole(tester).top,
        closeTo(slot.top - HtmlJourneyTokens.trPadCard, 2),
      );

      // Next to the quests slot: the page scrolls further down. The ListView
      // may have recycled the shelf by now, so only assert it when mounted.
      await tester.tap(find.text('Next'));
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      if (shelf.hasClients) expect(shelf.offset, 0);
      slot = _slot(tester, 'quests');
      final hole = _hole(tester);
      expect(hole.top, closeTo(slot.top - HtmlJourneyTokens.trPad, 2));
      expect(hole.bottom, lessThanOrEqualTo(874.0));
    },
  );
}
