import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Normalized device tilt in the range [-1.0, 1.0] along X and Y axes.
///
/// X corresponds to roll (tilting phone left or right).
/// Y corresponds to pitch (tilting phone forward or backward around a ~45° natural reading angle).
///
/// Implements exponential moving average (low-pass smoothing) to filter out
/// sensor noise and hand jitter, exactly matching the HTML reference experience.
class DeviceTiltService with WidgetsBindingObserver {
  DeviceTiltService._();

  static final DeviceTiltService instance = DeviceTiltService._();

  final ValueNotifier<Offset> tiltNotifier = ValueNotifier<Offset>(Offset.zero);

  /// Current smoothed tilt.
  Offset get tilt => tiltNotifier.value;

  StreamSubscription<AccelerometerEvent>? _subscription;
  Stream<AccelerometerEvent> Function()? _streamFactory;
  bool _initialized = false;
  bool _isPaused = false;
  bool _isSimulated = false;

  double _targetX = 0.0;
  double _targetY = 0.0;
  double _currentX = 0.0;
  double _currentY = 0.0;

  /// Smoothing factor per sensor tick (0.0 < factor <= 1.0).
  /// Lower values produce smoother, more damped motion.
  static const double smoothing = 0.12;

  /// Initialize sensor subscription and lifecycle observer.
  void init({Stream<AccelerometerEvent> Function()? streamFactory}) {
    if (streamFactory != null) {
      _streamFactory = streamFactory;
    }
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addObserver(this);
    _startListening();
  }

  /// Start or resume listening to accelerometer events.
  void _startListening() {
    if (_isSimulated || _isPaused) return;
    _subscription?.cancel();

    runZonedGuarded(
      () {
        try {
          final stream = _streamFactory != null
              ? _streamFactory!()
              : accelerometerEventStream();
          _subscription = stream.listen(
            _onAccelerometerEvent,
            onError: (Object error) {
              _subscription?.cancel();
              _subscription = null;
            },
            cancelOnError: true,
          );
        } on MissingPluginException {
          // Ignored on headless test environments.
        } catch (e) {
          debugPrint('DeviceTiltService: Accelerometer unavailable: $e');
        }
      },
      (error, stack) {
        // Gracefully swallow unhandled async channel exceptions on unsupported platforms.
        if (error is! MissingPluginException) {
          debugPrint('DeviceTiltService async error: $error');
        }
      },
    );
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    if (_isSimulated) return;

    // ax: positive when tilted right, negative when tilted left
    // ay: positive when tilted downward
    // az: positive when facing up
    // Roll (left/right tilt) in radians:
    final rollRad = math.atan2(
      -event.x,
      math.sqrt(event.y * event.y + event.z * event.z),
    );
    final rollDeg = rollRad * 180.0 / math.pi;

    // Pitch (forward/backward tilt) in radians:
    final pitchRad = math.atan2(event.y, event.z);
    final pitchDeg = pitchRad * 180.0 / math.pi;

    // Reference angle for natural viewing is around 45°:
    _targetX = (rollDeg / 25.0).clamp(-1.0, 1.0);
    _targetY = ((pitchDeg - 45.0) / 25.0).clamp(-1.0, 1.0);

    _applySmoothing();
  }

  void _applySmoothing() {
    _currentX += (_targetX - _currentX) * smoothing;
    _currentY += (_targetY - _currentY) * smoothing;

    // Snap to zero if extremely close to avoid endless micro-ticks
    if (_currentX.abs() < 0.001) _currentX = 0.0;
    if (_currentY.abs() < 0.001) _currentY = 0.0;

    final next = Offset(_currentX, _currentY);
    if ((tiltNotifier.value - next).distanceSquared > 0.00001) {
      tiltNotifier.value = next;
    }
  }

  /// Allows pointer hover (mouse/touchpad) or tests to drive the tilt.
  void setSimulatedTilt(Offset offset) {
    _isSimulated = true;
    _targetX = offset.dx.clamp(-1.0, 1.0);
    _targetY = offset.dy.clamp(-1.0, 1.0);
    _applySmoothing();
  }

  /// Clears simulation and resumes hardware sensor listening.
  void clearSimulation() {
    _isSimulated = false;
    _startListening();
  }

  /// Reset tilt back to zero.
  void reset() {
    _targetX = 0.0;
    _targetY = 0.0;
    _currentX = 0.0;
    _currentY = 0.0;
    tiltNotifier.value = Offset.zero;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _isPaused = false;
        _startListening();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _isPaused = true;
        _subscription?.cancel();
        _subscription = null;
        break;
    }
  }

  /// Dispose service (primarily for test teardown).
  @visibleForTesting
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _subscription = null;
    _streamFactory = null;
    _initialized = false;
    reset();
  }
}
