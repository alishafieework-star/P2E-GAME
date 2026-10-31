import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mygame_p2e/shared/widgets/player_avatar.dart';
import 'package:p2e_design_system/design_system.dart';

import 'onboarding_timing.dart';

/// One leaderboard person from the HTML (`LB_P`).
class LbPerson {
  const LbPerson({
    required this.letter,
    required this.theme,
    required this.skeleton,
    required this.points,
  });

  final String letter;
  final int theme;
  final double skeleton;
  final int points;
}

const lbPeople = <String, LbPerson>{
  'Z': LbPerson(
    letter: 'Z',
    theme: 3,
    skeleton: HtmlJourneyTokens.obSkelZ,
    points: 4263,
  ),
  'M': LbPerson(
    letter: 'M',
    theme: 4,
    skeleton: HtmlJourneyTokens.obSkelM,
    points: 3856,
  ),
  'N': LbPerson(
    letter: 'N',
    theme: 1,
    skeleton: HtmlJourneyTokens.obSkelN,
    points: 3567,
  ),
  'H': LbPerson(
    letter: 'H',
    theme: 4,
    skeleton: HtmlJourneyTokens.obSkelH,
    points: 2412,
  ),
  'F': LbPerson(
    letter: 'F',
    theme: 2,
    skeleton: HtmlJourneyTokens.obSkelF,
    points: 2166,
  ),
  'A': LbPerson(
    letter: 'A',
    theme: 0,
    skeleton: HtmlJourneyTokens.obSkelA,
    points: HtmlJourneyTokens.climbScoreEnd,
  ),
};

/// `.lbchip`: crown plate, points and the unit.
class PointsTag extends StatelessWidget {
  const PointsTag({
    super.key,
    required this.points,
    required this.unit,
    this.valueKey,
  });

  final String points;
  final String unit;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: roles.surfaceContainerBase,
        borderRadius: BorderRadius.circular(HtmlJourneyTokens.obChipRadius),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: HtmlJourneyTokens.obChipPadStart,
          end: HtmlJourneyTokens.obChipPadEnd,
          top: HtmlJourneyTokens.obChipPadV,
          bottom: HtmlJourneyTokens.obChipPadV,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: HomeRoles.totalPlate.resolve(context),
                borderRadius: BorderRadius.circular(
                  HtmlJourneyTokens.obChipRadius,
                ),
              ),
              child: SizedBox.square(
                dimension: HtmlJourneyTokens.obChipIcon,
                child: Center(
                  child: AssetAppIcon(
                    AppIconId.crown,
                    style: AppIconStyle.fill,
                    size: HtmlJourneyTokens.obChipCrown,
                    color: HomeRoles.totalArtwork.resolve(context),
                  ),
                ),
              ),
            ),
            const SizedBox(width: HtmlJourneyTokens.obChipCrownGap),
            Text(
              points,
              key: valueKey,
              textDirection: TextDirection.ltr,
              style:
                  OnboardingType.semibold(
                    HtmlJourneyTokens.obChipFont,
                    HtmlJourneyTokens.obChipLine,
                  ).copyWith(
                    color: roles.onSurfaceEmphasis,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
            ),
            const SizedBox(width: HtmlJourneyTokens.obChipGap),
            Text(
              unit,
              style: OnboardingType.regular(
                HtmlJourneyTokens.obChipFont,
                HtmlJourneyTokens.obChipLine,
                spacing: -0.04,
              ).copyWith(color: roles.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// A pair of laurel leaves tinted with [color].
class _Leaf extends StatelessWidget {
  const _Leaf({
    required this.asset,
    required this.width,
    required this.height,
    required this.color,
    this.mirror = false,
  });

  final String asset;
  final double width;
  final double height;
  final Color color;
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final leaf = SvgPicture.asset(
      asset,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      excludeFromSemantics: true,
    );
    return mirror
        // PHYSICAL: the laurel is drawn as a mirrored pair in every direction.
        ? Transform.flip(flipX: true, child: leaf)
        : leaf;
  }
}

/// `.laurel` around a podium avatar.
class PodiumLaurel extends StatelessWidget {
  const PodiumLaurel({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    const asset = 'assets/images/onboarding/laurel.svg';
    return SizedBox(
      width: HtmlJourneyTokens.obLaurelWidth,
      height: HtmlJourneyTokens.obLaurelLeafH,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: [
          _Leaf(
            asset: asset,
            width: HtmlJourneyTokens.obLaurelLeafW,
            height: HtmlJourneyTokens.obLaurelLeafH,
            color: color,
          ),
          const SizedBox(width: HtmlJourneyTokens.obLaurelGap),
          _Leaf(
            asset: asset,
            width: HtmlJourneyTokens.obLaurelLeafW,
            height: HtmlJourneyTokens.obLaurelLeafH,
            color: color,
            mirror: true,
          ),
        ],
      ),
    );
  }
}

/// `rankLaurel`: the rank number between two small leaves.
class RankLaurel extends StatelessWidget {
  const RankLaurel({
    super.key,
    required this.rank,
    required this.color,
    this.valueKey,
  });

  final String rank;
  final Color color;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    const asset = 'assets/images/onboarding/laurel_small.svg';
    return SizedBox(
      height: HtmlJourneyTokens.obRankLeafH,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: [
          _Leaf(
            asset: asset,
            width: HtmlJourneyTokens.obRankLeafW,
            height: HtmlJourneyTokens.obRankLeafH,
            color: color,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: HtmlJourneyTokens.obRankMinWidth,
            ),
            child: Text(
              rank,
              key: valueKey,
              textAlign: TextAlign.center,
              style: OnboardingType.medium(
                HtmlJourneyTokens.obRankFont,
                HtmlJourneyTokens.obRankFont,
              ).copyWith(color: color),
            ),
          ),
          _Leaf(
            asset: asset,
            width: HtmlJourneyTokens.obRankLeafW,
            height: HtmlJourneyTokens.obRankLeafH,
            color: color,
            mirror: true,
          ),
        ],
      ),
    );
  }
}

