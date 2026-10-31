import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/widgets/cover_image.dart';
import 'package:p2e_design_system/design_system.dart';

/// Game Primary Data `18526:12003`. Presentational and reused by id (D-121).
class GamePrimaryData extends StatelessWidget {
  const GamePrimaryData({
    super.key,
    required this.elementId,
    required this.icon,
    required this.name,
    required this.creator,
    required this.accessLabel,
    required this.ratingValue,
    required this.reviewCount,
    required this.reviewUnit,
    required this.ratingCaption,
    required this.downloadsValue,
    required this.downloadsUnit,
    required this.downloadsCaption,
    required this.sizeValue,
    required this.sizeUnit,
    required this.downloadLabel,
    required this.bookmarkLabel,
    required this.statsLabel,
    required this.onDownload,
    required this.onBookmark,
    this.showMark = true,
    this.bookmarked = false,
    this.runtimeLocator,
  });

  final String elementId;
  final ImageProvider icon;
  final String name, creator, accessLabel;
  final String ratingValue, reviewCount, reviewUnit, ratingCaption;
  final String downloadsValue, downloadsUnit, downloadsCaption;
  final String sizeValue, sizeUnit;
  final String downloadLabel, bookmarkLabel, statsLabel;
  final bool showMark, bookmarked;
  final VoidCallback? onDownload, onBookmark;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.primary-data',
      structureRef: 'game.primary-data',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: '18526:12003',
      componentSetId: null,
      rawSetName: 'Game Primary Data',
      rawVariantName: 'downloadable',
      variants: {'bookmarked': bookmarked.toString()},
      resolved: const {'source': '18526:12003'},
      declared: const {},
      child: Padding(
        padding: const EdgeInsetsDirectional.all(GameDetailsTokens.pagePadding),
        child: Column(
          children: [
            _Headline(
              icon: icon,
              name: name,
              creator: creator,
              accessLabel: accessLabel,
              showMark: showMark,
            ),
            const SizedBox(height: GameDetailsTokens.primaryGap),
            _Stats(
              ratingValue: ratingValue,
              reviewCount: reviewCount,
              reviewUnit: reviewUnit,
              ratingCaption: ratingCaption,
              downloadsValue: downloadsValue,
              downloadsUnit: downloadsUnit,
              downloadsCaption: downloadsCaption,
              sizeValue: sizeValue,
              sizeUnit: sizeUnit,
              statsLabel: statsLabel,
            ),
            const SizedBox(height: GameDetailsTokens.primaryGap),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    elementId: '$elementId.download',
                    label: downloadLabel,
                    family: AppButtonFamily.fill,
                    size: AppButtonSize.medium,
                    type: AppButtonType.tonal,
                    onPressed: onDownload,
                  ),
                ),
                const SizedBox(width: GameDetailsTokens.ctaGap),
                AppButton(
                  elementId: '$elementId.bookmark',
                  label: bookmarkLabel,
                  family: AppButtonFamily.icon,
                  size: AppButtonSize.medium,
                  type: AppButtonType.tonal,
                  icon: AssetAppIcon(
                    bookmarked
                        ? AppIconId.bookmarkAdded
                        : AppIconId.bookmarkAdd,
                  ),
                  iconMode: ButtonIconMode.fill,
                  onPressed: onBookmark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({
    required this.icon,
    required this.name,
    required this.creator,
    required this.accessLabel,
    required this.showMark,
  });

  final ImageProvider icon;
  final String name, creator, accessLabel;
  final bool showMark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadiusDirectional.all(
            Radius.circular(GameDetailsTokens.iconRadius),
          ),
          child: SizedBox.square(
            dimension: GameDetailsTokens.icon,
            child: Image(
              image: resizedCover(context, icon, GameDetailsTokens.icon),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) =>
                  const SizedBox.square(dimension: GameDetailsTokens.icon),
            ),
          ),
        ),
        const SizedBox(width: GameDetailsTokens.headlineGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                textAlign: TextAlign.start,
                style: GameDetailsText.titleLarge.copyWith(
                  color: GameDetailsRoles.emphasis.resolve(context),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      creator,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GameDetailsText.labelMedium.copyWith(
                        color: GameDetailsRoles.body.resolve(context),
                      ),
                    ),
                  ),
                  if (showMark) ...[
                    const SizedBox(width: GameDetailsTokens.creatorGap),
                    Text(
                      '®',
                      style: GameDetailsText.labelSmall.copyWith(
                        color: GameDetailsRoles.body.resolve(context),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                accessLabel,
                style: GameDetailsText.mutedLabel.copyWith(
                  color: GameDetailsRoles.muted.resolve(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({
    required this.ratingValue,
    required this.reviewCount,
    required this.reviewUnit,
    required this.ratingCaption,
    required this.downloadsValue,
    required this.downloadsUnit,
    required this.downloadsCaption,
    required this.sizeValue,
    required this.sizeUnit,
    required this.statsLabel,
  });

  final String ratingValue, reviewCount, reviewUnit, ratingCaption;
  final String downloadsValue, downloadsUnit, downloadsCaption;
  final String sizeValue, sizeUnit, statsLabel;

  @override
  Widget build(BuildContext context) {
    final emphasis = GameDetailsRoles.emphasis.resolve(context);
    final body = GameDetailsRoles.body.resolve(context);
    final muted = GameDetailsRoles.variant.resolve(context);
    return Semantics(
      container: true,
      label: statsLabel,
      child: ExcludeSemantics(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ratingValue,
                        style: GameDetailsText.numberLarge.copyWith(
                          color: emphasis,
                        ),
                      ),
                      const SizedBox(width: GameDetailsTokens.creatorGap),
                      AssetAppIcon(
                        AppIconId.star,
                        style: AppIconStyle.fill,
                        size: GameDetailsTokens.star,
                        color: GameDetailsPaints.star.resolve(context),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        reviewCount,
                        style: GameDetailsText.mutedNumber.copyWith(
                          color: body,
                        ),
                      ),
                      Text(
                        reviewUnit,
                        style: GameDetailsText.labelSmall.copyWith(color: body),
                      ),
                      const SizedBox(width: GameDetailsTokens.creatorGap),
                      Text(
                        ratingCaption,
                        style: GameDetailsText.mutedLabel.copyWith(
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const _Divider(),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        downloadsValue,
                        style: GameDetailsText.numberLarge.copyWith(
                          color: emphasis,
                        ),
                      ),
                      const SizedBox(width: GameDetailsTokens.creatorGap),
                      Text(
                        downloadsUnit,
                        style: GameDetailsText.labelMedium.copyWith(
                          color: body,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    downloadsCaption,
                    style: GameDetailsText.mutedLabel.copyWith(color: muted),
                  ),
                ],
              ),
            ),
            const _Divider(),
            Expanded(
              child: Column(
                children: [
                  AssetAppIcon(
                    AppIconId.download,
                    style: AppIconStyle.fill,
                    size: GameDetailsTokens.star,
                    color: emphasis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        sizeValue,
                        style: GameDetailsText.mutedNumber.copyWith(
                          color: body,
                        ),
                      ),
                      const SizedBox(width: GameDetailsTokens.creatorGap),
                      Text(
                        sizeUnit,
                        style: GameDetailsText.labelSmall.copyWith(color: body),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: GameDetailsTokens.statsDivider,
      height: GameDetailsTokens.statsDividerLength,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: GameDetailsRoles.divider.resolve(context),
        ),
      ),
    );
  }
}
