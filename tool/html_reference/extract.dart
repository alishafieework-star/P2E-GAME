// Reads docs/Sample/P2E - v1.0.html and writes the provisional journey assets
// and evidence. Origin is the HTML prototype, not Figma (D-135, D-137).
import 'dart:convert';
import 'dart:io';

const _viewBox = '0 0 500 330';

void main() {
  final html = File('docs/Sample/P2E - v1.0.html').readAsStringSync();
  for (final needle in [
    'const SPLASH_LOGO',
    'const PODIUM_SVG',
    'const LAUREL_BIG',
    'const LAUREL_SM',
    'const GC_IMG',
    'function charSVG',
    '--primary-press:#0093d8',
    'function confetti',
  ]) {
    if (!html.contains(needle)) {
      throw StateError('HTML prototype is missing $needle');
    }
  }
  _writeLogo(html);
  _writePodium(html);
  _writeLaurel(html);
  _writeLaurelSmall(html);
  final cards = _writeCards(html);
  final avatars = _writeAvatars();
  _writeEvidence(html, cards: cards, avatars: avatars);
  stdout.writeln(
    'Extracted logo layers, ${cards.length} game cards, '
    '${avatars.length} avatars, podium and laurel.',
  );
}

void _writeLogo(String html) {
  final start = html.indexOf("const SPLASH_LOGO = '");
  final from = start + "const SPLASH_LOGO = '".length;
  final end = html.indexOf("';", from);
  final svg = html.substring(from, end);
  final paths = RegExp('<path class="(p-bg|p-g|p-m|p-ring|p-hole)"([^>]*)>')
      .allMatches(svg)
      .toList();
  if (paths.length < 5) {
    throw StateError('Expected logo paths, found ${paths.length}');
  }
  final dir = Directory('assets/images/brand/logo')
    ..createSync(recursive: true);
  for (final entity in dir.listSync()) {
    if (entity is File && entity.path.endsWith('.svg')) entity.deleteSync();
  }
  var glyph = 0;
  for (final match in paths) {
    final kind = match.group(1)!;
    final name = switch (kind) {
      'p-g' => 'g_${glyph.toString().padLeft(2, '0')}',
      'p-bg' => 'bg',
      'p-m' => 'm',
      'p-ring' => 'ring',
      'p-hole' => 'hole',
      _ => kind,
    };
    if (kind == 'p-g') glyph++;
    var body = match.group(0)!;
    if (kind == 'p-hole' && !body.contains('fill=')) {
      body = body.replaceFirst('<path ', '<path fill="#00A6F4" ');
    }
    File('${dir.path}/$name.svg').writeAsStringSync(_svg(_viewBox, body));
  }
}

void _writePodium(String html) {
  const open = 'const PODIUM_SVG = `';
  final start = html.indexOf(open);
  final from = start + open.length;
  final end = html.indexOf('`;', from);
  final svg = html.substring(from, end).trim();
  if (!svg.startsWith('<svg')) throw StateError('Podium SVG missing');
  final file = File('assets/images/onboarding/podium.svg');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    svg.contains('xmlns=')
        ? svg
        : svg.replaceFirst('<svg ', '<svg xmlns="http://www.w3.org/2000/svg" '),
  );
}

void _writeLaurel(String html) {
  final match = RegExp("const LAUREL_BIG = '([^']+)';").firstMatch(html);
  if (match == null) throw StateError('Laurel path missing');
  File('assets/images/onboarding/laurel.svg').writeAsStringSync(
    _svg(
      '0 0 34 49',
      '<path fill-rule="evenodd" clip-rule="evenodd" d="${match.group(1)}" fill="currentColor"/>',
    ),
  );
}

void _writeLaurelSmall(String html) {
  final match = RegExp("const LAUREL_SM = '([^']+)';").firstMatch(html);
  if (match == null) throw StateError('Small laurel path missing');
  File('assets/images/onboarding/laurel_small.svg').writeAsStringSync(
    _svg(
      '0 0 14 32',
      '<path fill-rule="evenodd" clip-rule="evenodd" d="${match.group(1)}" fill="currentColor"/>',
    ),
  );
}

List<String> _writeCards(String html) {
  final start = html.indexOf('const GC_IMG = {');
  final end = html.indexOf('};', start);
  final body = html.substring(start, end);
  final images = RegExp(r'"([A-Za-z0-9_]+)": "data:image/jpeg;base64,([^"]+)"')
      .allMatches(body)
      .toList();
  if (images.isEmpty) throw StateError('No onboarding card images');
  final dir = Directory('assets/images/onboarding/cards')
    ..createSync(recursive: true);
  final names = <String>[];
  for (final image in images) {
    final name = image.group(1)!;
    names.add(name);
    File('${dir.path}/$name.jpg')
        .writeAsBytesSync(base64Decode(image.group(2)!));
  }
  return names;
}

List<String> _writeAvatars() {
  final dir = Directory('assets/images/avatars')..createSync(recursive: true);
  final names = <String>[];
  for (final character in _characters) {
    final name = character['n']!.toLowerCase();
    names.add(name);
    File('${dir.path}/$name.svg').writeAsStringSync(_charSvg(character));
  }
  return names;
}

