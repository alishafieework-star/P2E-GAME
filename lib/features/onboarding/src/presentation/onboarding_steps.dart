import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:p2e_design_system/design_system.dart';

import 'onboarding_timing.dart';

/// Everything one quest step shows at a given moment of the scene.
class QuestStepView {
  const QuestStepView({
    required this.name,
    required this.points,
    required this.enter,
    required this.done,
    required this.pop,
    required this.sparks,
    required this.activeFade,
    required this.fill,
    required this.tagKey,
  });

  final String name;
  final int points;

  /// 0..1 entrance (fade and rise).
  final double enter;
  final bool done;

  /// 0..1 progress of the node pop after the check.
  final double pop;

  /// 0..1 progress of the spark burst, or null when it is not playing.
  final double? sparks;

  /// 0..1 fade of the active border, aura and pulse.
  final double activeFade;

  /// 0..1 fill of the progress bar.
  final double fill;
  final GlobalKey tagKey;
}

/// `.qs-steps`: three step cards joined by two segments.
class QuestSteps extends StatelessWidget {
  const QuestSteps({
    super.key,
    required this.steps,
    required this.firstSegment,
    required this.secondSegment,
    required this.spin,
    required this.aura,
    required this.pulse,
    required this.march,
    required this.shine,
    required this.language,
  });

  final List<QuestStepView> steps;
  final double firstSegment;
  final double secondSegment;
  final double spin;
  final double aura;
  final double pulse;
  final double march;
  final double shine;
  final String language;

