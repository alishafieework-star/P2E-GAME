import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  Color role(Brightness brightness, String name) =>
      productSkin.valuesFor(brightness).color(name);

  testWidgets(
    'AppFilterChip displays label and count, and triggers onSelected',
    (tester) async {
      bool? selectedResult;
      await tester.pumpWidget(
        _host(
          Brightness.dark,
          AppFilterChip(
            elementId: 'chip.test-filter',
            label: 'This week',
            count: 14,
            selected: false,
            onSelected: (val) => selectedResult = val,
          ),
        ),
      );

      expect(find.text('This week'), findsOneWidget);
      expect(find.text('(14)'), findsOneWidget);

      await tester.tap(find.text('This week'));
      expect(selectedResult, isTrue);
    },
  );

  for (final brightness in Brightness.values) {
    testWidgets('AppFilterChip uses correct token colors in $brightness', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          brightness,
          Column(
            children: [
              AppFilterChip(
                elementId: 'chip.test-selected',
                label: 'Selected',
                selected: true,
                onSelected: (_) {},
              ),
              AppFilterChip(
                elementId: 'chip.test-unselected',
                label: 'Unselected',
                selected: false,
                onSelected: (_) {},
              ),
            ],
          ),
        ),
      );

      final selectedText = tester.widget<Text>(find.text('Selected'));
      final unselectedText = tester.widget<Text>(find.text('Unselected'));

      final expectedSelectedFg = role(
        brightness,
        brightness == Brightness.dark ? 'Alpha/Black' : 'Alpha/White',
      );
      final expectedUnselectedFg = role(brightness, 'On Surface/Base');

      expect(selectedText.style!.color, expectedSelectedFg);
      expect(unselectedText.style!.color, expectedUnselectedFg);
    });
  }

  testWidgets(
    'AppFilterChip disabled state suppresses taps and dims appearance',
    (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          Brightness.dark,
          AppFilterChip(
            elementId: 'chip.test-disabled',
            label: 'Disabled',
            enabled: false,
            onSelected: (_) => taps++,
          ),
        ),
      );

      await tester.tap(find.text('Disabled'), warnIfMissed: false);
      expect(taps, 0);

      final disabledText = tester.widget<Text>(find.text('Disabled'));
      expect(
        disabledText.style!.color,
        role(Brightness.dark, 'On Surface/Disabled'),
      );
    },
  );

  testWidgets('AppFilterChip exposes ElementIdentity metadata', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppFilterChip(
          elementId: 'chip.test-identity',
          label: 'Quests',
          selected: true,
          count: 5,
          size: AppFilterChipSize.small,
          onSelected: (_) {},
        ),
      ),
    );

    final elementFinder = find.byWidgetPredicate(
      (w) => w is ElementIdentity && w.elementId == 'chip.test-identity',
    );
    expect(elementFinder, findsOneWidget);

    final identity = tester.widget<ElementIdentity>(elementFinder);
    expect(identity.componentId, 'chip.filter-chip');
    expect(identity.fileKey, '7BurKbCwclcabEGJ7cLcKz');
    expect(identity.variants['selected'], 'true');
    expect(identity.variants['size'], 'small');
    expect(identity.declared['label'], 'Quests');
    expect(identity.declared['count'], 5);
  });

  testWidgets('AppFilterBar arranges chips in row with gap and padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppFilterBar(
          elementId: 'chip.test-filter-bar',
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          gap: 8,
          chips: [
            AppFilterChip(
              elementId: 'chip.test-bar-1',
              label: 'Tab 1',
              selected: true,
              onSelected: (_) {},
            ),
            AppFilterChip(
              elementId: 'chip.test-bar-2',
              label: 'Tab 2',
              selected: false,
              onSelected: (_) {},
            ),
          ],
        ),
      ),
    );

    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.text('Tab 2'), findsOneWidget);

    final chip1Rect = tester.getRect(find.text('Tab 1'));
    final chip2Rect = tester.getRect(find.text('Tab 2'));

    expect(chip1Rect.left, greaterThanOrEqualTo(16));
    expect(chip2Rect.left, greaterThan(chip1Rect.right));
  });

  testWidgets('AppFilterBar scrolls horizontally in RTL', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        Directionality(
          textDirection: TextDirection.rtl,
          child: AppFilterBar(
            elementId: 'chip.test-filter-bar-rtl',
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            gap: 8,
            chips: [
              AppFilterChip(
                elementId: 'chip.test-rtl-1',
                label: 'هفتگی',
                selected: true,
                onSelected: (_) {},
              ),
              AppFilterChip(
                elementId: 'chip.test-rtl-2',
                label: 'ماهانه',
                selected: false,
                onSelected: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('هفتگی'), findsOneWidget);
    expect(find.text('ماهانه'), findsOneWidget);

    final chip1Rect = tester.getRect(find.text('هفتگی'));
    final chip2Rect = tester.getRect(find.text('ماهانه'));

    // In RTL, first item starts near right edge
    expect(chip1Rect.right, lessThanOrEqualTo(800 - 16));
    expect(chip2Rect.right, lessThan(chip1Rect.left));
  });
}

Widget _host(Brightness brightness, Widget child) => MaterialApp(
  theme: AppThemeFactory.build(brightness: brightness, skin: productSkin),
  home: UiIdentityScope(
    routeName: 'test.chips',
    child: Scaffold(body: child),
  ),
);
