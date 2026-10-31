import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/core/sensors/device_tilt_service.dart';
import 'package:mygame_p2e/shared/widgets/parallax/app_parallax_canvas.dart';
import 'package:mygame_p2e/shared/widgets/parallax/parallax_layer.dart';

void main() {
  setUp(() {
    DeviceTiltService.instance.init(streamFactory: () => const Stream.empty());
    DeviceTiltService.instance.reset();
  });

  tearDown(() {
    DeviceTiltService.instance.clearSimulation();
    DeviceTiltService.instance.reset();
  });

  group('DeviceTiltService', () {
    test('setSimulatedTilt updates tilt notifier with smoothing', () {
      final service = DeviceTiltService.instance;
      expect(service.tilt, Offset.zero);

      service.setSimulatedTilt(const Offset(0.5, -0.5));
      expect(service.tilt.dx, greaterThan(0));
      expect(service.tilt.dy, lessThan(0));

      service.reset();
      expect(service.tilt, Offset.zero);
    });

    test('clamps tilt to [-1.0, 1.0]', () {
      final service = DeviceTiltService.instance;
      // Push beyond range multiple times to saturate smoothing:
      for (var i = 0; i < 30; i++) {
        service.setSimulatedTilt(const Offset(10.0, -10.0));
      }
      expect(service.tilt.dx, closeTo(1.0, 0.05));
      expect(service.tilt.dy, closeTo(-1.0, 0.05));
    });
  });

  group('AppParallaxCanvas', () {
    testWidgets('shifts layers in 2D according to tilt factors', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppParallaxCanvas(
              height: 300,
              enableSensor: false,
              layers: [
                ParallaxLayer.background(
                  key: const ValueKey('layer.bg'),
                  tiltFactor: const Offset(-4.0, -2.0),
                  child: const SizedBox.expand(),
                ),
                ParallaxLayer.stationary(
                  key: const ValueKey('layer.stat'),
                  child: const SizedBox.expand(),
                ),
                ParallaxLayer.foreground(
                  key: const ValueKey('layer.fg'),
                  tiltFactor: const Offset(8.0, 6.0),
                  child: const SizedBox(width: 100, height: 100),
                ),
              ],
            ),
          ),
        ),
      );

      final bgInitial = tester.getRect(find.byKey(const ValueKey('layer.bg')));
      final fgInitial = tester.getRect(find.byKey(const ValueKey('layer.fg')));
      final statInitial = tester.getRect(
        find.byKey(const ValueKey('layer.stat')),
      );

      // Simulate phone tilted to the right (+X) and slightly down (+Y)
      for (var i = 0; i < 30; i++) {
        DeviceTiltService.instance.setSimulatedTilt(const Offset(1.0, 1.0));
      }
      await tester.pump();

      final bgTilted = tester.getRect(find.byKey(const ValueKey('layer.bg')));
      final fgTilted = tester.getRect(find.byKey(const ValueKey('layer.fg')));
      final statTilted = tester.getRect(
        find.byKey(const ValueKey('layer.stat')),
      );

      // Background moves opposite to tilt (negative X and Y)
      expect(bgTilted.left - bgInitial.left, lessThan(0));
      expect(bgTilted.top - bgInitial.top, lessThan(0));

      // Foreground moves with tilt (positive X and Y)
      expect(fgTilted.left - fgInitial.left, greaterThan(0));
      expect(fgTilted.top - fgInitial.top, greaterThan(0));

      // Stationary layer does not shift
      expect(statTilted.left, statInitial.left);
      expect(statTilted.top, statInitial.top);
    });

    testWidgets('respects disableAnimations (reduced motion)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: AppParallaxCanvas(
                height: 300,
                parallaxOffset: 100,
                enableSensor: false,
                layers: [
                  ParallaxLayer.foreground(
                    key: const ValueKey('layer.fg'),
                    tiltFactor: const Offset(8.0, 6.0),
                    scrollFactor: 0.5,
                    child: const SizedBox(width: 100, height: 100),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final fgInitial = tester.getRect(find.byKey(const ValueKey('layer.fg')));

      for (var i = 0; i < 30; i++) {
        DeviceTiltService.instance.setSimulatedTilt(const Offset(1.0, 1.0));
      }
      await tester.pump();

      final fgAfter = tester.getRect(find.byKey(const ValueKey('layer.fg')));

      // With reduced motion, neither tilt nor scroll causes any offset shift:
      expect(fgAfter.left, fgInitial.left);
      expect(fgAfter.top, fgInitial.top);
    });
  });
}
