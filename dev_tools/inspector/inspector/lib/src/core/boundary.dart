import 'dart:math' as math;

import 'device.dart';

class RefinementResult {
  const RefinementResult({
    required this.monotonic,
    required this.method,
    required this.sampled,
    required this.failing,
    required this.passing,
  });
  final bool monotonic;
  final String method;
  final List<double> sampled;
  final List<double> failing;
  final List<double> passing;

  Map<String, Object?> toJson() => {
    'monotonic': monotonic,
    'method': method,
    'sampled': sampled,
    'failing': failing,
    'passing': passing,
  };
}

/// Searches only inside the observed bracket. A non-monotonic probe switches
/// to local samples and never treats an unsampled pixel as a failure.
Future<RefinementResult> refineEdge({
  required double passing,
  required double failing,
  required Future<bool> Function(double value) fails,
}) async {
  final known = <double, bool>{passing: false, failing: true};
  Future<bool> probe(double value) async {
    final cached = known[value];
    if (cached != null) return cached;
    final bad = await fails(value);
    known[value] = bad;
    return bad;
  }

  final span = (passing - failing).abs();
  if (span <= 1) {
    return _result(known, monotonic: true, method: 'already-1px');
  }
  final low = math.min(passing, failing);
  final high = math.max(passing, failing);
  const checkpoints = 8;
  for (var i = 0; i <= checkpoints; i++) {
    await probe((low + (high - low) * i / checkpoints).roundToDouble());
  }
  if (_flips(known) > 1 || _flips(known) == 0) {
    if (high - low <= 48) {
      for (var value = low; value <= high; value++) {
        await probe(value);
      }
    } else {
      await _zoomFlips(known, probe, low, high);
    }
    return _result(known, monotonic: false, method: 'local-sample');
  }
  final flip = _flipBracket(known);
  var pass = flip.$1;
  var fail = flip.$2;
  while ((pass - fail).abs() > 1) {
    final mid = ((pass + fail) / 2).floorToDouble();
    if (mid == pass || mid == fail) break;
    if (await probe(mid)) {
      fail = mid;
    } else {
      pass = mid;
    }
    if (_flips(known) > 1) {
      await _zoomFlips(known, probe, low, high);
      return _result(known, monotonic: false, method: 'local-sample');
    }
  }
  return _result(known, monotonic: true, method: 'binary');
}

Future<void> _zoomFlips(
  Map<double, bool> known,
  Future<bool> Function(double value) probe,
  double low,
  double high,
) async {
  final points = known.keys.toList()..sort();
  for (var i = 1; i < points.length; i++) {
    if (known[points[i]] == known[points[i - 1]]) continue;
    final start = math.max(low, points[i - 1]);
    final end = math.min(high, points[i]);
    if (end - start > 8) {
      for (var step = 1; step <= 4; step++) {
        await probe((start + (end - start) * step / 5).roundToDouble());
      }
    } else {
      for (var value = start; value <= end; value++) {
        await probe(value);
      }
    }
  }
}

class MinimalFailure {
  const MinimalFailure({required this.settings, required this.requiredFactors});
  final FrameSettings settings;
  final Map<String, String> requiredFactors;

  Map<String, Object?> toJson() => {
    'device': settings.toJson(),
    'requiredFactors': requiredFactors,
  };
}

const minimizerFactors = [
  'locales',
  'scale',
  'brightness',
  'platform',
  'keyboard',
  'keyboardHeight',
  'insets',
  'disableAnimations',
  'boldText',
  'highContrast',
  'testSkin',
];

/// Drops environment factors that are not required to keep [fails] true.
/// Width and height stay at the smallest sampled failing size.
Future<MinimalFailure> minimizeFailure({
  required FrameSettings failing,
  required FrameSettings baseline,
  required Future<bool> Function(FrameSettings settings) fails,
}) async {
  var current = failing;
  final required = <String, String>{};
  for (final factor in minimizerFactors) {
    if (_sameFactor(current, baseline, factor)) continue;
    final trial = _reset(current, baseline, factor);
    if (await fails(trial)) {
      current = trial;
    } else {
      required[factor] = _factorValue(failing, factor);
    }
  }
  return MinimalFailure(settings: current, requiredFactors: required);
}

