// GENERATED from docs/snapshots/2026-10-25_game-details/evidence/tokens.json
// and design/engineering/game_details.json by tool/tokens/generate_game_details.cjs.
// Do not edit. Game Details measurements, roles and text styles (D-121).
import 'package:flutter/painting.dart';

import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';

abstract final class GameDetailsTokens {
  static const double pagePadding = 16;
  static const double primaryGap = 24;
  static const double icon = 70;
  static const double iconRadius = 16;
  static const double headlineGap = 20;
  static const double headlinePadHorizontal = 16;
  static const double creatorGap = 2;
  static const double statsGap = 10;
  static const double statsDivider = 1.5;
  static const double statsDividerLength = 22;
  static const double ctaGap = 10;
  static const double mediaPadVertical = 8;
  static const double mediaWidth = 290;
  static const double mediaHeight = 180;
  static const double mediaRadius = 16;
  static const double playBadgeWidth = 64;
  static const double playBadgeHeight = 48;
  static const double playBadgeRadius = 16;
  static const double playIcon = 32;
  static const double cardRadius = 16;
  static const double cardPadding = 16;
  static const double cardGap = 12;
  static const double factGap = 12;
  static const double eventBannerHeight = 160;
  static const double eventBodyPadding = 14;
  static const double eventBodyGap = 4;
  static const double ratingGap = 12;
  static const double ratingPadding = 16;
  static const double star = 16;
  static const double histogramBarHeight = 8;
  static const double histogramBarRadius = 8;
  static const double histogramGap = 12;
  static const double histogramRowGap = 6;
  static const double summaryGap = 18;
  static const double summaryIcon = 16;
  static const double platformGlyph = 14;
  static const double voteGap = 18;
  static const double commentAvatar = 32;
  static const double commentGap = 12;
  static const double commentStarOverlap = 2;
  static const double studioCoverHeight = 210;
  static const double studioCoverPadding = 16;
  static const double studioShelfGap = 12;
  static const double studioLogo = 48;
  static const double studioLogoRadius = 10;
  static const double studioLogoPadding = 6;
  static const double studioInfoGap = 12;
}

abstract final class GameDetailsRoles {
  static const page = ThemedRole(dark: 'Surface/Base', light: 'Surface/Base');
  static const card = ThemedRole(
    dark: 'Surface Container/Base',
    light: 'Surface Container/Lowest',
  );
  static const emphasis = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Base',
  );
  static const body = ThemedRole(
    dark: 'On Surface/Base',
    light: 'On Surface/Variant',
  );
  static const muted = ThemedRole(
    dark: 'On Surface/Muted',
    light: 'On Surface/Muted',
  );
  static const variant = ThemedRole(
    dark: 'On Surface/Variant',
    light: 'On Surface/Muted',
  );
  static const divider = ThemedRole(
    dark: 'Outline/Base',
    light: 'Outline/Variant',
  );
  static const reviewDivider = ThemedRole(
    dark: 'Outline/Variant',
    light: 'Outline/Variant',
  );
  static const histogramTrack = ThemedRole(
    dark: 'Surface Container/High',
    light: 'Surface Container/Base',
  );
  static const histogramFill = ThemedRole(
    dark: 'Surface Container/Highest',
    light: 'Surface Container/Highest',
  );
  static const studioAction = ThemedRole(
    dark: 'Surface Container/High',
    light: 'Surface Container/High',
  );
  static const studioLogo = ThemedRole(
    dark: 'Alpha/Black',
    light: 'Alpha/Black',
  );
  static const playIcon = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Emphasis',
  );
  static const avatarPlate = ThemedRole(
    dark: 'Countainer/Purple',
    light: 'Countainer/Purple',
  );
  static const avatarInk = ThemedRole(
    dark: 'Primary/Purple',
    light: 'Primary/Purple',
  );
  static const avatarPlateTeal = ThemedRole(
    dark: 'Countainer/Teal',
    light: 'Countainer/Teal',
  );
  static const avatarInkTeal = ThemedRole(
    dark: 'Primary/Teal',
    light: 'Primary/Teal',
  );
  static const avatarPlatePink = ThemedRole(
    dark: 'Countainer/Pink',
    light: 'Countainer/Pink',
  );
  static const avatarInkPink = ThemedRole(
    dark: 'Primary/Pink',
    light: 'Primary/Pink',
  );
  static const avatarPlateEmerald = ThemedRole(
    dark: 'Countainer/Emerald',
    light: 'Countainer/Emerald',
  );
  static const avatarInkEmerald = ThemedRole(
    dark: 'Primary/Emerald',
    light: 'Primary/Emerald',
  );
}

/// Unbound source paints (E-113). Product skin keeps them; other skins use the fallback.
abstract final class GameDetailsPaints {
  static const playBadge = ThemedPaint(
    dark: RawPaint(Color(0xCC000000), fallbackRole: 'Alpha/Black'),
    light: RawPaint(Color(0xCCFFFFFF), fallbackRole: 'Alpha/White'),
  );
  static const studioScrim = ThemedPaint(
    dark: RawPaint(Color(0xB3000000), fallbackRole: 'Alpha/Black'),
    light: RawPaint(Color(0x80FFF4F4), fallbackRole: 'Alpha/White'),
  );
  static const star = ThemedPaint(
    dark: RawPaint(Color(0xFFFDC700), fallbackRole: 'Outline/Variant'),
    light: RawPaint(Color(0xFFFDC700), fallbackRole: 'Outline/Variant'),
  );
  static const platformAndroid = ThemedPaint(
    dark: RawPaint(Color(0xFF00C951), fallbackRole: 'Outline/Variant'),
    light: RawPaint(Color(0xFF00C951), fallbackRole: 'Outline/Variant'),
  );
}

abstract final class GameDetailsStrokes {
  static const card = ThemedStroke(
    dark: null,
    light: SourceStroke(RolePaint('Outline/Variant'), 1),
  );
}

abstract final class GameDetailsText {
  static final titleLarge = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 28 / 22,
      letterSpacing: -0.88,
    ),
  );
  static final titleSmall = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 24 / 18,
      letterSpacing: -0.72,
    ),
  );
  static final labelMedium = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 20 / 16,
      letterSpacing: -0.64,
    ),
  );
  static final labelSmall = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 18 / 14,
      letterSpacing: -0.56,
    ),
  );
  static final mutedLabel = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 18 / 14,
      letterSpacing: -0.56,
    ),
  );
  static final numberLarge = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 20 / 16,
      letterSpacing: 0,
    ),
  );
  static final mutedNumber = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 18 / 14,
      letterSpacing: 0,
    ),
  );
  static final body = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 18 / 14,
      letterSpacing: -0.56,
    ),
  );
  static final displayRating = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 40,
      fontWeight: FontWeight.w600,
      height: 50 / 40,
      letterSpacing: -1.6,
    ),
  );
  static final histogram = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 14 / 12,
      letterSpacing: 0,
    ),
  );
}

/// Values Figma does not define (D-121).
abstract final class GameDetailsEngineering {
  static const int aboutCollapsedLines = 13;
  static const requestTimeout = Duration(seconds: 8);
  static const viewerTransition = Duration(milliseconds: 200);
}
