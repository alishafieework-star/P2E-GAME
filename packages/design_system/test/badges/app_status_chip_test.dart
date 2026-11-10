import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  testWidgets('AppStatusChip renders label and supports dot indicator', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const AppStatusChip(
          elementId: 'badge.test-live',
          label: 'Live',
          status: AppStatusType.live,
        ),
      ),
    );

    expect(find.text('Live'), findsOneWidget);
    // Live automatically includes dot indicator
    final containerFinder = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).shape == BoxShape.circle,
    );
    expect(containerFinder, findsOneWidget);
  });

  for (final status in AppStatusType.values) {
    testWidgets('AppStatusChip renders correctly for status $status', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Brightness.dark,
          AppStatusChip(
            elementId: 'badge.test-${status.name}',
            label: status.name.toUpperCase(),
            status: status,
          ),
        ),
      );

      expect(find.text(status.name.toUpperCase()), findsOneWidget);
    });
  }

  testWidgets('AppStatusChip subtle vs outlined vs filled appearances', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const Column(
          children: [
            AppStatusChip(
              elementId: 'badge.test-subtle',
              label: 'Subtle',
              status: AppStatusType.success,
              appearance: AppStatusAppearance.subtle,
            ),
            AppStatusChip(
              elementId: 'badge.test-outlined',
              label: 'Outlined',
              status: AppStatusType.success,
              appearance: AppStatusAppearance.outlined,
            ),
            AppStatusChip(
              elementId: 'badge.test-filled',
              label: 'Filled',
              status: AppStatusType.success,
              appearance: AppStatusAppearance.filled,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Subtle'), findsOneWidget);
    expect(find.text('Outlined'), findsOneWidget);
    expect(find.text('Filled'), findsOneWidget);
  });

  testWidgets('AppStatusChip fires onTap callback when provided', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        AppStatusChip(
          elementId: 'badge.test-tap',
          label: 'Clickable',
          status: AppStatusType.info,
          onTap: () => taps++,
        ),
      ),
    );

    await tester.tap(find.text('Clickable'));
    expect(taps, 1);
  });

  testWidgets('AppStatusChip provides ElementIdentity v1.1 metadata', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const AppStatusChip(
          elementId: 'badge.test-identity',
          label: 'Confirmed',
          status: AppStatusType.success,
          size: AppStatusSize.medium,
        ),
      ),
    );

    final elementFinder = find.byWidgetPredicate(
      (w) => w is ElementIdentity && w.elementId == 'badge.test-identity',
    );
    expect(elementFinder, findsOneWidget);

    final identity = tester.widget<ElementIdentity>(elementFinder);
    expect(identity.componentId, 'badge.status-chip');
    expect(identity.fileKey, '7BurKbCwclcabEGJ7cLcKz');
    expect(identity.variants['status'], 'success');
    expect(identity.variants['size'], 'medium');
    expect(identity.declared['label'], 'Confirmed');
  });
}

Widget _host(Brightness brightness, Widget child) => MaterialApp(
  theme: AppThemeFactory.build(brightness: brightness, skin: productSkin),
  home: UiIdentityScope(
    routeName: 'test.status-chips',
    child: Scaffold(body: child),
  ),
);
