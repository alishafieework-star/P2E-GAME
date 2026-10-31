import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

import 'package:mygame_p2e/shared/tour/tour_target.dart';

import 'cover_image.dart';

/// Three source geometries of the same row (E-106).
enum GameInfoLayout { featured, card, quest }

/// Presentational game identity row. Text arrives display-ready.
class GameInfoRow extends StatelessWidget {
  const GameInfoRow({
    super.key,
    required this.elementId,
    required this.layout,
    required this.icon,
    required this.name,
    required this.creator,
    required this.actionLabel,
    this.showMark = true,
    this.onAction,
    this.caption,
    this.captionAnchorId,
    this.runtimeLocator,
  }) : assert(name != '' && creator != '' && actionLabel != ''),
       assert(caption == null || caption != '');

  final String elementId, name, creator, actionLabel;
  final GameInfoLayout layout;
  final ImageProvider icon;
  final bool showMark;
  final VoidCallback? onAction;
  final String? caption;
  final String? captionAnchorId;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    final spec = switch (layout) {
      GameInfoLayout.featured => (
        icon: HomeTokens.infoFeaturedIcon,
        padding: HomeTokens.infoFeaturedPadding,
        gap: HomeTokens.infoFeaturedGap,
        textGap: HomeTokens.infoFeaturedTextGap,
        minHeight: HomeTokens.infoFeaturedHeight,
        nameStyle: HomeText.featuredName,
        nameRole: HomeRoles.featuredName,
        source: '18533:4252',
      ),
      GameInfoLayout.card => (
        icon: HomeTokens.infoCardIcon,
        padding: HomeTokens.infoCardPadding,
        gap: HomeTokens.infoCardGap,
        textGap: HomeTokens.infoCardTextGap,
        minHeight: 0.0,
        nameStyle: HomeText.cardName,
        nameRole: HomeRoles.cardName,
        source: '18457:12229',
      ),
      GameInfoLayout.quest => (
        icon: HomeTokens.infoQuestIcon,
        padding: HomeTokens.infoQuestPadding,
        gap: HomeTokens.infoQuestGap,
        textGap: HomeTokens.infoQuestTextGap,
        minHeight: HomeTokens.infoQuestHeight,
        nameStyle: HomeText.questName,
        nameRole: HomeRoles.questName,
        source: '18457:13272',
      ),
    };
    final supporting = HomeRoles.infoSupporting.resolve(context);
    final row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: spec.minHeight),
      child: Padding(
        padding: EdgeInsetsDirectional.all(spec.padding),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadiusDirectional.all(
                Radius.circular(HomeTokens.infoIconRadius),
              ),
              child: Image(
                image: resizedCover(context, icon, spec.icon),
                width: spec.icon,
                height: spec.icon,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) =>
                    SizedBox.square(dimension: spec.icon),
              ),
            ),
            SizedBox(width: spec.gap),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.start,
                    style: spec.nameStyle.copyWith(
                      color: spec.nameRole.resolve(context),
                    ),
                  ),
                  SizedBox(height: spec.textGap),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          creator,
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
                ],
              ),
            ),
            SizedBox(width: spec.gap),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  elementId: '$elementId.action',
                  label: actionLabel,
                  onPressed: onAction,
                  family: AppButtonFamily.hug,
                  size: AppButtonSize.small,
                  type: AppButtonType.tonal,
                  feedback: layout == GameInfoLayout.quest
                      ? AppButtonFeedback.standard
                      : AppButtonFeedback.playNow,
                ),
                if (caption != null) ...[
                  const SizedBox(height: HomeTokens.infoActionGap),
                  () {
                    final captionText = Text(
                      caption!,
                      style: HomeText.caption.copyWith(color: supporting),
                    );
                    final anchor = captionAnchorId;
                    if (anchor == null) return captionText;
                    return TourTarget(id: anchor, child: captionText);
                  }(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
    final child = layout == GameInfoLayout.featured
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: HomeRoles.featuredSurface.resolve(context),
              borderRadius: const BorderRadiusDirectional.all(
                Radius.circular(HomeTokens.infoFeaturedRadius),
              ),
              boxShadow: HomeShadows.featured.of(Theme.of(context).brightness),
            ),
            child: row,
          )
        : row;
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.info-row',
      structureRef: 'game.info-row',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: spec.source,
      componentSetId: null,
      rawSetName: 'Game Card',
      rawVariantName: layout.name,
      variants: {'layout': layout.name},
      resolved: {'source': spec.source},
      declared: const {},
      child: child,
    );
  }
}
