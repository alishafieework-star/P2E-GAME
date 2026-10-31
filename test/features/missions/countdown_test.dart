import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/missions/src/presentation/widgets/countdown.dart';
import 'package:p2e_design_system/design_system.dart';

const _locator = UiRuntimeLocator(
  routeName: 'test-countdown',
  routeInstanceId: 't',
);

Widget _host(
  List<CountdownUnit> units, {
  TextDirection direction = TextDirection.ltr,
}) => MaterialApp(
  theme: AppThemeFactory.build(brightness: Brightness.dark),
  home: Directionality(
    textDirection: direction,
    child: UiIdentityScope(
      routeName: _locator.routeName,
      instanceKey: _locator.routeInstanceId,
      child: Scaffold(
        body: SizedBox(
          width: 370,
          child: Countdown(units: units, semanticLabel: 'Time left: test'),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('one digit box per character with dot separators', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const [
        CountdownUnit(digits: '01', label: 'd'),
        CountdownUnit(digits: '23', label: 'h'),
      ]),
    );
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('d'), findsOneWidget);
    expect(find.text('h'), findsOneWidget);
    // Two dots between the two units, none at the edges (each _Dots renders
    // two dot-sized squares sharing one widget instance).
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == HomeTokens.countdownDot &&
            widget.height == HomeTokens.countdownDot,
      ),
      findsNWidgets(2),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('digit rows keep fixed ascending order in RTL', (tester) async {
    await tester.pumpWidget(
      _host(const [
        CountdownUnit(digits: '98', label: 'دقیقه'),
      ], direction: TextDirection.rtl),
    );
    // PHYSICAL: clock digits stay in ascending visual order; the '9' box
    // sits before the '8' box from left to right.
    final nine = tester.getRect(find.text('9'));
    final eight = tester.getRect(find.text('8'));
    expect(nine.left, lessThan(eight.left));
    expect(tester.takeException(), isNull);
  });

  test('empty units are rejected', () {
    expect(
      () => Countdown(units: const [], semanticLabel: 'Time left'),
      throwsA(isA<Error>()),
    );
  });
}
