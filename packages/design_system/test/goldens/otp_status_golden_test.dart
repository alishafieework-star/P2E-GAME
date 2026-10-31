import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  testWidgets('otp-status-en-dark-1.0-product-402', (tester) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(402, 160);
    final success = FieldSpec.lookup(
      FieldFamily.otp,
      FieldVisualState.success,
      Brightness.dark,
    );
    final error = FieldSpec.lookup(
      FieldFamily.otp,
      FieldVisualState.error,
      Brightness.dark,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.build(brightness: Brightness.dark),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: Center(
              child: Row(
                key: const ValueKey('otp-status-sheet'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppOtpCell(
                    spec: success,
                    feedbackTone: AppOtpFeedbackTone.status,
                  ),
                  const SizedBox(width: 16),
                  AppOtpCell(
                    spec: error,
                    value: '1',
                    feedbackTone: AppOtpFeedbackTone.status,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('otp-status-sheet')),
      matchesGoldenFile(
        'baselines/windows/otp-status-en-dark-1.0-product-402.png',
      ),
    );
  }, tags: ['golden']);
}
