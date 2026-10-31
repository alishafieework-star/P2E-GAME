import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/home/src/presentation/home_app_bar.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/balance/balance.dart';
import 'package:mygame_p2e/shared/balance/fake_balance.dart';
import 'package:mygame_p2e/shared/profile/fake_profile.dart';
import 'package:mygame_p2e/shared/profile/profile.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  testWidgets('Home header actions press in place and do not open a page', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(402, 200);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          balanceRepositoryProvider.overrideWithValue(
            const FakeBalanceRepository(),
          ),
          profileRepositoryProvider.overrideWithValue(
            const FakeProfileRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppThemeFactory.build(
            brightness: Brightness.dark,
            skin: productSkin,
          ),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => TickerMode(
            enabled: true,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: false),
              child: child!,
            ),
          ),
          home: const UiIdentityScope(
            routeName: 'home',
            child: Scaffold(body: HomeAppBarContent()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final bar = tester.element(find.byType(HomeAppBarContent));
    expect(Navigator.of(bar).canPop(), isFalse);

    final hit = find.byKey(const ValueKey('home.app-bar.addCoins.hit'));
    final gesture = await tester.startGesture(tester.getCenter(hit));
    await tester.pump();
    await tester.pumpAndSettle();
    final scale = tester
        .widget<Transform>(
          find.descendant(
            of: hit,
            matching: find.byKey(const ValueKey('app-button-press-transform')),
          ),
        )
        .transform
        .storage[0];
    expect(scale, closeTo(ButtonMotion.iconPressedScale, 0.0001));
    expect(Navigator.of(bar).canPop(), isFalse);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(Navigator.of(bar).canPop(), isFalse);
  });
}
