import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';

Future<void> mount(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.dark,
  bool reduced = false,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppThemeFactory.build(brightness: brightness),
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: Scaffold(
          body: UiIdentityScope(
            routeName: 'otp-status',
            child: Center(child: child),
          ),
        ),
      ),
    ),
  );
}

BoxDecoration cellDecoration(WidgetTester tester) {
  final box = tester
      .widgetList<DecoratedBox>(find.byType(DecoratedBox))
      .map((box) => box.decoration)
      .whereType<BoxDecoration>()
      .firstWhere((decoration) => decoration.border != null);
  return box;
}

void main() {
  final dark = productSkin.valuesFor(Brightness.dark);
  final light = productSkin.valuesFor(Brightness.light);
  final green = dark.color('Actions/Success/On Container');
  final red = dark.color('Actions/Error/On Container');

  testWidgets('source tone keeps the neutral success border', (tester) async {
    final spec = FieldSpec.lookup(
      FieldFamily.otp,
      FieldVisualState.success,
      Brightness.dark,
    );
    await mount(tester, AppOtpCell(spec: spec, value: 'P'));
    await tester.pump(FieldMotion.color);
    expect(
      cellDecoration(tester).border!.top.color,
      spec.withSkin(productSkin).color('body', stroke: true),
    );
    expect(find.byType(AssetAppIcon), findsOneWidget);
    expect(find.text('P'), findsNothing);
  });

  testWidgets('status success is green and hides the digit', (tester) async {
    for (final brightness in Brightness.values) {
      final roles = brightness == Brightness.dark ? dark : light;
      final spec = FieldSpec.lookup(
        FieldFamily.otp,
        FieldVisualState.success,
        brightness,
      );
      await mount(
        tester,
        AppOtpCell(
          spec: spec,
          value: 'P',
          feedbackTone: AppOtpFeedbackTone.status,
        ),
        brightness: brightness,
      );
      await tester.pump(FieldMotion.statusColor);
      expect(
        cellDecoration(tester).border!.top.color,
        roles.color('Actions/Success/On Container'),
      );
      expect(find.text('P'), findsNothing);
    }
  });

  testWidgets('status error is red and shakes within 8dp', (tester) async {
    final controller = TextEditingController(text: 'P00000');
    addTearDown(controller.dispose);
    Future<void> show({
      FieldFeedback feedback = const FieldFeedback.neutral(),
    }) => mount(
      tester,
      AppOtpField(
        elementId: 'otp.status',
        label: 'Code',
        controller: controller,
        feedbackTone: AppOtpFeedbackTone.status,
        feedback: feedback,
      ),
    );
    await show();
    await show(feedback: FieldFeedback.error('Rejected'));
    await tester.pump(const Duration(milliseconds: 100));
    final moving = tester.widget<Transform>(
      find.byKey(const ValueKey('otp.shake')),
    );
    expect((moving.transform.getTranslation().x).abs(), lessThanOrEqualTo(8));
    expect(moving.transform.getTranslation().x, isNot(0));
    await tester.pump(FieldMotion.statusShake);
    final settled = tester.widget<Transform>(
      find.byKey(const ValueKey('otp.shake')),
    );
    expect(settled.transform.getTranslation().x, 0);
    await tester.pump(FieldMotion.statusColor);
    expect(cellDecoration(tester).border!.top.color, red);
    expect(tester.widget<Text>(find.text('P')).style!.color, red);
  });

  testWidgets('reduced motion does not shake', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    Future<void> show({
      FieldFeedback feedback = const FieldFeedback.neutral(),
    }) => mount(
      tester,
      AppOtpField(
        elementId: 'otp.reduced',
        label: 'Code',
        controller: controller,
        feedbackTone: AppOtpFeedbackTone.status,
        feedback: feedback,
      ),
      reduced: true,
    );
    await show();
    await show(feedback: FieldFeedback.error('Rejected'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(
      tester
          .widget<Transform>(find.byKey(const ValueKey('otp.shake')))
          .transform
          .getTranslation()
          .x,
      0,
    );
  });

  testWidgets('status success paint is the dark skin green', (tester) async {
    expect(green, isNot(red));
  });
}