  static const _pitch =
      HtmlJourneyTokens.obStepHeight + HtmlJourneyTokens.obStepGap;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final height =
        HtmlJourneyTokens.obStepHeight * steps.length +
        HtmlJourneyTokens.obStepGap * (steps.length - 1);
    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < steps.length; i++)
            PositionedDirectional(
              start: 0,
              end: 0,
              top: i * _pitch,
              height: HtmlJourneyTokens.obStepHeight,
              child: Opacity(
                opacity: steps[i].enter,
                child: Transform.translate(
                  offset: Offset(
                    0,
                    (1 - steps[i].enter) * HtmlJourneyTokens.obStepRise,
                  ),
                  child: _StepCard(
                    step: steps[i],
                    index: i,
                    last: i == steps.length - 1,
                    spin: spin,
                    aura: aura,
                    shine: shine,
                    language: language,
                  ),
                ),
              ),
            ),
          PositionedDirectional(
            start: HtmlJourneyTokens.obSegLeft,
            top: HtmlJourneyTokens.obSeg1Top,
            width: HtmlJourneyTokens.obSegWidth,
            height: HtmlJourneyTokens.obSeg1Height,
            child: _Segment(
              progress: firstSegment,
              dotted: false,
              march: march,
            ),
          ),
          PositionedDirectional(
            start: HtmlJourneyTokens.obSegLeft,
            top: HtmlJourneyTokens.obSeg2Top,
            width: HtmlJourneyTokens.obSegWidth,
            height: HtmlJourneyTokens.obSeg2Height,
            child: _Segment(
              progress: secondSegment,
              dotted: true,
              march: march,
            ),
          ),
          for (var i = 0; i < steps.length; i++)
            PositionedDirectional(
              start:
                  HtmlJourneyTokens.obStepPadH + HtmlJourneyTokens.obStepBorder,
              top:
                  i * _pitch +
                  (HtmlJourneyTokens.obStepHeight - HtmlJourneyTokens.obNode) /
                      2,
              child: Opacity(
                opacity: steps[i].enter,
                child: _Node(
                  index: i,
                  step: steps[i],
                  pulse: pulse,
                  language: language,
                  surface: roles.surfaceContainerBase,
                ),
              ),
            ),
          for (var i = 0; i < steps.length; i++)
            if (steps[i].sparks != null)
              PositionedDirectional(
                start:
                    HtmlJourneyTokens.obStepPadH +
                    HtmlJourneyTokens.obStepBorder +
                    HtmlJourneyTokens.obNode / 2,
                top: i * _pitch + HtmlJourneyTokens.obStepHeight / 2,
                child: _Sparks(progress: steps[i].sparks!),
              ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.step,
    required this.index,
    required this.last,
    required this.spin,
    required this.aura,
    required this.shine,
    required this.language,
  });

  final QuestStepView step;
  final int index;
  final bool last;
  final double spin;
  final double aura;
  final double shine;
  final String language;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final active = step.activeFade > 0;
    final glowWave = HtmlJourneyTokens.easeInOut.transform(
      1 - (2 * aura - 1).abs(),
    );
    final radius = BorderRadius.circular(HtmlJourneyTokens.obStepRadius);
    final tagFill = step.done
        ? HtmlJourneyTokens.success.withValues(alpha: 0.14)
        : active
        ? HtmlJourneyTokens.splashGradientMid.withValues(alpha: 0.12)
        : roles.surfaceContainerHigh;
    final tagInk = step.done
        ? HtmlJourneyTokens.success
        : active
        ? HtmlJourneyTokens.splashGradientEnd
        : HtmlJourneyTokens.obGray;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (active)
          Positioned.fill(
            child: Opacity(
              opacity: step.activeFade,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: HtmlJourneyTokens.splashGradientMid.withValues(
                        alpha: 0.18 + 0.10 * glowWave,
                      ),
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: HtmlJourneyTokens.splashGradientMid.withValues(
                        alpha: 0.10 + 0.12 * glowWave,
                      ),
                      blurRadius: 16 + 12 * glowWave,
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: roles.surfaceContainerBase,
              borderRadius: radius,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: HtmlJourneyTokens.obStepPadH,
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width:
                        HtmlJourneyTokens.obNode +
                        HtmlJourneyTokens.obStepInner,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              OnboardingType.semibold(
                                HtmlJourneyTokens.obStepName,
                                HtmlJourneyTokens.obStepNameLine,
                              ).copyWith(
                                color: step.done
                                    ? HtmlJourneyTokens.obGray
                                    : roles.onSurfaceEmphasis,
                              ),
                        ),
                        if (last) ...[
                          const SizedBox(
                            height: HtmlJourneyTokens.obStepBarGap,
                          ),
                          _Bar(fill: step.fill, shine: shine),
                        ],
                      ],
                    ),
                  ),
                  DecoratedBox(
                    key: step.tagKey,
                    decoration: BoxDecoration(
                      color: tagFill,
                      borderRadius: BorderRadius.circular(
                        HtmlJourneyTokens.obTagRadius,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: HtmlJourneyTokens.obTagPadH,
                        vertical: HtmlJourneyTokens.obTagPadV,
                      ),
                      child: Text(
                        formatGain(step.points, languageCode: language),
                        textDirection: TextDirection.ltr,
                        style:
                            OnboardingType.semibold(
                              HtmlJourneyTokens.obTagFont,
                              HtmlJourneyTokens.obTagLine,
                            ).copyWith(
                              color: tagInk,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (active)
          Positioned.fill(
            child: Opacity(
              opacity: step.activeFade,
              child: CustomPaint(
                painter: _SpinBorderPainter(angle: spin * math.pi * 2),
              ),
            ),
          ),
      ],
    );
  }
}

class _SpinBorderPainter extends CustomPainter {
  const _SpinBorderPainter({required this.angle});

  final double angle;

  @override
  void paint(Canvas canvas, Size size) {
    final dim = HtmlJourneyTokens.splashGradientMid.withValues(alpha: 0.12);
    final sky = HtmlJourneyTokens.obSky;
    final rect = (Offset.zero & size).inflate(1);
    final stroke = HtmlJourneyTokens.obBoardBorder;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(stroke / 2),
        const Radius.circular(HtmlJourneyTokens.obStepRadius),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..shader = SweepGradient(
          colors: [dim, dim, sky, HtmlJourneyTokens.obWhite, sky, dim],
          stops: const [0, 0.556, 0.778, 0.867, 0.93, 1],
          transform: GradientRotation(angle),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_SpinBorderPainter oldDelegate) =>
      oldDelegate.angle != angle;
}

class _Bar extends StatelessWidget {
  const _Bar({required this.fill, required this.shine});

