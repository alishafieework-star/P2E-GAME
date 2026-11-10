import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  testWidgets('AppStickyActionBar single button mode expands full-width', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppStickyActionBar(
          elementId: 'action-bar.test-single',
          primaryAction: ElevatedButton(
            onPressed: () {},
            child: const Text('Confirm Payment'),
          ),
          useSafeArea: false,
        ),
      ),
    );

    expect(find.text('Confirm Payment'), findsOneWidget);
    final buttonSize = tester.getSize(find.byType(ElevatedButton));
    // Single mode expands button to full width minus padding (800 - 32 = 768)
    expect(buttonSize.width, 800 - 32);
  });

  testWidgets('AppStickyActionBar dual button mode renders both actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppStickyActionBar(
          elementId: 'action-bar.test-dual',
          primaryAction: ElevatedButton(
            onPressed: () {},
            child: const Text('Confirm'),
          ),
          secondaryAction: OutlinedButton(
            onPressed: () {},
            child: const Text('Cancel'),
          ),
          useSafeArea: false,
        ),
      ),
    );

    expect(find.text('Confirm'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    final cancelRect = tester.getRect(find.text('Cancel'));
    final confirmRect = tester.getRect(find.text('Confirm'));

    expect(cancelRect.left, lessThan(confirmRect.left));
  });

  testWidgets('AppStickyActionBar summary mode renders title and price', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppStickyActionBar(
          elementId: 'action-bar.test-summary',
          summaryTitle: 'Total Amount',
          summarySubtitle: '54,000 Toman',
          primaryAction: ElevatedButton(
            onPressed: () {},
            child: const Text('Pay Now'),
          ),
          useSafeArea: false,
        ),
      ),
    );

    expect(find.text('Total Amount'), findsOneWidget);
    expect(find.text('54,000 Toman'), findsOneWidget);
    expect(find.text('Pay Now'), findsOneWidget);
  });

  testWidgets('AppStickyActionBar respects RTL layout mirroring', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        Directionality(
          textDirection: TextDirection.rtl,
          child: AppStickyActionBar(
            elementId: 'action-bar.test-rtl',
            summaryTitle: 'مبلغ قابل پرداخت',
            summarySubtitle: '۵۴,۰۰۰ تومان',
            primaryAction: ElevatedButton(
              onPressed: () {},
              child: const Text('پرداخت'),
            ),
            useSafeArea: false,
          ),
        ),
      ),
    );

    expect(find.text('مبلغ قابل پرداخت'), findsOneWidget);
    expect(find.text('پرداخت'), findsOneWidget);

    final summaryRect = tester.getRect(find.text('مبلغ قابل پرداخت'));
    final payRect = tester.getRect(find.text('پرداخت'));

    // In RTL, summary is at start (right), primary CTA is at end (left)
    expect(summaryRect.right, greaterThan(payRect.right));
  });

  testWidgets('AppStickyActionBar provides ElementIdentity v1.1 metadata', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppStickyActionBar(
          elementId: 'action-bar.test-identity',
          summaryTitle: 'Total',
          summarySubtitle: '10,000',
          primaryAction: ElevatedButton(
            onPressed: () {},
            child: const Text('OK'),
          ),
          useSafeArea: true,
        ),
      ),
    );

    final elementFinder = find.byWidgetPredicate(
      (w) => w is ElementIdentity && w.elementId == 'action-bar.test-identity',
    );
    expect(elementFinder, findsOneWidget);

    final identity = tester.widget<ElementIdentity>(elementFinder);
    expect(identity.componentId, 'navigation.sticky-action-bar');
    expect(identity.fileKey, '7BurKbCwclcabEGJ7cLcKz');
    expect(identity.variants['hasSummary'], 'true');
    expect(identity.variants['useSafeArea'], 'true');
    expect(identity.declared['summaryTitle'], 'Total');
  });
}

Widget _host(Brightness brightness, Widget child) => MaterialApp(
  theme: AppThemeFactory.build(brightness: brightness, skin: productSkin),
  home: UiIdentityScope(
    routeName: 'test.sticky-action-bar',
    child: Scaffold(bottomNavigationBar: child),
  ),
);
