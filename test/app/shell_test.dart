import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/bootstrap.dart';
import 'package:mygame_p2e/app/config/app_config.dart';
import 'package:mygame_p2e/app/router/app_router.dart';
import 'package:mygame_p2e/core/platform/device_inputs.dart';
import 'package:mygame_p2e/core/time/clock.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/shared/session/session.dart';
import 'package:p2e_design_system/design_system.dart';

final _now = DateTime.utc(2026, 10, 24, 12);

final class _FixedClock implements Clock {
  const _FixedClock(this.value);
  final DateTime value;
  @override
  DateTime now() => value;
}

/// Development composition with in-process fakes, signed in at 402×1809.
Future<ProviderContainer> _signIn(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(402, 1809);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    composeApp(
      config: const AppConfig(environment: AppEnvironment.dev),
      providerOverrides: [
        clockProvider.overrideWithValue(_FixedClock(_now)),
        secondTickerProvider.overrideWith((_) => Stream.value(_now)),
      ],
    ),
  );
  await tester.pumpAndSettle();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(AuthEntryScreen)),
  );
  container
      .read(sessionControllerProvider.notifier)
      .update(SessionStatus.signedIn);
  await tester.pumpAndSettle();
  return container;
}

String _path(ProviderContainer container) =>
    container.read(appRouterProvider).routeInformationProvider.value.uri.path;

void main() {
  setUp(() => WidgetController.hitTestWarningShouldBeFatal = true);
  tearDown(() => WidgetController.hitTestWarningShouldBeFatal = false);

  testWidgets('sign-in opens Home inside the five-tab shell', (tester) async {
    final container = await _signIn(tester);
    expect(_path(container), '/home');
    expect(find.byKey(const ValueKey('home.page')), findsOneWidget);
    final bar = tester.widget<AppNavigationBar>(find.byType(AppNavigationBar));
    expect(bar.selectedDestinationId, 'home');
    expect(bar.destinations.map((d) => d.id), [
      'home',
      'mission',
      'games',
      'leaderboard',
      'shop',
    ]);
    expect(bar.destinations[1].badge?.label, '1');
    expect(bar.destinations[4].badge, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a mouse drag pages the Home quest shelf', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(402, 1809);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      composeApp(
        config: const AppConfig(environment: AppEnvironment.dev),
        providerOverrides: [
          clockProvider.overrideWithValue(_FixedClock(_now)),
          secondTickerProvider.overrideWith((_) => Stream.value(_now)),
          deviceMouseDragProvider.overrideWithValue(true),
        ],
      ),
    );
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(AuthEntryScreen)),
    );
    container
        .read(sessionControllerProvider.notifier)
        .update(SessionStatus.signedIn);
    await tester.pumpAndSettle();
    final card = find.text('Clash Royal');
    final before = tester.getTopLeft(card).dx;
    await tester.drag(
      card,
      const Offset(-280, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(card).dx, lessThan(before - 200));
    expect(find.text('8 Ball Pool'), findsOneWidget);
  });

  testWidgets('View More opens the owning tab; Home returns', (tester) async {
    final container = await _signIn(tester);
    await tester.tap(find.text('View More').first);
    await tester.pumpAndSettle();
    expect(_path(container), '/games');
    expect(find.text('Games — screen coming next'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('home')));
    await tester.pumpAndSettle();
    expect(_path(container), '/home');

    await tester.tap(find.text('View All Missions'));
    await tester.pumpAndSettle();
    expect(_path(container), '/missions');
    expect(find.text('Mission — screen coming next'), findsOneWidget);
  });

  testWidgets('a game card opens details inside the same tab', (tester) async {
    final container = await _signIn(tester);
    await tester.tap(find.text('Sifu'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const ValueKey('game.details.page')), findsOneWidget);
    expect(find.byType(AppNavigationBar), findsOneWidget);
    final bar = tester.widget<AppNavigationBar>(find.byType(AppNavigationBar));
    expect(bar.selectedDestinationId, 'home');
    await tester.tap(
      find.byKey(const ValueKey('game.details.app-bar.back.hit')),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home.page')), findsOneWidget);
    expect(_path(container), '/home');

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Quest details — screen coming next'), findsOneWidget);
  });

  testWidgets('signing out from a tab returns to Entry', (tester) async {
    final container = await _signIn(tester);
    await tester.tap(find.byKey(const ValueKey('leaderboard')));
    await tester.pumpAndSettle();
    expect(_path(container), '/leaderboard');
    container
        .read(sessionControllerProvider.notifier)
        .update(SessionStatus.signedOut);
    await tester.pumpAndSettle();
    expect(_path(container), '/entry');
    expect(find.byType(AuthEntryScreen), findsOneWidget);
  });
}