/// A gray skeleton bar standing in for a player's name.
class NameSkeleton extends StatelessWidget {
  const NameSkeleton({
    super.key,
    required this.width,
    required this.color,
    this.top = 0,
    this.bottom = 0,
  });

  final double width;
  final Color color;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: top, bottom: bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(HtmlJourneyTokens.obSkelRadius),
        ),
        child: SizedBox(width: width, height: HtmlJourneyTokens.obSkelHeight),
      ),
    );
  }
}

/// `.pu`: one podium player (avatar with laurel and rank, name bar, points).
class PodiumPlayer extends StatelessWidget {
  const PodiumPlayer({
    super.key,
    required this.person,
    required this.rank,
    required this.tier,
    required this.points,
    required this.unit,
    required this.hover,
    this.avatarKey,
    this.avatarVisible = true,
    this.avatarScale = 1,
  });

  final LbPerson person;
  final String rank;
  final Color tier;
  final String points;
  final String unit;

  /// 0..1 wave of the endless bobbing.
  final double hover;
  final GlobalKey? avatarKey;
  final bool avatarVisible;
  final double avatarScale;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final phase = switch (person.letter) {
      'Z' => 1.1 / 3.4,
      'M' => 2.3 / 3.4,
      'N' => 1.7 / 3.4,
      _ => 0.0,
    };
    final playerHover = (hover + phase) % 1.0;
    // Harmonic wave: pure cosine wave is infinitely smooth (C^inf) with zero
    // velocity at both top and bottom extremes, eliminating turnaround stutter.
    final wave = (1 - math.cos(playerHover * 2 * math.pi)) / 2;
    // OVERRIDE(O-002): Increased hover amplitude from 6px to 12px for smooth visibility.
    final lift = Offset(0, -HtmlJourneyTokens.obPuHover * 2.0 * wave);
    return SizedBox(
      width: HtmlJourneyTokens.obPuWidth,
      child: Transform.translate(
        offset: lift,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: HtmlJourneyTokens.avatarExtentMedium,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: HtmlJourneyTokens.obLaurelTop,
                    child: PodiumLaurel(color: tier),
                  ),
                  Transform.scale(
                    scale: avatarScale,
                    child: Opacity(
                      opacity: avatarVisible ? 1 : 0,
                      child: SizedBox(
                        key: avatarKey,
                        child: PlayerAvatar(
                          letter: person.letter,
                          theme: person.theme,
                          size: PlayerAvatarSize.medium,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -HtmlJourneyTokens.obRankBadgeOutset,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: tier,
                        borderRadius: BorderRadius.circular(
                          HtmlJourneyTokens.obChipRadius,
                        ),
                      ),
                      child: SizedBox.square(
                        dimension: HtmlJourneyTokens.climbBadgeExtent,
                        child: Center(
                          child: Text(
                            rank,
                            style: OnboardingType.semibold(
                              HtmlJourneyTokens.obRankBadgeFont,
                              HtmlJourneyTokens.obRankBadgeFont,
                            ).copyWith(color: roles.onSurfaceEmphasis),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: HtmlJourneyTokens.obPuGap),
            NameSkeleton(
              width: person.skeleton,
              color: HtmlJourneyTokens.obSkeletonDark,
              top: HtmlJourneyTokens.obSkelTop,
              bottom: HtmlJourneyTokens.obSkelBottom,
            ),
            const SizedBox(height: HtmlJourneyTokens.obPuGap),
            PointsTag(points: points, unit: unit),
          ],
        ),
      ),
    );
  }
}

/// `.lb-row`: rank laurel, avatar, name (or skeleton) and points.
class BoardRow extends StatelessWidget {
  const BoardRow({
    super.key,
    required this.rank,
    required this.rankColor,
    required this.person,
    required this.points,
    required this.unit,
    this.name,
    this.avatarVisible = true,
    this.avatarKey,
    this.border,
    this.shadows = const [],
    this.rankKey,
    this.pointsKey,
  });

