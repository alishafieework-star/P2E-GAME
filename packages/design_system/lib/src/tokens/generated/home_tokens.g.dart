// GENERATED from docs/snapshots/2026-10-24_home/evidence and
// design/engineering/home.json by tool/tokens/generate_home.cjs. Do not edit.
// Product Home measurements, roles and text styles (D-101, D-102).
import 'package:flutter/painting.dart';

import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';

abstract final class HomeTokens {
  static const double infoIconRadius = 10;
  static const double infoFeaturedIcon = 54;
  static const double infoFeaturedPadding = 12;
  static const double infoFeaturedGap = 14;
  static const double infoFeaturedRadius = 20;
  static const double infoFeaturedHeight = 78;
  static const double infoFeaturedTextGap = 0;
  static const double infoCardIcon = 48;
  static const double infoCardPadding = 14;
  static const double infoCardGap = 14;
  static const double infoCardTextGap = 0;
  static const double infoQuestIcon = 46;
  static const double infoQuestPadding = 16;
  static const double infoQuestGap = 12;
  static const double infoQuestHeight = 85;
  static const double infoQuestTextGap = 2;
  static const double infoMarkGap = 2;
  static const double infoActionGap = 4;
  static const double rewardRadius = 16;
  static const double rewardOverlayPadTop = 4;
  static const double rewardOverlayPadEnd = 6;
  static const double rewardOverlayPadBottom = 4;
  static const double rewardOverlayPadStart = 4;
  static const double rewardOverlayGap = 4;
  static const double rewardOverlayInsetTop = 4;
  static const double rewardOverlayInsetEnd = 4;
  static const double rewardPlate = 18;
  static const double rewardArtwork = 14;
  static const double rewardAmountUnitGap = 2;
  static const double rewardBlur = 5;
  static const double rewardStepPadVertical = 2;
  static const double rewardStepPadHorizontal = 6;
  static const double rewardTotalPadTop = 4;
  static const double rewardTotalPadEnd = 8;
  static const double rewardTotalPadBottom = 4;
  static const double rewardTotalPadStart = 4;
  static const double rewardTotalGap = 4;
  static const double rewardTotalSegmentGap = 4;
  static const double rewardTotalUnitGap = 2;
  static const double compactWidth = 120;
  static const double compactImageRadius = 16;
  static const double compactGap = 8;
  static const double compactInfoPadHorizontal = 4;
  static const double compactDetailedInfoGap = 0;
  static const double compactSimpleInfoGap = 4;
  static const double ratingInsetVertical = 6;
  static const double ratingPadHorizontal = 6;
  static const double ratingPadVertical = 2;
  static const double ratingGap = 2;
  static const double ratingRadius = 8;
  static const double ratingStar = 16;
  static const double expandRadius = 16;
  static const double expandBannerHeight = 150;
  static const double questRadius = 20;
  static const double questBodyPadHorizontal = 16;
  static const double questPanelRadius = 16;
  static const double questTrackInsetTop = 14;
  static const double questTrackPadHorizontal = 16;
  static const double questTrackInsetBottom = 16;
  static const double questDividerWidth = 1.5;
  static const double questDetailsPadding = 16;
  static const double questDetailsGap = 10;
  static const double questStatusGap = 2;
  static const double questFooterPadding = 16;
  static const double progressTrackHeight = 12;
  static const double progressMarker = 28;
  static const double progressMarkerRadius = 8;
  static const double progressMarkerPadding = 4;
  static const double progressIcon = 20;
  static const double progressSegment = 50;
  static const double progressRewardGap = 12;
  static const double countdownGap = 6;
  static const double countdownUnitGap = 4;
  static const double countdownDigitGap = 4;
  static const double countdownDigitWidth = 28;
  static const double countdownDigitPadding = 6;
  static const double countdownDigitRadius = 5;
  static const double countdownLabelPadHorizontal = 2.5;
  static const double countdownDot = 2.5;
  static const double countdownDotGap = 5;
  static const double countdownDotInsetBottom = 20;
  static const double heroReferenceWidth = 402;
  static const double heroReferenceHeight = 343;
  static const double heroRowTop = 224;
  static const double heroRowInset = 16;
  static const double heroCardHeight = 302;
}

