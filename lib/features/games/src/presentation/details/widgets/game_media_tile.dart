import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/widgets/cover_image.dart';
import 'package:p2e_design_system/design_system.dart';

/// One media tile, 290×180. A video draws the centered play badge (E-113).
class GameMediaTile extends StatelessWidget {
  const GameMediaTile({
    super.key,
    required this.elementId,
    required this.image,
    required this.semanticLabel,
    this.video = false,
    this.onPressed,
    this.runtimeLocator,
  });

  final String elementId;
  final ImageProvider image;
  final String semanticLabel;
  final bool video;
  final VoidCallback? onPressed;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    final radius = const BorderRadiusDirectional.all(
      Radius.circular(GameDetailsTokens.mediaRadius),
    );
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.media-tile',
      structureRef: 'game.media-tile',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: video ? '18526:12049' : '18526:12053',
      componentSetId: null,
      rawSetName: 'Media',
      rawVariantName: video ? 'video' : 'image',
      variants: {'kind': video ? 'video' : 'image'},
      resolved: const {'source': '18526:13773'},
      declared: const {},
      child: Semantics(
        button: onPressed != null,
        label: semanticLabel,
        child: GestureDetector(
          onTap: onPressed,
          child: ClipRRect(
            borderRadius: radius,
            child: SizedBox(
              width: GameDetailsTokens.mediaWidth,
              height: GameDetailsTokens.mediaHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    image: resizedCover(
                      context,
                      image,
                      GameDetailsTokens.mediaWidth,
                    ),
                    width: GameDetailsTokens.mediaWidth,
                    height: GameDetailsTokens.mediaHeight,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                    excludeFromSemantics: true,
                  ),
                  if (video)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: GameDetailsPaints.playBadge.resolve(context),
                        borderRadius: const BorderRadiusDirectional.all(
                          Radius.circular(GameDetailsTokens.playBadgeRadius),
                        ),
                      ),
                      child: SizedBox(
                        width: GameDetailsTokens.playBadgeWidth,
                        height: GameDetailsTokens.playBadgeHeight,
                        child: Center(
                          child: AssetAppIcon(
                            AppIconId.playArrow,
                            style: AppIconStyle.fill,
                            size: GameDetailsTokens.playIcon,
                            color: GameDetailsRoles.playIcon.resolve(context),
                          ),
                        ),
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
