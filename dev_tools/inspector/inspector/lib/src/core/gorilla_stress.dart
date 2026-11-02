import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

import 'device.dart';
import 'performance.dart';
import 'problems.dart';
import 'selection.dart';

/// Abstract driver to oscillate simulated tilt or gyro hardware.
abstract interface class InspectorSensorDriver {
  void setTilt(Offset offset);
  void reset();
}

enum GorillaMode { sensorShake, fastScroll, slowScroll, monkeyTap, fullChaos }

enum GorillaIntensity { gentle, normal, extreme }

enum GorillaDuration { fiveSeconds, tenSeconds, continuous }

enum GorillaTapTarget {
  selectedElement,
  interactiveWidgets,
  topZone,
  centerZone,
  bottomZone,
  customPoint,
}

class GorillaStressRunner extends ChangeNotifier {
  GorillaStressRunner({
    required this.appKey,
    required this.device,
    required this.session,
    required this.recorder,
    required this.performance,
    this.sensorDriver,
  });

  final GlobalKey appKey;
  final SimulatedDevice device;
  final InspectionSession session;
  final ProblemRecorder recorder;
  final PerformanceMonitor performance;
  final InspectorSensorDriver? sensorDriver;

  bool running = false;
  GorillaMode mode = GorillaMode.fullChaos;
  GorillaIntensity intensity = GorillaIntensity.normal;
  GorillaDuration duration = GorillaDuration.fiveSeconds;
  GorillaTapTarget tapTarget = GorillaTapTarget.interactiveWidgets;

  Offset? customTapPoint;
  Offset? lastDispatchedTapLocal;

  int dispatchedEvents = 0;
  int initialSlowFrames = 0;
  int initialProblems = 0;
  double elapsedSeconds = 0.0;

  Timer? _timer;
  Timer? _pressTimer;
  int _pointerIdCounter = 1000;
  int _tickCount = 0;
  double _timeAccumulator = 0.0;
  bool _scrollDirectionDown = true;
  final math.Random _random = math.Random();

  int get slowFramesDuringRun =>
      math.max(0, performance.slowFrames - initialSlowFrames);

  int get problemsDuringRun =>
      math.max(0, recorder.problems.length - initialProblems);

  double get targetDurationSeconds => switch (duration) {
    GorillaDuration.fiveSeconds => 5.0,
    GorillaDuration.tenSeconds => 10.0,
    GorillaDuration.continuous => double.infinity,
  };

  void configure({
    GorillaMode? mode,
    GorillaIntensity? intensity,
    GorillaDuration? duration,
    GorillaTapTarget? tapTarget,
    Offset? customTapPoint,
  }) {
    if (running) return;
    if (mode != null) this.mode = mode;
    if (intensity != null) this.intensity = intensity;
    if (duration != null) this.duration = duration;
    if (tapTarget != null) this.tapTarget = tapTarget;
    if (customTapPoint != null) this.customTapPoint = customTapPoint;
    notifyListeners();
  }

  void start() {
    if (running) return;
    running = true;
    dispatchedEvents = 0;
    _tickCount = 0;
    elapsedSeconds = 0.0;
    _timeAccumulator = 0.0;
    lastDispatchedTapLocal = null;
    initialSlowFrames = performance.slowFrames;
    initialProblems = recorder.problems.length;
    notifyListeners();

    // 50ms tick interval (20 Hz)
    _timer = Timer.periodic(const Duration(milliseconds: 50), _onTick);
  }

