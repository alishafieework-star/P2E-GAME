import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/auth/src/presentation/account_journey_screens.dart';
import 'package:mygame_p2e/features/legal/src/presentation/legal_reader_screen.dart';
import 'package:mygame_p2e/features/onboarding/src/presentation/onboarding_quests.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/preferences/device_preferences.dart';
import 'package:p2e_design_system/design_system.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  bool reduced = false,
  EphemeralDevicePreferences? preferences,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(402, 874);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (preferences != null)
          devicePreferencesRepositoryProvider.overrideWithValue(preferences),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppThemeFactory.build(
          brightness: Brightness.dark,
          skin: productSkin,
        ),
        home: UiIdentityScope(
          routeName: 'test.motion',
          child: MediaQuery(
            data: MediaQueryData(
              size: const Size(402, 874),
              disableAnimations: reduced,
            ),
            child: child,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('quest clock rests on the HTML time when motion is reduced', (
    tester,
  ) async {
    await _pump(tester, const OnboardingQuests(active: true), reduced: true);
    expect(
      tester
          .getSemantics(find.byKey(const ValueKey('onboarding.quest.clock')))
          .label,
      '06:47:49',
    );
    expect(find.text('1,750'), findsOneWidget);
  });

  testWidgets(
    'legal reader lists every HTML section and slides the indicator',
    (tester) async {
      await _pump(tester, const LegalReaderScreen(doc: 'terms'), reduced: true);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w.key is ValueKey<String> &&
              (w.key! as ValueKey<String>).value.startsWith('legal.toc.'),
        ),
        findsNWidgets(9),
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text && (widget.data?.contains('Who we are') ?? false),
        ),
        findsWidgets,
      );
      final indicator = tester.widget<AnimatedAlign>(
        find.byKey(const ValueKey('legal.indicator')),
      );
      expect(indicator.alignment, AlignmentDirectional.centerStart);
      expect(indicator.curve, HtmlJourneyTokens.spring);
      await tester.tap(find.text('Privacy Policy'));
      await tester.pump();
      expect(
        tester
            .widget<AnimatedAlign>(
              find.byKey(const ValueKey('legal.indicator')),
            )
            .alignment,
        AlignmentDirectional.centerEnd,
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w.key is ValueKey<String> &&
              (w.key! as ValueKey<String>).value.startsWith('legal.toc.'),
        ),
        findsNWidgets(8),
      );
    },
  );

  testWidgets('notification permission screen shows the three HTML rows', (
    tester,
  ) async {
    await _pump(tester, const NotificationsScreen(), reduced: true);
    expect(find.text('Mission complete · claim your Points'), findsOneWidget);
    expect(find.text('New daily missions are ready'), findsOneWidget);
    expect(find.text('Payment confirmed and Coins added'), findsOneWidget);
  });
}
