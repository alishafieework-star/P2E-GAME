import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/app.dart';
import 'package:mygame_p2e/app/bootstrap.dart';
import 'package:mygame_p2e/app/config/app_config.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/main.dart' as release;
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/features/onboarding/onboarding.dart';

void main() {
  for (final entrypoint in {'release': release.main}.entries) {
    testWidgets('${entrypoint.key} boots Auth Entry', (tester) async {
      entrypoint.value();
      await tester.pump();
      for (var i = 0; i < 9; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(P2EApp), findsOneWidget);
      expect(
        find.byType(AuthEntryScreen).evaluate().isNotEmpty ||
            find.byType(OnboardingScreen).evaluate().isNotEmpty,
        isTrue,
      );
    });
  }
  for (final language in ['fa', 'en']) {
    for (final brightness in Brightness.values) {
      testWidgets('boots $language $brightness with neutral hooks', (
        tester,
      ) async {
        tester.platformDispatcher.platformBrightnessTestValue = brightness;
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
        var wrapped = false;
        await tester.pumpWidget(
          composeApp(
            config: const AppConfig(environment: AppEnvironment.stage),
            providerOverrides: [
              appLocaleProvider.overrideWithValue(Locale(language)),
            ],
            rootWrapper: (root) {
              wrapped = true;
              return root;
            },
          ),
        );
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(Text).first);
        expect(wrapped, isTrue);
        expect(Theme.of(context).brightness, Brightness.dark);
        expect(
          Directionality.of(context),
          language == 'fa' ? TextDirection.rtl : TextDirection.ltr,
        );
        expect(
          find.text(AppLocalizations.of(context).authTitle),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}
