import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  testWidgets('AppKeyValueRow renders label and value text', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const AppKeyValueRow(
          elementId: 'row.test-basic',
          label: 'Order ID',
          value: '#T-20377',
        ),
      ),
    );

    expect(find.text('Order ID'), findsOneWidget);
    expect(find.text('#T-20377'), findsOneWidget);
  });

  testWidgets('AppKeyValueRow renders valueWidget slot', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const AppKeyValueRow(
          elementId: 'row.test-slot',
          label: 'Status',
          valueWidget: AppStatusChip(
            elementId: 'badge.test-slot-status',
            label: 'Paid',
            status: AppStatusType.success,
          ),
        ),
      ),
    );

    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Paid'), findsOneWidget);
    expect(find.byType(AppStatusChip), findsOneWidget);
  });

  for (final variant in AppKeyValueVariant.values) {
    testWidgets('AppKeyValueRow variant $variant renders without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Brightness.dark,
          AppKeyValueRow(
            elementId: 'row.test-${variant.name}',
            label: 'Total',
            value: '54,000 Toman',
            variant: variant,
          ),
        ),
      );

      expect(find.text('Total'), findsOneWidget);
      expect(find.text('54,000 Toman'), findsOneWidget);
    });
  }

  testWidgets('AppKeyValueRow renders top and bottom dividers when enabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const AppKeyValueRow(
          elementId: 'row.test-dividers',
          label: 'Grand Total',
          value: '100,000',
          hasTopDivider: true,
          hasBottomDivider: true,
        ),
      ),
    );

    expect(find.byType(Divider), findsNWidgets(2));
  });

  testWidgets('AppKeyValueRow fires onTap when tapped', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppKeyValueRow(
          elementId: 'row.test-tap',
          label: 'Tracking Code',
          value: 'TRK-987654',
          onTap: () => tapped++,
        ),
      ),
    );

    await tester.tap(find.text('TRK-987654'));
    expect(tapped, 1);
  });

  testWidgets('AppKeyValueRow supports RTL directional layout', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const Directionality(
          textDirection: TextDirection.rtl,
          child: AppKeyValueRow(
            elementId: 'row.test-rtl',
            label: 'مبلغ کل',
            value: '۵۰,۰۰۰ تومان',
          ),
        ),
      ),
    );

    expect(find.text('مبلغ کل'), findsOneWidget);
    expect(find.text('۵۰,۰۰۰ تومان'), findsOneWidget);

    final labelRect = tester.getRect(find.text('مبلغ کل'));
    final valueRect = tester.getRect(find.text('۵۰,۰۰۰ تومان'));

    // In RTL, start (label) is on the right, end (value) is on the left
    expect(labelRect.right, greaterThan(valueRect.right));
  });

  testWidgets('AppKeyValueRow provides ElementIdentity v1.1 metadata', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const AppKeyValueRow(
          elementId: 'row.test-identity',
          label: 'Discount',
          value: '-5,000',
          variant: AppKeyValueVariant.total,
          hasTopDivider: true,
        ),
      ),
    );

    final elementFinder = find.byWidgetPredicate(
      (w) => w is ElementIdentity && w.elementId == 'row.test-identity',
    );
    expect(elementFinder, findsOneWidget);

    final identity = tester.widget<ElementIdentity>(elementFinder);
    expect(identity.componentId, 'collection.key-value-row');
    expect(identity.fileKey, '7BurKbCwclcabEGJ7cLcKz');
    expect(identity.variants['variant'], 'total');
    expect(identity.variants['hasTopDivider'], 'true');
    expect(identity.declared['label'], 'Discount');
    expect(identity.declared['value'], '-5,000');
  });
}

Widget _host(Brightness brightness, Widget child) => MaterialApp(
  theme: AppThemeFactory.build(brightness: brightness, skin: productSkin),
  home: UiIdentityScope(
    routeName: 'test.key-value-rows',
    child: Scaffold(body: Center(child: child)),
  ),
);
