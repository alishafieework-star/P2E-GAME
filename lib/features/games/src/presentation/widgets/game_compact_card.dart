import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/widgets/cover_image.dart';
import 'package:mygame_p2e/shared/widgets/rating_badge.dart';
import 'package:mygame_p2e/shared/widgets/reward_badge.dart';
import 'package:p2e_design_system/design_system.dart';

/// Game Compact Card `18457:14096`: Detailed shows the creator; simple does not.
/// The source Theme axis is not a parameter (E-100).
enum GameCompactCardAppearance { detailed, simple }

/// Presentational compact game card. Every string arrives display-ready.
class GameCompactCard extends StatelessWidget {
  const GameCompactCard({
    super.key,
    required this.elementId,
    required this.appearance,
    required this.image,
    required this.name,
    required this.rating,
    required this.ratingLabel,
    required this.rewardAmount,
    required this.rewardUnit,
    this.creator,
    this.showMark = true,
    this.onPressed,
    this.runtimeLocator,
  }) : assert(name != '' && rating != ''),
       assert(
         (appearance == GameCompactCardAppearance.detailed) ==
             (creator != null && creator != ''),
         'Only the Detailed appearance shows a creator.',
       );

  final String elementId, name, rating, ratingLabel, rewardAmount, rewardUnit;
  final GameCompactCardAppearance appearance;
  final ImageProvider image;
  final String? creator;
  final bool showMark;
  final VoidCallback? onPressed;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    final detailed = appearance == GameCompactCardAppearance.detailed;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final variantId = switch ((detailed, dark)) {
      (true, true) => '18451:10177',
      (true, false) => '18457:14097',
      (false, true) => '18530:2907',
      (false, false) => '18530:2929',
    };
    final supporting = HomeRoles.infoSupporting.resolve(context);
    final badge = RatingBadge(
      value: rating,
      semanticLabel: ratingLabel,
      appearance: detailed
          ? RatingBadgeAppearance.detailed
          : RatingBadgeAppearance.simple,
    );
    final card = SizedBox(
      width: HomeTokens.compactWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: HomeTokens.compactWidth,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadiusDirectional.all(
                    Radius.circular(HomeTokens.compactImageRadius),
                  ),
                  child: Image(
                    image: resizedCover(
                      context,
                      image,
                      HomeTokens.compactWidth,
                    ),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                    excludeFromSemantics: true,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
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
          const SizedBox(height: HomeTokens.compactGap),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: HomeTokens.compactInfoPadHorizontal,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // E-111: one line each; screen readers get the full text.
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: HomeText.cardName.copyWith(
                    color: HomeRoles.cardName.resolve(context),
                  ),
                ),
                if (detailed) ...[
                  const SizedBox(height: HomeTokens.compactDetailedInfoGap),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          creator!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: HomeText.creator.copyWith(color: supporting),
                        ),
                      ),
                      if (showMark) ...[
                        const SizedBox(width: HomeTokens.infoMarkGap),
                        Text(
                          '®',
                          style: HomeText.creator.copyWith(color: supporting),
                        ),
                      ],
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: HomeTokens.ratingInsetVertical,
                    ),
                    child: badge,
                  ),
                ] else ...[
                  const SizedBox(height: HomeTokens.compactSimpleInfoGap),
                  badge,
                ],
              ],
            ),
          ),
        ],
      ),
    );
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.compact-card',
      structureRef: 'game.compact-card',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: variantId,
      componentSetId: '18457:14096',
      rawSetName: 'Game Compact Card',
      rawVariantName: appearance.name,
      variants: {'appearance': appearance.name},
      resolved: const {},
      declared: {'interactive': onPressed != null},
      // One node: name, creator, rating and reward are read together.
      child: MergeSemantics(
        child: Semantics(
          button: onPressed != null,
          onTap: onPressed,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed,
            child: card,
          ),
        ),
      ),
    );
  }
}
