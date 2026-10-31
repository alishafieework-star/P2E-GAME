import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/router/app_router.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../support/auth_harness.dart';

void main() {
  testWidgets('password screen lays out at text scale 2', (tester) async {
    addTearDown(tester.view.reset);
    await _showPassword(tester, scale: 2);
    expect(tester.takeException(), isNull);
    expect(find.text('Enter Your Password'), findsOneWidget);
  });

  testWidgets('empty password keeps Login disabled', (tester) async {
    addTearDown(tester.view.reset);
    await _showPassword(tester);
    expect(find.text('Enter Your Password'), findsOneWidget);
    expect(find.text('Logging in as'), findsOneWidget);
    expect(find.textContaining('me.ardeshir.rashidi@gma'), findsWidgets);
    expect(
      tester
          .widget<AppButton>(find.byKey(const ValueKey('auth.password.login')))
          .onPressed,
      isNull,
    );
  });

  testWidgets('P12345 signs in and a wrong password stays on the field', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await _showPassword(tester);
    await _typePassword(tester, 'nope');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('auth.password.login')));
    await tester.pump();
    expect(
      find.text('That password is not correct. Please try again.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('home.page')), findsNothing);
    await _typePassword(tester, 'P12345');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('auth.password.login')));
    await tester.pump();
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byKey(const ValueKey('home.page')), findsOneWidget);
  });

  testWidgets('forgot password verifies P12345 and sets a new password', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await _showPassword(tester);
    await tester.tap(find.text('Forgot password?'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Check Your Inbox'), findsOneWidget);
    expect(find.text('Wrong Email?'), findsOneWidget);
    expect(find.text('01:34'), findsOneWidget);
    expect(
      tester
          .widget<AppButton>(find.byKey(const ValueKey('auth.otp.verify')))
          .onPressed,
      isNull,
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth.otp.code.editor')),
      'P12345',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('auth.otp.verify')));
    await tester.pump();
    expect(find.text('Enter Your Password'), findsNothing);
    await tester.pump(const Duration(milliseconds: 899));
    expect(find.text('Check Your Inbox'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1));
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.text('Set a New Password'), findsOneWidget);
    expect(find.byKey(const ValueKey('home.page')), findsNothing);
  });
}

Future<void> _typePassword(WidgetTester tester, String value) async {
  tester
      .widget<AppPasswordField>(find.byType(AppPasswordField))
      .options
      .focusNode!
      .requestFocus();
  await tester.pump();
  await tester.enterText(
    find.byKey(
      const ValueKey('auth.password.field.editor'),
      skipOffstage: false,
    ),
    value,
  );
  await tester.pump();
}

Future<void> _showPassword(WidgetTester tester, {double scale = 1}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(402, 874);
  await pumpAuth(tester, scale: scale);
  final container = ProviderScope.containerOf(
    tester.element(find.byType(AuthEntryScreen)),
  );
  final email =
      IdentifierClassifier.classify('me.ardeshir.rashidi@gmail.com') as Email;
  container
      .read(authFlowProvider.notifier)
      .accept(EmailFlowResult(email, EmailAccountStatus.registered, false));
  container.read(appRouterProvider).go('/entry/password');
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}
