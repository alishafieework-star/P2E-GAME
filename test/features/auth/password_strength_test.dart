import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/auth/src/presentation/password/widgets/password_strength.dart';
import 'package:p2e_design_system/design_system.dart';

/// The meter colors come from the HTML prototype (D-135): rose, amber,
/// blue, green. Amber ships as OVERRIDE(O-001) until a token exists.
Widget _host(String password, String level) => MaterialApp(
  theme: AppThemeFactory.build(brightness: Brightness.dark, skin: productSkin),
  home: Scaffold(
    body: PasswordStrength(
      password: password,
      strengthLabel: 'Password strength',
      level: level,
      longLabel: '8+ characters',
      numberLabel: 'At least a number',
      caseLabel: 'Upper & lowercase',
      symbolLabel: 'A symbol (#, !, @, ...)',
    ),
  ),
);

List<BoxDecoration> _segments(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).borderRadius is BorderRadius &&
            widget.child is SizedBox &&
            (widget.child as SizedBox).height == AuthEntryTokens.amountUnitGap,
      ),
    )
    .map((box) => box.decoration as BoxDecoration)
    .toList();

List<Color> _colors(WidgetTester tester) =>
    _segments(tester).map((segment) => segment.color!).toList();

void main() {
  testWidgets('an empty password fills nothing and shows no label', (
    tester,
  ) async {
    await tester.pumpWidget(_host('', ''));
    expect(_segments(tester).length, 4);
    expect(_colors(tester).toSet().length, 1);
    expect(find.text('Weak'), findsNothing);
  });

  testWidgets('meter and label colors follow the strength level', (
    tester,
  ) async {
    await tester.pumpWidget(_host('abc', 'Weak'));
    var colors = _colors(tester);
    expect(colors[0], HtmlJourneyTokens.jlRose);
    expect(colors[1], colors[2]);
    expect(colors[2], colors[3]);
    expect(
      tester.widget<Text>(find.text('Weak')).style?.color,
      HtmlJourneyTokens.jlRose,
    );

    await tester.pumpWidget(_host('abcdefgh1', 'Fair'));
    colors = _colors(tester);
    expect(colors[0], const Color(0xFFFF9F0A)); // OVERRIDE(O-001)
    expect(colors[1], const Color(0xFFFF9F0A));
    expect(colors[2], colors[3]);
    expect(
      tester.widget<Text>(find.text('Fair')).style?.color,
      const Color(0xFFFF9F0A),
    );

    await tester.pumpWidget(_host('Abcdefgh1', 'Good'));
    colors = _colors(tester);
    expect(colors[2], HtmlJourneyTokens.splashGradientMid);
    expect(colors[3], isNot(HtmlJourneyTokens.splashGradientMid));
    expect(
      tester.widget<Text>(find.text('Good')).style?.color,
      HtmlJourneyTokens.splashGradientMid,
    );

    await tester.pumpWidget(_host('Abcdefgh1!', 'Strong'));
    colors = _colors(tester);
    expect(colors.toSet(), {HtmlJourneyTokens.success});
    expect(
      tester.widget<Text>(find.text('Strong')).style?.color,
      HtmlJourneyTokens.success,
    );

    // The met-rule checks stay one fixed green at every level.
    final icons = tester.widgetList<AssetAppIcon>(find.byType(AssetAppIcon));
    expect(icons.length, 4);
    expect(icons.map((icon) => icon.color).toSet(), {
      HtmlJourneyTokens.success,
    });
  });
}