  final double fill;
  final double shine;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(HtmlJourneyTokens.obBarHeight / 2);
    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: HtmlJourneyTokens.obBarHeight,
        child: DecoratedBox(
          decoration: const BoxDecoration(color: HtmlJourneyTokens.obBarTrack),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: HtmlJourneyTokens.obBarFraction * fill,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final slide = Curves.easeInOut.transform(
                    (shine / 0.6).clamp(0.0, 1.0),
                  );
                  final lead = -0.4 + 1.5 * slide;
                  return DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          HtmlJourneyTokens.splashGradientMid,
                          HtmlJourneyTokens.splashGradientEnd,
                        ],
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        PositionedDirectional(
                          start: lead * width,
                          top: 0,
                          bottom: 0,
                          width: width * 0.4,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  HtmlJourneyTokens.obWhite.withValues(
                                    alpha: 0,
                                  ),
                                  HtmlJourneyTokens.obWhite.withValues(
                                    alpha: 0.55,
                                  ),
                                  HtmlJourneyTokens.obWhite.withValues(
                                    alpha: 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({
    required this.index,
    required this.step,
    required this.pulse,
    required this.language,
    required this.surface,
  });

  final int index;
  final QuestStepView step;
  final double pulse;
  final String language;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    final active = step.activeFade > 0 && !step.done;
    final pop = HtmlJourneyTokens.spring.transform(step.pop);
    final scale = step.done
        ? keyframes(pop, const [0, 0.6, 1], const [0.6, 1.15, 1])
        : 1.0;
    final ring = Curves.easeOut.transform(pulse);
    final ink = active
        ? HtmlJourneyTokens.splashGradientMid
        : HtmlJourneyTokens.silver;
    final fill = step.done
        ? HtmlJourneyTokens.success
        : active
        ? HtmlJourneyTokens.obNodeFill
        : surface;
    final line = step.done
        ? HtmlJourneyTokens.success
        : active
        ? HtmlJourneyTokens.splashGradientMid
        : HtmlJourneyTokens.obNodeLine;
    return SizedBox.square(
      dimension: HtmlJourneyTokens.obNode,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (active)
            Positioned.fill(
              left: -HtmlJourneyTokens.obPulseInset,
              top: -HtmlJourneyTokens.obPulseInset,
              right: -HtmlJourneyTokens.obPulseInset,
              bottom: -HtmlJourneyTokens.obPulseInset,
              child: Opacity(
                opacity: 0.8 * (1 - ring) * step.activeFade,
                child: Transform.scale(
                  scale: 0.72 + 0.73 * ring,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: HtmlJourneyTokens.splashGradientMid,
                        width: HtmlJourneyTokens.obNodeBorder,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Transform.scale(
            scale: scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: Border.all(
                  color: line,
                  width: HtmlJourneyTokens.obNodeBorder,
                ),
              ),
              child: SizedBox.square(
                dimension: HtmlJourneyTokens.obNode,
                child: Center(
                  child: step.done
                      ? _Tick(
                          progress: window(
                            step.pop *
                                HtmlJourneyTokens.obNodePopMs.inMilliseconds,
                            HtmlJourneyTokens.obTickDrawDelayMs,
                            HtmlJourneyTokens.obTickDrawMs,
                            HtmlJourneyTokens.ease,
                          ),
                        )
                      : Text(
                          formatCount(index + 1, languageCode: language),
                          style: OnboardingType.semibold(
                            HtmlJourneyTokens.obNodeFont,
                            HtmlJourneyTokens.obNodeFont,
                          ).copyWith(color: ink),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.progress,
    required this.dotted,
    required this.march,
  });

  final double progress;
  final bool dotted;
  final double march;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SegmentPainter(
        progress: progress,
        dotted: dotted,
        march: march,
      ),
    );
  }
}

class _SegmentPainter extends CustomPainter {
  const _SegmentPainter({
    required this.progress,
    required this.dotted,
    required this.march,
  });

  final double progress;
  final bool dotted;
  final double march;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(HtmlJourneyTokens.obSegWidth / 2);
    if (!dotted) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, radius),
        Paint()..color = HtmlJourneyTokens.obSegTrack,
      );
      if (progress <= 0) return;
      final rect = Rect.fromLTWH(0, 0, size.width, size.height * progress);
      final fillRect = RRect.fromRectAndRadius(rect, radius);
      canvas.drawRRect(
        fillRect,
        Paint()
          ..color = HtmlJourneyTokens.success.withValues(alpha: 0.55)
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            HtmlJourneyTokens.obCardGap / 2,
          ),
      );
      canvas.drawRRect(
        fillRect,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HtmlJourneyTokens.success,
              HtmlJourneyTokens.obSuccessLight,
            ],
          ).createShader(Offset.zero & size),
      );
      return;
    }
    final center = size.width / 2;
    final dot = HtmlJourneyTokens.obSegDot;
    for (
      var y = dot;
      y < size.height + HtmlJourneyTokens.obSegPitch;
      y += HtmlJourneyTokens.obSegPitch
    ) {
      canvas.drawCircle(
        Offset(center, y),
        dot - 0.1,
        Paint()..color = HtmlJourneyTokens.obNodeLine,
      );
    }
    if (progress <= 0) return;
    final reach = size.height * progress;
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(-dot * 2, 0, size.width + dot * 4, reach));
    final shift = march * HtmlJourneyTokens.obSegPitch;
    for (
      var y = dot - HtmlJourneyTokens.obSegPitch + shift;
      y < size.height + HtmlJourneyTokens.obSegPitch;
      y += HtmlJourneyTokens.obSegPitch
    ) {
      canvas.drawCircle(
        Offset(center, y),
        dot + 1.5,
        Paint()
          ..color = HtmlJourneyTokens.splashGradientMid.withValues(alpha: 0.8)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
      canvas.drawCircle(
        Offset(center, y),
        dot,
        Paint()..color = HtmlJourneyTokens.obSky,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SegmentPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.march != march;
}

class _Sparks extends StatelessWidget {
  const _Sparks({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final e = const Cubic(0.2, 0.7, 0.3, 1).transform(progress);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (var k = 0; k < HtmlJourneyTokens.obSparkCount; k++)
          Builder(
            builder: (context) {
              final angle =
                  k * math.pi * 2 / HtmlJourneyTokens.obSparkCount +
                  math.pi / HtmlJourneyTokens.obSparkCount;
              final reach =
                  HtmlJourneyTokens.obSparkRadius +
                  (k % 2) * HtmlJourneyTokens.obSparkRadiusAlt;
              final size = HtmlJourneyTokens.obSparkSize * (1 - 0.8 * e);
              return PositionedDirectional(
                start: math.cos(angle) * reach * e - size / 2,
                top: math.sin(angle) * reach * e - size / 2,
                child: Opacity(
                  opacity: 1 - e,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: k.isEven
                          ? HtmlJourneyTokens.success
                          : HtmlJourneyTokens.obSparkLight,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(dimension: size),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

/// HTML QS_CHECK: a white 3.4px round-capped tick that draws itself.
class _Tick extends StatelessWidget {
  const _Tick({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size.square(HtmlJourneyTokens.obTickSize),
    painter: _TickPainter(progress),
  );
}

class _TickPainter extends CustomPainter {
  const _TickPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / HtmlJourneyTokens.obTickViewBox;
    final path = Path()
      ..moveTo(5 * unit, 12.5 * unit)
      ..lineTo(9.5 * unit, 17 * unit)
      ..lineTo(19 * unit, 7.5 * unit);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = HtmlJourneyTokens.obTickStroke * unit
      ..color = HtmlJourneyTokens.obWhite;
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
    }
  }

  @override
  bool shouldRepaint(_TickPainter old) => old.progress != progress;
}
