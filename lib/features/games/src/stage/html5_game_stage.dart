import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:p2e_design_system/design_system.dart';

import 'game_bridge_controller.dart';
import 'stage_hud.dart';

/// Fullscreen HTML5 Game Stage.
///
/// Runs HTML5 web games inside an isolated, hardware-accelerated WebView.
/// Provides a bidirectional bridge for scoring, rewards, and audio control.
class Html5GameStage extends ConsumerStatefulWidget {
  const Html5GameStage({
    super.key,
    required this.gameId,
    required this.url,
    required this.gameName,
  });

  final String gameId;
  final Uri url;
  final String gameName;

  /// Pushes the game stage as a fullscreen modal route.
  static Future<void> open(
    BuildContext context, {
    required String gameId,
    required Uri url,
    required String gameName,
  }) {
    final container = ProviderScope.containerOf(context);
    return _findAppNavigator(context).push(
      PageRouteBuilder<void>(
        opaque: true,
        pageBuilder: (routeContext, _, _) => UncontrolledProviderScope(
          container: container,
          child: UiIdentityScope(
            routeName: 'game.stage',
            instanceKey: 'game.stage:$gameId',
            child: Html5GameStage(gameId: gameId, url: url, gameName: gameName),
          ),
        ),
        transitionsBuilder: (context, animation, _, child) {
          if (MediaQuery.disableAnimationsOf(context)) return child;
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Finds the highest [NavigatorState] within the application's [ProviderScope],
  /// preventing modal routes from escaping the simulated device frame into
  /// host tools like the Inspector.
  static NavigatorState _findAppNavigator(BuildContext context) {
    NavigatorState? appNavigator;
    context.visitAncestorElements((element) {
      if (element.widget is ProviderScope) {
        return false;
      }
      if (element is StatefulElement && element.state is NavigatorState) {
        appNavigator = element.state as NavigatorState;
      }
      return true;
    });
    return appNavigator ?? Navigator.of(context);
  }

  @override
  ConsumerState<Html5GameStage> createState() => _Html5GameStageState();
}

class _Html5GameStageState extends ConsumerState<Html5GameStage> {
  InAppWebViewController? _controller;
  bool _hudVisible = true;

  @override
  void initState() {
    super.initState();
    // Request fullscreen immersion and lock portrait orientation during gameplay.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Restore system chrome and orientation when leaving the stage.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _setupBridgeHandlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: 'onGameReady',
      callback: (_) {
        ref.read(gameBridgeProvider.notifier).markReady();
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onScore',
      callback: (args) {
        if (args.isNotEmpty && args[0] is num) {
          final score = (args[0] as num).toInt();
          ref.read(gameBridgeProvider.notifier).updateScore(score);
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onReward',
      callback: (args) {
        if (args.isNotEmpty && args[0] is num) {
          final pts = (args[0] as num).toInt();
          ref.read(gameBridgeProvider.notifier).addReward(pts);
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onGameOver',
      callback: (_) {
        ref.read(gameBridgeProvider.notifier).setGameOver();
      },
    );
  }

  void _togglePause() {
    final notifier = ref.read(gameBridgeProvider.notifier);
    final isPaused = ref.read(gameBridgeProvider).isPaused;
    if (isPaused) {
      _controller?.evaluateJavascript(
        source: 'window.dispatchEvent(new CustomEvent("p2e:resume"));',
      );
    } else {
      _controller?.evaluateJavascript(
        source: 'window.dispatchEvent(new CustomEvent("p2e:pause"));',
      );
    }
    notifier.togglePause();
  }

  void _onExit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(gameBridgeProvider);
    final pageBg = GameDetailsRoles.page.resolve(context);
    final emphasisColor = GameDetailsRoles.emphasis.resolve(context);

    return Scaffold(
      backgroundColor: pageBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── WebView ────────────────────────────────────────────────────────
          InAppWebView(
            initialFile: widget.url.scheme == 'asset' ? widget.url.path : null,
            initialUrlRequest: widget.url.scheme != 'asset'
                ? URLRequest(url: WebUri.uri(widget.url))
                : null,
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              transparentBackground: true,
              useHybridComposition: true,
              supportZoom: false,
              disableContextMenu: true,
              hardwareAcceleration: true,
              domStorageEnabled: true,
              databaseEnabled: true,
              mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
              javaScriptCanOpenWindowsAutomatically: false,
            ),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              return NavigationActionPolicy.ALLOW;
            },
            onWebViewCreated: (controller) {
              _controller = controller;
              _setupBridgeHandlers(controller);
            },
            onLoadStop: (controller, url) {
              ref.read(gameBridgeProvider.notifier).markReady();
              // Inject CSS reset to prevent layout jitter, zooming or text selection
              controller.evaluateJavascript(
                source: '''
                (function() {
                  var style = document.createElement('style');
                  style.textContent = [
                    'html, body {',
                    '  margin: 0; padding: 0; overflow: hidden;',
                    '  width: 100%; height: 100%;',
                    '  touch-action: none;',
                    '  -webkit-touch-callout: none;',
                    '  -webkit-user-select: none;',
                    '  user-select: none;',
                    '}'
                  ].join('\\n');
                  document.head.appendChild(style);
                })();
              ''',
              );
            },
            onReceivedError: (controller, request, error) {
              if (request.isForMainFrame ?? false) {
                ref
                    .read(gameBridgeProvider.notifier)
                    .setError(error.description);
              }
            },
            onConsoleMessage: (controller, consoleMessage) {
              debugPrint(
                'GameJS: [${consoleMessage.messageLevel}] ${consoleMessage.message}',
              );
            },
          ),

          // ── HUD Overlay ────────────────────────────────────────────────────
          if (_hudVisible)
            StageHud(
              session: session,
              gameName: widget.gameName,
              onExit: _onExit,
              onTogglePause: _togglePause,
              onHide: () => setState(() => _hudVisible = false),
            ),

          // ── Reveal HUD Tab (shown when HUD is hidden) ──────────────────────
          if (!_hudVisible)
            SafeArea(
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(
                    GameDetailsTokens.pagePadding,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _hudVisible = true),
                    behavior: HitTestBehavior.opaque,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: GameDetailsRoles.card.resolve(context),
                        shape: BoxShape.circle,
                        border: GameDetailsStrokes.card.resolve(context),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(
                          GameDetailsTokens.statsGap,
                        ),
                        child: AssetAppIcon(
                          AppIconId.visibility,
                          size: GameDetailsTokens.star,
                          color: emphasisColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ── Loading Skeleton / Overlay ────────────────────────────────────
          if (!session.isReady && session.errorMessage == null)
            DecoratedBox(
              decoration: BoxDecoration(color: pageBg),
              child: Center(
                child: SizedBox.square(
                  dimension: GameDetailsTokens.playIcon,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: emphasisColor,
                  ),
                ),
              ),
            ),

          // ── Error Fallback View ───────────────────────────────────────────
          if (session.errorMessage != null)
            DecoratedBox(
              decoration: BoxDecoration(color: pageBg),
              child: Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(
                    GameDetailsTokens.pagePadding,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Unable to load game',
                        style: GameDetailsText.numberLarge.copyWith(
                          color: emphasisColor,
                        ),
                      ),
                      const SizedBox(height: GameDetailsTokens.statsGap),
                      Text(
                        session.errorMessage!,
                        style: GameDetailsText.labelMedium.copyWith(
                          color: GameDetailsRoles.body.resolve(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: GameDetailsTokens.primaryGap),
                      AppButton(
                        elementId: 'stage.retry',
                        label: 'Retry',
                        family: AppButtonFamily.fill,
                        size: AppButtonSize.medium,
                        type: AppButtonType.tonal,
                        onPressed: () {
                          ref.read(gameBridgeProvider.notifier).reset();
                          _controller?.reload();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