void _writeEvidence(
  String html, {
  required List<String> cards,
  required List<String> avatars,
}) {
  final confettiAt = html.indexOf('function confetti');
  final confettiWindow = html.substring(confettiAt, confettiAt + 4000);
  final confetti = RegExp(r'#[0-9A-Fa-f]{6}')
      .allMatches(confettiWindow)
      .map((m) => m.group(0)!.toUpperCase())
      .toSet()
      .toList();
  final dir = Directory('docs/snapshots/2026-10-26_html-prototype/evidence')
    ..createSync(recursive: true);
  final evidence = {
    'origin': 'HTML prototype docs/Sample/P2E - v1.0.html',
    'notFigma': true,
    'decisionIds': [
      'D-135',
      'D-136',
      'D-137',
      'D-138',
      'D-140',
      'D-141',
      'D-142',
    ],
    'logoViewBox': _viewBox,
    'logoHoleFill': '#00A6F4',
    'cards': cards,
    'avatars': avatars,
    'themes': _themes,
    'confetti': confetti,
    'colors': {
      'primaryPress': '#0093D8',
      'gold': '#FE9A00',
      'silver': '#737373',
      'bronze': '#E18651',
      'splashGradientStart': '#0369A1',
      'splashGradientMid': '#00A6F4',
      'splashGradientEnd': '#7DD3FC',
      'launchBackground': '#0A0A0A',
      'success': '#00C951',
      'playNowHover': '#000000',
      'glowViolet': '#5B21B6',
      'glowBlue': '#024A70',
      'glowOrange': '#EA580C',
    },
    'motion': {
      'ease': [0.22, 1.0, 0.36, 1.0],
      'spring': [0.34, 1.56, 0.64, 1.0],
      'easeIn': [0.4, 0.0, 1.0, 1.0],
      'easeInOut': [0.65, 0.0, 0.35, 1.0],
      'pressScale': 0.97,
      'pressMilliseconds': 160,
      'hoverMilliseconds': 280,
      'iconPressScale': 0.9,
      'quietPressScale': 0.95,
      'quietOpacity': 0.6,
      'rowPressScale': 0.985,
      'togglePressScale': 0.88,
      'socialHoverLift': 2.0,
      'socialHoverBrightness': 1.12,
      'playNowPressScale': 0.95,
      'viewMorePressScale': 0.96,
      'viewMoreHoverAlpha': 0.08,
      'indicatorPressScale': 0.94,
      'expandImageHoverScale': 1.08,
      'splashReducedMilliseconds': 600,
      'splashCollapseMilliseconds': 2150,
      'splashRevealMilliseconds': 3300,
      'splashRevealDurationMilliseconds': 950,
      'splashLoadDelayMilliseconds': 800,
      'splashLoadDurationMilliseconds': 1350,
      'revealStartRadius': 22.6,
      'revealEndRadius': 533.0,
      'ringRevealScale': 47.13,
      'onboardingPlayback': 1.45,
      'marqueeSeconds': [60, 52],
      'swipeThreshold': 60.0,
      'softOutMilliseconds': 750,
      'softInMilliseconds': 1050,
      'softInDelayMilliseconds': 220,
      'softOutScale': 0.955,
      'softInScale': 1.035,
      'softOutBlur': 8.0,
      'softInBlur': 6.0,
      'marqueeTiltDegrees': -12.0,
      'cardExtent': 120.0,
      'cardRadius': 16.0,
      'cardGap': 14.0,
      'edgeFadeStop': 0.15,
      'legalProgressExtent': 2.0,
      'landPopStart': 0.8,
      'landPopPeak': 1.12,
      'confettiGravity': 0.22,
      'legalEnterMilliseconds': 460,
      'legalExitMilliseconds': 300,
      'legalTopThreshold': 480.0,
      'legalIndicatorMilliseconds': 450,
      'legalSwipeThreshold': 70.0,
      'legalSwipeDominance': 1.6,
      'legalHighlightMilliseconds': 1800,
      'tourMoveMilliseconds': 600,
      'tourIntroMilliseconds': 700,
      'tourIntroInset': 14.0,
      'tourPulseMilliseconds': 2400,
      'tourPulseDelayMilliseconds': 500,
      'tourPulsePad': 8.0,
      'tourPulseAlpha': 0.9,
      'tourHoleBorderAlpha': 0.28,
      'tourFadeMilliseconds': 500,
      'tourTooltipWidth': 300.0,
      'tourTooltipGap': 14.0,
      'overlayAlpha': 0.7,
      'badgePopMilliseconds': 340,
      'avatarBadgeHoverScale': 1.1,
      'avatarBadgeHoverDegrees': -8.0,
      'verifiedDelayMilliseconds': 600,
      'bellPulseMilliseconds': 2600,
      'bellPulseDelayMilliseconds': 1300,
      'bellPulseScale': 1.55,
      'countUpMilliseconds': 1200,
      'countUpDelayMilliseconds': 250,
      'questFlyMilliseconds': 820,
      'questAddMilliseconds': 520,
      'climbMilliseconds': 1150,
      'confettiMilliseconds': 2600,
      'confettiCount': 110,
      'glowSeconds': [12, 15, 18],
      'questClockSeconds': 24469,
      'questDaySeconds': 86400,
      'questRingExtent': 176.0,
      'questRingRadius': 62.0,
      'questRingStroke': 8.0,
      'questRingTicks': 60,
      'questRingCenter': 75.0,
      'questRingEnterScale': 0.86,
      'questRingEnterDegrees': -8.0,
      'questPoints': [250, 500, 1000],
      'questTotal': 1750,
      'tourArrowExtent': 12.0,
      'tourArrowOutset': 5.0,
      'podiumHeight': 250.0,
      'podiumFirstTop': 5.0,
      'podiumSecondTop': 45.0,
      'podiumThirdTop': 70.0,
      'podiumSideOffset': 121.0,
      'climbRankStart': 28,
      'climbRankEnd': 1,
      'climbScoreStart': 584,
      'climbScoreEnd': 5325,
      'climbNeighborPoints': [4263, 3856, 3567, 2412, 2166],
      'climbSceneMilliseconds': 3950,
      'climbCountDelayMilliseconds': 1000,
      'climbCountMilliseconds': 1300,
      'climbMoveDelayMilliseconds': 1250,
      'climbFlyDelayMilliseconds': 2400,
      'climbFlyMilliseconds': 950,
      'climbRowExtent': 64.0,
      'climbBadgeExtent': 18.0,
      'sheetEnterMilliseconds': 460,
      'sheetExitMilliseconds': 280,
    },
    'onboarding': _onboardingNumbers,
    'onboardingColors': _onboardingColors,
    'onboardingCurves': _onboardingCurves,
  };
  File('${dir.path}/journey.json')
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(evidence));
}

