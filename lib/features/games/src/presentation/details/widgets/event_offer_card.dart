import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/widgets/cover_image.dart';
import 'package:mygame_p2e/shared/widgets/reward_badge.dart';
import 'package:p2e_design_system/design_system.dart';

import 'game_surface.dart';

/// Event and Offer Card set `18526:11872`. Reward text is display-ready (E-115).
class EventOfferCard extends StatelessWidget {
  const EventOfferCard({
    super.key,
    required this.elementId,
    required this.image,
    required this.title,
    required this.description,
    required this.rewardAmount,
    required this.rewardUnit,
    required this.semanticLabel,
    this.onPressed,
    this.runtimeLocator,
  });

  final String elementId,
      title,
      description,
      rewardAmount,
      rewardUnit,
      semanticLabel;
  final ImageProvider image;
  final VoidCallback? onPressed;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    final radius = const BorderRadiusDirectional.all(
      Radius.circular(GameDetailsTokens.cardRadius),
    );
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.event-offer-card',
      structureRef: 'game.event-offer-card',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: '18526:11871',
      componentSetId: '18526:11872',
      rawSetName: 'Event and Offer Card',
      rawVariantName: 'Theme=Default',
      variants: const {},
      resolved: const {'source': '18526:11872'},
      declared: const {},
      child: Semantics(
        button: onPressed != null,
        label: semanticLabel,
        child: GestureDetector(
          onTap: onPressed,
          child: GameSurface(
            padding: EdgeInsetsDirectional.zero,
            child: ClipRRect(
              borderRadius: radius,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: GameDetailsTokens.eventBannerHeight,
                    child: Stack(
                      children: [
                        Image(
                          image: resizedCover(
                            context,
                            image,
                            MediaQuery.sizeOf(context).width,
                          ),
                          width: double.infinity,
                          height: GameDetailsTokens.eventBannerHeight,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                          excludeFromSemantics: true,
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
                  Padding(
                    padding: const EdgeInsetsDirectional.all(
                      GameDetailsTokens.eventBodyPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GameDetailsText.titleSmall.copyWith(
                            color: GameDetailsRoles.emphasis.resolve(context),
                          ),
                        ),
                        const SizedBox(height: GameDetailsTokens.eventBodyGap),
                        Text(
                          description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GameDetailsText.body.copyWith(
                            color: GameDetailsRoles.body.resolve(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
