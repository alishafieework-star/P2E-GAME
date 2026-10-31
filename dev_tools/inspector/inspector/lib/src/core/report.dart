import 'dart:convert';

import 'accessibility.dart';
import 'inspection.dart';
import 'performance.dart';
import 'sweep.dart';

final _bannedKey = RegExp(
  r'passwordvalue|otpvalue|inputvalue|rawinput|rawtext|secret|tokenvalue|accesstoken|authtoken|hascontent|hasvalue',
  caseSensitive: false,
);

/// Drops secret-shaped keys without the snapshot truncator, so sweep ranges
/// stay intact. String values are still capped.
Object? scrubReport(Object? value) {
  if (value is Map) {
    return <String, Object?>{
      for (final entry in value.entries)
        if (!_bannedKey.hasMatch(entry.key.toString()))
          entry.key.toString(): scrubReport(entry.value),
    };
  }
  if (value is List) {
    return [for (final item in value) scrubReport(item)];
  }
  if (value is String && value.length > 500) return value.substring(0, 500);
  if (value is num || value is bool || value is String || value == null) {
    return value;
  }
  return value.runtimeType.toString();
}

Map<String, Object?> buildReportBundle({
  required String host,
  required SweepRunner sweep,
  required AccessibilityAuditor accessibility,
  required PerformanceMonitor performance,
  String? scenarioId,
}) {
  final report = scrubReport({
    'format': 'p2e-inspector-bundle-v2',
    'inspectorBuildMarker': inspectorBuildMarker,
    'host': host,
    'scenarioId': scenarioId ?? sweep.scenarioId,
    'sweep': sweep.exportBundle(),
    'accessibility': accessibility.toJson(),
    'performance': performance.toJson(),
    'claims': {
      'pixelEquality': false,
      'platformAccessibilityCertification': false,
      'sampledOnly': true,
    },
  });
  return report as Map<String, Object?>;
}

String exportReportBundle(Map<String, Object?> bundle) =>
    const JsonEncoder.withIndent('  ').convert(bundle);

/// Throws [FormatException] when a bundle violates the v2 contract.
void validateSweepBundle(Map<String, Object?> bundle) {
  if (bundle['format'] != 'p2e-inspector-bundle-v2') {
    throw const FormatException('Unexpected bundle format');
  }
  final sweep = bundle['sweep'];
  if (sweep is! Map || sweep['format'] != 'p2e-sweep-v2') {
    throw const FormatException('Unexpected sweep format');
  }
  for (final key in [
    'seed',
    'coverage',
    'ranges',
    'refinements',
    'minimalCases',
    'sampleCount',
  ]) {
    if (!sweep.containsKey(key)) throw FormatException('Missing sweep.$key');
  }
  final claims = bundle['claims'];
  if (claims is! Map ||
      claims['pixelEquality'] != false ||
      claims['platformAccessibilityCertification'] != false ||
      claims['sampledOnly'] != true) {
    throw const FormatException('Bundle claims are not allowed');
  }
  final accessibility = bundle['accessibility'];
  if (accessibility is! Map || accessibility['format'] != 'p2e-a11y-audit-v1') {
    throw const FormatException('Unexpected accessibility format');
  }
  final performance = bundle['performance'];
  if (performance is! Map || performance['format'] != 'p2e-inspector-perf-v1') {
    throw const FormatException('Unexpected performance format');
  }
  final encoded = jsonEncode(bundle).toLowerCase();
  for (final banned in ['passwordvalue', 'otpvalue', 'inputvalue', 'rawtext']) {
    if (encoded.contains('"$banned"')) {
      throw FormatException('Bundle contains $banned');
    }
  }
}