/// Numbers read from the HTML onboarding CSS and timelines (D-138). A key ending
/// in `Ms` becomes a Duration; every other key keeps its number type.
const _onboardingNumbers = <String, num>{
  // Shell: .ob-text, .ob-dots, .ob-foot, .ob-skip, .ob-stage.
  'obTextInsetH': 24.0,
  'obTextBottom': 24.0,
  'obTextGap': 8.0,
  'obDotsGap': 6.0,
  'obDotSize': 6.0,
  'obDotActive': 20.0,
  'obDotsBottom': 20.0,
  'obFootInsetH': 20.0,
  'obFootBottom': 34.0,
  'obSkipHeight': 64.0,
  'obSkipEnd': 16.0,
  'obStageTop': 76.0,
  'obStageBottom': 16.0,
  'obStageInset': 16.0,
  'obStageLbBottom': 20.0,
  'obWallTop': 53.0,
  'obWallBleed': 4.0,
  'obRise': 16.0,
  'obFadeMs': 500,
  'obRiseMs': 600,
  'obRiseDelayMs': 80,
  'obDotMs': 400,
  'obPageMs': 700,
  // Slide 1: .gc-plane, .gc-row, .gcc.
  'obPlaneBleed': 110.0,
  'obPlaneTop': 14.0,
  'obPlaneGap': 22.0,
  'obRowPadV': 8.0,
  'obRowPadEnd': 14.0,
  'obCardGap': 8.0,
  'obCardInfoInset': 4.0,
  'obCardShadowY': 10.0,
  'obCardShadowBlur': 24.0,
  'obCardShadowAlpha': 0.45,
  'obRowFadeMs': 1000,
  'obRowFadeDelayMs': 150,
  'obGlowFadeMs': 1600,
  'obFadeSolid': 12.0,
  'obFadeTopSpan': 0.08,
  'obFadeBottomStop': 0.78,
  'obFadeBleed': 6.0,
  'obGlowOneTop': 180.0,
  'obGlowOneW': 460.0,
  'obGlowOneH': 300.0,
  'obGlowOneDx': -230.0,
  'obGlowOneAlpha': 0.40,
  'obGlowOneMidAlpha': 0.14,
  'obGlowOneScale': 1.08,
  'obGlowTwoTop': 250.0,
  'obGlowTwoW': 240.0,
  'obGlowTwoH': 200.0,
  'obGlowTwoDx': -200.0,
  'obGlowTwoAlpha': 0.38,
  'obGlowTwoShiftX': 120.0,
  'obGlowTwoShiftY': 50.0,
  'obGlowThreeTop': 360.0,
  'obGlowThreeW': 220.0,
  'obGlowThreeH': 180.0,
  'obGlowThreeDx': -10.0,
  'obGlowThreeAlpha': 0.26,
  'obGlowThreeShiftX': -110.0,
  'obGlowThreeShiftY': -40.0,
  'obGlowOneMs': 12000,
  'obGlowTwoMs': 15000,
  'obGlowThreeMs': 18000,
  'obMarqueeOneMs': 60000,
  'obMarqueeTwoMs': 52000,
  // Slide 2: .qs-*.
  'obQsGap': 14.0,
  'obClockSize': 40.0,
  'obClockLabelSize': 12.0,
  'obClockLabelLine': 14.0,
  'obClockSecSize': 13.0,
  'obClockGap': 3.0,
  'obClockMargin': 2.0,
  'obColonWidth': 0.32,
  'obColonLift': 0.06,
  'obStepsTop': 4.0,
  'obStepHeight': 62.0,
  'obStepBorder': 1.0,
  'obPulseInset': 6.0,
  'obStepRadius': 20.0,
  'obStepGap': 10.0,
  'obStepPadH': 16.0,
  'obStepInner': 12.0,
  'obNode': 30.0,
  'obNodeBorder': 2.0,
  'obNodeFont': 13.0,
  'obStepName': 15.0,
  'obStepNameLine': 20.0,
  'obStepBarGap': 8.0,
  'obBarHeight': 4.0,
  'obBarFraction': 0.6,
  'obTagPadH': 8.0,
  'obTagPadV': 4.0,
  'obTagRadius': 12.0,
  'obTagFont': 13.0,
  'obTagLine': 16.0,
  'obSegLeft': 31.5,
  'obSegWidth': 3.0,
  'obSeg1Top': 49.0,
  'obSeg1Height': 36.0,
  'obSeg2Top': 120.0,
  'obSeg2Height': 38.0,
  'obSegDot': 1.5,
  'obSegPitch': 7.0,
  'obSparkCount': 8,
  'obSparkSize': 5.0,
  'obSparkRadius': 20.0,
  'obSparkRadiusAlt': 6.0,
  'obSparkMs': 520,
  'obRingGlowInset': 22.0,
  'obRingEnterMs': 800,
  'obRingFadeMs': 500,
  'obTotalEnterMs': 600,
  'obTotalDelayMs': 150,
  'obTotalFadeMs': 450,
  'obTotalRise': 8.0,
  'obStepEnterMs': 600,
  'obStepDelayMs': 250,
  'obStepStaggerMs': 80,
  'obStepRise': 14.0,
  'obArcDelayMs': 220,
  'obArcMs': 1150,
  'obStepOneMs': 760,
  'obLineGapMs': 1180,
  'obLineMs': 420,
  'obTokenRise': 6.0,
  'obTokenArc': 30.0,
  'obBumpMs': 500,
  'obBumpScale': 1.1,
  'obNodePopMs': 450,
  'obOdometerMs': 500,
  'obPulseMs': 1700,
  'obSpinMs': 3200,
  'obGlowMs': 3200,
  'obHaloMs': 1000,
  'obShineMs': 1800,
  'obMarchMs': 800,
  'obBarFillMs': 1100,
  'obTickBigInner': 68.5,
  'obTickSmallInner': 69.5,
  'obTickOuter': 72.5,
  'obTickBigWidth': 1.6,
  'obTickSmallWidth': 1.1,
  'obTipHalo': 7.0,
  'obTipDot': 4.2,
  'obRingViewBox': 150.0,
  // Slide 3: .pu, .lb-*, .lbchip.
  'obPuWidth': 120.0,
  'obPuGap': 8.0,
  'obLaurelWidth': 100.0,
  'obLaurelTop': 8.0,
  'obLaurelLeafW': 34.0,
  'obLaurelLeafH': 49.0,
  'obLaurelGap': 18.0,
  'obRankBadgeFont': 10.0,
  'obRankBadgeOutset': 8.0,
  'obSkelHeight': 12.0,
  'obSkelZ': 78.0,
  'obSkelM': 70.0,
  'obSkelN': 86.0,
  'obSkelH': 108.0,
  'obSkelF': 92.0,
  'obSkelA': 82.0,
  'obSkelRowExtra': 16.0,
  'obSlotPitch': 74.0,
  'obLandPeakAt': 0.55,
  'obSkelTop': 8.0,
  'obSkelBottom': 4.0,
  'obSkelRadius': 6.0,
  'obChipPadStart': 4.0,
  'obChipPadEnd': 8.0,
  'obChipPadV': 4.0,
  'obChipIcon': 20.0,
  'obChipCrown': 16.0,
  'obChipGap': 4.0,
  'obChipCrownGap': 6.0,
  'obChipRadius': 16.0,
  'obChipFont': 14.0,
  'obChipLine': 18.0,
  'obSheetRadius': 26.0,
  'obSheetPad': 10.0,
  'obSheetGap': 10.0,
  'obSheetInset': 10.0,
  'obSheetShadowBlur': 14.0,
  'obSheetShadowY': -4.0,
  'obSheetShadowAlpha': 0.35,
  'obBoardRadius': 20.0,
  'obBoardPadH': 16.0,
  'obBoardGap': 12.0,
  'obBoardBorder': 1.5,
  'obBoardShadowBlur': 26.0,
  'obBoardShadowY': -14.0,
  'obBoardShadowAlpha': 0.6,
  'obRiseGlow': 4.0,
  'obRiseGlowAlpha': 0.14,
  'obRankLeafW': 14.0,
  'obRankLeafH': 32.0,
  'obRankFont': 16.0,
  'obRankMinWidth': 10.0,
  'obNameFont': 16.0,
  'obNameLine': 20.0,
  'obBlocksWidth': 370.0,
  'obBlocksHeight': 120.0,
  'obPuHover': 6.0,
  'obPuHoverMs': 3400,
  'obPuEnterMs': 450,
  'obPuRiseMs': 600,
  'obPuRise': 18.0,
  'obPuDelayOneMs': 500,
  'obPuDelayTwoMs': 620,
  'obPuDelayThreeMs': 740,
  'obPuMoveMs': 750,
  'obPuOutRise': 26.0,
  'obPuOutScale': 0.85,
  'obBlocksDelayMs': 100,
  'obBlocksFadeMs': 600,
  'obBlocksRiseMs': 800,
  'obBlocksRise': 40.0,
  'obSheetDelayMs': 300,
  'obSheetFadeMs': 500,
  'obSheetRiseMs': 700,
  'obSheetRise': 30.0,
  'obLiftMs': 320,
  'obLiftScale': 1.04,
  'obClimbPeakScale': 1.06,
  'obClimbPeakShift': -4.0,
  'obClimbSettle': -3.0,
  'obRowOneDelayMs': 170,
  'obRowTwoDelayMs': 520,
  'obRowMoveMs': 560,
  'obRankChangeMs': 200,
  'obSwapOneMs': 260,
  'obSwapTwoMs': 360,
  'obSwapOutMs': 170,
  'obSwapInMs': 280,
  'obSwapShift': 8.0,
  'obFlyArc': 40.0,
  'obFlyPeakScale': 1.25,
  'obLandMs': 600,
  'lgBar': 64.0,
  'lgBarInset': 16.0,
  'lgTabsInsetH': 16.0,
  'lgTabsBottom': 12.0,
  'lgTabsHeight': 44.0,
  'lgTabsPad': 4.0,
  'lgTabsRadius': 14.0,
  'lgIndRadius': 10.0,
  'lgScrollTop': 20.0,
  'lgScrollH': 16.0,
  'lgScrollBottom': 120.0,
  'lgMetaGap': 8.0,
  'lgMetaDot': 3.0,
  'lgMetaInset': 4.0,
  'lgMetaBottom': 16.0,
  'lgKeyPad': 16.0,
  'lgKeyRadius': 20.0,
  'lgKeyBottom': 12.0,
  'lgKeyTitleGap': 12.0,
  'lgKeyListGap': 12.0,
  'lgKeyItemGap': 10.0,
  'lgTagPadH': 6.0,
  'lgTagPadV': 3.0,
  'lgTagRadius': 6.0,
  'lgTagGap': 8.0,
  'lgTocPad': 8.0,
  'lgTocBottom': 28.0,
  'lgTocHeadPadH': 8.0,
  'lgTocHeadTop': 8.0,
  'lgTocHeadBottom': 6.0,
  'lgTocRowH': 40.0,
  'lgTocRowPadH': 8.0,
  'lgTocRowRadius': 12.0,
  'lgTocRowGap': 12.0,
  'lgNumSize': 22.0,
  'lgNumRadius': 7.0,
  'lgChevron': 16.0,
  'lgChevronNudge': 3.0,
  'lgSecInset': 4.0,
  'lgSecBottom': 24.0,
  'lgSecGap': 6.0,
  'lgSecTitleBottom': 8.0,
  'lgHlMark': 10.0,
  'lgHlWidth': 3.0,
  'lgEndTop': 8.0,
  'lgEndPadTop': 20.0,
  'lgFootTop': 28.0,
  'lgFootBottom': 34.0,
  'lgFootH': 16.0,
  'lgFootGap': 8.0,
  'lgTopBtn': 46.0,
  'lgTopBtnRadius': 12.0,
  'lgDocShift': 28.0,
  'lgIntroRise': 14.0,
  'lgShadowBlur': 24.0,
  'lgShadowDy': 10.0,
  'lgShadowAlpha': 0.55,
  'lgScrolledAt': 4.0,
  'lgCheck': 20.0,
  'lgKeyTint': 0.07,
  'lgKeyRing': 0.12,
  'lgCheckFill': 0.14,
  'lgTagFill': 0.1,
  'lgTitleSize': 18.0,
  'lgTitleLine': 24.0,
  'lgTitleSpace': -0.04,
  'lgTabSize': 14.0,
  'lgTabLine': 18.0,
  'lgTabSpace': -0.04,
  'lgMetaSize': 13.0,
  'lgMetaLine': 16.0,
  'lgMetaSpace': -0.02,
  'lgKeyTitleSize': 16.0,
  'lgKeyTitleLine': 20.0,
  'lgKeyTitleSpace': -0.04,
  'lgKeyTextSize': 14.0,
  'lgKeyTextLine': 19.0,
  'lgKeyTextSpace': -0.02,
  'lgTagSize': 11.0,
  'lgTagLine': 13.0,
  'lgTagSpace': 0.02,
  'lgTocHeadSize': 12.0,
  'lgTocHeadLine': 16.0,
  'lgTocHeadSpace': 0.04,
  'lgTocRowSize': 14.0,
  'lgTocRowLine': 18.0,
  'lgTocRowSpace': -0.02,
  'lgNumTextSize': 12.0,
  'lgSecTitleSize': 17.0,
  'lgSecTitleLine': 22.0,
  'lgSecTitleSpace': -0.04,
  'lgSecBodySize': 15.0,
  'lgSecBodyLine': 23.0,
  'lgSecBodySpace': -0.01,
  'lgEndSize': 13.0,
  'lgEndLine': 18.0,
  'pgInShift': 28.0,
  'pgOutShift': 30.0,
  'pgOutScale': 0.985,
  'cbBox': 20.0,
  'cbRadius': 8.0,
  'cbBorder': 1.5,
  'cbPad': 8.0,
  'cbPress': 0.88,
  'cbTickW': 9.0,
  'cbTickH': 5.0,
  'cbTickStroke': 2.0,
  'cbTickNudge': 1.0,
  'cbLabelPad': 4.0,
  'cbLabelSize': 16.0,
  'cbLabelLine': 20.0,
  'cbFocusRing': 2.0,
  'cbFocusGap': 2.0,
  'lgDocMs': 380,
  'lgIntroMs': 520,
  'lgIntroDelayMs': 160,
  'lgIntroStepMs': 60,
  'lgTopBtnMs': 400,
  'lgFadeMs': 250,
  'lgSlideMs': 380,
  'pgInMs': 420,
  'pgInDelayMs': 50,
  'pgOutMs': 260,
  'cbMs': 200,
  'cbPopMs': 320,
  'cbPressMs': 160,
  // Centered header screens, items and rewards (HTML .ch, .items, .item, .reward).
  'jlHeadTop': 64.0,
  'jlHeadH': 24.0,
  'jlHeadGap': 24.0,
  'jlTextGap': 8.0,
  'jlTitle': 24.0,
  'jlTitleLine': 30.0,
  'jlTitleLg': 28.0,
  'jlTitleLgLine': 36.0,
  'jlBody': 16.0,
  'jlBodyLine': 20.0,
  'jlBodyMax': 354.0,
  'jlCircle': 96.0,
  'jlItemsPad': 24.0,
  'jlItemsGap': 12.0,
  'jlItemGap': 8.0,
  'jlItemIc': 52.0,
  'jlItemRadius': 16.0,
  'jlItemPad': 16.0,
  'jlCtaPad': 20.0,
  'jlCtaGap': 14.0,
  'jlBadge': 34.0,
  'jlBadgeBorder': 4.0,
  'jlRewardPad': 12.0,
  'jlRewardGap': 10.0,
  'jlRewardIc': 48.0,
  'jlRewardIcRadius': 12.0,
  'jlRewardAmt': 20.0,
  'jlRewardPts': 16.0,
  'jlRewardSub': 14.0,
  'jlRewardSubLine': 18.0,
  'jlChipH': 32.0,
  'jlChipIc': 24.0,
  // Avatar picker (HTML .picker, .alist, .tlist, .sheet).
  'avEdit': 32.0,
  'avTopGap': 12.0,
  'avGap': 24.0,
  'avNick': 20.0,
  'avNickLine': 26.0,
  'avTtl': 14.0,
  'avTtlLine': 18.0,
  'avGrpGap': 16.0,
  'avListGap': 10.0,
  'avQuick': 52.0,
  'avRing': 4.0,
  'avRingInset': 5.0,
  'avTheme': 24.0,
  'avThemeRing': 2.0,
  'avThemeInset': 4.0,
  'shGrabW': 40.0,
  'shGrabH': 5.0,
  'shPadTop': 10.0,
  'shPadH': 20.0,
  'shPadBottom': 30.0,
  'shGap': 16.0,
  'shTitle': 20.0,
  'shTitleLine': 26.0,
  'shBody': 16.0,
  'shBodyLine': 20.0,
  'shGridGap': 12.0,
  'shGridCols': 4,
  'shUploadH': 46.0,
  'shUploadRadius': 12.0,
  'shMaxFraction': 0.88,
  // Username (HTML .ideas, .status-badge).
  'unIdeasGap': 12.0,
  'unIdeasPadV': 12.0,
  'unChipH': 36.0,
  'unChipRadius': 10.0,
  'unChipGap': 8.0,
  'unChipText': 14.0,
  'unChipLine': 18.0,
  'unBadgePadV': 6.0,
  'unBadgePadH': 8.0,
  'unBadgeRadius': 10.0,
  'unBadgeText': 14.0,
  'unBadgeLine': 18.0,
  'unCheckMs': 450,
  'unTrailInset': 16.0,
  // Tour (HTML .tour-tip, .tour-n, buttons).
  'trTipPad': 16.0,
  'trTipRadius': 20.0,
  'trTitle': 18.0,
  'trTitleLine': 24.0,
  'trBody': 14.0,
  'trBodyLine': 18.0,
  'trBodyGap': 4.0,
  'trFootGap': 16.0,
  'trBtnGap': 8.0,
  'trBtnH': 36.0,
  'trBtnPadH': 12.0,
  'trBtnRadius': 10.0,
  'trNextMin': 64.0,
  'trPillW': 16.0,
  'trPillOnW': 28.0,
  'trPillH': 4.0,
  'trPillGap': 4.0,
  'trMargin': 16.0,
  'trTipFit': 170.0,
  'trScrollMin': 140.0,
  'trScrollNavReserve': 96.0,
  'trScrollTipReserve': 190.0,
  'trScrollOffset': 200.0,
  'trScrollOffsetQuests': 150.0,
  'trScrollMs': 520,
  'trShowDelayMs': 180,
  'trArrowEdge': 18.0,
  'trHoleEdge': 6.0,
  'trTipRise': 8.0,
  'trPad': 6.0,
  'trPadCard': 8.0,
  'trRadius': 20.0,
  'trRadiusCard': 22.0,
  'trShadowBlur': 40.0,
  'trShadowY': 16.0,
  'obTickViewBox': 24.0,
  'obTickSize': 14.0,
  'obTickStroke': 3.4,
  'obTickDrawDelayMs': 80,
  'obTickDrawMs': 350,
  'obCfWidth': 402.0,
  'obCfHeight': 874.0,
  'obCfSideCount': 70,
  'obCfTopCount': 60,
  'obCfSideY': 600.0,
  'obCfSideOut': 10.0,
  'obCfTopY': 190.0,
  'obCfDrag': 0.985,
  'obCfGravity': 0.3,
  'obCfMaxMs': 6500,
  'obCfFrame': 16.667,
  'obCfLeftA0': -78.0,
  'obCfLeftA1': -42.0,
  'obCfRightA0': -138.0,
  'obCfRightA1': -102.0,
  'obCfSideV0': 11.0,
  'obCfSideV1': 18.0,
  'obCfTopA0': -170.0,
  'obCfTopA1': -10.0,
  'obCfTopV0': 3.0,
  'obCfTopV1': 10.0,
  'obCfW0': 5.0,
  'obCfWRange': 5.0,
  'obCfH0': 9.0,
  'obCfHRange': 8.0,
  'obCfSpin': 0.35,
  'obCfFlip0': 0.07,
  'obCfFlipRange': 0.12,
  'obCfRound': 0.22,
};

