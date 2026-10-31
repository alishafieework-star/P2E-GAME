import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/shared/widgets/collection_section.dart';
import 'package:mygame_p2e/shared/widgets/game_info_row.dart';
import 'package:mygame_p2e/shared/widgets/reward_badge.dart';
import 'package:p2e_design_system/design_system.dart';

/// A 1×1 transparent PNG, so the test does not depend on product artwork.
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

void main() {
  Color role(Brightness brightness, String name) =>
      productSkin.valuesFor(brightness).color(name);

  testWidgets('featured row shows identity, action and caption', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        GameInfoRow(
          elementId: 'games.row.featured',
          layout: GameInfoLayout.featured,
          icon: _pixel,
          name: 'Clash of Clans',
          creator: 'Supercell',
          actionLabel: 'Play Now',
          caption: 'Free to Play',
          onAction: () => taps++,
        ),
      ),
    );
    expect(find.text('Clash of Clans'), findsOneWidget);
    expect(find.text('Supercell'), findsOneWidget);
    expect(find.text('Free to Play'), findsOneWidget);
    await tester.tap(find.text('Play Now'));
    expect(taps, 1);
  });

  for (final brightness in Brightness.values) {
    testWidgets('featured row shadow and name follow $brightness source', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          brightness,
          GameInfoRow(
            elementId: 'games.row.featured',
            layout: GameInfoLayout.featured,
            icon: _pixel,
            name: 'Clash of Clans',
            creator: 'Supercell',
            actionLabel: 'Play Now',
          ),
        ),
      );
      final surface = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((decoration) => decoration.borderRadius != null);
      expect(
        surface.boxShadow ?? const [],
        hasLength(brightness == Brightness.light ? 1 : 0),
      );
      expect(
        tester.widget<Text>(find.text('Clash of Clans')).style!.color,
        role(brightness, 'On Surface/Emphasis'),
      );
    });

    testWidgets('quest step reward uses the $brightness source roles', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          brightness,
          const RewardBadge(
            elementId: 'missions.reward.step',
            appearance: RewardBadgeAppearance.step,
            amount: '+250',
            unit: 'pts',
          ),
        ),
      );
      expect(
        tester.widget<Text>(find.text('+250')).style!.color,
        role(
          brightness,
          brightness == Brightness.dark
              ? 'On Surface/Emphasis'
              : 'On Surface/Variant',
        ),
      );
    });
  }

  testWidgets('a failed icon keeps the row layout', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        GameInfoRow(
          elementId: 'games.row.card',
          layout: GameInfoLayout.card,
          icon: MemoryImage(Uint8List.fromList(const [0, 1, 2, 3])),
          name: 'MONOPOLY',
          creator: 'Marmalade Game',
          actionLabel: 'Play Now',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('MONOPOLY'), findsOneWidget);
  });

  testWidgets('reward appearances keep supplied digits', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const Column(
          children: [
            RewardBadge(
              elementId: 'games.reward.overlay',
              appearance: RewardBadgeAppearance.overlay,
              amount: '+520',
              unit: 'pts',
            ),
            RewardBadge(
              elementId: 'missions.reward.total',
              appearance: RewardBadgeAppearance.total,
              amount: '750',
              unit: 'pts',
              secondaryAmount: '1,750',
            ),
          ],
        ),
      ),
    );
    expect(find.text('+520'), findsOneWidget);
    expect(find.text('750'), findsOneWidget);
    expect(find.text('1,750'), findsOneWidget);
    expect(find.bySemanticsLabel('750 / 1,750 pts'), findsOneWidget);
  });

  testWidgets('collection section insets the header, not the content', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const SingleChildScrollView(
          child: CollectionSection(
            elementId: 'test.section',
            header: SizedBox(key: ValueKey('header'), height: 36),
            content: SizedBox(key: ValueKey('content'), height: 50),
            footer: SizedBox(key: ValueKey('footer'), width: 30, height: 8),
          ),
        ),
      ),
    );
    const padding = CollectionTokens.sectionPadding;
    const gap = CollectionTokens.sectionContentGap;
    final header = tester.getRect(find.byKey(const ValueKey('header')));
    final content = tester.getRect(find.byKey(const ValueKey('content')));
    final footer = tester.getRect(find.byKey(const ValueKey('footer')));
    expect(header.topLeft, const Offset(padding, padding));
    expect(content.left, 0);
    expect(content.top, header.bottom + gap);
    expect(footer.top, content.bottom + gap);
    expect(footer.center.dx, 400);
    expect(
      tester.getSize(find.byType(CollectionSection)).height,
      padding + 36 + gap + 50 + gap + 8 + padding,
    );
  });

  testWidgets('light overlay keeps the source white scrim', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.light,
        const RewardBadge(
          elementId: 'games.reward.overlay',
          appearance: RewardBadgeAppearance.overlay,
          amount: '+520',
          unit: 'pts',
        ),
      ),
    );
    final scrim = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((decoration) => decoration.shape == BoxShape.rectangle);
    expect(scrim.color, (HomePaints.overlayScrim.light as RawPaint).color);
  });
}

Widget _host(Brightness brightness, Widget child) => MaterialApp(
  theme: AppThemeFactory.build(brightness: brightness, skin: productSkin),
  home: UiIdentityScope(
    routeName: 'test.home',
    child: Scaffold(body: child),
  ),
);
