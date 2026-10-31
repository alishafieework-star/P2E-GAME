import 'package:flutter/material.dart';

import 'device.dart';

/// One discrete environment axis. Levels are stable string ids, never user text.
class EnvironmentFactor {
  const EnvironmentFactor(this.id, this.levels);
  final String id;
  final List<String> levels;
}

const environmentFactors = <EnvironmentFactor>[
  EnvironmentFactor('locale', ['fa-IR', 'en-US', 'fa-IR,en-US']),
  EnvironmentFactor('scale', ['1', '1.3', '2']),
  EnvironmentFactor('brightness', ['dark', 'light']),
  EnvironmentFactor('platform', ['android', 'iOS']),
  EnvironmentFactor('keyboard', ['off', 'on']),
  EnvironmentFactor('keyboardHeight', ['0', '300']),
  EnvironmentFactor('insets', ['none', 'phone', 'asymmetric']),
  EnvironmentFactor('motion', ['normal', 'reduced']),
  EnvironmentFactor('bold', ['off', 'on']),
  EnvironmentFactor('contrast', ['off', 'on']),
  EnvironmentFactor('skin', ['product', 'test']),
];

class SweepSample {
  const SweepSample({
    required this.index,
    required this.settings,
    required this.factors,
    required this.sizeId,
  });
  final int index;
  final FrameSettings settings;
  final Map<String, String> factors;
  final String sizeId;

  String get factorKey {
    final entries = factors.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries.map((entry) => '${entry.key}=${entry.value}').join('&');
  }
}

/// Deterministic pairwise rows. The same seed always yields the same rows.
List<Map<String, String>> buildPairwise(
  List<EnvironmentFactor> factors, {
  int seed = 1,
}) {
  final pending = _allPairs(factors);
  final rows = <Map<String, String>>[];
  var guard = 0;
  while (pending.isNotEmpty && guard < pending.length + factors.length * 8) {
    guard++;
    final ordered = pending.toList()..sort();
    final chosen = ordered[(seed + rows.length) % ordered.length];
    final row = <String, String>{};
    for (final part in chosen.split('|')) {
      final split = part.indexOf('=');
      row[part.substring(0, split)] = part.substring(split + 1);
    }
    for (final factor in factors) {
      if (row.containsKey(factor.id)) continue;
      var best = factor.levels.first;
      var bestScore = -1;
      var bestIndex = 0;
      for (var i = 0; i < factor.levels.length; i++) {
        final level = factor.levels[i];
        var score = 0;
        for (final other in row.entries) {
          if (pending.contains(
            _pairKey(factor.id, level, other.key, other.value),
          )) {
            score++;
          }
        }
        final tie =
            score == bestScore &&
            _tie(seed, rows.length, factor.id, i) <
                _tie(seed, rows.length, factor.id, bestIndex);
        if (score > bestScore || tie) {
          bestScore = score;
          best = level;
          bestIndex = i;
        }
      }
      row[factor.id] = best;
    }
    pending.removeWhere((pair) => _rowCovers(row, pair));
    rows.add(Map.unmodifiable(row));
  }
  if (pending.isNotEmpty) {
    throw StateError('Pairwise generator left ${pending.length} pairs');
  }
  return rows;
}

int uncoveredPairs(
  List<EnvironmentFactor> factors,
  List<Map<String, String>> rows,
) {
  final pending = _allPairs(factors);
  for (final row in rows) {
    pending.removeWhere((pair) => _rowCovers(row, pair));
  }
  return pending.length;
}

Set<String> _allPairs(List<EnvironmentFactor> factors) {
  final pairs = <String>{};
  for (var i = 0; i < factors.length; i++) {
    for (var j = i + 1; j < factors.length; j++) {
      for (final left in factors[i].levels) {
        for (final right in factors[j].levels) {
          pairs.add(_pairKey(factors[i].id, left, factors[j].id, right));
        }
      }
    }
  }
  return pairs;
}

String _pairKey(String a, String av, String b, String bv) =>
    a.compareTo(b) < 0 ? '$a=$av|$b=$bv' : '$b=$bv|$a=$av';