FrameSettings _reset(
  FrameSettings current,
  FrameSettings baseline,
  String factor,
) => switch (factor) {
  'locales' => current.copyWith(locales: baseline.locales),
  'scale' => current.copyWith(scale: baseline.scale),
  'brightness' => current.copyWith(brightness: baseline.brightness),
  'platform' => current.copyWith(platform: baseline.platform),
  'keyboard' => current.copyWith(keyboard: baseline.keyboard),
  'keyboardHeight' => current.copyWith(keyboardHeight: baseline.keyboardHeight),
  'insets' => current.copyWith(insets: baseline.insets),
  'disableAnimations' => current.copyWith(
    disableAnimations: baseline.disableAnimations,
  ),
  'boldText' => current.copyWith(boldText: baseline.boldText),
  'highContrast' => current.copyWith(highContrast: baseline.highContrast),
  'testSkin' => current.copyWith(testSkin: baseline.testSkin),
  _ => current,
};

bool _sameFactor(
  FrameSettings current,
  FrameSettings baseline,
  String factor,
) => switch (factor) {
  'locales' => _tags(current) == _tags(baseline),
  'scale' => current.scale == baseline.scale,
  'brightness' => current.brightness == baseline.brightness,
  'platform' => current.platform == baseline.platform,
  'keyboard' => current.keyboard == baseline.keyboard,
  'keyboardHeight' => current.keyboardHeight == baseline.keyboardHeight,
  'insets' => current.insets == baseline.insets,
  'disableAnimations' =>
    current.disableAnimations == baseline.disableAnimations,
  'boldText' => current.boldText == baseline.boldText,
  'highContrast' => current.highContrast == baseline.highContrast,
  'testSkin' => current.testSkin == baseline.testSkin,
  _ => true,
};

String _factorValue(FrameSettings settings, String factor) => switch (factor) {
  'locales' => _tags(settings),
  'scale' => settings.scale.toString(),
  'brightness' => settings.brightness.name,
  'platform' => settings.platform.name,
  'keyboard' => settings.keyboard.toString(),
  'keyboardHeight' => settings.keyboardHeight.toString(),
  'insets' =>
    '${settings.insets.left},${settings.insets.top},${settings.insets.right},${settings.insets.bottom}',
  'disableAnimations' => settings.disableAnimations.toString(),
  'boldText' => settings.boldText.toString(),
  'highContrast' => settings.highContrast.toString(),
  'testSkin' => settings.testSkin.toString(),
  _ => '',
};

String _tags(FrameSettings settings) =>
    settings.locales.map((locale) => locale.toLanguageTag()).join(',');

RefinementResult _result(
  Map<double, bool> known, {
  required bool monotonic,
  required String method,
}) {
  final sampled = known.keys.toList()..sort();
  return RefinementResult(
    monotonic: monotonic,
    method: method,
    sampled: sampled,
    failing: [
      for (final value in sampled)
        if (known[value]!) value,
    ],
    passing: [
      for (final value in sampled)
        if (!known[value]!) value,
    ],
  );
}

int _flips(Map<double, bool> known) {
  final points = known.keys.toList()..sort();
  var flips = 0;
  for (var i = 1; i < points.length; i++) {
    if (known[points[i]] != known[points[i - 1]]) flips++;
  }
  return flips;
}

(double, double) _flipBracket(Map<double, bool> known) {
  final points = known.keys.toList()..sort();
  for (var i = 1; i < points.length; i++) {
    if (known[points[i]] != known[points[i - 1]]) {
      final leftFails = known[points[i - 1]]!;
      return leftFails
          ? (points[i], points[i - 1])
          : (points[i - 1], points[i]);
    }
  }
  return (points.first, points.last);
}
