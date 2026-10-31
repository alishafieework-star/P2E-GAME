import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:mygame_p2e/shared/widgets/reward_badge.dart';
import 'package:p2e_design_system/design_system.dart';

import 'onboarding_ring.dart';
import 'onboarding_steps.dart';
import 'onboarding_timing.dart';

/// Quest ring, rolling digits, step chain and the points that fly to the
/// total (HTML `qsRun`, D-138).
class OnboardingQuests extends StatefulWidget {
  const OnboardingQuests({super.key, required this.active});

  final bool active;

  @override
  State<OnboardingQuests> createState() => _OnboardingQuestsState();
}

class _OnboardingQuestsState extends State<OnboardingQuests>
    with TickerProviderStateMixin {
  static const _easeOut = Cubic(0.215, 0.61, 0.355, 1);

  // Scene timeline in HTML milliseconds.
  static final _arcStart = HtmlJourneyTokens.obArcDelayMs;
  static final _checkOne = HtmlJourneyTokens.obStepOneMs;
  static final _lineOne = _checkOne + HtmlJourneyTokens.obLineGapMs;
  static final _checkTwo = _lineOne + HtmlJourneyTokens.obLineMs;
  static final _lineTwo = _checkTwo + HtmlJourneyTokens.obLineMs;
  static final _active = _lineTwo + HtmlJourneyTokens.obLineMs;
  static final _addOne = _checkOne + HtmlJourneyTokens.questFly;
  static final _addTwo = _checkTwo + HtmlJourneyTokens.questFly;
  static final _length =
      _active + HtmlJourneyTokens.obRiseDelayMs + HtmlJourneyTokens.obBarFillMs;

  late final ScenePlayer player;
  final stageKey = GlobalKey();
  final totalKey = GlobalKey();
  final tagKeys = [GlobalKey(), GlobalKey(), GlobalKey()];
  var left = HtmlJourneyTokens.questClockSeconds;
  Timer? ticker;

  @override
  void initState() {
    super.initState();
    player = ScenePlayer(vsync: this, length: _length);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync(restart: false);
  }

  @override
  void didUpdateWidget(OnboardingQuests oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(restart: widget.active && !oldWidget.active);
  }

  void _sync({required bool restart}) {
    player.sync(context, active: widget.active, restart: restart);
    ticker?.cancel();
    ticker = null;
    if (widget.active && !MediaQuery.disableAnimationsOf(context)) {
      ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => left = math.max(0, left - 1));
      });
    }
  }

  @override
  void dispose() {
    ticker?.cancel();
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
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final top = MediaQuery.paddingOf(context).top;
    final names = [
      strings.onboardingQuestStepPlay,
      strings.onboardingQuestStepScore,
      strings.onboardingQuestStepWin,
    ];
    final points = HtmlJourneyTokens.questPoints;
    final checks = [_checkOne, _checkTwo];
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: top + HtmlJourneyTokens.obStageTop,
        bottom: HtmlJourneyTokens.obStageBottom,
        start: HtmlJourneyTokens.obStageInset,
        end: HtmlJourneyTokens.obStageInset,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: constraints.maxWidth,
              child: AnimatedBuilder(
                animation: player.listenable,
                builder: (context, _) =>
                    _stage(context, strings, language, names, points, checks),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stage(
    BuildContext context,
    AppLocalizations strings,
    String language,
    List<String> names,
    List<int> points,
    List<Duration> checks,
  ) {
    final base = player.base;
    final ease = HtmlJourneyTokens.ease;
    final dayShare = left / HtmlJourneyTokens.questDaySeconds;
    final wind = window(base, _arcStart, HtmlJourneyTokens.obArcMs, _easeOut);
    final fraction = wind < 1 ? dayShare * wind : dayShare;
    final ringFade = window(
      base,
      Duration.zero,
      HtmlJourneyTokens.obRingFadeMs,
      ease,
    );
    final ringSpring = window(
      base,
      Duration.zero,
      HtmlJourneyTokens.obRingEnterMs,
      HtmlJourneyTokens.spring,
    );
    final totalFade = window(
      base,
      HtmlJourneyTokens.obTotalDelayMs,
      HtmlJourneyTokens.obTotalFadeMs,
      ease,
    );
    final totalRise = window(
      base,
      HtmlJourneyTokens.obTotalDelayMs,
      HtmlJourneyTokens.obTotalEnterMs,
      ease,
    );
    final first = window(base, _addOne, HtmlJourneyTokens.questAdd, _easeOut);
    final second = window(base, _addTwo, HtmlJourneyTokens.questAdd, _easeOut);
    final earned = (points[0] * first + points[1] * second).round();
    final bump = math.max(_bump(base, _addOne), _bump(base, _addTwo));
    final fill = window(
      base,
      _active + HtmlJourneyTokens.obRiseDelayMs,
      HtmlJourneyTokens.obBarFillMs,
      ease,
    );
    final activeFade = window(base, _active, HtmlJourneyTokens.obFadeMs, ease);
    final steps = [
      for (var i = 0; i < names.length; i++)
        QuestStepView(
          name: names[i],
          points: points[i],
          enter: window(
            base,
            HtmlJourneyTokens.obStepDelayMs +
                HtmlJourneyTokens.obStepStaggerMs * i,
            HtmlJourneyTokens.obStepEnterMs,
            ease,
          ),
          done: i < checks.length && base >= checks[i].inMilliseconds,
          pop: i < checks.length
              ? window(base, checks[i], HtmlJourneyTokens.obNodePopMs)
              : 0,
          sparks: i < checks.length ? _burst(base, checks[i]) : null,
          activeFade: i == names.length - 1 ? activeFade : 0,
          fill: i == names.length - 1 ? fill : 0,
          tagKey: tagKeys[i],
        ),
    ];
    final cycle = player.cycle;
    return Stack(
      clipBehavior: Clip.none,
      key: stageKey,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: ringFade,
              child: Transform.rotate(
                angle:
                    HtmlJourneyTokens.questRingEnterDegrees *
                    (1 - ringSpring) *
                    math.pi /
                    180,
                child: Transform.scale(
                  scale:
                      HtmlJourneyTokens.questRingEnterScale +
                      (1 - HtmlJourneyTokens.questRingEnterScale) * ringSpring,
                  child: QuestRing(
                    fraction: fraction,
                    glow: cycle(HtmlJourneyTokens.obGlowMs),
                    halo: cycle(HtmlJourneyTokens.obHaloMs),
                    left: left,
                    language: language,
                    endsLabel: strings.onboardingQuestEnds,
                    secondsLabel: strings.onboardingQuestSeconds,
                  ),
                ),
              ),
            ),
            const SizedBox(height: HtmlJourneyTokens.obQsGap),
            Opacity(
              opacity: totalFade,
              child: Transform.translate(
                offset: Offset(
                  0,
                  (1 - totalRise) * HtmlJourneyTokens.obTotalRise,
                ),
                child: Transform.scale(
                  scale: bump,
                  child: KeyedSubtree(
                    key: totalKey,
                    child: KeyedSubtree(
                      key: const ValueKey('onboarding.quest.total'),
                      child: RewardBadge(
                        elementId: 'onboarding.quest.reward',
                        appearance: RewardBadgeAppearance.total,
                        amount: formatCount(earned, languageCode: language),
                        secondaryAmount: formatCount(
                          HtmlJourneyTokens.questTotal,
                          languageCode: language,
                        ),
                        unit: strings.homePointsUnit,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: HtmlJourneyTokens.obQsGap + HtmlJourneyTokens.obStepsTop,
            ),
            QuestSteps(
              steps: steps,
              firstSegment: window(
                base,
                _lineOne,
                HtmlJourneyTokens.obLineMs,
                _easeOut,
              ),
              secondSegment: window(
                base,
                _lineTwo,
                HtmlJourneyTokens.obLineMs,
                _easeOut,
              ),
              spin: cycle(HtmlJourneyTokens.obSpinMs),
              aura: cycle(HtmlJourneyTokens.obGlowMs),
              pulse: cycle(HtmlJourneyTokens.obPulseMs),
              march: cycle(HtmlJourneyTokens.obMarchMs),
              shine: cycle(HtmlJourneyTokens.obShineMs),
              language: language,
            ),
          ],
        ),
        for (var k = 0; k < checks.length; k++)
          ..._token(k, base, checks[k], points[k], language),
      ],
    );
  }

  /// `qsBump`: the total swells while points land.
  double _bump(double base, Duration start) {
    final p = window(
      base,
      start,
      HtmlJourneyTokens.obBumpMs,
      HtmlJourneyTokens.spring,
    );
    if (p <= 0 || p >= 1) return 1;
    return keyframes(
      p,
      const [0, 0.35, 1],
      [1, HtmlJourneyTokens.obBumpScale, 1],
    );
  }

  double? _burst(double base, Duration start) {
    final p = window(base, start, HtmlJourneyTokens.obSparkMs);
    return p <= 0 || p >= 1 ? null : p;
  }

  /// `qsToken`: the green pill leaves the step and lands on the total crown.
  List<Widget> _token(
    int index,
    double base,
    Duration start,
    int amount,
    String language,
  ) {
    final raw = window(base, start, HtmlJourneyTokens.questFly);
    if (raw <= 0 || raw >= 1) return const [];
    final from = _rect(tagKeys[index]);
    final total = _rect(totalKey);
    if (from == null || total == null) return const [];
    final k = HtmlJourneyTokens.obTokenCurve.transform(raw);
    final dx =
        total.left +
        HomeTokens.rewardTotalPadStart +
        HomeTokens.rewardPlate / 2 -
        from.center.dx;
    final dy = total.center.dy - from.center.dy;
    const stops = [0.0, 0.16, 0.62, 1.0];
    final x = keyframes(k, stops, [0, 0, dx * 0.62, dx]);
    final y = keyframes(k, stops, [
      0,
      -HtmlJourneyTokens.obTokenRise,
      dy * 0.5 - HtmlJourneyTokens.obTokenArc,
      dy,
    ]);
    final scale = keyframes(k, stops, const [0.9, 1.08, 1, 0.4]);
    final fade = keyframes(k, stops, const [0, 1, 1, 0.2]);
    return [
      Positioned(
        left: from.left,
        top: from.top,
        child: IgnorePointer(
          child: Opacity(
            opacity: fade,
            child: Transform.translate(
              offset: Offset(x, y),
              child: Transform.scale(
                scale: scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: HtmlJourneyTokens.success,
                    borderRadius: BorderRadius.circular(
                      HtmlJourneyTokens.obTagRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: HtmlJourneyTokens.success.withValues(alpha: 0.4),
                        offset: const Offset(0, HtmlJourneyTokens.obTokenRise),
                        blurRadius: HtmlJourneyTokens.obCardGap + 4,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: HtmlJourneyTokens.obTagPadH,
                      vertical: HtmlJourneyTokens.obTagPadV,
                    ),
                    child: Text(
                      formatGain(amount, languageCode: language),
                      textDirection: TextDirection.ltr,
                      style: OnboardingType.semibold(
                        HtmlJourneyTokens.obTagFont,
                        HtmlJourneyTokens.obTagLine,
                      ).copyWith(color: HtmlJourneyTokens.obWhite),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
