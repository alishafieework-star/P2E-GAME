import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  testWidgets('AppProgressBar renders progress value and labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const AppProgressBar(
          elementId: 'progress.test-basic',
          value: 0.75,
          label: 'Quest Step',
          trailingLabel: '3/4',
          minLabel: '0',
          maxLabel: '100',
          animated: false,
        ),
      ),
    );

    expect(find.text('Quest Step'), findsOneWidget);
    expect(find.text('3/4'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);

    final fractionFinder = find.byType(FractionallySizedBox);
    expect(fractionFinder, findsOneWidget);

    final fraction = tester.widget<FractionallySizedBox>(fractionFinder);
    expect(fraction.widthFactor, 0.75);
  });

  for (final height in AppProgressHeight.values) {
    testWidgets(
      'AppProgressBar height $height renders with correct track height',
      (tester) async {
        await tester.pumpWidget(
          _host(
            Brightness.dark,
            AppProgressBar(
              elementId: 'progress.test-${height.name}',
              value: 0.5,
              height: height,
              animated: false,
            ),
          ),
        );

        final expectedHeight = switch (height) {
          AppProgressHeight.sm => 6.0,
          AppProgressHeight.md => 8.0,
          AppProgressHeight.lg => 12.0,
        };

        final trackContainer = find.byWidgetPredicate(
          (w) => w is Container && w.constraints?.maxHeight == expectedHeight,
        );
        expect(trackContainer, findsWidgets);
      },
    );
  }

  for (final tone in AppProgressTone.values) {
    testWidgets('AppProgressBar tone $tone renders without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Brightness.dark,
          AppProgressBar(
            elementId: 'progress.test-${tone.name}',
            value: 0.4,
            tone: tone,
            animated: false,
          ),
        ),
      );

      expect(find.byType(AppProgressBar), findsOneWidget);
    });
  }

  testWidgets('AppProgressBar indeterminate mode renders', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const AppProgressBar(
          elementId: 'progress.test-indeterminate',
          value: null,
        ),
      ),
    );

    expect(find.byType(AppProgressBar), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('AppProgressBar directional start aligns in RTL', (tester) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const Directionality(
          textDirection: TextDirection.rtl,
          child: AppProgressBar(
            elementId: 'progress.test-rtl',
            value: 0.5,
            label: 'پیشرفت',
            animated: false,
          ),
        ),
      ),
    );

    expect(find.text('پیشرفت'), findsOneWidget);

    final alignFinder = find.byWidgetPredicate(
      (w) => w is Align && w.alignment == AlignmentDirectional.centerStart,
    );
    expect(alignFinder, findsOneWidget);
  });

  testWidgets('AppProgressBar provides ElementIdentity v1.1 metadata', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Brightness.dark,
        const AppProgressBar(
          elementId: 'progress.test-identity',
          value: 0.6,
          height: AppProgressHeight.lg,
          tone: AppProgressTone.emerald,
          label: 'Missions',
          animated: false,
        ),
      ),
    );

    final elementFinder = find.byWidgetPredicate(
      (w) => w is ElementIdentity && w.elementId == 'progress.test-identity',
    );
    expect(elementFinder, findsOneWidget);

    final identity = tester.widget<ElementIdentity>(elementFinder);
    expect(identity.componentId, 'progress.bar');
    expect(identity.fileKey, '7BurKbCwclcabEGJ7cLcKz');
    expect(identity.variants['height'], 'lg');
    expect(identity.variants['tone'], 'emerald');
    expect(identity.variants['hasHeader'], 'true');
    expect(identity.declared['value'], 0.6);
  });
}

Widget _host(Brightness brightness, Widget child) => MaterialApp(
  theme: AppThemeFactory.build(brightness: brightness, skin: productSkin),
  home: UiIdentityScope(
    routeName: 'test.progress-bars',
    child: Scaffold(body: Center(child: child)),
  ),
);
