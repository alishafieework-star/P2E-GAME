import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/formatting/digits.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:p2e_design_system/design_system.dart';

import 'onboarding_timing.dart';

/// `.qs-ring`: ticks, track, gradient arc with its tip, and the odometer clock.
class QuestRing extends StatelessWidget {
  const QuestRing({
    super.key,
    required this.fraction,
    required this.glow,
    required this.halo,
    required this.left,
    required this.language,
    required this.endsLabel,
    required this.secondsLabel,
  });

  /// Share of the day left, drawn clockwise from the top.
  final double fraction;

  /// 0..1 waves of the endless halo and glow.
  final double glow;
  final double halo;
  final int left;
  final String language;
  final String endsLabel;
  final String secondsLabel;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final hours = left ~/ 3600;
    final minutes = (left % 3600) ~/ 60;
    final seconds = left % 60;
    final wave = HtmlJourneyTokens.easeInOut.transform(glow);
    final clock =
        OnboardingType.semibold(
          HtmlJourneyTokens.obClockSize,
          HtmlJourneyTokens.obClockSize,
        ).copyWith(
          color: roles.onSurfaceEmphasis,
          fontFeatures: const [FontFeature.tabularFigures()],
        );
    final secondsStyle =
        OnboardingType.semibold(
          HtmlJourneyTokens.obClockSecSize,
          HtmlJourneyTokens.obClockSecSize,
        ).copyWith(
          color: HtmlJourneyTokens.obGrayLight,
          fontFeatures: const [FontFeature.tabularFigures()],
        );
    final unitStyle = OnboardingType.regular(
      HtmlJourneyTokens.obClockSecSize,
      HtmlJourneyTokens.obClockSecSize,
    ).copyWith(color: HtmlJourneyTokens.silver);
    return SizedBox.square(
      dimension: HtmlJourneyTokens.questRingExtent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            left: -HtmlJourneyTokens.obRingGlowInset,
            top: -HtmlJourneyTokens.obRingGlowInset,
            right: -HtmlJourneyTokens.obRingGlowInset,
            bottom: -HtmlJourneyTokens.obRingGlowInset,
            child: Opacity(
              opacity: 0.65 + 0.35 * wave,
              child: Transform.scale(
                scale: 0.96 + 0.08 * wave,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        HtmlJourneyTokens.splashGradientMid.withValues(
                          alpha: 0.17,
                        ),
                        HtmlJourneyTokens.splashGradientMid.withValues(
                          alpha: 0,
                        ),
                      ],
                      stops: const [0, 0.9],
                    ),
                  ),
                ),
              ),
            ),
          ),
          CustomPaint(
            size: const Size.square(HtmlJourneyTokens.questRingExtent),
            painter: _RingPainter(
              fraction: fraction,
              halo: halo,
              tip: roles.onSurfaceEmphasis,
            ),
          ),
          Semantics(
            key: const ValueKey('onboarding.quest.clock'),
            label:
                '${formatTwoDigits(hours, languageCode: language)}:'
                '${formatTwoDigits(minutes, languageCode: language)}:'
                '${formatTwoDigits(seconds, languageCode: language)}',
            child: ExcludeSemantics(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    endsLabel.toUpperCase(),
                    style: OnboardingType.medium(
                      HtmlJourneyTokens.obClockLabelSize,
                      HtmlJourneyTokens.obClockLabelLine,
                      spacing: 0.02,
                    ).copyWith(color: HtmlJourneyTokens.silver),
                  ),
                  const SizedBox(height: HtmlJourneyTokens.obClockGap),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: HtmlJourneyTokens.obClockMargin,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      // PHYSICAL: clock digits keep their reading order in RTL.
                      textDirection: TextDirection.ltr,
                      children: [
                        Odometer(
                          value: hours,
                          style: clock,
                          language: language,
                        ),
                        _Colon(style: clock),
                        Odometer(
                          value: minutes,
                          style: clock,
                          language: language,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: HtmlJourneyTokens.obClockGap),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.ltr,
                    children: [
                      Odometer(
                        value: seconds,
                        style: secondsStyle,
                        language: language,
                      ),
                      const SizedBox(width: HtmlJourneyTokens.obCardGap / 2),
                      Text(secondsLabel, style: unitStyle),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Colon extends StatelessWidget {
  const _Colon({required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final size = style.fontSize!;
    return SizedBox(
      width: size * HtmlJourneyTokens.obColonWidth,
      height: size,
      child: Transform.translate(
        offset: Offset(0, -size * HtmlJourneyTokens.obColonLift),
        child: Text(
          ':',
          textAlign: TextAlign.center,
          style: style.copyWith(color: HtmlJourneyTokens.obGray),
        ),
      ),
    );
  }
}

/// `.od`: a two-digit odometer, one rolling column per digit.
class Odometer extends StatelessWidget {
  const Odometer({
    super.key,
    required this.value,
    required this.style,
    required this.language,
  });

  final int value;
  final TextStyle style;
  final String language;

  @override
  Widget build(BuildContext context) {
    final text = value.toString().padLeft(2, '0');
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: [
        for (final glyph in text.split(''))
          _DigitColumn(
            digit: int.parse(glyph),
            style: style,
            language: language,
          ),
      ],
    );
  }
}

class _DigitColumn extends StatelessWidget {
  const _DigitColumn({
    required this.digit,
    required this.style,
    required this.language,
  });

  final int digit;
  final TextStyle style;
  final String language;

  @override
  Widget build(BuildContext context) {
    final line = style.fontSize!;
    final probe = TextPainter(
      text: TextSpan(text: '0', style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    final reduced = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(end: digit.toDouble()),
      duration: reduced
          ? Duration.zero
          : slowed(HtmlJourneyTokens.obOdometerMs),
      curve: HtmlJourneyTokens.obOdometerCurve,
      builder: (context, shown, _) => ClipRect(
        child: SizedBox(
          width: probe.width,
          height: line,
          child: OverflowBox(
            alignment: Alignment.topCenter,
            maxHeight: double.infinity,
            child: Transform.translate(
              offset: Offset(0, -shown * line),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 10; i++)
                    SizedBox(
                      height: line,
                      child: Text(
                        localizedDigits('$i', languageCode: language),
                        style: style,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.fraction,
    required this.halo,
    required this.tip,
  });

  final double fraction;
  final double halo;
  final Color tip;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / HtmlJourneyTokens.obRingViewBox;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = HtmlJourneyTokens.questRingRadius * scale;
    final stroke = HtmlJourneyTokens.questRingStroke * scale;
    for (var k = 0; k < HtmlJourneyTokens.questRingTicks; k++) {
      final big = k % 5 == 0;
      final angle = k * math.pi * 2 / HtmlJourneyTokens.questRingTicks;
      final direction = Offset(math.sin(angle), -math.cos(angle));
      final inner = big
          ? HtmlJourneyTokens.obTickBigInner
          : HtmlJourneyTokens.obTickSmallInner;
      canvas.drawLine(
        center + direction * inner * scale,
        center + direction * HtmlJourneyTokens.obTickOuter * scale,
        Paint()
          ..color = big
              ? HtmlJourneyTokens.obTickBig
              : HtmlJourneyTokens.obTickSmall
          ..strokeWidth =
              (big
                  ? HtmlJourneyTokens.obTickBigWidth
                  : HtmlJourneyTokens.obTickSmallWidth) *
              scale
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = HtmlJourneyTokens.obTrack,
    );
    if (fraction <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * fraction,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HtmlJourneyTokens.splashGradientEnd,
            HtmlJourneyTokens.splashGradientMid,
          ],
        ).createShader(Offset.zero & size),
    );
    final angle = -math.pi / 2 + math.pi * 2 * fraction;
    final tipCenter =
        center + Offset(math.cos(angle), math.sin(angle)) * radius;
    final pulse = HtmlJourneyTokens.easeInOut.transform(
      1 - (2 * halo - 1).abs(),
    );
    canvas.drawCircle(
      tipCenter,
      HtmlJourneyTokens.obTipHalo * scale * (0.85 + 0.5 * pulse),
      Paint()
        ..color = HtmlJourneyTokens.splashGradientMid.withValues(
          alpha: 0.45 - 0.33 * pulse,
        ),
    );
    canvas.drawCircle(
      tipCenter,
      HtmlJourneyTokens.obTipDot * scale,
      Paint()..color = tip,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.fraction != fraction ||
      oldDelegate.halo != halo ||
      oldDelegate.tip != tip;
}
