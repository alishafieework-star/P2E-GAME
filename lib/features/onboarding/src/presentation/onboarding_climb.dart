import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:mygame_p2e/shared/widgets/player_avatar.dart';
import 'package:p2e_design_system/design_system.dart';

import 'onboarding_board.dart';
import 'onboarding_timing.dart';

/// Three-player podium, the You row's climb, and the flight to first
/// (HTML `lbRun`, D-138).
class OnboardingClimb extends StatefulWidget {
  const OnboardingClimb({
    super.key,
    required this.active,
    required this.onLanded,
  });

  final bool active;

  /// Fires once per run when the You avatar lands on first place.
  final VoidCallback onLanded;

  @override
  State<OnboardingClimb> createState() => _OnboardingClimbState();
}

class _OnboardingClimbState extends State<OnboardingClimb>
    with TickerProviderStateMixin {
  static const _easeOutCubic = Cubic(0.215, 0.61, 0.355, 1);
  static const _easeIn = Cubic(0.42, 0, 1, 1);

  // Scene timeline in HTML milliseconds.
  static final _liftAt = HtmlJourneyTokens.climbCountDelay;
  static final _climbAt = HtmlJourneyTokens.climbMoveDelay;
  static final _flyAt = HtmlJourneyTokens.climbFlyDelay;
  static final _landAt = _flyAt + HtmlJourneyTokens.climbFly;

  late final ScenePlayer player;
  final stageKey = GlobalKey();
  final meAvatarKey = GlobalKey();
  final firstAvatarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    player = ScenePlayer(vsync: this, length: HtmlJourneyTokens.climbScene);
    player.clock.addListener(_watchLanding);
  }

  var _landed = false;

  void _watchLanding() {
    final landed = player.base >= _landAt.inMilliseconds;
    if (landed && !_landed && widget.active) widget.onLanded();
    _landed = landed;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    player.sync(context, active: widget.active, restart: false);
  }

  @override
  void didUpdateWidget(OnboardingClimb oldWidget) {
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

  Rect? _rect(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    final stage = stageKey.currentContext?.findRenderObject();
    if (box is! RenderBox || stage is! RenderBox) return null;
    if (!box.attached || !stage.attached || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero, ancestor: stage) & box.size;
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            top: top + HtmlJourneyTokens.obStageTop,
            bottom: HtmlJourneyTokens.obStageLbBottom,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Align(
              alignment: Alignment.bottomCenter,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: AnimatedBuilder(
                    animation: player.listenable,
                    builder: (context, _) => _stage(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stage(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final base = player.base;
    final ease = HtmlJourneyTokens.ease;
    String count(int value) => formatCount(value, languageCode: language);

    final blocks = window(
      base,
      HtmlJourneyTokens.obBlocksDelayMs,
      HtmlJourneyTokens.obBlocksFadeMs,
      ease,
    );
    final blocksRise = window(
      base,
      HtmlJourneyTokens.obBlocksDelayMs,
      HtmlJourneyTokens.obBlocksRiseMs,
      ease,
    );
    final sheetFade = window(
      base,
      HtmlJourneyTokens.obSheetDelayMs,
      HtmlJourneyTokens.obSheetFadeMs,
      ease,
    );
    final sheetRise = window(
      base,
      HtmlJourneyTokens.obSheetDelayMs,
      HtmlJourneyTokens.obSheetRiseMs,
      ease,
    );
    final hover = player.cycle(HtmlJourneyTokens.obPuHoverMs);
    final unit = strings.homePointsUnit;

    Widget podium(double width) {
      final mid = width / 2;
      Offset slot(double rank) {
        final dx = rank <= 1
            ? 0.0
            : rank <= 2
            ? -HtmlJourneyTokens.podiumSideOffset
            : HtmlJourneyTokens.podiumSideOffset;
        final y = rank <= 1
            ? HtmlJourneyTokens.podiumFirstTop
            : rank <= 2
            ? HtmlJourneyTokens.podiumSecondTop
            : HtmlJourneyTokens.podiumThirdTop;
        return Offset(dx, y);
      }

      Color tier(int rank) => switch (rank) {
        1 => HtmlJourneyTokens.gold,
        2 => HtmlJourneyTokens.silver,
        _ => HtmlJourneyTokens.bronze,
      };
      final move = window(base, _flyAt, HtmlJourneyTokens.obPuMoveMs, ease);
      final tint = window(base, _flyAt, HtmlJourneyTokens.obPuRiseMs, ease);
      final moved = base >= _flyAt.inMilliseconds;

      Widget place({
        required String id,
        required int from,
        required int to,
        required Duration delay,
        bool out = false,
      }) {
        final enter = window(base, delay, HtmlJourneyTokens.obPuEnterMs, ease);
        final drop = window(
          base,
          delay,
          HtmlJourneyTokens.obPuRiseMs,
          HtmlJourneyTokens.spring,
        );
        final a = slot(from.toDouble());
        final b = slot(to.toDouble());
        final at = Offset.lerp(a, b, move)!;
        final leave = out
            ? window(base, _flyAt, HtmlJourneyTokens.obPuEnterMs, ease)
            : 0.0;
        final fall = out
            ? window(
                base,
                _flyAt,
                HtmlJourneyTokens.obPuRiseMs,
                HtmlJourneyTokens.spring,
              )
            : 0.0;
        final rank = moved ? to : from;
        return Positioned(
          left: mid + at.dx - HtmlJourneyTokens.obPuWidth / 2,
          top: at.dy,
          child: Opacity(
            opacity: (enter * (1 - leave)).clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(
                0,
                -HtmlJourneyTokens.obPuRise * (1 - drop) +
                    HtmlJourneyTokens.obPuOutRise * fall,
              ),
              child: Transform.scale(
                scale: 1 - (1 - HtmlJourneyTokens.obPuOutScale) * fall,
                child: PodiumPlayer(
                  person: lbPeople[id]!,
                  rank: count(rank),
                  tier: Color.lerp(tier(from), tier(to), tint)!,
                  points: count(lbPeople[id]!.points),
                  unit: unit,
                  hover: hover,
                ),
              ),
            ),
          ),
        );
      }

      final land = window(base, _landAt, HtmlJourneyTokens.obLandMs);
      final landed = base >= _landAt.inMilliseconds;
      final landPop = keyframes(
        HtmlJourneyTokens.spring.transform(land),
        [0, HtmlJourneyTokens.obLandPeakAt, 1],
        [HtmlJourneyTokens.landPopStart, HtmlJourneyTokens.landPopPeak, 1],
      );
      final winner = Positioned(
        left: mid - HtmlJourneyTokens.obPuWidth / 2,
        top: HtmlJourneyTokens.podiumFirstTop,
        child: Opacity(
          opacity: window(base, _landAt, HtmlJourneyTokens.obPuEnterMs, ease),
          child: PodiumPlayer(
            person: lbPeople['A']!,
            rank: count(1),
            tier: HtmlJourneyTokens.gold,
            points: count(lbPeople['A']!.points),
            unit: unit,
            hover: hover,
            avatarKey: firstAvatarKey,
            avatarVisible: landed,
            avatarScale: landed ? landPop : 1,
          ),
        ),
      );
      return SizedBox(
        width: width,
        height: HtmlJourneyTokens.podiumHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: blocks,
                child: Transform.translate(
                  offset: Offset(
                    0,
                    HtmlJourneyTokens.obBlocksRise * (1 - blocksRise),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/onboarding/podium.svg',
                    width: HtmlJourneyTokens.obBlocksWidth,
                    height: HtmlJourneyTokens.obBlocksHeight,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
            place(
              id: 'N',
              from: 3,
              to: 3,
              delay: HtmlJourneyTokens.obPuDelayThreeMs,
              out: true,
            ),
            place(
              id: 'M',
              from: 2,
              to: 3,
              delay: HtmlJourneyTokens.obPuDelayTwoMs,
            ),
            place(
              id: 'Z',
              from: 1,
              to: 2,
              delay: HtmlJourneyTokens.obPuDelayOneMs,
            ),
            winner,
          ],
        ),
      );
    }

    final slotPitch =
        HtmlJourneyTokens.climbRowExtent + HtmlJourneyTokens.obSheetGap;
    final climbRaw = window(base, _climbAt, HtmlJourneyTokens.climb);
    final climb = HtmlJourneyTokens.obClimbCurve.transform(climbRaw);
    final lift = window(
      base,
      _liftAt,
      HtmlJourneyTokens.obLiftMs,
      HtmlJourneyTokens.obLiftCurve,
    );
    final counting = _easeOutCubic.transform(
      window(base, _liftAt, HtmlJourneyTokens.climbCount),
    );
    final rank = math.max(
      HtmlJourneyTokens.climbRankEnd,
      (HtmlJourneyTokens.climbRankStart -
              (HtmlJourneyTokens.climbRankStart -
                      HtmlJourneyTokens.climbRankEnd) *
                  counting)
          .round(),
    );
    final score =
        (HtmlJourneyTokens.climbScoreStart +
                (HtmlJourneyTokens.climbScoreEnd -
                        HtmlJourneyTokens.climbScoreStart) *
                    counting)
            .round();
    final rising = base >= _liftAt.inMilliseconds;
    final top = base >= _flyAt.inMilliseconds;
    final flying =
        base >= _flyAt.inMilliseconds && base < _landAt.inMilliseconds;
    final meShift = keyframes(
      climb,
      const [0, 0.5, 0.86, 1],
      [slotPitch * 2, slotPitch * 2 * 0.45, HtmlJourneyTokens.obClimbSettle, 0],
    );
    final meDrift = keyframes(
      climb,
      const [0, 0.5, 0.86, 1],
      [0, HtmlJourneyTokens.obClimbPeakShift, 0, 0],
    );
    final meScale = climbRaw > 0
        ? keyframes(
            climb,
            const [0, 0.5, 0.86, 1],
            [
              HtmlJourneyTokens.obLiftScale,
              HtmlJourneyTokens.obClimbPeakScale,
              HtmlJourneyTokens.obLiftScale,
              1,
            ],
          )
        : 1 + (HtmlJourneyTokens.obLiftScale - 1) * lift;
    final lifting = rising && climbRaw < 1;
    final gold = HtmlJourneyTokens.gold;
    final edge = Color.lerp(
      roles.outlineBase,
      gold,
      window(base, _liftAt, HtmlJourneyTokens.obPuEnterMs, ease),
    )!;
    final shadows = [
      if (rising)
        BoxShadow(
          color: gold.withValues(alpha: HtmlJourneyTokens.obRiseGlowAlpha),
          spreadRadius: HtmlJourneyTokens.obRiseGlow,
        ),
      BoxShadow(
        color: HtmlJourneyTokens.playNowHover.withValues(
          alpha: lifting
              ? HtmlJourneyTokens.overlayAlpha
              : HtmlJourneyTokens.obBoardShadowAlpha,
        ),
        offset: Offset(
          0,
          lifting
              ? HtmlJourneyTokens.obBoardRadius - 2
              : HtmlJourneyTokens.obBoardShadowY,
        ),
        blurRadius: lifting
            ? HtmlJourneyTokens.obBoardShadowBlur * 1.5
            : HtmlJourneyTokens.obBoardShadowBlur,
      ),
    ];

    /// A swap of a plain row: the old person fades down, the new one fades in.
    Widget plain({
      required int index,
      required String oldId,
      required int oldRank,
      required int newRank,
      required String newId,
      required Duration swapAt,
      required Duration rankAt,
    }) {
      final out = window(base, swapAt, HtmlJourneyTokens.obSwapOutMs, _easeIn);
      final inn = window(
        base,
        swapAt + HtmlJourneyTokens.obSwapOutMs,
        HtmlJourneyTokens.obSwapInMs,
        HtmlJourneyTokens.obSwapInCurve,
      );
      final swapped =
          base >= (swapAt + HtmlJourneyTokens.obSwapOutMs).inMilliseconds;
      final id = swapped ? newId : oldId;
      final shownRank = swapped
          ? newRank
          : (base >= rankAt.inMilliseconds ? oldRank + 1 : oldRank);
      final opacity = swapped ? inn : 1 - out;
      final shift = swapped
          ? -HtmlJourneyTokens.obSwapShift * (1 - inn)
          : HtmlJourneyTokens.obSwapShift * out;
      return Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(0, shift),
          child: BoardRow(
            rank: count(shownRank),
            rankColor: HtmlJourneyTokens.obGray,
            person: lbPeople[id]!,
            points: count(lbPeople[id]!.points),
            unit: unit,
          ),
        ),
      );
    }

    Widget sheet(double width) {
      final rowOne = HtmlJourneyTokens.obRowCurve.transform(
        window(
          base,
          _climbAt + HtmlJourneyTokens.obRowOneDelayMs,
          HtmlJourneyTokens.obRowMoveMs,
        ),
      );
      final rowTwo = HtmlJourneyTokens.obRowCurve.transform(
        window(
          base,
          _climbAt + HtmlJourneyTokens.obRowTwoDelayMs,
          HtmlJourneyTokens.obRowMoveMs,
        ),
      );
      final inner = SizedBox(
        height:
            HtmlJourneyTokens.climbRowExtent * 3 +
            HtmlJourneyTokens.obSheetGap * 2,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            PositionedDirectional(
              start: 0,
              end: 0,
              top: slotPitch - slotPitch * (1 - rowTwo),
              child: plain(
                index: 0,
                oldId: 'H',
                oldRank: 4,
                newRank: 4,
                newId: 'N',
                swapAt: _flyAt + HtmlJourneyTokens.obSwapOneMs,
                rankAt:
                    _climbAt +
                    HtmlJourneyTokens.obRowTwoDelayMs +
                    HtmlJourneyTokens.obRankChangeMs,
              ),
            ),
            PositionedDirectional(
              start: 0,
              end: 0,
              top: slotPitch * 2 - slotPitch * (1 - rowOne),
              child: plain(
                index: 1,
                oldId: 'F',
                oldRank: 5,
                newRank: 5,
                newId: 'H',
                swapAt: _flyAt + HtmlJourneyTokens.obSwapTwoMs,
                rankAt:
                    _climbAt +
                    HtmlJourneyTokens.obRowOneDelayMs +
                    HtmlJourneyTokens.obRankChangeMs,
              ),
            ),
            PositionedDirectional(
              start: 0,
              end: 0,
              top: meShift,
              child: Transform.translate(
                offset: Offset(meDrift, 0),
                child: Transform.scale(
                  scale: meScale,
                  child: BoardRow(
                    rank: count(rank),
                    rankColor: top ? gold : HtmlJourneyTokens.obOnDarkSoft,
                    person: lbPeople['A']!,
                    points: count(score),
                    unit: unit,
                    name: strings.onboardingYou,
                    avatarKey: meAvatarKey,
                    avatarVisible: !flying,
                    border: edge,
                    shadows: shadows,
                    rankKey: const ValueKey('onboarding.climb.rank'),
                    pointsKey: const ValueKey('onboarding.climb.score'),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      return Opacity(
        opacity: sheetFade,
        child: Transform.translate(
          offset: Offset(0, HtmlJourneyTokens.obSheetRise * (1 - sheetRise)),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: HtmlJourneyTokens.obSheetInset,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: roles.surfaceContainerBase,
                borderRadius: BorderRadius.circular(
                  HtmlJourneyTokens.obSheetRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: HtmlJourneyTokens.playNowHover.withValues(
                      alpha: HtmlJourneyTokens.obSheetShadowAlpha,
                    ),
                    offset: const Offset(0, HtmlJourneyTokens.obSheetShadowY),
                    blurRadius: HtmlJourneyTokens.obSheetShadowBlur,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(
                  HtmlJourneyTokens.obSheetPad,
                ),
                child: inner,
              ),
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Stack(
          clipBehavior: Clip.none,
          key: stageKey,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [podium(width), sheet(width)],
            ),
            ..._flyer(base),
          ],
        );
      },
    );
  }

  /// `lbFly`: the You avatar flies from its row up to first place.
  List<Widget> _flyer(double base) {
    final raw = window(base, _flyAt, HtmlJourneyTokens.climbFly);
    if (raw <= 0 || raw >= 1) return const [];
    final from = _rect(meAvatarKey);
    final to = _rect(firstAvatarKey);
    if (from == null || to == null) return const [];
    final k = HtmlJourneyTokens.obFlyCurve.transform(raw);
    final dx = to.center.dx - from.center.dx;
    final dy = to.center.dy - from.center.dy;
    final grow = to.width / from.width;
    const stops = [0.0, 0.6, 1.0];
    return [
      Positioned(
        left: from.left,
        top: from.top,
        child: IgnorePointer(
          child: Transform.translate(
            offset: Offset(
              keyframes(k, stops, [0, dx * 0.45, dx]),
              keyframes(k, stops, [
                0,
                dy * 0.55 - HtmlJourneyTokens.obFlyArc,
                dy,
              ]),
            ),
            child: Transform.scale(
              scale: keyframes(k, stops, [
                1,
                grow * HtmlJourneyTokens.obFlyPeakScale,
                grow,
              ]),
              child: const PlayerAvatar(
                letter: 'A',
                theme: 0,
                size: PlayerAvatarSize.compact,
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
