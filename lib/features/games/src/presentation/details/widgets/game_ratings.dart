import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p2e_design_system/design_system.dart';

import 'game_surface.dart';

/// Five stars. A fractional part of at least one half draws [AppIconId.starHalf].
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    required this.semanticLabel,
    this.overlap = false,
  });

  final double rating;
  final String semanticLabel;
  final bool overlap;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < 5; index++)
              Transform.translate(
                // PHYSICAL: the comment row's source gap is -2.
                offset: Offset(
                  overlap
                      ? (direction == TextDirection.rtl ? 1 : -1) *
                            GameDetailsTokens.commentStarOverlap *
                            index
                      : 0,
                  0,
                ),
                child: AssetAppIcon(
                  _icon(index),
                  style: AppIconStyle.fill,
                  size: GameDetailsTokens.star,
                  color: _filled(index)
                      ? GameDetailsPaints.star.resolve(context)
                      : GameDetailsRoles.muted.resolve(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _filled(int index) => rating >= index + 0.5;

  AppIconId _icon(int index) {
    if (rating >= index + 1) return AppIconId.star;
    if (rating >= index + 0.5) return AppIconId.starHalf;
    return AppIconId.star;
  }
}

class RatingSummary extends StatelessWidget {
  const RatingSummary({
    super.key,
    required this.elementId,
    required this.average,
    required this.rating,
    required this.count,
    required this.countUnit,
    required this.caption,
    required this.semanticLabel,
    required this.labels,
    required this.fractions,
    this.runtimeLocator,
  });

  final String elementId, average, count, countUnit, caption, semanticLabel;
  final double rating;
  final List<String> labels;
  final List<double> fractions;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.rating-summary',
      structureRef: 'game.rating-summary',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: '18526:12106',
      componentSetId: null,
      rawSetName: 'Ratings',
      rawVariantName: 'average',
      variants: const {},
      resolved: const {'source': '18526:12105'},
      declared: const {},
      child: Semantics(
        label: semanticLabel,
        child: ExcludeSemantics(
          child: Row(
            children: [
              GameSurface(
                padding: const EdgeInsetsDirectional.all(
                  GameDetailsTokens.ratingPadding,
                ),
                child: Column(
                  children: [
                    Text(
                      average,
                      style: GameDetailsText.displayRating.copyWith(
                        color: GameDetailsRoles.emphasis.resolve(context),
                      ),
                    ),
                    StarRating(rating: rating, semanticLabel: semanticLabel),
                    const SizedBox(height: GameDetailsTokens.histogramRowGap),
                    Text(
                      '$count$countUnit $caption',
                      style: GameDetailsText.mutedLabel.copyWith(
                        color: GameDetailsRoles.variant.resolve(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: GameDetailsTokens.ratingGap),
              Expanded(
                child: GameSurface(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: GameDetailsTokens.ratingPadding,
                    vertical: GameDetailsTokens.cardGap,
                  ),
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < fractions.length;
                        index++
                      ) ...[
                        if (index > 0)
                          const SizedBox(
                            height: GameDetailsTokens.histogramRowGap,
                          ),
                        _HistogramRow(
                          label: labels[index],
                          fraction: fractions[index],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistogramRow extends StatelessWidget {
  const _HistogramRow({required this.label, required this.fraction});
  final String label;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: GameDetailsTokens.histogramGap,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GameDetailsText.histogram.copyWith(
              color: GameDetailsRoles.emphasis.resolve(context),
            ),
          ),
        ),
        const SizedBox(width: GameDetailsTokens.histogramGap),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadiusDirectional.all(
              Radius.circular(GameDetailsTokens.histogramBarRadius),
            ),
            child: SizedBox(
              height: GameDetailsTokens.histogramBarHeight,
              child: Stack(
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(),
                    child: SizedBox.expand(),
                  ),
                  ColoredBox(
                    color: GameDetailsRoles.histogramTrack.resolve(context),
                    child: const SizedBox.expand(),
                  ),
                  FractionallySizedBox(
                    widthFactor: fraction.clamp(0, 1),
                    child: ColoredBox(
                      color: GameDetailsRoles.histogramFill.resolve(context),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AiSummaryCard extends StatelessWidget {
  const AiSummaryCard({
    super.key,
    required this.elementId,
    required this.title,
    required this.summary,
    required this.likeLabel,
    required this.dislikeLabel,
    required this.moreLabel,
    this.runtimeLocator,
  });

  final String elementId, title, summary, likeLabel, dislikeLabel, moreLabel;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    final color = GameDetailsRoles.body.resolve(context);
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.ai-summary',
      structureRef: 'game.ai-summary',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: '18526:12149',
      componentSetId: null,
      rawSetName: 'Summarized by AI',
      rawVariantName: 'summary',
      variants: const {'actions': 'unavailable'},
      resolved: const {'source': '18526:12149'},
      declared: const {},
      child: GameSurface(
        padding: const EdgeInsetsDirectional.all(GameDetailsTokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // D-067: feature-owned AI-summary artwork; the Figma icon
                // registry has no AI-spark twin, so AppIconId cannot serve it.
                SvgPicture.asset(
                  'assets/icons/platforms/ai_spark.svg',
                  width: GameDetailsTokens.summaryIcon,
                  height: GameDetailsTokens.summaryIcon,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  excludeFromSemantics: true,
                ),
                const SizedBox(width: GameDetailsTokens.histogramRowGap),
                Expanded(
                  child: Text(
                    title,
                    style: GameDetailsText.labelSmall.copyWith(color: color),
                  ),
                ),
                _QuietIcon(icon: AppIconId.thumbUp, label: likeLabel),
                const SizedBox(width: GameDetailsTokens.voteGap),
                _QuietIcon(icon: AppIconId.thumbDown, label: dislikeLabel),
                const SizedBox(width: GameDetailsTokens.voteGap),
                _QuietIcon(icon: AppIconId.moreVertical, label: moreLabel),
              ],
            ),
            const SizedBox(height: GameDetailsTokens.summaryGap),
            Text(summary, style: GameDetailsText.body.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    super.key,
    required this.elementId,
    required this.initial,
    required this.author,
    required this.rating,
    required this.ratingLabel,
    required this.date,
    required this.text,
    required this.moreLabel,
    required this.colorIndex,
    this.avatar,
    this.runtimeLocator,
  });

  final String elementId, initial, author, ratingLabel, date, text, moreLabel;
  final double rating;
  final int colorIndex;
  final ImageProvider? avatar;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    final plate = switch (colorIndex % 4) {
      0 => GameDetailsRoles.avatarPlate,
      1 => GameDetailsRoles.avatarPlateTeal,
      2 => GameDetailsRoles.avatarPlatePink,
      _ => GameDetailsRoles.avatarPlateEmerald,
    };
    final ink = switch (colorIndex % 4) {
      0 => GameDetailsRoles.avatarInk,
      1 => GameDetailsRoles.avatarInkTeal,
      2 => GameDetailsRoles.avatarInkPink,
      _ => GameDetailsRoles.avatarInkEmerald,
    };
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.review',
      structureRef: 'game.review',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: '18526:11913',
      componentSetId: '18526:11914',
      rawSetName: 'Comment',
      rawVariantName: 'Theme=Dark',
      variants: const {},
      resolved: const {'source': '18526:11914'},
      declared: const {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: SizedBox.square(
                  dimension: GameDetailsTokens.commentAvatar,
                  child: avatar == null
                      ? ColoredBox(
                          color: plate.resolve(context),
                          child: Center(
                            child: Text(
                              initial,
                              style: GameDetailsText.labelMedium.copyWith(
                                color: ink.resolve(context),
                              ),
                            ),
                          ),
                        )
                      : Image(image: avatar!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: GameDetailsTokens.commentGap),
              Expanded(
                child: Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GameDetailsText.labelMedium.copyWith(
                    color: GameDetailsRoles.emphasis.resolve(context),
                  ),
                ),
              ),
              _QuietIcon(icon: AppIconId.moreVertical, label: moreLabel),
            ],
          ),
          const SizedBox(height: GameDetailsTokens.cardGap),
          Row(
            children: [
              StarRating(
                rating: rating,
                semanticLabel: ratingLabel,
                overlap: true,
              ),
              const SizedBox(width: GameDetailsTokens.commentGap),
              Text(
                date,
                style: GameDetailsText.mutedNumber.copyWith(
                  color: GameDetailsRoles.variant.resolve(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: GameDetailsTokens.cardGap),
          Text(
            text,
            style: GameDetailsText.body.copyWith(
              color: GameDetailsRoles.body.resolve(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Source-painted icon that is honestly unavailable (D-121).
class _QuietIcon extends StatelessWidget {
  const _QuietIcon({required this.icon, required this.label});
  final AppIconId icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: false,
      label: label,
      child: ExcludeSemantics(
        child: AssetAppIcon(
          icon,
          style: AppIconStyle.outline,
          size: GameDetailsTokens.star,
          color: GameDetailsRoles.body.resolve(context),
        ),
      ),
    );
  }
}