const _onboardingCurves = <String, List<double>>{
  'obPageCurve': [0.6, 0.0, 0.25, 1.0],
  'obOdometerCurve': [0.3, 1.25, 0.4, 1.0],
  'obTokenCurve': [0.45, 0.0, 0.25, 1.0],
  'obClimbCurve': [0.45, 0.0, 0.2, 1.0],
  'obRowCurve': [0.3, 0.7, 0.2, 1.0],
  'obFlyCurve': [0.55, 0.0, 0.25, 1.0],
  'obSwapInCurve': [0.2, 0.8, 0.2, 1.0],
  'obLiftCurve': [0.3, 0.7, 0.2, 1.0],
};

const _onboardingColors = <String, String>{
  'obWhite': '#FFFFFF',
  'jlRose': '#FF2056',
  'jlSurface': '#0A0A0A',
  'jlSkipFill': '#000000',
  'jlCyanDone': '#004A74',
  'obTrack': '#1F1F1F',
  'obTickBig': '#404040',
  'obTickSmall': '#262626',
  'obNodeLine': '#404040',
  'obNodeFill': '#14212A',
  'obSuccessLight': '#2EE883',
  'obSparkLight': '#7DFFB0',
  'obSky': '#38BDF8',
  'obGray': '#A1A1A1',
  'obGrayLight': '#E5E5E5',
  'obSkeletonDark': '#262626',
  'obSkeletonLight': '#404040',
  'obOnDarkSoft': '#F5F5F5',
  'obBarTrack': '#262626',
  'obSegTrack': '#262626',
  'obCf0': '#00A6F4',
  'obCf1': '#FF2056',
  'obCf2': '#FE9A00',
  'obCf3': '#00C951',
  'obCf4': '#EEB0C6',
  'obCf5': '#A1F2DC',
  'obCf6': '#D0C4E8',
  'obCf7': '#FFD166',
  'obCf8': '#C0F0FF',
  'obCf9': '#FFFFFF',
  'lgKeyText': '#D4D4D4',
  'lgTocText': '#E5E5E5',
};

