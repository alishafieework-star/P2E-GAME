import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_dev_inspector/inspector.dart';

class _FakeSensorDriver implements InspectorSensorDriver {
  final List<Offset> tilts = [];
  bool resetCalled = false;

  @override
  void setTilt(Offset offset) {
    tilts.add(offset);
  }

  @override
  void reset() {
    resetCalled = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GorillaStressRunner', () {
    late GlobalKey appKey;
    late SimulatedDevice device;
    late InspectionSession session;
    late ProblemRecorder recorder;
    late PerformanceMonitor performance;
    late _FakeSensorDriver sensorDriver;
    late GorillaStressRunner runner;

    setUp(() {
      appKey = GlobalKey();
      device = SimulatedDevice(const FrameSettings());
      session = InspectionSession(appKey);
      recorder = ProblemRecorder(session, device);
      performance = PerformanceMonitor(session);
      sensorDriver = _FakeSensorDriver();
      runner = GorillaStressRunner(
        appKey: appKey,
        device: device,
        session: session,
        recorder: recorder,
        performance: performance,
        sensorDriver: sensorDriver,
      );
    });

    tearDown(() {
      runner.dispose();
      recorder.dispose();
      session.dispose();
      device.dispose();
    });

    test('configures mode, intensity, and duration when not running', () {
      expect(runner.mode, GorillaMode.fullChaos);
      expect(runner.intensity, GorillaIntensity.normal);
      expect(runner.duration, GorillaDuration.fiveSeconds);

      runner.configure(
        mode: GorillaMode.sensorShake,
        intensity: GorillaIntensity.extreme,
        duration: GorillaDuration.continuous,
      );

      expect(runner.mode, GorillaMode.sensorShake);
      expect(runner.intensity, GorillaIntensity.extreme);
      expect(runner.duration, GorillaDuration.continuous);
    });

    test('starts, stops and resets sensor driver', () {
      expect(runner.running, isFalse);
      runner.start();
      expect(runner.running, isTrue);

      runner.stop();
      expect(runner.running, isFalse);
      expect(sensorDriver.resetCalled, isTrue);
    });

    testWidgets('sensor shake drives valid tilt coordinates', (tester) async {
      runner.configure(
        mode: GorillaMode.sensorShake,
        intensity: GorillaIntensity.normal,
      );

      runner.start();
      // Pump several timers
      await tester.pump(const Duration(milliseconds: 100));

      expect(sensorDriver.tilts.isNotEmpty, isTrue);
      for (final tilt in sensorDriver.tilts) {
        expect(tilt.dx.isFinite, isTrue);
        expect(tilt.dy.isFinite, isTrue);
        expect(tilt.dx, inInclusiveRange(-1.0, 1.0));
        expect(tilt.dy, inInclusiveRange(-1.0, 1.0));
      }
      expect(runner.dispatchedEvents, greaterThan(0));

      runner.stop();
      expect(sensorDriver.resetCalled, isTrue);
    });

    testWidgets(
      'scroll and tap stress dispatch pointer events without errors',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                key: appKey,
                width: 360,
                height: 640,
                child: ListView(
                  children: [
                    for (var i = 0; i < 20; i++)
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Button $i'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        runner.configure(
          mode: GorillaMode.fullChaos,
          intensity: GorillaIntensity.extreme,
        );
        runner.start();

        await tester.pump(const Duration(milliseconds: 300));
        expect(runner.dispatchedEvents, greaterThan(0));
        expect(runner.running, isTrue);

        runner.stop();
        await tester.pump();
        expect(runner.running, isFalse);
      },
    );
  });

  group('GorillaStressPanel Widget', () {
    testWidgets('renders all controls, allows mode toggling and starting', (
      tester,
    ) async {
      final appKey = GlobalKey();
      final device = SimulatedDevice(const FrameSettings());
      final session = InspectionSession(appKey);
      final recorder = ProblemRecorder(session, device);
      final performance = PerformanceMonitor(session);
      final sensorDriver = _FakeSensorDriver();
      final runner = GorillaStressRunner(
        appKey: appKey,
        device: device,
        session: session,
        recorder: recorder,
        performance: performance,
        sensorDriver: sensorDriver,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GorillaStressPanel(runner: runner)),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('gorilla-mode-sensorShake')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('gorilla-mode-fastScroll')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('gorilla-mode-monkeyTap')),
        findsOneWidget,
      );

      // Tap sensor shake chip
      await tester.tap(find.byKey(const ValueKey('gorilla-mode-sensorShake')));
      await tester.pumpAndSettle();
      expect(runner.mode, GorillaMode.sensorShake);

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('gorilla-start-stop')),
        200,
      );
      expect(find.byKey(const ValueKey('gorilla-start-stop')), findsOneWidget);

      // Start stress test
      await tester.tap(find.byKey(const ValueKey('gorilla-start-stop')));
      await tester.pump(const Duration(milliseconds: 50));
      expect(runner.running, isTrue);

      // Stop stress test
      await tester.tap(find.byKey(const ValueKey('gorilla-start-stop')));
      await tester.pump();
      expect(runner.running, isFalse);

      runner.dispose();
      recorder.dispose();
      session.dispose();
      device.dispose();
    });
  });
}