  void stop() {
    if (!running) return;
    _timer?.cancel();
    _timer = null;
    _pressTimer?.cancel();
    _pressTimer = null;
    running = false;
    lastDispatchedTapLocal = null;
    sensorDriver?.reset();
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  Future<void> _onTick(Timer timer) async {
    if (!running) return;
    _tickCount++;
    const dt = 0.050;
    elapsedSeconds += dt;
    _timeAccumulator += dt;

    if (elapsedSeconds >= targetDurationSeconds) {
      stop();
      return;
    }

    final (scrollInterval, tapInterval) = switch (intensity) {
      GorillaIntensity.gentle => (6, 8),
      GorillaIntensity.normal => (3, 4),
      GorillaIntensity.extreme => (1, 2),
    };

    try {
      switch (mode) {
        case GorillaMode.sensorShake:
          _tickSensorShake(_timeAccumulator);
        case GorillaMode.fastScroll:
          if ((_tickCount % scrollInterval) == 0) {
            await _tickScroll(fast: true);
          }
        case GorillaMode.slowScroll:
          if ((_tickCount % scrollInterval) == 0) {
            await _tickScroll(fast: false);
          }
        case GorillaMode.monkeyTap:
          if ((_tickCount % tapInterval) == 0) {
            _tickMonkeyTap();
          }
        case GorillaMode.fullChaos:
          _tickSensorShake(_timeAccumulator);
          if ((_tickCount % scrollInterval) == 0) {
            await _tickScroll(fast: _random.nextBool());
          }
          if ((_tickCount % tapInterval) == 0) {
            _tickMonkeyTap();
          }
      }
    } catch (e, st) {
      debugPrint('Gorilla stress tick error: $e\n$st');
    }

    notifyListeners();
  }

  void _tickSensorShake(double time) {
    if (sensorDriver == null) return;
    final (freq, amp) = switch (intensity) {
      GorillaIntensity.gentle => (4.0, 0.4),
      GorillaIntensity.normal => (10.0, 0.75),
      GorillaIntensity.extreme => (22.0, 1.0),
    };

    final x = math.sin(time * freq * math.pi) * amp;
    final y = math.cos(time * freq * 0.7 * math.pi) * (amp * 0.6);
    sensorDriver?.setTilt(Offset(x.clamp(-1.0, 1.0), y.clamp(-1.0, 1.0)));
    dispatchedEvents++;
  }

  RenderBox? _findAppBox() {
    final context = appKey.currentContext;
    if (context == null || !context.mounted) return null;
    final obj = context.findRenderObject();
    if (obj is RenderBox &&
        obj.hasSize &&
        obj.size.width > 20 &&
        obj.size.height > 20) {
      return obj;
    }
    return null;
  }

  List<ScrollableState> _findScrollables() {
    final context = appKey.currentContext;
    if (context == null || !context.mounted) return const [];
    final results = <ScrollableState>[];
    void visit(Element element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        final s = element.state as ScrollableState;
        if (s.position.hasContentDimensions && s.position.maxScrollExtent > 0) {
          results.add(s);
        }
      }
      element.visitChildElements(visit);
    }

    context.visitChildElements(visit);
    return results;
  }

  Future<void> _tickScroll({required bool fast}) async {
    final box = _findAppBox();
    if (box == null) return;

    final scrollables = _findScrollables();
    final scrollDelta = fast
        ? (_scrollDirectionDown ? 280.0 : -280.0)
        : (_scrollDirectionDown ? 35.0 : -35.0);

    if (scrollables.isNotEmpty) {
      for (final s in scrollables) {
        if (!s.position.hasContentDimensions) continue;
        final max = s.position.maxScrollExtent;
        final min = s.position.minScrollExtent;
        if (max <= min) continue;

        final current = s.position.pixels;
        final next = (current + scrollDelta).clamp(min, max);

        if (next >= max - 5) {
          _scrollDirectionDown = false;
        } else if (next <= min + 5) {
          _scrollDirectionDown = true;
        }

        if (fast) {
          s.position.animateTo(
            next,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
          );
        } else {
          s.position.jumpTo(next);
        }
        dispatchedEvents++;
      }
    }

    // Also dispatch pointer wheel scroll event to the center
    final globalTopLeft = box.localToGlobal(Offset.zero);
    final center = Offset(
      globalTopLeft.dx + box.size.width / 2,
      globalTopLeft.dy + box.size.height / 2,
    );
    GestureBinding.instance.handlePointerEvent(
      PointerScrollEvent(position: center, scrollDelta: Offset(0, scrollDelta)),
    );
    dispatchedEvents++;
  }

