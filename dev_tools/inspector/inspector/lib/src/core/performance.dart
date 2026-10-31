import 'dart:ui' show FrameTiming;

import 'package:flutter/widgets.dart';

import 'selection.dart';

/// Frame and rebuild counts for this embed. Not a device benchmark.
class PerformanceMonitor extends ChangeNotifier {
  PerformanceMonitor(this.session);
  final InspectionSession session;
  int sampledFrames = 0;
  int slowFrames = 0;
  int maxBuildMicros = 0;
  int maxRasterMicros = 0;
  int rebuildDelta = 0;
  int refreshDelta = 0;
  int idleRefreshes = 0;
  int _lastBuilds = 0;
  int _lastRefreshes = 0;
  bool _attached = false;

  void attach() {
    if (_attached) return;
    _attached = true;
    _lastBuilds = session.buildSignals;
    _lastRefreshes = session.refreshes;
    WidgetsBinding.instance.addTimingsCallback(_onTimings);
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      noteTiming(
        timing.buildDuration.inMicroseconds,
        timing.rasterDuration.inMicroseconds,
      );
    }
  }

  void noteTiming(int buildMicros, int rasterMicros) {
    sampledFrames++;
    if (buildMicros > maxBuildMicros) maxBuildMicros = buildMicros;
    if (rasterMicros > maxRasterMicros) maxRasterMicros = rasterMicros;
    if (buildMicros + rasterMicros > 16000) slowFrames++;
    notifyListeners();
  }

  void sampleTransition() {
    final builds = session.buildSignals - _lastBuilds;
    final refreshes = session.refreshes - _lastRefreshes;
    if (builds > 0) rebuildDelta += builds;
    if (refreshes > 0) refreshDelta += refreshes;
    if (builds <= 0 && refreshes > 0) idleRefreshes += refreshes;
    _lastBuilds = session.buildSignals;
    _lastRefreshes = session.refreshes;
  }

  Map<String, Object?> toJson() => {
    'format': 'p2e-inspector-perf-v1',
    'note': 'Diagnostic counts for this embed. Not a device benchmark or a Figma comparison.',
    'sampledFrames': sampledFrames,
    'slowFrames': slowFrames,
    'maxBuildMicros': maxBuildMicros,
    'maxRasterMicros': maxRasterMicros,
    'rebuildDelta': rebuildDelta,
    'refreshDelta': refreshDelta,
    'idleRefreshes': idleRefreshes,
    'buildSignals': session.buildSignals,
    'refreshes': session.refreshes,
    'traversals': session.traversals,
  };

  @override
  void dispose() {
    if (_attached) {
      WidgetsBinding.instance.removeTimingsCallback(_onTimings);
      _attached = false;
    }
    super.dispose();
  }
}
