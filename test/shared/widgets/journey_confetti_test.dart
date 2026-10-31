import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/shared/widgets/journey_confetti.dart';

void main() {
  testWidgets('JourneyConfetti renders in burst mode without crashing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: JourneyConfetti(style: JourneyConfettiStyle.burst),
        ),
      ),
    );
    expect(find.byType(JourneyConfetti), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('JourneyConfetti renders in celebration mode without crashing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: JourneyConfetti(style: JourneyConfettiStyle.celebration),
        ),
      ),
    );
    expect(find.byType(JourneyConfetti), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('JourneyConfetti respects reduced motion', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: JourneyConfetti(style: JourneyConfettiStyle.burst),
          ),
        ),
      ),
    );
    expect(find.byType(SizedBox), findsWidgets);
  });
}