  void _tickMonkeyTap() {
    final box = _findAppBox();
    if (box == null) return;

    final localTarget = _resolveTapTargetLocal(box);
    if (localTarget == null) return;

    lastDispatchedTapLocal = localTarget;
    final globalTopLeft = box.localToGlobal(Offset.zero);
    final globalTarget = Offset(
      globalTopLeft.dx + localTarget.dx,
      globalTopLeft.dy + localTarget.dy,
    );

    final pointer = _pointerIdCounter++;

    GestureBinding.instance.handlePointerEvent(
      PointerDownEvent(
        pointer: pointer,
        position: globalTarget,
        kind: PointerDeviceKind.mouse,
        buttons: kPrimaryMouseButton,
      ),
    );
    dispatchedEvents++;
    notifyListeners();

    _pressTimer?.cancel();
    _pressTimer = Timer(const Duration(milliseconds: 45), () {
      if (!running) return;
      GestureBinding.instance.handlePointerEvent(
        PointerUpEvent(
          pointer: pointer,
          position: globalTarget,
          kind: PointerDeviceKind.mouse,
        ),
      );
      dispatchedEvents++;
      notifyListeners();
    });
  }

  Offset? _resolveTapTargetLocal(RenderBox appBox) {
    final width = appBox.size.width;
    final height = appBox.size.height;

    switch (tapTarget) {
      case GorillaTapTarget.selectedElement:
        final selected = session.selected;
        if (selected != null && selected.element.mounted) {
          final render = selected.element.findRenderObject();
          if (render is RenderBox && render.hasSize) {
            final appTopLeft = appBox.localToGlobal(Offset.zero);
            final targetGlobal = render.localToGlobal(
              render.size.center(Offset.zero),
            );
            final local = targetGlobal - appTopLeft;
            return Offset(
              local.dx.clamp(10, width - 10),
              local.dy.clamp(10, height - 10),
            );
          }
        }
        return Offset(width / 2, height / 2);

      case GorillaTapTarget.interactiveWidgets:
        final targets = _findInteractiveTargets(appBox);
        if (targets.isNotEmpty) {
          final globalTopLeft = appBox.localToGlobal(Offset.zero);
          final picked = targets[_random.nextInt(targets.length)];
          final local = picked - globalTopLeft;
          return Offset(
            local.dx.clamp(10, width - 10),
            local.dy.clamp(10, height - 10),
          );
        }
        return Offset(width / 2, height / 2);

      case GorillaTapTarget.topZone:
        return Offset(
          width * (0.2 + _random.nextDouble() * 0.6),
          height * (0.06 + _random.nextDouble() * 0.12),
        );

      case GorillaTapTarget.centerZone:
        return Offset(
          width * (0.2 + _random.nextDouble() * 0.6),
          height * (0.38 + _random.nextDouble() * 0.24),
        );

      case GorillaTapTarget.bottomZone:
        return Offset(
          width * (0.2 + _random.nextDouble() * 0.6),
          height * (0.80 + _random.nextDouble() * 0.14),
        );

      case GorillaTapTarget.customPoint:
        if (customTapPoint != null) {
          return Offset(
            customTapPoint!.dx.clamp(10, width - 10),
            customTapPoint!.dy.clamp(10, height - 10),
          );
        }
        return Offset(width / 2, height / 2);
    }
  }

  List<Offset> _findInteractiveTargets(RenderBox appBox) {
    final context = appKey.currentContext;
    if (context == null || !context.mounted) return const [];
    final results = <Offset>[];
    final globalTopLeft = appBox.localToGlobal(Offset.zero);
    final appRect = globalTopLeft & appBox.size;

    void visit(Element element) {
      if (!element.mounted) return;
      final widget = element.widget;
      final isInteractive =
          widget is ButtonSegment ||
          widget is InkResponse ||
          widget is EditableText ||
          (widget is ElementIdentity &&
              (widget.elementId.contains('.button') ||
                  widget.elementId.contains('.field') ||
                  widget.elementId.contains('.chip') ||
                  widget.elementId.contains('.tab') ||
                  widget.elementId.contains('.item')));

      if (isInteractive) {
        final render = element.findRenderObject();
        if (render is RenderBox && render.hasSize) {
          final bounds = render.localToGlobal(Offset.zero) & render.size;
          if (appRect.contains(bounds.center)) {
            results.add(bounds.center);
          }
        }
      }
      element.visitChildElements(visit);
    }

    context.visitChildElements(visit);
    return results;
  }
}