String _svg(String viewBox, String body) =>
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="$viewBox" fill="none">$body</svg>\n';

String _shade(String hex, double factor) {
  final n = int.parse(hex.substring(1), radix: 16);
  int channel(int shift) {
    final value = ((n >> shift) & 255) * factor;
    return value.round().clamp(0, 255);
  }

  return 'rgb(${channel(16)},${channel(8)},${channel(0)})';
}

String _charSvg(Map<String, String> ch) {
  final c = ch['c']!;
  final d = _shade(c, 0.7);
  const ink = '#16181F';
  final ring = c == '#FFFFFF' ? 'stroke="#D0D0D0"' : '';
  final body = switch (ch['s']) {
    'round' => '<circle cx="50" cy="62" r="27" fill="$c"/>',
    'square' =>
      '<rect x="24" y="36" width="52" height="50" rx="16" fill="$c"/>',
    'blob' =>
      '<path d="M50 34c22 0 29 14 29 29 0 16-12 24-29 24S21 79 21 63c0-15 7-29 29-29z" fill="$c"/>',
    'ghost' =>
      '<path d="M25 62c0-16 11-27 25-27s25 11 25 27v26l-8-6-8.5 6-8.5-6-8.5 6-8.5-6-8 6z" fill="$c"/>',
    'tri' => '<path d="M50 33l29 50q2 5-4 5H25q-6 0-4-5z" fill="$c"/>',
    _ => '',
  };
  final top = switch (ch['t']) {
    'antenna' =>
      '<path d="M50 36V21" stroke="$d" stroke-width="3" stroke-linecap="round"/><circle cx="50" cy="19" r="5" fill="$d"/>',
    'leaf' =>
      '<path d="M50 35c-2-10 4-16 14-16-1 10-6 15-14 16z" fill="#1F9A5A"/>',
    'horns' => '<path d="M34 42l-6-16 14 10zM66 42l6-16-14 10z" fill="$d"/>',
    'ears' =>
      '<circle cx="31" cy="41" r="9" fill="$c"/><circle cx="69" cy="41" r="9" fill="$c"/><circle cx="31" cy="41" r="4" fill="$d"/><circle cx="69" cy="41" r="4" fill="$d"/>',
    'crown' => '<path d="M36 38l3-14 7 8 4-10 4 10 7-8 3 14z" fill="#FFC94A" stroke="#C99520" stroke-width="1.5" stroke-linejoin="round"/>',
    _ => '',
  };
  final ey = ch['s'] == 'tri' ? 66 : 60;
  final my = ey + 14;
  final eyes = switch (ch['e']) {
    'dots' =>
      '<circle cx="41" cy="$ey" r="4" fill="$ink"/><circle cx="59" cy="$ey" r="4" fill="$ink"/>',
    'big' =>
      '<circle cx="40" cy="$ey" r="8" fill="#fff" $ring/><circle cx="60" cy="$ey" r="8" fill="#fff" $ring/><circle cx="42" cy="${ey + 1}" r="4" fill="$ink"/><circle cx="62" cy="${ey + 1}" r="4" fill="$ink"/>',
    'cyclops' =>
      '<circle cx="50" cy="${ey - 1}" r="11" fill="#fff"/><circle cx="51" cy="$ey" r="5.5" fill="$ink"/><circle cx="53" cy="${ey - 2}" r="1.6" fill="#fff"/>',
    'visor' =>
      '<rect x="31" y="${ey - 7}" width="38" height="13" rx="6.5" fill="$ink"/><rect x="36" y="${ey - 4}" width="12" height="3" rx="1.5" fill="#7FD3FF"/>',
    'sleepy' =>
      '<path d="M35 ${ey}q5 5 10 0M55 ${ey}q5 5 10 0" stroke="$ink" stroke-width="3" fill="none" stroke-linecap="round"/>',
    _ => '',
  };
  final mouth = switch (ch['m']) {
    'smile' =>
      '<path d="M43 ${my}q7 7 14 0" stroke="$ink" stroke-width="3" fill="none" stroke-linecap="round"/>',
    'open' => '<ellipse cx="50" cy="${my + 1}" rx="6" ry="4.5" fill="$ink"/>',
    'flat' =>
      '<path d="M44 ${my + 1}h12" stroke="$ink" stroke-width="3" stroke-linecap="round"/>',
    'fang' =>
      '<path d="M42 ${my}q8 7 16 0" stroke="$ink" stroke-width="3" fill="none" stroke-linecap="round"/><path d="M45 ${my + 2.5}l2 4 2-3.4z" fill="#fff"/>',
    _ => '',
  };
  return _svg('0 0 100 100', '$top$body$eyes$mouth');
}

