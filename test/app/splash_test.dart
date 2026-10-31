import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/app/startup/animated_logo.dart';
import 'package:mygame_p2e/app/startup/splash_overlay.dart';
import 'package:mygame_p2e/app/startup/startup_controller.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  testWidgets('splash holds the next route until the logo collapses', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SplashOverlay(child: Text('next'))),
      ),
    );
    expect(container.read(splashGateProvider), SplashGate.covering);
    await tester.pump(HtmlJourneyTokens.splashCollapse);
    await tester.pump();
    expect(container.read(splashGateProvider), SplashGate.collapsed);
    expect(find.text('next'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    expect(find.byType(AnimatedLogo), findsNothing);
  });

  testWidgets('reduced motion shows a static logo then continues', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
          home: const SplashOverlay(child: Text('next')),
        ),
      ),
    );
    expect(container.read(splashGateProvider), SplashGate.covering);
    await tester.pump(HtmlJourneyTokens.splashReduced);
    expect(container.read(splashGateProvider), SplashGate.collapsed);
    expect(find.byType(AnimatedLogo), findsNothing);
  });
}
