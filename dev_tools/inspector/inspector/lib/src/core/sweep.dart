import 'dart:convert';

import 'package:flutter/material.dart';

import 'accessibility.dart';
import 'boundary.dart';
import 'device.dart';
import 'matrix.dart';
import 'performance.dart';
import 'problems.dart';

enum SweepStrategy { legacy, pairwiseBoundary }

class SweepPlan {
  const SweepPlan({
    this.axis = SweepAxis.width,
    this.minWidth = 200,
    this.maxWidth = 1400,
    this.minHeight = 300,
    this.maxHeight = 1400,
    this.widthStep = 4,
    this.heightStep = 8,
    this.scales = const [],
    this.locales = const [],
    this.strategy = SweepStrategy.legacy,
    this.seed = 1,
    this.refine = false,
    this.minimize = false,
    this.scenarioId,
    this.environments,
  });
  final SweepAxis axis;
  final double minWidth, maxWidth, minHeight, maxHeight, widthStep, heightStep;
  final List<double> scales;
  final List<List<Locale>> locales;
  final SweepStrategy strategy;
  final int seed;
  final bool refine, minimize;
  final String? scenarioId;

  /// Explicit environment rows. Null generates the seeded pairwise matrix.
  final List<Map<String, String>>? environments;

  SweepPlan copyWith({String? scenarioId, bool clearScenario = false}) =>
      SweepPlan(
        axis: axis,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
        widthStep: widthStep,
        heightStep: heightStep,
        scales: scales,
        locales: locales,
        strategy: strategy,
        seed: seed,
        refine: refine,
        minimize: minimize,
        scenarioId: clearScenario ? null : scenarioId ?? this.scenarioId,
        environments: environments,
      );

  String get signature => jsonEncode({
    'axis': axis.name,
    'minWidth': minWidth,
    'maxWidth': maxWidth,
    'minHeight': minHeight,
    'maxHeight': maxHeight,
    'widthStep': widthStep,
    'heightStep': heightStep,
    'scales': scales,
    'locales': [
      for (final list in locales)
        [for (final locale in list) locale.toLanguageTag()],
    ],
    'strategy': strategy.name,
    'seed': seed,
    'refine': refine,
    'minimize': minimize,
    'environments': environments,
  });

  Iterable<FrameSettings> frames(FrameSettings base) sync* {
    if (widthStep <= 0 || heightStep <= 0) {
      throw ArgumentError('Positive sweep steps required');
    }
    for (final scale in scales.isEmpty ? [base.scale] : scales) {
      for (final locale in locales.isEmpty ? [base.locales] : locales) {
        for (
          var w = axis == SweepAxis.height ? base.size.width : minWidth;
          w <= (axis == SweepAxis.height ? base.size.width : maxWidth);
          w += widthStep
        ) {
          for (
            var h = axis == SweepAxis.width ? base.size.height : minHeight;
            h <= (axis == SweepAxis.width ? base.size.height : maxHeight);
            h += heightStep
          ) {
            yield base.copyWith(
              size: Size(w, h),
              scale: scale,
              locales: locale,
            );
          }
        }
      }
    }
  }
}

class _Outcome {
  _Outcome(this.sample, this.groups);
  final SweepSample sample;
  final Set<String> groups;
}

/// v1.1 grouping is unchanged. Professional runs add sampled refinement and
/// a minimal replay case without claiming unsampled pixels.
class SweepRunner extends ChangeNotifier {
  SweepRunner(this.device, this.recorder, {this.auditor, this.performance});
  final SimulatedDevice device;
  final ProblemRecorder recorder;
  final AccessibilityAuditor? auditor;
  final PerformanceMonitor? performance;
  bool running = false, cancelled = false, canResume = false;
  int completed = 0, total = 0, resumeAt = 0, scenariosCompleted = 0;
  String? scenarioId;
  int? seed;
  String strategy = SweepStrategy.legacy.name;
  List<Map<String, Object?>> ranges = [];
  List<Map<String, Object?>> refinements = [];
  List<Map<String, Object?>> minimalCases = [];
  Map<String, Object?> coverage = {};
  String? _signature;
  List<SweepSample> _planned = [];
  final List<_Outcome> _outcomes = [];
  FrameSettings? _baseline;
  SweepPlan? _plan;
  int _scenarioCursor = 0;

