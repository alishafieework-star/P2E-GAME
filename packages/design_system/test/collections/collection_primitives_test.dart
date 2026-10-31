import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  Color role(Brightness brightness, String name) =>
      productSkin.valuesFor(brightness).color(name);

  testWidgets('section header action is optional and fires once', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppSectionHeader(
          elementId: 'test.section.recommended',
          title: 'Recommended for You',
          actionLabel: 'View More',
          onAction: () => taps++,
        ),
      ),
    );
    await tester.tap(find.text('View More'));
    expect(taps, 1);
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const AppSectionHeader(
          elementId: 'test.section.recommended',
          title: 'Recommended for You',
        ),
      ),
    );
    expect(find.text('View More'), findsNothing);
  });

  for (final brightness in Brightness.values) {
    testWidgets('section header uses the $brightness source roles', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          brightness,
          AppSectionHeader(
            elementId: 'test.section.recommended',
            title: 'Recommended for You',
            actionLabel: 'View More',
            onAction: () {},
          ),
        ),
      );
      final title = tester.widget<Text>(find.text('Recommended for You'));
      final action = tester.widget<Text>(find.text('View More'));
      expect(
        title.style!.color,
        role(
          brightness,
          brightness == Brightness.dark
              ? 'On Surface/Emphasis'
              : 'On Surface/Base',
        ),
      );
      expect(action.style!.color, role(brightness, 'Action/Accent'));
    });
  }

  testWidgets('a two-tone header can omit the chevron', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.light,
        AppSectionHeader(
          elementId: 'test.section.about',
          lead: 'About',
          subject: 'Clash of Clans',
          actionLabel: 'Read More',
          actionChevron: false,
          onAction: () {},
        ),
      ),
    );
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Clash of Clans'), findsOneWidget);
    expect(find.byType(AssetAppIcon), findsNothing);
    final lead = tester.widget<Text>(find.text('About'));
    expect(lead.style!.color, role(Brightness.light, 'On Surface/Muted'));
  });

  testWidgets('page indicator marks one selected dot', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.light,
        const AppPageIndicator(
          elementId: 'test.pages.multiplayer',
          count: 3,
          index: 1,
          semanticLabel: 'Page 2 of 3',
        ),
      ),
    );
    expect(find.bySemanticsLabel('Page 2 of 3'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('collection.page-dot.active')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('collection.page-dot')), findsNWidgets(2));
  });

  for (final spacing in AppShelfSpacing.values) {
    testWidgets('paged shelf ($spacing) reports the settled page', (
      tester,
    ) async {
      var page = 0;
      await tester.pumpWidget(
        _host(
          Brightness.dark,
          AppShelf(
            elementId: 'test.shelf.paged',
            layout: AppShelfLayout.paged,
            spacing: spacing,
            onPageChanged: (value) => page = value,
            children: const [
              SizedBox(key: ValueKey('a'), height: 100),
              SizedBox(key: ValueKey('b'), height: 100),
            ],
          ),
        ),
      );
      final identity = tester.widget<ElementIdentity>(
        find.byType(ElementIdentity).first,
      );
      expect(
        identity.resolved['gap'],
        spacing == AppShelfSpacing.regular
            ? CollectionTokens.shelfGapRegular
            : CollectionTokens.shelfGapRelaxed,
      );
      await tester.fling(
        find.byType(SingleChildScrollView),
        const Offset(-500, 0),
        800,
      );
      await tester.pumpAndSettle();
      expect(page, 1);
      const inset = CollectionTokens.sectionPadding;
      final second = tester.getRect(find.byKey(const ValueKey('b')));
      expect(second.left, inset);
      expect(second.width, 800 - inset * 2);
    });
  }

  testWidgets(
    'scroll shelf rests at the inset and grows to its tallest child',
    (tester) async {
      await tester.pumpWidget(
        _host(
          Brightness.dark,
          const SingleChildScrollView(
            child: AppShelf(
              elementId: 'test.shelf.scroll',
              children: [
                SizedBox(key: ValueKey('a'), width: 120, height: 100),
                SizedBox(key: ValueKey('b'), width: 120, height: 180),
              ],
            ),
          ),
        ),
      );
      final first = tester.getRect(find.byKey(const ValueKey('a')));
      final second = tester.getRect(find.byKey(const ValueKey('b')));
      expect(first.left, CollectionTokens.sectionPadding);
      expect(second.left - first.right, CollectionTokens.shelfGapRegular);
      expect(tester.getSize(find.byType(AppShelf)).height, 180);
    },
  );

  testWidgets('scroll shelf mirrors in right-to-left', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const Directionality(
          textDirection: TextDirection.rtl,
          child: AppShelf(
            elementId: 'test.shelf.scroll',
            children: [SizedBox(key: ValueKey('a'), width: 120, height: 100)],
          ),
        ),
      ),
    );
    expect(
      tester.getRect(find.byKey(const ValueKey('a'))).right,
      800 - CollectionTokens.sectionPadding,
    );
  });
}

Widget _host(Brightness brightness, Widget child) => MaterialApp(
  theme: AppThemeFactory.build(brightness: brightness, skin: productSkin),
  home: UiIdentityScope(
    routeName: 'test.collections',
    child: Scaffold(body: child),
  ),
);
