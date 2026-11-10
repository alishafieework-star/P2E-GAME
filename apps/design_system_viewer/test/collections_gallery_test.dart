import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';
import 'package:p2e_design_system_viewer/main.dart';

void main() {
  for (final language in ['en', 'fa']) {
    testWidgets('$language collections catalog shows the primitives', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(2400, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        DevelopmentViewer(initialLocale: Locale(language)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('section-8')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('components-collections')));
      await tester.pumpAndSettle();
      expect(find.byType(AppSectionHeader), findsNWidgets(2));
      expect(find.byType(AppShelf), findsNWidgets(2));
      expect(find.byType(AppPageIndicator), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