  Future<void> run(
    SweepPlan plan,
    Future<void> Function() frame, {
    bool resume = false,
    List<String>? scenarioIds,
    Future<void> Function(String id)? activateScenario,
  }) async {
    if (running) return;
    if (plan.strategy == SweepStrategy.legacy &&
        (scenarioIds == null || scenarioIds.isEmpty)) {
      await _runLegacy(plan, frame);
      return;
    }
    await _runProfessional(
      plan,
      frame,
      resume: resume,
      scenarioIds: scenarioIds,
      activateScenario: activateScenario,
    );
  }

  Future<void> _runLegacy(SweepPlan plan, Future<void> Function() frame) async {
    final saved = device.settings, savedMode = device.mode;
    running = true;
    cancelled = false;
    canResume = false;
    completed = 0;
    ranges = [];
    refinements = [];
    minimalCases = [];
    strategy = SweepStrategy.legacy.name;
    device.mode = FrameMode.free;
    final active = <String, Map<String, Object?>>{};
    final frames = plan.frames(saved).toList();
    total = frames.length;
    try {
      for (final settings in frames) {
        if (cancelled) break;
        final before = recorder.events.length;
        device.apply(settings);
        await frame();
        recorder.sampleLayout();
        final seen = <String>{};
        for (final p in recorder.events.skip(before)) {
          final key =
              '${p.group}|${settings.scale}|${settings.locales}|${settings.size.height}';
          if (!seen.add(key)) continue;
          final previous = active[key];
          if (previous != null &&
              (previous['lastWidth'] as double) + plan.widthStep ==
                  settings.size.width &&
              plan.axis != SweepAxis.height) {
            previous['lastWidth'] = settings.size.width;
          } else {
            final row = <String, Object?>{
              ...p.toJson(),
              'firstWidth': settings.size.width,
              'lastWidth': settings.size.width,
              'firstHeight': settings.size.height,
              'lastHeight': settings.size.height,
              'widthStep': plan.widthStep,
              'heightStep': plan.heightStep,
            };
            final heightKey =
                '${p.group}|${settings.scale}|${settings.locales}|${settings.size.width}';
            final previousHeight = active[heightKey];
            if (plan.axis == SweepAxis.height &&
                previousHeight != null &&
                (previousHeight['lastHeight'] as double) + plan.heightStep ==
                    settings.size.height) {
              previousHeight['lastHeight'] = settings.size.height;
            } else {
              ranges.add(row);
              active[plan.axis == SweepAxis.height ? heightKey : key] = row;
            }
          }
        }
        completed++;
        notifyListeners();
      }
    } finally {
      device.mode = savedMode;
      device.apply(saved);
      await frame();
      running = false;
      notifyListeners();
    }
  }

  Future<void> _runProfessional(
    SweepPlan plan,
    Future<void> Function() frame, {
    required bool resume,
    List<String>? scenarioIds,
    Future<void> Function(String id)? activateScenario,
  }) async {
    final ids = (scenarioIds == null || scenarioIds.isEmpty)
        ? <String?>[plan.scenarioId]
        : scenarioIds;
    final saved = device.settings, savedMode = device.mode;
    running = true;
    cancelled = false;
    auditor?.suspend();
    device.mode = FrameMode.free;
    final same = resume && _signature == plan.signature && _plan != null;
    if (!same) {
      completed = 0;
      resumeAt = 0;
      scenariosCompleted = 0;
      _scenarioCursor = 0;
      ranges = [];
      refinements = [];
      minimalCases = [];
      _outcomes.clear();
      _planned = [];
      _baseline = saved;
      _signature = plan.signature;
      canResume = false;
    }
    _plan = plan;
    strategy = plan.strategy.name;
    seed = plan.seed;
    try {
      for (var index = _scenarioCursor; index < ids.length; index++) {
        if (cancelled) break;
        final id = ids[index];
        scenarioId = id;
        if (id != null && activateScenario != null) {
          await activateScenario(id);
          await frame();
        }
        final current = plan.copyWith(
          scenarioId: id,
          clearScenario: id == null,
        );
        final resuming =
            same && index == _scenarioCursor && _planned.isNotEmpty;
        await _sample(current, frame, resume: resuming);
        if (cancelled) {
          _scenarioCursor = index;
          canResume = true;
          break;
        }
        if (current.refine) await _refine(current, frame);
        if (cancelled) {
          _scenarioCursor = index;
          canResume = true;
          break;
        }
        if (current.minimize) await _minimize(current, frame);
        _outcomes.clear();
        _planned = [];
        resumeAt = 0;
        _scenarioCursor = index + 1;
        scenariosCompleted = _scenarioCursor;
      }
      if (!cancelled) canResume = false;
    } finally {
      device.mode = savedMode;
      device.apply(saved);
      await frame();
      auditor?.resume();
      running = false;
      notifyListeners();
    }
  }