abstract final class HomeRoles {
  static const featuredSurface = ThemedRole(
    dark: 'Surface Container/Base',
    light: 'Surface Container/Lowest',
  );
  static const featuredName = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Emphasis',
  );
  static const cardName = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Base',
  );
  static const questName = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Base',
  );
  static const infoSupporting = ThemedRole(
    dark: 'On Surface/Base',
    light: 'On Surface/Muted',
  );
  static const overlayPlate = ThemedRole(
    dark: 'Countainer/Pink',
    light: 'Primary/Pink',
  );
  static const overlayArtwork = ThemedRole(
    dark: 'Primary/Pink',
    light: 'Countainer/Pink',
  );
  static const overlayAmount = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Emphasis',
  );
  static const overlayUnit = ThemedRole(
    dark: 'On Surface/Base',
    light: 'On Surface/Variant',
  );
  static const stepSurface = ThemedRole(
    dark: 'Surface Container/Highest',
    light: 'Surface Container/Lowest',
  );
  static const stepAmountActive = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Variant',
  );
  static const stepAmountUpcoming = ThemedRole(
    dark: 'On Surface/Variant',
    light: 'On Surface/Muted',
  );
  static const stepUnit = ThemedRole(
    dark: 'On Surface/Variant',
    light: 'On Surface/Muted',
  );
  static const totalSurface = ThemedRole(
    dark: 'Surface Container/Highest',
    light: 'Surface Container/Lowest',
  );
  static const totalPlate = ThemedRole(
    dark: 'Countainer/Pink',
    light: 'Countainer/Pink',
  );
  static const totalArtwork = ThemedRole(
    dark: 'Primary/Pink',
    light: 'Primary/Pink',
  );
  static const totalAmount = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Base',
  );
  static const totalSlash = ThemedRole(
    dark: 'On Surface/Variant',
    light: 'On Surface/Muted',
  );
  static const totalSecondary = ThemedRole(
    dark: 'On Surface/Base',
    light: 'On Surface/Variant',
  );
  static const totalUnit = ThemedRole(
    dark: 'On Surface/Variant',
    light: 'On Surface/Muted',
  );
  static const ratingDetailedSurface = ThemedRole(
    dark: 'Surface Container/Base',
    light: 'Surface Container/High',
  );
  static const ratingDetailedValue = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Variant',
  );
  static const ratingSimpleSurface = ThemedRole(
    dark: 'Surface Container/High',
    light: 'Surface Container/Lowest',
  );
  static const ratingSimpleValue = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Base',
  );
  static const expandSurface = ThemedRole(
    dark: 'Surface Container/Base',
    light: 'Surface Container/Lowest',
  );
  static const questSurface = ThemedRole(
    dark: 'Surface Container/Base',
    light: 'Surface Container/Lowest',
  );
  static const questPanel = ThemedRole(
    dark: 'Surface Container/High',
    light: 'Surface Container/High',
  );
  static const questDivider = ThemedRole(
    dark: 'Outline/Base',
    light: 'Outline/Base',
  );
  static const questStatus = ThemedRole(
    dark: 'On Surface/Base',
    light: 'On Surface/Muted',
  );
  static const countdownSurface = ThemedRole(
    dark: 'Surface Container/High',
    light: 'Surface Container/High',
  );
  static const countdownValue = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Variant',
  );
}

