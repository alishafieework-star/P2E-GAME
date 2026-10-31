import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_dev_inspector/inspector.dart';

void main() {
  testWidgets('performance counts are diagnostic and privacy-safe', (
    tester,
  ) async {
    await tester.pumpWidget(
      InspectorHost(
        appBuilder: (settings, key) => SizedBox.expand(
          key: key,
          child: const ColoredBox(color: Color(0xFF111111)),
        ),
      ),
    );
    await tester.pump();
    final host = tester.state<InspectorHostState>(find.byType(InspectorHost));
    host.performance.noteTiming(20000, 1000);
    host.performance.sampleTransition();
    final report = host.performance.toJson();
    expect(report['slowFrames'], 1);
    expect(report['format'], 'p2e-inspector-perf-v1');
    expect('${report['note']}', contains('Not a device benchmark'));
    final bundle = buildReportBundle(
      host: 'inspector',
      sweep: host.sweep,
      accessibility: host.accessibility,
      performance: host.performance,
    );
    validateSweepBundle(bundle);
    final scrubbed = scrubReport({
      'passwordValue': 'do-not-keep',
      'kind': 'overflow',
      'ranges': List.generate(30, (index) => index),
    }) as Map;
    expect(jsonEncode(scrubbed), isNot(contains('passwordValue')));
    expect((scrubbed['ranges'] as List).length, 30);
  });
}
