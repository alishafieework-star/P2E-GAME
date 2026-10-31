import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

enum RewardBadgeAppearance { overlay, step, total }

enum RewardBadgeEmphasis { active, upcoming }

/// Presentational reward. Amounts and the unit arrive localized (D-049).
class RewardBadge extends StatelessWidget {
  const RewardBadge({
    super.key,
    required this.elementId,
    required this.appearance,
    required this.amount,
    required this.unit,
    this.emphasis = RewardBadgeEmphasis.active,
    this.secondaryAmount,
    this.runtimeLocator,
  }) : assert(amount != '' && unit != ''),
       assert(
         appearance == RewardBadgeAppearance.total
             ? secondaryAmount != null && secondaryAmount != ''
             : secondaryAmount == null,
       ),
       assert(
         emphasis == RewardBadgeEmphasis.active ||
             appearance == RewardBadgeAppearance.step,
       );

  final String elementId, amount, unit;
  final RewardBadgeAppearance appearance;
  final RewardBadgeEmphasis emphasis;
  final String? secondaryAmount;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    final body = switch (appearance) {
      RewardBadgeAppearance.overlay => _overlay(context),
      RewardBadgeAppearance.step => _step(context),
      RewardBadgeAppearance.total => _total(context),
    };
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'reward.badge',
      structureRef: 'reward.badge',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: appearance == RewardBadgeAppearance.overlay
          ? '18451:10177'
          : '18457:13272',
      componentSetId: null,
      rawSetName: 'Reward',
      rawVariantName: appearance.name,
      variants: {'appearance': appearance.name, 'emphasis': emphasis.name},
      resolved: const {},
      declared: const {},
      child: Semantics(
        container: true,
        excludeSemantics: true,
        label: appearance == RewardBadgeAppearance.total
            ? '$amount / $secondaryAmount $unit'
            : '$amount $unit',
        child: body,
      ),
    );
  }

  /// Scrim only. The source blur is not applied while the badge scrolls (E-120).
  Widget _overlay(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: HomePaints.overlayScrim.resolve(context),
      borderRadius: _radius,
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        HomeTokens.rewardOverlayPadStart,
        HomeTokens.rewardOverlayPadTop,
        HomeTokens.rewardOverlayPadEnd,
        HomeTokens.rewardOverlayPadBottom,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Crown(
            plate: HomeRoles.overlayPlate,
            artwork: HomeRoles.overlayArtwork,
          ),
          const SizedBox(width: HomeTokens.rewardOverlayGap),
          _number(
            amount,
            HomeText.rewardAmount,
            HomeRoles.overlayAmount,
            context,
          ),
          const SizedBox(width: HomeTokens.rewardAmountUnitGap),
          Text(
            unit,
            style: HomeText.rewardUnit.copyWith(
              color: HomeRoles.overlayUnit.resolve(context),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _step(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: HomeRoles.stepSurface.resolve(context),
      borderRadius: _radius,
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: HomeTokens.rewardStepPadHorizontal,
        vertical: HomeTokens.rewardStepPadVertical,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _number(
            amount,
            HomeText.rewardAmount,
            emphasis == RewardBadgeEmphasis.active
                ? HomeRoles.stepAmountActive
                : HomeRoles.stepAmountUpcoming,
            context,
          ),
          const SizedBox(width: HomeTokens.rewardAmountUnitGap),
          Text(
            unit,
            style: HomeText.rewardUnit.copyWith(
              color: HomeRoles.stepUnit.resolve(context),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _total(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: HomeRoles.totalSurface.resolve(context),
      borderRadius: _radius,
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        HomeTokens.rewardTotalPadStart,
        HomeTokens.rewardTotalPadTop,
        HomeTokens.rewardTotalPadEnd,
        HomeTokens.rewardTotalPadBottom,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Crown(plate: HomeRoles.totalPlate, artwork: HomeRoles.totalArtwork),
          const SizedBox(width: HomeTokens.rewardTotalGap),
          _number(amount, HomeText.rewardTotal, HomeRoles.totalAmount, context),
          const SizedBox(width: HomeTokens.rewardTotalSegmentGap),
          Text(
            '/',
            style: HomeText.rewardUnit.copyWith(
              color: HomeRoles.totalSlash.resolve(context),
            ),
          ),
          const SizedBox(width: HomeTokens.rewardTotalSegmentGap),
          _number(
            secondaryAmount!,
            HomeText.rewardTotal,
            HomeRoles.totalSecondary,
            context,
          ),
          const SizedBox(width: HomeTokens.rewardTotalUnitGap),
          Text(
            unit,
            style: HomeText.rewardUnit.copyWith(
              color: HomeRoles.totalUnit.resolve(context),
            ),
          ),
        ],
      ),
    ),
  );

  static const _radius = BorderRadius.all(
    Radius.circular(HomeTokens.rewardRadius),
  );

  /// Numeric runs keep left-to-right digit order inside right-to-left text.
  Widget _number(
    String value,
    TextStyle style,
    ThemedRole role,
    BuildContext context,
  ) => Text(
    value,
    textDirection: TextDirection.ltr,
    style: style.copyWith(color: role.resolve(context)),
  );
}

class _Crown extends StatelessWidget {
  const _Crown({required this.plate, required this.artwork});
  final ThemedRole plate, artwork;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: plate.resolve(context),
      shape: BoxShape.circle,
    ),
    child: SizedBox.square(
      dimension: HomeTokens.rewardPlate,
      child: Center(
        child: AssetAppIcon(
          AppIconId.crown,
          style: AppIconStyle.fill,
          size: HomeTokens.rewardArtwork,
          color: artwork.resolve(context),
        ),
      ),
    ),
  );
}
