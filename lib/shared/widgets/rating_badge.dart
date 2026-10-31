import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Source appearances of the Rate frame inside Game Compact Card (E-109).
enum RatingBadgeAppearance { detailed, simple }

/// Shared rating chip (Games cards and the onboarding wall). The value arrives display-ready.
class RatingBadge extends StatelessWidget {
  const RatingBadge({
    super.key,
    required this.value,
    required this.semanticLabel,
    required this.appearance,
  }) : assert(value != '' && semanticLabel != '');

  final String value, semanticLabel;
  final RatingBadgeAppearance appearance;

  @override
  Widget build(BuildContext context) {
    final detailed = appearance == RatingBadgeAppearance.detailed;
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              (detailed
                      ? HomeRoles.ratingDetailedSurface
                      : HomeRoles.ratingSimpleSurface)
                  .resolve(context),
          borderRadius: const BorderRadiusDirectional.all(
            Radius.circular(HomeTokens.ratingRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: HomeTokens.ratingPadHorizontal,
            vertical: HomeTokens.ratingPadVertical,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: HomeText.rating.copyWith(
                  color:
                      (detailed
                              ? HomeRoles.ratingDetailedValue
                              : HomeRoles.ratingSimpleValue)
                          .resolve(context),
                ),
              ),
              const SizedBox(width: HomeTokens.ratingGap),
              AssetAppIcon(
                AppIconId.star,
                style: AppIconStyle.fill,
                size: HomeTokens.ratingStar,
                color:
                    (detailed
                            ? HomePaints.ratingStarDetailed
                            : HomePaints.ratingStarSimple)
                        .resolve(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
