import 'dart:convert';
import 'dart:io';

/// Checks a `p2e-inspector-bundle-v2` file. Sampled findings only; no pixel claim.
void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln('Usage: dart run tool/validate_sweep_v2.dart <bundle.json>');
    exitCode = 64;
    return;
  }
  final bundle = jsonDecode(File(arguments.single).readAsStringSync());
  if (bundle is! Map) {
    throw const FormatException('Bundle must be an object');
  }
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
  final encoded = jsonEncode(bundle).toLowerCase();
  for (final banned in ['passwordvalue', 'otpvalue', 'inputvalue', 'rawtext']) {
    if (encoded.contains('"$banned"')) {
      throw FormatException('Bundle contains $banned');
    }
  }
  stdout.writeln('Sweep bundle v2 verified.');
}