  final String rank;
  final Color rankColor;
  final LbPerson person;
  final String points;
  final String unit;

  /// Null draws the skeleton bar.
  final String? name;
  final bool avatarVisible;
  final GlobalKey? avatarKey;
  final Color? border;
  final List<BoxShadow> shadows;
  final Key? rankKey;
  final Key? pointsKey;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final shown = name;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: roles.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(HtmlJourneyTokens.obBoardRadius),
        border: border == null
            ? null
            : Border.all(
                color: border!,
                width: HtmlJourneyTokens.obBoardBorder,
              ),
        boxShadow: shadows,
      ),
      child: SizedBox(
        height: HtmlJourneyTokens.climbRowExtent,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: HtmlJourneyTokens.obBoardPadH,
          ),
          child: Row(
            children: [
              RankLaurel(rank: rank, color: rankColor, valueKey: rankKey),
              const SizedBox(width: HtmlJourneyTokens.obBoardGap),
              Opacity(
                opacity: avatarVisible ? 1 : 0,
                child: SizedBox(
                  key: avatarKey,
                  child: PlayerAvatar(
                    letter: person.letter,
                    theme: person.theme,
                    size: PlayerAvatarSize.compact,
                  ),
                ),
              ),
              const SizedBox(width: HtmlJourneyTokens.obBoardGap),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: shown == null
                      ? NameSkeleton(
                          width:
                              person.skeleton +
                              HtmlJourneyTokens.obSkelRowExtra,
                          color: HtmlJourneyTokens.obSkeletonLight,
                        )
                      : Text(
                          shown,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: OnboardingType.semibold(
                            HtmlJourneyTokens.obNameFont,
                            HtmlJourneyTokens.obNameLine,
                          ).copyWith(color: roles.onSurfaceEmphasis),
                        ),
                ),
              ),
              const SizedBox(width: HtmlJourneyTokens.obBoardGap),
              PointsTag(points: points, unit: unit, valueKey: pointsKey),
            ],
          ),
        ),
      ),
    );
  }
}