  Future<void> _sample(
    SweepPlan plan,
    Future<void> Function() frame, {
    required bool resume,
  }) async {
    final baseline = _baseline!;
    if (!resume || _planned.isEmpty) {
      final environments =
          plan.environments ??
          buildPairwise(environmentFactors, seed: plan.seed);
      final sizes = sizesFor(
        axis: plan.axis,
        base: baseline,
        minWidth: plan.minWidth,
        maxWidth: plan.maxWidth,
        minHeight: plan.minHeight,
        maxHeight: plan.maxHeight,
      );
      _planned = [
        for (
          var environment = 0;
          environment < environments.length;
          environment++
        )
          for (var size = 0; size < sizes.length; size++)
            SweepSample(
              index: environment * sizes.length + size,
              settings: applyEnvironment(
                baseline,
                environments[environment],
                size: sizes[size].size,
                presetInsets: sizes[size].insets,
              ),
              factors: environments[environment],
              sizeId: sizes[size].id,
            ),
      ];
      coverage = {
        'strategy': plan.strategy.name,
        'seed': plan.seed,
        'environments': environments.length,
        'sizes': [for (final size in sizes) size.id],
        'samples': _planned.length,
        'pairs': plan.environments == null
            ? uncoveredPairs(environmentFactors, environments) == 0
                  ? 'covered'
                  : 'incomplete'
            : 'explicit',
        'scenarioId': plan.scenarioId,
      };
      resumeAt = 0;
    }
    total = _planned.length;
    for (var index = resumeAt; index < _planned.length; index++) {
      if (cancelled) {
        resumeAt = index;
        canResume = true;
        return;
      }
      final sample = _planned[index];
      final before = recorder.events.length;
      device.apply(sample.settings);
      await frame();
      recorder.sampleLayout();
      performance?.sampleTransition();
      final groups = <String>{};
      for (final problem in recorder.events.skip(before)) {
        if (groups.add(problem.group)) {
          ranges.add({
            ...problem.toJson(),
            'firstWidth': sample.settings.size.width,
            'lastWidth': sample.settings.size.width,
            'firstHeight': sample.settings.size.height,
            'lastHeight': sample.settings.size.height,
            'sampleIndex': sample.index,
            'sizeId': sample.sizeId,
            'scenarioId': plan.scenarioId,
            'seed': plan.seed,
          });
        }
      }
      _outcomes.add(_Outcome(sample, groups));
      resumeAt = index + 1;
      completed = resumeAt;
      notifyListeners();
    }
    canResume = false;
  }

