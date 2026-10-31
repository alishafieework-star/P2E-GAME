import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/app.dart';
import 'package:mygame_p2e/app/config/app_config.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/features/auth/src/presentation/entry/widgets/auth_entry_widgets.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../support/auth_harness.dart';

void main() {
  testWidgets('keyboard open and close keep the editor and settle', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(402, 874);
    final inset = ValueNotifier<double>(0);
    addTearDown(inset.dispose);
    final repos = ImmediateRepositories();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(environment: AppEnvironment.stage),
          ),
          appLocaleProvider.overrideWithValue(const Locale('en')),
          welcomeOfferRepositoryProvider.overrideWith((_) => repos),
          phoneSignInRepositoryProvider.overrideWith((_) => repos),
          emailSignInRepositoryProvider.overrideWith((_) => repos),
          socialSignInRepositoryProvider.overrideWith((_) => repos),
        ],
        child: ValueListenableBuilder<double>(
          valueListenable: inset,
          child: const P2EApp(),
          builder: (context, bottom, child) => MediaQuery(
            data: MediaQueryData(
              size: const Size(402, 874),
              padding: const EdgeInsets.only(top: 55),
              viewPadding: const EdgeInsets.only(top: 55),
              viewInsets: EdgeInsets.only(bottom: bottom),
              disableAnimations: false,
            ),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    tester
        .widget<AppTextField>(find.byType(AppTextField))
        .options
        .focusNode!
        .requestFocus();
    await tester.pumpAndSettle();
    final editor = find.byType(EditableText);
    await tester.showKeyboard(editor);
    await tester.enterText(editor, 'user@example.com');
    await tester.pumpAndSettle();
    final original = tester.state<EditableTextState>(editor);

    inset.value = 331;
    await tester.pump();
    expect(find.byType(HeroBanner), findsOneWidget);
    expect(find.byType(AppCheckbox), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 120));
    expect(find.byType(HeroBanner), findsOneWidget);
    expect(tester.state<EditableTextState>(editor), same(original));

    await tester.pumpAndSettle();
    expect(find.byType(HeroBanner), findsNothing);
    expect(find.byType(AppCheckbox), findsNothing);
    expect(find.byType(AppButton), findsOneWidget);
    expect(tester.state<EditableTextState>(editor), same(original));

    inset.value = 0;
    await tester.pump();
    expect(find.byType(HeroBanner), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(HeroBanner), findsOneWidget);
    expect(find.byType(AppCheckbox), findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget);
    expect(tester.state<EditableTextState>(editor), same(original));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
