import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/router/app_router.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/features/games/games.dart';
import 'package:mygame_p2e/features/home/home.dart';
import 'package:mygame_p2e/features/missions/missions.dart';
import 'package:mygame_p2e/shared/navigation/app_locations.dart';
import 'package:p2e_design_system/design_system.dart';
import 'package:p2e_dev_inspector/inspector.dart';
import 'package:p2e_product_host/main.dart';
import 'package:p2e_product_host/scenarios/home_fixtures.dart';
import 'package:p2e_product_host/scenarios/product_scenarios.dart';

void main() {
  test('scenario ids are unique and every current route is represented', () {
    final ids = [for (final scenario in productScenarios) scenario.id];
    expect(ids.toSet(), hasLength(ids.length));
    const paths = [
      '/startup',
      '/entry',
      '/entry/otp',
      '/entry/verify',
      '/entry/password',
      '/entry/create-password',
      '/entry/forgot-password',
      '/home',
      '/missions',
      '/games',
      '/leaderboard',
      '/shop',
    ];
    for (final path in paths) {
      expect(
        productScenarios.any((scenario) => scenario.path == path),
        isTrue,
        reason: path,
      );
    }
    expect(
      productScenarios.any(
        (scenario) => scenario.path == AppLocations.game('sample'),
      ),
      isTrue,
    );
    expect(
      productScenarios.any(
        (scenario) => scenario.path == AppLocations.quest('sample'),
      ),
      isTrue,
    );
    expect(productScenarios.any((scenario) => scenario.fixtures), isTrue);
    expect(productScenarios.map((scenario) => scenario.sectionId).toSet(), {
      'startup',
      'onboarding',
      'auth',
      'home',
      'missions',
      'games',
      'leaderboard',
      'shop',
      'legal',
      'designSystem',
    });
    expect(
      productScenarioById('auth.create-password').flow!().step,
      AuthStep.createPassword,
    );
    expect(
      productScenarioById('auth.verify.phone').flow!().step,
      AuthStep.verify,
    );
    expect(productScenarioById('auth.verify.email').path, '/entry/verify');
    expect(productScenarioById('auth.otp.player').path, '/entry/otp');
    expect(productScenarioById('home.tour').tourPending, isTrue);
    expect(
      productScenarioById('game.studio').path,
      AppLocations.studioOn(AppLocations.home, 'sample'),
    );
    expect(
      productScenarios
          .where((scenario) => scenario.sectionId == 'auth')
          .map((scenario) => scenario.id),
      isNot(contains('shell.home')),
    );
  });

  testWidgets(
    'selecting a scenario mounts that route without resetting the device',
    (tester) async {
      tester.view.physicalSize = const Size(1600, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final device = SimulatedDevice();
      addTearDown(device.dispose);
      device.resize(480, 900);
      await tester.pumpWidget(ProductInspectionHost(device: device));
      await tester.pumpAndSettle();
      expect(find.byType(AppTextField), findsWidgets);
      tester
          .widget<DropdownButton<String>>(
            find.byKey(const ValueKey('scenario')),
          )
          .onChanged!('shell.home');
      await tester.pumpAndSettle();
      expect(device.settings.size, const Size(480, 900));
      final host = tester.state<InspectorHostState>(find.byType(InspectorHost));
      final container = ProviderScope.containerOf(host.appKey.currentContext!);
      expect(container.read(appRouterProvider).state.uri.path, '/home');
      expect(find.byKey(const ValueKey('home.page')), findsOneWidget);
    },
  );

  testWidgets(
    'every scenario mounts and reports do not contain the fixture email',
    (tester) async {
      tester.view.physicalSize = const Size(1600, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      for (final scenario in productScenarios) {
        await tester.pumpWidget(
          ProductInspectionHost(
            key: ValueKey(scenario.id),
            initialScenario: scenario.id,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1));
        final hasAnimation =
            scenario.id.contains('loading') ||
            scenario.id.startsWith('route.') ||
            scenario.id.startsWith('startup.') ||
            scenario.id == 'onboarding' ||
            scenario.id == 'auth.notifications' ||
            scenario.id == 'auth.all-set' ||
            scenario.id == 'auth.username' ||
            scenario.id == 'auth.otp.sms-access' ||
            scenario.id == 'home.tour';
        if (hasAnimation) {
          await tester.pump(const Duration(milliseconds: 50));
        } else {
          await tester.pumpAndSettle();
        }
        while (tester.takeException() != null) {}
        final host = tester.state<InspectorHostState>(
          find.byType(InspectorHost),
        );
        expect(
          host.widget.scenarioCatalog!.activeId,
          scenario.id,
          reason: scenario.id,
        );
        if (scenario.id == 'route.startup') {
          host.session.scan();
          expect(
            host.session.tree.any(
              (node) => node.identity.elementId == 'startup.page',
            ),
            isTrue,
          );
        }
        if (scenario.id == 'home.empty') {
          expect(find.byKey(const ValueKey('home.page')), findsOneWidget);
        }
        if (scenario.id == 'home.loading') {
          expect(find.byType(HomeScreen), findsOneWidget);
        }
        if (scenario.home == HomeFixture.offline ||
            scenario.home == HomeFixture.error) {
          final container = ProviderScope.containerOf(
            host.appKey.currentContext!,
          );
          expect(container.read(gamesRepositoryProvider), isNotNull);
          expect(container.read(questsRepositoryProvider), isNotNull);
        }
      }
      await tester.pumpWidget(
        const ProductInspectionHost(initialScenario: 'auth.password'),
      );
      await tester.pumpAndSettle();
      final host = tester.state<InspectorHostState>(find.byType(InspectorHost));
      await host.auditCurrent();
      final report = host.reportBundle();
      expect(report, isNot(contains(fixtureEmailLiteral)));
      expect(report.toLowerCase(), isNot(contains('passwordvalue')));
      expect(jsonDecode(report)['claims']['pixelEquality'], isFalse);
      validateSweepBundle(jsonDecode(report) as Map<String, Object?>);
    },
  );
}
