import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

import 'game_bridge_controller.dart';

/// Floating in-game HUD for [Html5GameStage].
///
/// Fully adheres to P2E Design System tokens:
/// - Directional layout only
/// - Colors from [GameDetailsRoles] and [GameDetailsTokens]
/// - Icons from [AppIconId]
class StageHud extends StatelessWidget {
  const StageHud({
    super.key,
    required this.session,
    required this.gameName,
    required this.onExit,
    required this.onTogglePause,
    required this.onHide,
  });

  final GameSessionState session;
  final String gameName;
  final VoidCallback onExit;
  final VoidCallback onTogglePause;
  final VoidCallback onHide;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = GameDetailsRoles.card.resolve(context);
    final emphasisColor = GameDetailsRoles.emphasis.resolve(context);
    final bodyColor = GameDetailsRoles.body.resolve(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(GameDetailsTokens.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // Exit button
                _CircleIconButton(
                  icon: AppIconId.close,
                  backgroundColor: surfaceColor,
                  iconColor: emphasisColor,
                  onTap: onExit,
                ),
                const SizedBox(width: GameDetailsTokens.ctaGap),

                // Pause / Resume button
                _CircleIconButton(
                  icon: session.isPaused
                      ? AppIconId.playCircle
                      : AppIconId.pauseCircle,
                  backgroundColor: surfaceColor,
                  iconColor: emphasisColor,
                  onTap: onTogglePause,
                ),

                const Spacer(),

                // Score ticker pill
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: const BorderRadiusDirectional.all(
                      Radius.circular(GameDetailsTokens.cardRadius),
                    ),
                    border: GameDetailsStrokes.card.resolve(context),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: GameDetailsTokens.cardPadding,
                      vertical: GameDetailsTokens.histogramRowGap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AssetAppIcon(
                          AppIconId.trophy,
                          size: GameDetailsTokens.star,
                          color: emphasisColor,
                        ),
                        const SizedBox(width: GameDetailsTokens.creatorGap),
                        Text(
                          '${session.score}',
                          style: GameDetailsText.numberLarge.copyWith(
                            color: emphasisColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: GameDetailsTokens.ctaGap),

                // Hide HUD button
                _CircleIconButton(
                  icon: AppIconId.visibilityOff,
                  backgroundColor: surfaceColor,
                  iconColor: bodyColor,
                  onTap: onHide,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  final AppIconId icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: GameDetailsStrokes.card.resolve(context),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(GameDetailsTokens.statsGap),
          child: AssetAppIcon(
            icon,
            size: GameDetailsTokens.star,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
