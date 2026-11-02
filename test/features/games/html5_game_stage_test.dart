import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/games/src/stage/game_bridge_controller.dart';
import 'package:mygame_p2e/features/games/src/stage/html5_game_registry.dart';
import 'package:mygame_p2e/features/games/src/stage/stage_hud.dart';
import 'package:p2e_design_system/design_system.dart';

void main() {
  group('Html5GameRegistry', () {
    setUp(() => Html5GameRegistry.fallbackAllGames = false);
    tearDown(() => Html5GameRegistry.fallbackAllGames = true);

    test('returns null for unregistered games', () {
      expect(Html5GameRegistry.urlFor('unknown_game'), isNull);
      expect(Html5GameRegistry.isHtml5('unknown_game'), isFalse);
    });

    test('registers and unregisters games dynamically', () {
      final testUri = Uri.parse('https://games.example.com/speed_runner');
      Html5GameRegistry.register('test_runner', testUri);

      expect(Html5GameRegistry.urlFor('test_runner'), testUri);
      expect(Html5GameRegistry.isHtml5('test_runner'), isTrue);

      Html5GameRegistry.unregister('test_runner');
      expect(Html5GameRegistry.urlFor('test_runner'), isNull);
      expect(Html5GameRegistry.isHtml5('test_runner'), isFalse);
    });
  });

  group('GameBridgeController', () {
    test('manages game session state transitions cleanly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(gameBridgeProvider).isReady, isFalse);
      expect(container.read(gameBridgeProvider).score, 0);

      final notifier = container.read(gameBridgeProvider.notifier);
      notifier.markReady();
      expect(container.read(gameBridgeProvider).isReady, isTrue);

      notifier.updateScore(150);
      expect(container.read(gameBridgeProvider).score, 150);

      notifier.addReward(50);
      notifier.addReward(25);
      expect(container.read(gameBridgeProvider).rewardPoints, 75);

      notifier.togglePause();
      expect(container.read(gameBridgeProvider).isPaused, isTrue);

      notifier.togglePause();
      expect(container.read(gameBridgeProvider).isPaused, isFalse);

      notifier.setGameOver();
      expect(container.read(gameBridgeProvider).isGameOver, isTrue);
    });
  });

  group('StageHud Widget', () {
    testWidgets('renders score and responds to actions', (tester) async {
      var exitCalled = false;
      var pauseCalled = false;
      var hideCalled = false;

      const session = GameSessionState(
        isReady: true,
        score: 420,
        rewardPoints: 50,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: StageHud(
              session: session,
              gameName: 'Galaxy Runner',
              onExit: () => exitCalled = true,
              onTogglePause: () => pauseCalled = true,
              onHide: () => hideCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('420'), findsOneWidget);

      // Tap exit button
      final exitFinder = find.byWidgetPredicate(
        (w) => w is AssetAppIcon && w.id == AppIconId.close,
      );
      expect(exitFinder, findsOneWidget);
      await tester.tap(exitFinder);
      expect(exitCalled, isTrue);

      // Tap pause button
      final pauseFinder = find.byWidgetPredicate(
        (w) => w is AssetAppIcon && w.id == AppIconId.pauseCircle,
      );
      expect(pauseFinder, findsOneWidget);
      await tester.tap(pauseFinder);
      expect(pauseCalled, isTrue);

      // Tap hide button
      final hideFinder = find.byWidgetPredicate(
        (w) => w is AssetAppIcon && w.id == AppIconId.visibilityOff,
      );
      expect(hideFinder, findsOneWidget);
      await tester.tap(hideFinder);
      expect(hideCalled, isTrue);
    });
  });
}
