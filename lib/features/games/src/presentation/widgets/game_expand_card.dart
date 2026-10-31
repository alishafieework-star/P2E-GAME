import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/widgets/cover_image.dart';
import 'package:mygame_p2e/shared/widgets/game_info_row.dart';
import 'package:mygame_p2e/shared/widgets/reward_badge.dart';
import 'package:p2e_design_system/design_system.dart';

/// Presentational Games Expand Card `18457:14486`. It fills the width it is
/// given (one paged shelf page). The source rating row is hidden.
class GameExpandCard extends StatelessWidget {
  const GameExpandCard({
    super.key,
    required this.elementId,
    required this.banner,
    required this.icon,
    required this.name,
    required this.creator,
    required this.actionLabel,
    required this.rewardAmount,
    required this.rewardUnit,
    required this.semanticLabel,
    this.caption,
    this.showMark = true,
    this.onPressed,
    this.onAction,
    this.runtimeLocator,
  }) : assert(semanticLabel != '');

  final String elementId, name, creator, actionLabel, rewardAmount, rewardUnit;
  final String semanticLabel;
  final ImageProvider banner, icon;
  final String? caption;
  final bool showMark;
  final VoidCallback? onPressed, onAction;
  final UiRuntimeLocator? runtimeLocator;

  static const _radius = BorderRadiusDirectional.all(
    Radius.circular(HomeTokens.expandRadius),
  );

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.expand-card',
      structureRef: 'game.expand-card',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: dark ? '18457:12229' : '18457:14487',
      componentSetId: '18457:14486',
      rawSetName: 'Games Expand Card',
      rawVariantName: dark ? 'Theme=Dark' : 'Theme=Light',
      variants: const {},
      resolved: const {},
      declared: {'interactive': onPressed != null},
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: HomeStrokes.expand.resolve(context),
          borderRadius: _radius,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: HomeRoles.expandSurface.resolve(context),
            borderRadius: _radius,
          ),
          child: ClipRRect(
            borderRadius: _radius,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  container: true,
                  button: onPressed != null,
                  label: semanticLabel,
                  onTap: onPressed,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onPressed,
                    child: SizedBox(
                      height: HomeTokens.expandBannerHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _HoverCover(
                            enabled: onPressed != null,
                            child: Image(
                              image: resizedCover(
                                context,
                                banner,
                                MediaQuery.sizeOf(context).width,
                              ),
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.low,
                              excludeFromSemantics: true,
                              errorBuilder: (_, _, _) =>
                                  const SizedBox.shrink(),
                            ),
                          ),
                          PositionedDirectional(
                            top: HomeTokens.rewardOverlayInsetTop,
                            end: HomeTokens.rewardOverlayInsetEnd,
                            child: RewardBadge(
                              elementId: '$elementId.reward',
                              appearance: RewardBadgeAppearance.overlay,
                              amount: rewardAmount,
                              unit: rewardUnit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GameInfoRow(
                  elementId: '$elementId.info',
                  layout: GameInfoLayout.card,
                  icon: icon,
                  name: name,
                  creator: creator,
                  actionLabel: actionLabel,
                  caption: caption,
                  showMark: showMark,
                  onAction: onAction,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverCover extends StatefulWidget {
  const _HoverCover({required this.enabled, required this.child});
  final bool enabled;
  final Widget child;
  @override
  State<_HoverCover> createState() => _HoverCoverState();
}

class _HoverCoverState extends State<_HoverCover> {
  bool hovering = false;

  void setHover(PointerEvent event, bool next) {
    final kind = event.kind;
    if (kind != PointerDeviceKind.mouse && kind != PointerDeviceKind.stylus) {
      return;
    }
    if (hovering == next) return;
    setState(() => hovering = next);
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context) || !widget.enabled;
    return MouseRegion(
      onEnter: (event) => setHover(event, true),
      onExit: (event) => setHover(event, false),
      child: AnimatedScale(
        scale: !reduced && hovering ? ButtonMotion.expandImageHoverScale : 1,
        duration: reduced ? Duration.zero : ButtonMotion.expandHoverDuration,
        curve: ButtonMotion.curve,
        child: widget.child,
      ),
    );
  }
}
