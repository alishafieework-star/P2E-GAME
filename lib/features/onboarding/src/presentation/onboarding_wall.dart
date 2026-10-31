import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:mygame_p2e/shared/widgets/rating_badge.dart';
import 'package:p2e_design_system/design_system.dart';

import 'onboarding_timing.dart';

const _rowOne = ['sifu', 'kings', 'dome', 'snack', 'railway', 'letter'];
const _rowTwo = ['chess', 'grabby', 'hokm', 'backgammon', 'poker', 'letter'];

/// Tilted dual marquee from the HTML game wall (D-138). Decorative, so it is
/// hidden from screen readers and ignores the text scale like the prototype.
class OnboardingWall extends StatefulWidget {
  const OnboardingWall({super.key, required this.active});

  final bool active;

  @override
  State<OnboardingWall> createState() => _OnboardingWallState();
}

class _OnboardingWallState extends State<OnboardingWall>
    with TickerProviderStateMixin {
  late final ScenePlayer player;

  @override
  void initState() {
    super.initState();
    player = ScenePlayer(
      vsync: this,
      length:
          HtmlJourneyTokens.obRowFadeDelayMs + HtmlJourneyTokens.obGlowFadeMs,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    player.sync(context, active: widget.active, restart: false);
  }

  @override
  void didUpdateWidget(OnboardingWall oldWidget) {
    super.didUpdateWidget(oldWidget);
    player.sync(
      context,
      active: widget.active,
      restart: widget.active && !oldWidget.active,
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final tilt =
        HtmlJourneyTokens.marqueeTiltDegrees * (rtl ? -1 : 1) * math.pi / 180;
    final top = MediaQuery.paddingOf(context).top;
    return ExcludeSemantics(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: AnimatedBuilder(
          animation: player.listenable,
          builder: (context, _) {
            final base = player.base;
            final glow = window(
              base,
              Duration.zero,
              HtmlJourneyTokens.obGlowFadeMs,
              HtmlJourneyTokens.ease,
            );
            final rows = [
              window(
                base,
                Duration.zero,
                HtmlJourneyTokens.obRowFadeMs,
                HtmlJourneyTokens.ease,
              ),
              window(
                base,
                HtmlJourneyTokens.obRowFadeDelayMs,
                HtmlJourneyTokens.obRowFadeMs,
                HtmlJourneyTokens.ease,
              ),
            ];
            return Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                Opacity(
                  opacity: glow,
                  child: _Glows(
                    first: player.cycle(HtmlJourneyTokens.obGlowOneMs),
                    second: player.cycle(HtmlJourneyTokens.obGlowTwoMs),
                    third: player.cycle(HtmlJourneyTokens.obGlowThreeMs),
                  ),
                ),
                PositionedDirectional(
                  start: -HtmlJourneyTokens.obWallBleed,
                  end: -HtmlJourneyTokens.obWallBleed,
                  top: top + HtmlJourneyTokens.obWallTop,
                  bottom: -HtmlJourneyTokens.obWallBleed,
                  child: ClipRect(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final plane =
                            constraints.maxWidth +
                            HtmlJourneyTokens.obPlaneBleed * 2;
                        return OverflowBox(
                          minWidth: plane,
                          maxWidth: plane,
                          maxHeight: double.infinity,
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              top: HtmlJourneyTokens.obPlaneTop,
                            ),
                            child: Transform.rotate(
                              angle: tilt,
                              child: SizedBox(
                                width: plane,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Opacity(
                                      opacity: rows[0],
                                      child: _WallRow(
                                        ids: _rowOne,
                                        reverse: false,
                                        phase: player.cycle(
                                          HtmlJourneyTokens.obMarqueeOneMs,
                                        ),
                                        moving: widget.active,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: HtmlJourneyTokens.obPlaneGap,
                                    ),
                                    Opacity(
                                      opacity: rows[1],
                                      child: _WallRow(
                                        ids: _rowTwo,
                                        reverse: true,
                                        phase: player.cycle(
                                          HtmlJourneyTokens.obMarqueeTwoMs,
                                        ),
                                        moving: widget.active,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: -HtmlJourneyTokens.obFadeBleed,
                  end: -HtmlJourneyTokens.obFadeBleed,
                  top:
                      top +
                      HtmlJourneyTokens.obWallTop -
                      HtmlJourneyTokens.obFadeBleed,
                  bottom: -HtmlJourneyTokens.obFadeBleed,
                  child: const _EdgeFade(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EdgeFade extends StatelessWidget {
  const _EdgeFade();

  @override
  Widget build(BuildContext context) {
    final ink = HtmlJourneyTokens.launchBackground;
    final clear = ink.withValues(alpha: 0);
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final solidX = HtmlJourneyTokens.obFadeSolid / w;
          final solidY = HtmlJourneyTokens.obFadeSolid / h;
          return Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.centerStart,
                    end: AlignmentDirectional.centerEnd,
                    colors: [ink, ink, clear, clear, ink, ink],
                    stops: [
                      0,
                      solidX,
                      HtmlJourneyTokens.edgeFadeStop,
                      1 - HtmlJourneyTokens.edgeFadeStop,
                      1 - solidX,
                      1,
                    ],
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [ink, ink, clear, clear, ink, ink],
                    stops: [
                      0,
                      solidY,
                      solidY + HtmlJourneyTokens.obFadeTopSpan,
                      HtmlJourneyTokens.obFadeBottomStop,
                      1 - solidY,
                      1,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Glows extends StatelessWidget {
  const _Glows({
    required this.first,
    required this.second,
    required this.third,
  });

  final double first;
  final double second;
  final double third;

  double _wave(double cycle) =>
      HtmlJourneyTokens.easeInOut.transform(1 - (2 * cycle - 1).abs());

  @override
  Widget build(BuildContext context) {
    final one = _wave(first);
    final two = _wave(second);
    final three = _wave(third);
    return LayoutBuilder(
      builder: (context, constraints) {
        final mid = constraints.maxWidth / 2;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: mid + HtmlJourneyTokens.obGlowOneDx,
              top: HtmlJourneyTokens.obGlowOneTop,
              child: Transform.scale(
                scale: 1 + (HtmlJourneyTokens.obGlowOneScale - 1) * one,
                child: _Glow(
                  width: HtmlJourneyTokens.obGlowOneW,
                  height: HtmlJourneyTokens.obGlowOneH,
                  color: HtmlJourneyTokens.glowViolet,
                  alpha: HtmlJourneyTokens.obGlowOneAlpha,
                  midAlpha: HtmlJourneyTokens.obGlowOneMidAlpha,
                ),
              ),
            ),
            Positioned(
              left: mid + HtmlJourneyTokens.obGlowTwoDx,
              top: HtmlJourneyTokens.obGlowTwoTop,
              child: Transform.translate(
                offset: Offset(
                  HtmlJourneyTokens.obGlowTwoShiftX * two,
                  HtmlJourneyTokens.obGlowTwoShiftY * two,
                ),
                child: _Glow(
                  width: HtmlJourneyTokens.obGlowTwoW,
                  height: HtmlJourneyTokens.obGlowTwoH,
                  color: HtmlJourneyTokens.glowBlue,
                  alpha: HtmlJourneyTokens.obGlowTwoAlpha,
                ),
              ),
            ),
            Positioned(
              left: mid + HtmlJourneyTokens.obGlowThreeDx,
              top: HtmlJourneyTokens.obGlowThreeTop,
              child: Transform.translate(
                offset: Offset(
                  HtmlJourneyTokens.obGlowThreeShiftX * three,
                  HtmlJourneyTokens.obGlowThreeShiftY * three,
                ),
                child: _Glow(
                  width: HtmlJourneyTokens.obGlowThreeW,
                  height: HtmlJourneyTokens.obGlowThreeH,
                  color: HtmlJourneyTokens.glowOrange,
                  alpha: HtmlJourneyTokens.obGlowThreeAlpha,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({
    required this.width,
    required this.height,
    required this.color,
    required this.alpha,
    this.midAlpha,
  });

  final double width;
  final double height;
  final Color color;
  final double alpha;
  final double? midAlpha;

  @override
  Widget build(BuildContext context) {
    final mid = midAlpha;
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox.square(
          dimension: width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: alpha),
                  if (mid != null) color.withValues(alpha: mid),
                  color.withValues(alpha: 0),
                ],
                stops: mid == null ? null : const [0, 0.64, 0.99],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WallRow extends StatelessWidget {
  const _WallRow({
    required this.ids,
    required this.reverse,
    required this.phase,
    required this.moving,
  });

  final List<String> ids;
  final bool reverse;
  final double phase;
  final bool moving;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final travel =
        ids.length * (HtmlJourneyTokens.cardExtent + HtmlJourneyTokens.cardGap);
    final reduced = MediaQuery.disableAnimationsOf(context);
    final shift = reduced || !moving
        ? 0.0
        : (reverse ? (phase - 1) * travel : -phase * travel);
    return UnconstrainedBox(
      alignment: AlignmentDirectional.centerStart,
      clipBehavior: Clip.hardEdge,
      child: Transform.translate(
        offset: Offset(shift * (rtl ? -1 : 1), 0),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            top: HtmlJourneyTokens.obRowPadV,
            bottom: HtmlJourneyTokens.obRowPadV,
            end: HtmlJourneyTokens.obRowPadEnd,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final id in [...ids, ...ids]) ...[
                _GameCard(id: id),
                const SizedBox(width: HtmlJourneyTokens.cardGap),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Game Compact Card layout (detailed), drawn with its Home tokens. The art
/// already carries the reward chip, so no second overlay is added.
class _GameCard extends StatelessWidget {
  const _GameCard({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final (name, studio, rating) = switch (id) {
      'sifu' => (
        strings.onboardingGameSifu,
        strings.onboardingStudioKepler,
        4.4,
      ),
      'kings' => (
        strings.onboardingGameKings,
        strings.onboardingStudioPlaydigious,
        3.6,
      ),
      'dome' => (
        strings.onboardingGameDome,
        strings.onboardingStudioRawFury,
        2.1,
      ),
      'snack' => (
        strings.onboardingGameSnack,
        strings.onboardingStudioTepes,
        4.4,
      ),
      'chess' => (
        strings.onboardingGameChess,
        strings.onboardingStudioChess,
        4.9,
      ),
      'hokm' => (
        strings.onboardingGameHokm,
        strings.onboardingStudioToofun,
        4.3,
      ),
      'backgammon' => (
        strings.onboardingGameBackgammon,
        strings.onboardingStudioEasybrain,
        5.0,
      ),
      'poker' => (
        strings.onboardingGamePoker,
        strings.onboardingStudioZynga,
        3.6,
      ),
      'railway' => (
        strings.onboardingGameRailway,
        strings.onboardingStudioDarkmater,
        4.4,
      ),
      'grabby' => (
        strings.onboardingGameGrabby,
        strings.onboardingStudioTepes,
        4.4,
      ),
      _ => (strings.onboardingGameLetter, strings.onboardingStudioOlivia, 4.4),
    };
    final shown = formatRating(rating, languageCode: language);
    final supporting = HomeRoles.infoSupporting.resolve(context);
    return SizedBox(
      width: HtmlJourneyTokens.cardExtent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(HtmlJourneyTokens.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: HtmlJourneyTokens.playNowHover.withValues(
                    alpha: HtmlJourneyTokens.obCardShadowAlpha,
                  ),
                  offset: const Offset(0, HtmlJourneyTokens.obCardShadowY),
                  blurRadius: HtmlJourneyTokens.obCardShadowBlur,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(HtmlJourneyTokens.cardRadius),
              child: Image.asset(
                'assets/images/onboarding/cards/$id.jpg',
                width: HtmlJourneyTokens.cardExtent,
                height: HtmlJourneyTokens.cardExtent,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
            ),
          ),
          const SizedBox(height: HtmlJourneyTokens.obCardGap),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: HomeTokens.compactInfoPadHorizontal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: HomeText.cardName.copyWith(
                    color: HomeRoles.cardName.resolve(context),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        studio,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HomeText.creator.copyWith(color: supporting),
                      ),
                    ),
                    const SizedBox(width: HomeTokens.infoMarkGap),
                    Text(
                      strings.onboardingRegisteredMark,
                      style: HomeText.creator.copyWith(color: supporting),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    vertical: HomeTokens.ratingInsetVertical,
                  ),
                  child: RatingBadge(
                    value: shown,
                    semanticLabel: shown,
                    appearance: RatingBadgeAppearance.detailed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