const _themes = [
  {'name': 'Purple', 'container': '#D0C4E8', 'onContainer': '#604598'},
  {'name': 'Teal', 'container': '#D3F7FF', 'onContainer': '#014F5A'},
  {'name': 'Pink', 'container': '#EEB0C6', 'onContainer': '#83244D'},
  {'name': 'Cyan', 'container': '#C0F0FF', 'onContainer': '#004A74'},
  {'name': 'Emerald', 'container': '#A1F2DC', 'onContainer': '#005143'},
];

const _characters = [
  {
    'n': 'Bolt',
    's': 'round',
    'c': '#FFC94A',
    'e': 'big',
    'm': 'smile',
    't': 'antenna',
  },
  {
    'n': 'Mossy',
    's': 'blob',
    'c': '#4CC27F',
    'e': 'dots',
    'm': 'open',
    't': 'leaf',
  },
  {
    'n': 'Byte',
    's': 'square',
    'c': '#3E9BEA',
    'e': 'visor',
    'm': 'flat',
    't': 'antenna',
  },
  {
    'n': 'Ember',
    's': 'tri',
    'c': '#FF7A59',
    'e': 'big',
    'm': 'fang',
    't': 'horns',
  },
  {
    'n': 'Boo',
    's': 'ghost',
    'c': '#FFFFFF',
    'e': 'big',
    'm': 'open',
    't': 'none',
  },
  {
    'n': 'Pip',
    's': 'round',
    'c': '#FF7FB6',
    'e': 'dots',
    'm': 'smile',
    't': 'ears',
  },
  {
    'n': 'Rook',
    's': 'square',
    'c': '#8B78F5',
    'e': 'cyclops',
    'm': 'smile',
    't': 'crown',
  },
  {
    'n': 'Fizz',
    's': 'blob',
    'c': '#2BC7C7',
    'e': 'sleepy',
    'm': 'smile',
    't': 'antenna',
  },
  {
    'n': 'Grim',
    's': 'ghost',
    'c': '#7D889C',
    'e': 'cyclops',
    'm': 'flat',
    't': 'horns',
  },
  {
    'n': 'Nova',
    's': 'tri',
    'c': '#F5B83D',
    'e': 'dots',
    'm': 'open',
    't': 'crown',
  },
  {
    'n': 'Chomp',
    's': 'round',
    'c': '#6FD35B',
    'e': 'big',
    'm': 'fang',
    't': 'ears',
  },
  {
    'n': 'Glitch',
    's': 'square',
    'c': '#F0487A',
    'e': 'visor',
    'm': 'open',
    't': 'horns',
  },
];