/// Source paints that may be unbound in one theme (E-103, E-105, E-109).
abstract final class HomePaints {
  static const overlayScrim = ThemedPaint(
    dark: RawPaint(Color(0x80000000), fallbackRole: 'Alpha/Black'),
    light: RawPaint(Color(0xCCFFFFFF), fallbackRole: 'Alpha/White'),
  );
  static const ratingStarDetailed = ThemedPaint(
    dark: RawPaint(Color(0xFFFDC700)),
    light: RawPaint(Color(0xFFFFB900)),
  );
  static const ratingStarSimple = ThemedPaint(
    dark: RawPaint(Color(0xFFFDC700)),
    light: RawPaint(Color(0xFFFE9A00)),
  );
  static const progressSegmentDone = ThemedPaint(
    dark: RawPaint(Color(0xFF00C951)),
    light: RawPaint(Color(0xFF00C951)),
  );
  static const progressSegmentPending = ThemedPaint(
    dark: RawPaint(Color(0xB3404040)),
    light: RawPaint(Color(0x33404040)),
  );
  static const progressMarkerDone = ThemedPaint(
    dark: RolePaint('Surface Container/Highest'),
    light: RawPaint(Color(0xFF00A63E)),
  );
  static const progressMarkerIdle = ThemedPaint(
    dark: RolePaint('Surface Container/Highest'),
    light: RolePaint('Surface Container/Highest'),
  );
  static const progressDoneIcon = ThemedPaint(
    dark: RolePaint('On Surface/Emphasis'),
    light: RolePaint('Alpha/White'),
  );
  static const progressStartIdleIcon = ThemedPaint(
    dark: RolePaint('On Surface/Emphasis'),
    light: RolePaint('On Surface/Variant'),
  );
  static const progressWaitingIcon = ThemedPaint(
    dark: RolePaint('On Surface/Base'),
    light: RolePaint('On Surface/Muted'),
  );
}

abstract final class HomeStrokes {
  static const expand = ThemedStroke(
    dark: null,
    light: SourceStroke(RolePaint('Outline/Variant'), 1),
  );
  static const quest = ThemedStroke(
    dark: null,
    light: SourceStroke(RolePaint('Outline/Variant'), 1),
  );
}

abstract final class HomeShadows {
  static const featured = ThemedShadows(
    dark: [],
    light: [
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 10,
        spreadRadius: 0,
        offset: Offset(0, 0),
      ),
    ],
  );

  /// E-108: raw vignette colors; fallback roles are engineering choices.
  static const heroVignette = ThemedInnerShadows(
    dark: [
      SourceInnerShadow(
        RawPaint(Color(0xFF0A0A0A), fallbackRole: 'Surface/Base'),
        50,
      ),
      SourceInnerShadow(
        RawPaint(Color(0xFF0A0A0A), fallbackRole: 'Surface/Base'),
        120,
      ),
    ],
    light: [
      SourceInnerShadow(
        RawPaint(Color(0xFFFFFFFF), fallbackRole: 'Alpha/White'),
        40,
      ),
      SourceInnerShadow(
        RawPaint(Color(0xFF03A7E2), fallbackRole: 'Outline/Variant'),
        90,
      ),
    ],
  );
}

abstract final class HomeText {
  static final featuredName = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 26 / 20,
      letterSpacing: -0.8,
    ),
  );
  static final cardName = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 24 / 18,
      letterSpacing: -0.72,
    ),
  );
  static final questName = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 26 / 20,
      letterSpacing: -0.8,
    ),
  );
  static final creator = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 18 / 14,
      letterSpacing: -0.56,
    ),
  );
  static final rewardAmount = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 14 / 12,
      letterSpacing: 0,
    ),
  );
  static final rewardUnit = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 18 / 14,
      letterSpacing: -0.56,
    ),
  );
  static final rewardTotal = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 18 / 14,
      letterSpacing: 0,
    ),
  );
  static final rating = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 18 / 14,
      letterSpacing: 0,
    ),
  );
  static final questStatus = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 18 / 14,
      letterSpacing: -0.56,
    ),
  );
  static final questStatusNumber = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 18 / 14,
      letterSpacing: 0,
    ),
  );
  static final countdownDigit = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 20 / 16,
      letterSpacing: 0,
    ),
  );
  static final countdownLabel = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 10,
      fontWeight: FontWeight.w600,
      height: 12 / 10,
      letterSpacing: -0.4,
    ),
  );

  /// E-102: the source caption has no text style; measured from node 18457:13109.
  /// Its AUTO line height is the measured caption box height.
  static final caption = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 10,
      fontWeight: FontWeight.w600,
      height: 13 / 10,
      letterSpacing: -0.4,
    ),
  );
}
