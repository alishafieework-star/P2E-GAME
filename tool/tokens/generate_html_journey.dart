// Generates HTML-prototype journey tokens. Not Figma (D-135).
import 'dart:io';

import 'generate_buttons.dart' as helpers;

Future<void> main(List<String> args) async {
  const source =
      'docs/snapshots/2026-10-26_html-prototype/evidence/journey.json';
  final data = helpers.readJson(source);
  if (data['notFigma'] != true) {
    throw StateError('Journey evidence must declare a non-Figma origin');
  }
  final colors = helpers.object(data['colors']);
  final motion = helpers.object(data['motion']);
  final themes = helpers.objects(data['themes']);
  final confetti = (data['confetti'] as List).cast<String>();
  final ease = (motion['ease'] as List).cast<num>();
  final spring = (motion['spring'] as List).cast<num>();
  final easeIn = (motion['easeIn'] as List).cast<num>();
  final easeInOut = (motion['easeInOut'] as List).cast<num>();
  final marquees = (motion['marqueeSeconds'] as List).cast<num>();
  final glows = (motion['glowSeconds'] as List).cast<num>();
  final questPoints = (motion['questPoints'] as List).cast<num>();
  final climbNeighbors = (motion['climbNeighborPoints'] as List).cast<num>();
  final themeLines = [
    for (final theme in themes)
      'JourneyAvatarTheme(${_color(theme['container'] as String)}, ${_color(theme['onContainer'] as String)}),',
  ].join('\n    ');
  final confettiLines = confetti.map(_color).join(', ');
  final onboardingLines = [
    for (final entry in helpers.object(data['onboarding']).entries)
      entry.key.endsWith('Ms')
          ? '  static const ${entry.key} = Duration(milliseconds: ${entry.value});'
          : '  static const ${entry.key} = ${entry.value};',
    for (final entry in helpers.object(data['onboardingColors']).entries)
      '  static const ${entry.key} = ${_color(entry.value as String)};',
    for (final entry in helpers.object(data['onboardingCurves']).entries)
      '  static const ${entry.key} = Cubic(${(entry.value as List).join(', ')});',
  ].join('\n');
  final text = await helpers.format('''
// GENERATED – do not edit
// Source: $source. Origin: HTML prototype, NOT Figma (D-135).
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

final class JourneyAvatarTheme {
  const JourneyAvatarTheme(this.container, this.onContainer);
  final Color container;
  final Color onContainer;
}

abstract final class HtmlJourneyTokens {
  static const primaryPress = ${_color(colors['primaryPress'] as String)};
  static const gold = ${_color(colors['gold'] as String)};
  static const silver = ${_color(colors['silver'] as String)};
  static const bronze = ${_color(colors['bronze'] as String)};
  static const splashGradientStart = ${_color(colors['splashGradientStart'] as String)};
  static const splashGradientMid = ${_color(colors['splashGradientMid'] as String)};
  static const splashGradientEnd = ${_color(colors['splashGradientEnd'] as String)};
  static const launchBackground = ${_color(colors['launchBackground'] as String)};
  static const success = ${_color(colors['success'] as String)};
  static const playNowHover = ${_color(colors['playNowHover'] as String)};
  static const glowViolet = ${_color(colors['glowViolet'] as String)};
  static const glowBlue = ${_color(colors['glowBlue'] as String)};
  static const glowOrange = ${_color(colors['glowOrange'] as String)};
  static const confetti = <Color>[$confettiLines];
  static const avatarThemes = <JourneyAvatarTheme>[
    $themeLines
  ];

  static const ease = Cubic(${ease.join(', ')});
  static const spring = Cubic(${spring.join(', ')});
  static const easeIn = Cubic(${easeIn.join(', ')});
  static const easeInOut = Cubic(${easeInOut.join(', ')});

  static const splashReduced = Duration(milliseconds: ${motion['splashReducedMilliseconds']});
  static const splashCollapse = Duration(milliseconds: ${motion['splashCollapseMilliseconds']});
  static const splashReveal = Duration(milliseconds: ${motion['splashRevealMilliseconds']});
  static const splashRevealDuration = Duration(milliseconds: ${motion['splashRevealDurationMilliseconds']});
  static const splashLoadDelay = Duration(milliseconds: ${motion['splashLoadDelayMilliseconds']});
  static const splashLoadDuration = Duration(milliseconds: ${motion['splashLoadDurationMilliseconds']});
  static const revealStartRadius = ${motion['revealStartRadius']};
  static const revealEndRadius = ${motion['revealEndRadius']};
  static const ringRevealScale = ${motion['ringRevealScale']};
  static const onboardingPlayback = ${motion['onboardingPlayback']};
  static const marqueeDurations = <Duration>[
    Duration(seconds: ${marquees[0]}),
    Duration(seconds: ${marquees[1]}),
  ];
  static const swipeThreshold = ${motion['swipeThreshold']};
  static const softOut = Duration(milliseconds: ${motion['softOutMilliseconds']});
  static const softIn = Duration(milliseconds: ${motion['softInMilliseconds']});
  static const softInDelay = Duration(milliseconds: ${motion['softInDelayMilliseconds']});
  static const softOutScale = ${motion['softOutScale']};
  static const softInScale = ${motion['softInScale']};
  static const softOutBlur = ${motion['softOutBlur']};
  static const softInBlur = ${motion['softInBlur']};
  static const marqueeTiltDegrees = ${motion['marqueeTiltDegrees']};
  static const cardExtent = ${motion['cardExtent']};
  static const cardRadius = ${motion['cardRadius']};
  static const cardGap = ${motion['cardGap']};
  static const edgeFadeStop = ${motion['edgeFadeStop']};
  static const legalProgressExtent = ${motion['legalProgressExtent']};
  static const landPopStart = ${motion['landPopStart']};
  static const landPopPeak = ${motion['landPopPeak']};
  static const confettiGravity = ${motion['confettiGravity']};
  static const legalEnter = Duration(milliseconds: ${motion['legalEnterMilliseconds']});
  static const legalExit = Duration(milliseconds: ${motion['legalExitMilliseconds']});
  static const legalTopThreshold = ${motion['legalTopThreshold']};
  static const legalIndicator = Duration(milliseconds: ${motion['legalIndicatorMilliseconds']});
  static const legalSwipeThreshold = ${motion['legalSwipeThreshold']};
  static const legalSwipeDominance = ${motion['legalSwipeDominance']};
  static const legalHighlight = Duration(milliseconds: ${motion['legalHighlightMilliseconds']});
  static const tourMove = Duration(milliseconds: ${motion['tourMoveMilliseconds']});
  static const tourIntro = Duration(milliseconds: ${motion['tourIntroMilliseconds']});
  static const tourIntroInset = ${motion['tourIntroInset']};
  static const tourPulse = Duration(milliseconds: ${motion['tourPulseMilliseconds']});
  static const tourPulseDelay = Duration(milliseconds: ${motion['tourPulseDelayMilliseconds']});
  static const tourPulsePad = ${motion['tourPulsePad']};
  static const tourPulseAlpha = ${motion['tourPulseAlpha']};
  static const tourHoleBorderAlpha = ${motion['tourHoleBorderAlpha']};
  static const tourFade = Duration(milliseconds: ${motion['tourFadeMilliseconds']});
  static const tourTooltipWidth = ${motion['tourTooltipWidth']};
  static const tourTooltipGap = ${motion['tourTooltipGap']};
  static const overlayAlpha = ${motion['overlayAlpha']};
  static const badgePop = Duration(milliseconds: ${motion['badgePopMilliseconds']});
  static const avatarBadgeHoverScale = ${motion['avatarBadgeHoverScale']};
  static const avatarBadgeHoverDegrees = ${motion['avatarBadgeHoverDegrees']};
  static const verifiedDelay = Duration(milliseconds: ${motion['verifiedDelayMilliseconds']});
  static const bellPulse = Duration(milliseconds: ${motion['bellPulseMilliseconds']});
  static const bellPulseDelay = Duration(milliseconds: ${motion['bellPulseDelayMilliseconds']});
  static const bellPulseScale = ${motion['bellPulseScale']};
  static const countUp = Duration(milliseconds: ${motion['countUpMilliseconds']});
  static const countUpDelay = Duration(milliseconds: ${motion['countUpDelayMilliseconds']});
  static const questFly = Duration(milliseconds: ${motion['questFlyMilliseconds']});
  static const questAdd = Duration(milliseconds: ${motion['questAddMilliseconds']});
  static const climb = Duration(milliseconds: ${motion['climbMilliseconds']});
  static const confettiDuration = Duration(milliseconds: ${motion['confettiMilliseconds']});
  static const confettiCount = ${motion['confettiCount']};
  static const glowDurations = <Duration>[
    Duration(seconds: ${glows[0]}),
    Duration(seconds: ${glows[1]}),
    Duration(seconds: ${glows[2]}),
  ];
  static const questClockSeconds = ${motion['questClockSeconds']};
  static const questDaySeconds = ${motion['questDaySeconds']};
  static const questRingExtent = ${motion['questRingExtent']};
  static const questRingRadius = ${motion['questRingRadius']};
  static const questRingStroke = ${motion['questRingStroke']};
  static const questRingTicks = ${motion['questRingTicks']};
  static const questRingCenter = ${motion['questRingCenter']};
  static const questRingEnterScale = ${motion['questRingEnterScale']};
  static const questRingEnterDegrees = ${motion['questRingEnterDegrees']};
  static const questPoints = <int>[${questPoints.join(', ')}];
  static const questTotal = ${motion['questTotal']};
  static const tourArrowExtent = ${motion['tourArrowExtent']};
  static const tourArrowOutset = ${motion['tourArrowOutset']};
  static const podiumHeight = ${motion['podiumHeight']};
  static const podiumFirstTop = ${motion['podiumFirstTop']};
  static const podiumSecondTop = ${motion['podiumSecondTop']};
  static const podiumThirdTop = ${motion['podiumThirdTop']};
  static const podiumSideOffset = ${motion['podiumSideOffset']};
  static const climbRankStart = ${motion['climbRankStart']};
  static const climbRankEnd = ${motion['climbRankEnd']};
  static const climbScoreStart = ${motion['climbScoreStart']};
  static const climbScoreEnd = ${motion['climbScoreEnd']};
  static const climbNeighborPoints = <int>[${climbNeighbors.join(', ')}];
  static const climbScene = Duration(milliseconds: ${motion['climbSceneMilliseconds']});
  static const climbCountDelay = Duration(milliseconds: ${motion['climbCountDelayMilliseconds']});
  static const climbCount = Duration(milliseconds: ${motion['climbCountMilliseconds']});
  static const climbMoveDelay = Duration(milliseconds: ${motion['climbMoveDelayMilliseconds']});
  static const climbFlyDelay = Duration(milliseconds: ${motion['climbFlyDelayMilliseconds']});
  static const climbFly = Duration(milliseconds: ${motion['climbFlyMilliseconds']});
  static const climbRowExtent = ${motion['climbRowExtent']};
  static const climbBadgeExtent = ${motion['climbBadgeExtent']};
  static const sheetEnter = Duration(milliseconds: ${motion['sheetEnterMilliseconds']});
  static const sheetExit = Duration(milliseconds: ${motion['sheetExitMilliseconds']});

  // HTML avatarHTML sizes: 32, 38, 48, 52 and 96. Letters: 38 to 20, 52 to 24, 96 to 46.
  static const avatarExtentCompact = 32.0;
  static const avatarExtentSmall = 38.0;
  static const avatarExtentMedium = 48.0;
  static const avatarExtentLarge = 52.0;
  static const avatarExtentHero = 96.0;
  static const avatarLetterCompact = 20.0;
  static const avatarLetterSmall = 20.0;
  static const avatarLetterMedium = 22.0;
  static const avatarLetterLarge = 24.0;
  static const avatarLetterHero = 46.0;
  static const sheetTopRadius = 28.0;
  static const sheetGap = 8.0;

  // HTML onboarding CSS and timelines (D-138).
$onboardingLines
}
''');
  const out =
      'packages/design_system/lib/src/tokens/generated/html_journey_tokens.g.dart';
  final file = File(out);
  if (args.contains('--check')) {
    if (!file.existsSync() || file.readAsStringSync() != text) {
      throw StateError('Stale HTML journey tokens');
    }
    return;
  }
  file.writeAsStringSync(text);
}

String _color(String hex) {
  final raw = hex.replaceFirst('#', '');
  if (raw.length != 6) throw StateError('Expected #RRGGBB, got $hex');
  return 'Color(0xFF${raw.toUpperCase()})';
}
