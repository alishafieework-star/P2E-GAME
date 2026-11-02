import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/core/sensors/device_tilt_service.dart';
import 'package:p2e_dev_inspector/inspector.dart';
import 'package:p2e_product_host/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Gorilla stress test drives product parallax and gestures cleanly',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProductInspectionHost(initialScenario: 'shell.home'),
      );
      await tester.pumpAndSettle();

      // Verify Gorilla tab exists
      final gorillaTab = find.text('Gorilla');
      final gorillaTabFa = find.text('گوریلا (استرس)');
      final hasTab =
          gorillaTab.evaluate().isNotEmpty ||
          gorillaTabFa.evaluate().isNotEmpty;
      expect(hasTab, isTrue);

      // Switch to Gorilla tab
      final tabFinder = gorillaTab.evaluate().isNotEmpty
          ? gorillaTab
          : gorillaTabFa;
      await tester.tap(tabFinder);
      await tester.pumpAndSettle();

      // Verify Start button exists
      final startButton = find.byKey(const ValueKey('gorilla-start-stop'));
      expect(startButton, findsOneWidget);

      // Find state
      final hostState = tester.state<InspectorHostState>(
        find.byType(InspectorHost),
      );
      final runner = hostState.gorilla;

      // Run sensor shake stress
      runner.configure(
        mode: GorillaMode.sensorShake,
        intensity: GorillaIntensity.extreme,
        duration: GorillaDuration.continuous,
      );
      runner.start();

      // Pump several frames to let timer dispatch events to DeviceTiltService
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 25));
      }

      // Verify DeviceTiltService was driven by the stress test
      expect(runner.dispatchedEvents, greaterThan(0));
      expect(DeviceTiltService.instance.tilt, isNot(Offset.zero));

      // Now test scroll chaos
      runner.configure(
        mode: GorillaMode.fastScroll,
        intensity: GorillaIntensity.extreme,
      );
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 30));
      }

      // Stop runner
      runner.stop();
      await tester.pumpAndSettle();

      expect(runner.running, isFalse);
      expect(DeviceTiltService.instance.tilt, Offset.zero);
      expect(tester.takeException(), isNull);
    },
  );
}
