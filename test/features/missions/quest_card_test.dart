import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/missions/missions.dart';
import 'package:p2e_design_system/design_system.dart';

const _locator = UiRuntimeLocator(
  routeName: 'test-quest-card',
  routeInstanceId: 't',
);

Widget _host(Widget child, {TextDirection direction = TextDirection.ltr}) =>
    MaterialApp(
      theme: AppThemeFactory.build(brightness: Brightness.dark),
      home: Directionality(
        textDirection: direction,
        child: UiIdentityScope(
          routeName: _locator.routeName,
          instanceKey: _locator.routeInstanceId,
          child: Scaffold(body: SizedBox(width: 370, child: child)),
        ),
      ),
    );

QuestCard _card({required bool started, required int completed}) => QuestCard(
  elementId: 'test.quest',
  runtimeLocator: _locator,
  icon: const NetworkImage('http://media.test/icon.png'),
  gameName: 'Probe Quest',
  creator: 'Kepler Interactive',
  actionLabel: started ? 'Continue' : 'Start Quest',
  caption: 'Free to Play',
  rewards: const [
    QuestStepReward(amount: '250', unit: 'pts'),
    QuestStepReward(amount: '500', unit: 'pts'),
  ],
  completed: completed,
  started: started,
  progressLabel: '$completed of 2 steps completed',
  status: started
      ? const [QuestStatusPart('2 done')]
      : const [QuestStatusPart('Not Started Yet!')],
  total: const QuestTotal(earned: '750', possible: '1,750', unit: 'pts'),
  countdown: const [
    CountdownUnit(digits: '00', label: 'd'),
    CountdownUnit(digits: '06', label: 'h'),
  ],
  countdownLabel: 'Time left: 0 days, 6 hours',
);

void main() {
  testWidgets('renders display-ready content with semantics', (tester) async {
    await tester.pumpWidget(_host(_card(started: true, completed: 2)));
    expect(find.text('Probe Quest'), findsOneWidget);
    expect(find.text('Kepler Interactive'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Free to Play'), findsOneWidget);
    expect(find.text('250'), findsOneWidget);
    expect(find.text('2 done'), findsOneWidget);
    expect(find.text('0'), findsAtLeastNWidgets(2));
    expect(find.text('6'), findsOneWidget);
    expect(find.bySemanticsLabel('2 of 2 steps completed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an unstarted card mirrors in RTL', (tester) async {
    await tester.pumpWidget(
      _host(_card(started: false, completed: 0), direction: TextDirection.rtl),
    );
    expect(find.text('Not Started Yet!'), findsOneWidget);
    expect(find.text('Start Quest'), findsOneWidget);
    // RTL: the card content starts at the right edge (title sits past the
    // horizontal midline of the card, unlike the LTR layout).
    final cardWidth = tester.getSize(find.byType(QuestCard)).width;
    expect(
      tester.getTopRight(find.text('Probe Quest')).dx,
      greaterThan(cardWidth / 2),
    );
    expect(tester.takeException(), isNull);
  });
}