bool _rowCovers(Map<String, String> row, String pair) {
  final parts = pair.split('|');
  for (final part in parts) {
    final split = part.indexOf('=');
    if (row[part.substring(0, split)] != part.substring(split + 1)) {
      return false;
    }
  }
  return true;
}

int _tie(int seed, int row, String factor, int level) {
  var mixed = seed + row * 17 + level * 13;
  for (final unit in factor.codeUnits) {
    mixed = (mixed * 33 + unit) & 0x7fffffff;
  }
  return (1103515245 * mixed + 12345) & 0x7fffffff;
}

List<Locale> localesFromLevel(String level) => [
  for (final tag in level.split(','))
    Locale(
      tag.split('-').first,
      tag.split('-').length > 1 ? tag.split('-')[1] : null,
    ),
];

FrameSettings applyEnvironment(
  FrameSettings base,
  Map<String, String> levels, {
  Size? size,
  EdgeInsets? presetInsets,
}) {
  final locale = levels['locale'];
  final scale = levels['scale'];
  final brightness = levels['brightness'];
  final platform = levels['platform'];
  final keyboard = levels['keyboard'];
  final keyboardHeight = levels['keyboardHeight'];
  final insets = levels['insets'];
  final motion = levels['motion'];
  final bold = levels['bold'];
  final contrast = levels['contrast'];
  final skin = levels['skin'];
  return base.copyWith(
    size: size ?? base.size,
    locales: locale == null ? null : localesFromLevel(locale),
    scale: scale == null ? null : double.parse(scale),
    brightness: brightness == null
        ? null
        : brightness == 'light'
        ? Brightness.light
        : Brightness.dark,
    platform: platform == null
        ? null
        : platform == 'iOS'
        ? TargetPlatform.iOS
        : TargetPlatform.android,
    keyboard: keyboard == null ? null : keyboard == 'on',
    keyboardHeight: keyboardHeight == null
        ? null
        : double.parse(keyboardHeight),
    insets: presetInsets ?? _insets(base, insets),
    disableAnimations: motion == null ? null : motion == 'reduced',
    boldText: bold == null ? null : bold == 'on',
    highContrast: contrast == null ? null : contrast == 'on',
    testSkin: skin == null ? null : skin == 'test',
  );
}

EdgeInsets? _insets(FrameSettings base, String? level) => switch (level) {
  null => null,
  'none' => EdgeInsets.zero,
  'phone' => const EdgeInsets.fromLTRB(0, 24, 0, 24),
  'asymmetric' => const EdgeInsets.fromLTRB(40, 12, 8, 48),
  _ => base.insets,
};

/// Boundary sizes inside the plan limits. Width and height axes keep the
/// other side on the baseline so a failure can be attributed to one axis.
List<FramePreset> sizesFor({
  required SweepAxis axis,
  required FrameSettings base,
  required double minWidth,
  required double maxWidth,
  required double minHeight,
  required double maxHeight,
}) {
  bool inside(Size size) =>
      size.width >= minWidth &&
      size.width <= maxWidth &&
      size.height >= minHeight &&
      size.height <= maxHeight;
  final selected = <FramePreset>[];
  void add(String id, Size size, {EdgeInsets? insets}) {
    if (!inside(size)) return;
    if (selected.any((preset) => preset.id == id)) return;
    selected.add(FramePreset(id, size, insets: insets));
  }

  switch (axis) {
    case SweepAxis.width:
      for (final width in [251, 252, 253, 360, 599, 600, 601, 839, 840, 841]) {
        add(
          'w$width',
          Size(width.toDouble(), base.size.height.clamp(minHeight, maxHeight)),
        );
      }
    case SweepAxis.height:
      for (final height in [300, 402, 800, 874, 1400]) {
        add(
          'h$height',
          Size(base.size.width.clamp(minWidth, maxWidth), height.toDouble()),
        );
      }
    case SweepAxis.grid:
      for (final preset in engineeringPresets) {
        add(preset.id, preset.size, insets: preset.insets);
      }
  }
  if (selected.isEmpty) add('baseline', base.size);
  return selected;
}

enum SweepAxis { width, height, grid }
