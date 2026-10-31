// GENERATED from docs/snapshots/2026-10-24_home/evidence and
// design/engineering/home.json by tool/tokens/generate_home.cjs. Do not edit.
// Provisional collection primitives (D-101, D-102, R-100, R-101).
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';

abstract final class CollectionTokens {
  static const double sectionHeaderHeight = 36;
  static const double sectionGap = 10;
  static const double sectionTitleInsetStart = 12;
  static const double sectionTitleInsetEnd = 12;
  static const double sectionActionPadding = 8;
  static const double sectionActionGap = 4;
  static const double sectionActionRadius = 10;
  static const double sectionActionIcon = 20;
  static const double sectionPadding = 16;
  static const double sectionContentGap = 12;
  static const double pageIndicatorActive = 7.5;
  static const double pageIndicatorInactive = 5;
  static const double pageIndicatorGap = 5;
  static const double shelfGapRegular = 12;
  static const double shelfGapRelaxed = 16;
  static const double sectionTitlePartGap = 6;
  static const double sectionMarkGap = 2;
}

abstract final class CollectionRoles {
  static const sectionTitle = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Base',
  );
  // D-121: lead is Base in Dark and Muted in Light (Game Details 18526:12062 / 18533:9377).
  static const sectionLead = ThemedRole(
    dark: 'On Surface/Base',
    light: 'On Surface/Muted',
  );
  static const sectionAction = ThemedRole(
    dark: 'Action/Accent',
    light: 'Action/Accent',
  );
  static const pageActive = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Variant',
  );
  static const pageInactive = ThemedRole(
    dark: 'On Surface/Muted',
    light: 'On Surface/Muted',
  );
}

abstract final class CollectionText {
  static final sectionTitle = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 24 / 18,
      letterSpacing: -0.72,
    ),
  );
  static final sectionAction = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 18 / 14,
      letterSpacing: -0.56,
    ),
  );
}

/// Engineering motion. Figma defines none (R-101, D-102, D-104).
abstract final class CollectionMotion {
  static const pageDuration = Duration(milliseconds: 250);
  static const pageCurve = Curves.easeOut;
  static const double heroParallaxBackground = 0.25;
  static const double heroParallaxForeground = 0.55;
  static const double heroParallaxMax = 48;
}
