import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  testWidgets('AppSegmentedTabs renders tabs, badges, and fires onChanged', (
    tester,
  ) async {
    int? selected;
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppSegmentedTabs(
          elementId: 'tabs.test-basic',
          selectedIndex: 0,
          onChanged: (val) => selected = val,
          tabs: const [
            AppSegmentedTabItem(label: 'Coins', badge: '12'),
            AppSegmentedTabItem(label: 'Rewards'),
          ],
        ),
      ),
    );

    expect(find.text('Coins'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);

    await tester.tap(find.text('Rewards'));
    expect(selected, 1);
  });

  testWidgets('AppSegmentedTabs respects RTL layout order', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        Directionality(
          textDirection: TextDirection.rtl,
          child: AppSegmentedTabs(
            elementId: 'tabs.test-rtl',
            selectedIndex: 0,
            tabs: const [
              AppSegmentedTabItem(label: 'سکه‌ها'),
              AppSegmentedTabItem(label: 'جوایز'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('سکه‌ها'), findsOneWidget);
    expect(find.text('جوایز'), findsOneWidget);

    final coinsRect = tester.getRect(find.text('سکه‌ها'));
    final rewardsRect = tester.getRect(find.text('جوایز'));

    // In RTL, tab 0 (سکه‌ها) is on the right, tab 1 (جوایز) is on the left
    expect(coinsRect.right, greaterThan(rewardsRect.right));
  });

  testWidgets('AppSegmentedTabs provides ElementIdentity v1.1 metadata', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppSegmentedTabs(
          elementId: 'tabs.test-identity',
          selectedIndex: 1,
          tabs: [
            AppSegmentedTabItem(label: 'Overall'),
            AppSegmentedTabItem(label: 'Games'),
          ],
        ),
      ),
    );

    final elementFinder = find.byWidgetPredicate(
      (w) => w is ElementIdentity && w.elementId == 'tabs.test-identity',
    );
    expect(elementFinder, findsOneWidget);

    final identity = tester.widget<ElementIdentity>(elementFinder);
    expect(identity.componentId, 'tabs.segmented');
    expect(identity.fileKey, '7BurKbCwclcabEGJ7cLcKz');
    expect(identity.variants['selectedIndex'], '1');
    expect(identity.variants['tabCount'], '2');
    expect(identity.declared['selectedIndex'], 1);
  });
}

Widget _host(Brightness brightness, Widget child) => MaterialApp(
  theme: AppThemeFactory.build(brightness: brightness, skin: productSkin),
  home: UiIdentityScope(
    routeName: 'test.segmented-tabs',
    child: Scaffold(body: Center(child: child)),
  ),
);
