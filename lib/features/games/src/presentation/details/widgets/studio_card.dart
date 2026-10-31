import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/widgets/cover_image.dart';
import 'package:p2e_design_system/design_system.dart';

import 'game_surface.dart';

/// More-by-studio card: cover, simple game shelf, identity and action.
class StudioCard extends StatelessWidget {
  const StudioCard({
    super.key,
    required this.elementId,
    required this.cover,
    required this.games,
    required this.logo,
    required this.name,
    required this.tagline,
    required this.actionLabel,
    required this.onAction,
    this.showMark = true,
    this.runtimeLocator,
  });

  final String elementId, name, tagline, actionLabel;
  final ImageProvider cover, logo;
  final List<Widget> games;
  final bool showMark;
  final VoidCallback? onAction;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.studio-card',
      structureRef: 'game.studio-card',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: '18530:1911',
      componentSetId: null,
      rawSetName: 'Studio Card',
      rawVariantName: 'more-by',
      variants: const {},
      resolved: const {'source': '18526:12504'},
      declared: const {},
      child: GameSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: GameDetailsTokens.studioCoverHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: resizedCover(
                      context,
                      cover,
                      MediaQuery.sizeOf(context).width,
                    ),
                    fit: dark ? BoxFit.cover : BoxFit.fill,
                    filterQuality: FilterQuality.low,
                    excludeFromSemantics: true,
                  ),
                  ColoredBox(
                    color: GameDetailsPaints.studioScrim.resolve(context),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.all(
                      GameDetailsTokens.studioCoverPadding,
                    ),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: games.length,
                      separatorBuilder: (_, _) => const SizedBox(
                        width: GameDetailsTokens.studioShelfGap,
                      ),
                      itemBuilder: (_, index) => games[index],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                GameDetailsTokens.cardPadding,
                GameDetailsTokens.cardPadding,
                GameDetailsTokens.cardPadding,
                0,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadiusDirectional.all(
                      Radius.circular(GameDetailsTokens.studioLogoRadius),
                    ),
                    child: ColoredBox(
                      color: GameDetailsRoles.studioLogo.resolve(context),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(
                          GameDetailsTokens.studioLogoPadding,
                        ),
                        child: Image(
                          image: resizedCover(
                            context,
                            logo,
                            GameDetailsTokens.studioLogo,
                          ),
                          width:
                              GameDetailsTokens.studioLogo -
                              GameDetailsTokens.studioLogoPadding * 2,
                          height:
                              GameDetailsTokens.studioLogo -
                              GameDetailsTokens.studioLogoPadding * 2,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.low,
                          excludeFromSemantics: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: GameDetailsTokens.studioInfoGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GameDetailsText.titleSmall.copyWith(
                                  color: GameDetailsRoles.emphasis.resolve(
                                    context,
                                  ),
                                ),
                              ),
                            ),
                            if (showMark)
                              Text(
                                '®',
                                style: GameDetailsText.titleSmall.copyWith(
                                  color: GameDetailsRoles.emphasis.resolve(
                                    context,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          tagline,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GameDetailsText.labelSmall.copyWith(
                            color: GameDetailsRoles.body.resolve(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(
                GameDetailsTokens.cardPadding,
              ),
              child: AppButton(
                elementId: '$elementId.action',
                label: actionLabel,
                family: AppButtonFamily.fill,
                size: AppButtonSize.medium,
                type: AppButtonType.tonal,
                backgroundColor: GameDetailsRoles.studioAction.resolve(context),
                onPressed: onAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
