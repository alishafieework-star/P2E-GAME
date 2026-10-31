import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_dev_inspector/inspector.dart';
import 'package:p2e_product_host/main.dart';
import 'package:p2e_product_host/scenarios/product_scenarios.dart';

void main() {
  testWidgets(
    'full route gorilla sweep across the medium boundary',
    (tester) async {
      tester.view.physicalSize = const Size(1800, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final device = SimulatedDevice();
      addTearDown(device.dispose);
      await tester.pumpWidget(ProductInspectionHost(device: device));
      await tester.pumpAndSettle();
      while (tester.takeException() != null) {}
      final host = tester.state<InspectorHostState>(find.byType(InspectorHost));
      Future<void> frame() async {
        await tester.pump(const Duration(milliseconds: 16));
        while (tester.takeException() != null) {}
      }

      Future<void> activate(String id) async {
        final pending = host.widget.scenarioCatalog!.activate(id);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1));
        await tester.pump(const Duration(milliseconds: 1));
        await pending;
      }

      await host.sweep.run(
        const SweepPlan(
          strategy: SweepStrategy.pairwiseBoundary,
          minWidth: 599,
          maxWidth: 601,
          refine: false,
          minimize: false,
          seed: 1,
          environments: [
            {'scale': '1', 'locale': 'en-US', 'brightness': 'dark'},
          ],
        ),
        frame,
        scenarioIds: [for (final scenario in productScenarios) scenario.id],
        activateScenario: activate,
      );
      final bundle = buildReportBundle(
        host: 'product_host',
        sweep: host.sweep,
        accessibility: host.accessibility,
        performance: host.performance,
      );
      validateSweepBundle(bundle);
      final output = Directory('../../../../build/inspector-v2')
        ..createSync(recursive: true);
      File('${output.path}/full-route-sweep.json')
          .writeAsStringSync(exportReportBundle(bundle));
      expect(host.sweep.coverage['pairs'], 'explicit');
      expect(host.sweep.scenariosCompleted, productScenarios.length);
      expect(bundle['sweep'], isA<Map>());
      expect(jsonEncode(bundle), isNot(contains(fixtureEmailLiteral)));
    },
    skip: Platform.environment['RUN_FULL_ROUTE_SWEEP'] != '1',
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
