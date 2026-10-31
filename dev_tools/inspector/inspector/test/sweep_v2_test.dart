import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_design_system/design_system.dart';
import 'package:p2e_dev_inspector/inspector.dart';

Widget overflowApp(FrameSettings settings, GlobalKey key) {
  final identity = ElementIdentity(
    elementId: 'probe.overflow',
    componentId: 'probe.overflow',
    structureRef: 'probe.overflow',
    runtimeLocator: const UiRuntimeLocator(
      routeName: 'probe',
      routeInstanceId: 'one',
    ),
    fileKey: '',
    variantId: null,
    componentSetId: null,
    rawSetName: '',
    rawVariantName: '',
    resolved: const {},
    declared: const {},
    variants: const {},
    child: const SizedBox(
      height: 400,
      child: Row(children: [SizedBox(width: 300)]),
    ),
  );
  return MediaQuery(
    data: settings.media,
    child: SizedBox.expand(
      key: key,
      child: MaterialApp(debugShowCheckedModeBanner: false, home: identity),
    ),
  );
}

void main() {
  testWidgets('gorilla sweep refines the overflow edge and minimizes it', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(InspectorHost(appBuilder: overflowApp));
    await tester.pumpAndSettle();
    final host = tester.state<InspectorHostState>(find.byType(InspectorHost));
    Future<void> frame() async {
      await tester.pump();
      while (tester.takeException() != null) {}
    }

    const plan = SweepPlan(
      strategy: SweepStrategy.pairwiseBoundary,
      minWidth: 251,
      maxWidth: 360,
      seed: 3,
      refine: true,
      minimize: true,
      environments: [
        {'locale': 'en-US', 'scale': '2', 'bold': 'on'},
      ],
    );
    await host.sweep.run(plan, frame);
    expect(jsonDecode(host.sweep.exportJson())['format'], 'p2e-sweep-v1.1');
    final bundle = host.sweep.exportBundle();
    expect(bundle['format'], 'p2e-sweep-v2');
    expect(bundle['seed'], 3);
    final refinement = host.sweep.refinements.single;
    expect(refinement['monotonic'], isTrue);
    expect(refinement['failing'], contains(299));
    expect(refinement['passing'], contains(300));
    final minimal = host.sweep.minimalCases.single;
    expect((minimal['device'] as Map)['width'], 251);
    expect(minimal['requiredFactors'], isEmpty);
    validateSweepBundle(
      buildReportBundle(
        host: 'inspector',
        sweep: host.sweep,
        accessibility: host.accessibility,
        performance: host.performance,
      ),
    );
    expect(host.settings.toJson()['width'], 402);
  });

  testWidgets('a cancelled gorilla sweep resumes the remaining samples', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(InspectorHost(appBuilder: overflowApp));
    await tester.pumpAndSettle();
    final host = tester.state<InspectorHostState>(find.byType(InspectorHost));
    var pumps = 0;
    Future<void> frame() async {
      await tester.pump();
      while (tester.takeException() != null) {}
      pumps++;
      if (pumps == 1) host.sweep.cancelled = true;
    }

    const plan = SweepPlan(
      strategy: SweepStrategy.pairwiseBoundary,
      minWidth: 599,
      maxWidth: 601,
      refine: false,
      minimize: false,
      environments: [
        {'scale': '1'},
      ],
    );
    await host.sweep.run(plan, frame);
    expect(host.sweep.canResume, isTrue);
    expect(host.sweep.completed, 1);
    await host.sweep.run(plan, frame, resume: true);
    expect(host.sweep.completed, 3);
    expect(host.sweep.canResume, isFalse);
  });
}