  Future<void> _refine(SweepPlan plan, Future<void> Function() frame) async {
    final grouped = <String, List<_Outcome>>{};
    for (final outcome in _outcomes) {
      grouped.putIfAbsent(outcome.sample.factorKey, () => []).add(outcome);
    }
    final groups = <String>{for (final outcome in _outcomes) ...outcome.groups};
    for (final factorKey in grouped.keys) {
      final series = [...grouped[factorKey]!]
        ..sort(
          (a, b) => plan.axis == SweepAxis.height
              ? a.sample.settings.size.height.compareTo(
                  b.sample.settings.size.height,
                )
              : a.sample.settings.size.width.compareTo(
                  b.sample.settings.size.width,
                ),
        );
      for (final group in groups) {
        if (cancelled) return;
        final present = series
            .where((item) => item.groups.contains(group))
            .toList();
        final absent = series
            .where((item) => !item.groups.contains(group))
            .toList();
        if (present.isEmpty || absent.isEmpty) continue;
        final axisValue = plan.axis == SweepAxis.height
            ? (SweepSample sample) => sample.settings.size.height
            : (SweepSample sample) => sample.settings.size.width;
        final failing = present.reduce(
          (a, b) => axisValue(a.sample) <= axisValue(b.sample) ? a : b,
        );
        final higher = absent.where(
          (item) => axisValue(item.sample) > axisValue(failing.sample),
        );
        final lower = absent.where(
          (item) => axisValue(item.sample) < axisValue(failing.sample),
        );
        final neighbor = higher.isEmpty
            ? (lower.isEmpty
                  ? null
                  : lower.reduce(
                      (a, b) =>
                          axisValue(a.sample) >= axisValue(b.sample) ? a : b,
                    ))
            : higher.reduce(
                (a, b) => axisValue(a.sample) <= axisValue(b.sample) ? a : b,
              );
        if (neighbor == null) continue;
        final result = await refineEdge(
          passing: axisValue(neighbor.sample),
          failing: axisValue(failing.sample),
          fails: (value) => _fails(
            failing.sample.settings.copyWith(
              size: plan.axis == SweepAxis.height
                  ? Size(failing.sample.settings.size.width, value)
                  : Size(value, failing.sample.settings.size.height),
            ),
            group,
            frame,
          ),
        );
        refinements.add({
          'group': group,
          'scenarioId': plan.scenarioId,
          'seed': plan.seed,
          'factorKey': factorKey,
          'sizeId': failing.sample.sizeId,
          ...result.toJson(),
        });
        notifyListeners();
      }
    }
  }

  Future<void> _minimize(SweepPlan plan, Future<void> Function() frame) async {
    final baseline = _baseline;
    if (baseline == null) return;
    final seen = <String>{};
    for (final outcome in _outcomes) {
      for (final group in outcome.groups) {
        if (!seen.add('${outcome.sample.factorKey}|$group')) continue;
        if (cancelled) return;
        final peers = _outcomes.where(
          (item) =>
              item.sample.factorKey == outcome.sample.factorKey &&
              item.groups.contains(group),
        );
        final smallest = peers.reduce((a, b) {
          final aArea =
              a.sample.settings.size.width * a.sample.settings.size.height;
          final bArea =
              b.sample.settings.size.width * b.sample.settings.size.height;
          return aArea <= bArea ? a : b;
        });
        final minimal = await minimizeFailure(
          failing: smallest.sample.settings,
          baseline: baseline,
          fails: (settings) => _fails(settings, group, frame),
        );
        minimalCases.add({
          'group': group,
          'scenarioId': plan.scenarioId,
          'seed': plan.seed,
          'sampleIndex': smallest.sample.index,
          'sizeId': smallest.sample.sizeId,
          ...minimal.toJson(),
        });
        notifyListeners();
      }
    }
  }

  Future<bool> _fails(
    FrameSettings settings,
    String group,
    Future<void> Function() frame,
  ) async {
    final before = recorder.events.length;
    device.apply(settings);
    await frame();
    recorder.sampleLayout();
    return recorder.events
        .skip(before)
        .any((problem) => problem.group == group);
  }

  String exportJson() => const JsonEncoder.withIndent('  ').convert({
    'format': 'p2e-sweep-v1.1',
    'completed': completed,
    'ranges': ranges,
  });

  Map<String, Object?> exportBundle() => {
    'format': 'p2e-sweep-v2',
    'strategy': strategy,
    'seed': seed,
    'scenarioId': scenarioId,
    'sampleCount': completed,
    'scenariosCompleted': scenariosCompleted,
    'plannedSamples': total,
    'resumeAt': resumeAt,
    'cancelled': cancelled,
    'coverage': coverage,
    'ranges': ranges,
    'refinements': refinements,
    'minimalCases': minimalCases,
  };
}
