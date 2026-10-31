import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_dev_inspector/inspector.dart';

void main() {
  test('binary refinement stops at the sampled 1px edge', () async {
    final result = await refineEdge(
      passing: 320,
      failing: 280,
      fails: (value) async => value < 300,
    );
    expect(result.monotonic, isTrue);
    expect(result.method, 'binary');
    expect(result.failing, contains(299));
    expect(result.passing, contains(300));
    expect(result.sampled, isNot(contains(250)));
  });

  test('a non-monotonic bracket is reported only from local samples', () async {
    final result = await refineEdge(
      passing: 1,
      failing: 20,
      fails: (value) async => (value >= 8 && value <= 12) || value >= 18,
    );
    expect(result.monotonic, isFalse);
    expect(result.method, 'local-sample');
    expect(result.sampled, isNotEmpty);
    expect(result.failing.every(result.sampled.contains), isTrue);
  });

  test('minimizer keeps only factors required for the failure', () async {
    const baseline = FrameSettings(size: Size(400, 800));
    final failing = baseline.copyWith(
      size: const Size(200, 800),
      boldText: true,
      scale: 2,
    );
    final result = await minimizeFailure(
      failing: failing,
      baseline: baseline,
      fails: (settings) async => settings.boldText && settings.size.width < 250,
    );
    expect(result.requiredFactors.containsKey('boldText'), isTrue);
    expect(result.settings.scale, 1);
    expect(result.settings.size.width, 200);
    expect(result.settings.boldText, isTrue);
  });
}
