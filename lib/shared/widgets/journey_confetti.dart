import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:p2e_design_system/design_system.dart';

/// Which HTML burst to play.
enum JourneyConfettiStyle {
  /// `confetti()` (All Set): rich burst from the upper middle.
  burst,

  /// `lbConfetti()` (Onboarding climb): two side cannons and a top burst.
  celebration,
}

/// One-shot confetti shared by the climb slide and All Set (D-138, D-140).
/// It paints nothing once the burst has ended.
class JourneyConfetti extends StatefulWidget {
  const JourneyConfetti({
    super.key,
    this.style = JourneyConfettiStyle.burst,
    this.delay = Duration.zero,
  });

  final JourneyConfettiStyle style;
  final Duration delay;

  @override
  State<JourneyConfetti> createState() => _JourneyConfettiState();
}

class _JourneyConfettiState extends State<JourneyConfetti>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  final repaint = ValueNotifier<int>(0);
  late final List<_Bit> bits;
  var done = false;
  var frames = 0;
  var started = false;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    bits = widget.style == JourneyConfettiStyle.burst
        ? _burstBits(random)
        : _celebrationBits(random);
    ticker = createTicker(_tick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      done = true;
    } else if (!started) {
      started = true;
      if (widget.delay == Duration.zero) {
        ticker.start();
      } else {
        _delayTimer = Timer(widget.delay, () {
          if (mounted && !done) {
            ticker.start();
          }
        });
      }
    }
  }

  void _tick(Duration elapsed) {
    final limit = widget.style == JourneyConfettiStyle.burst
        ? HtmlJourneyTokens.confettiDuration
        : HtmlJourneyTokens.obCfMaxMs;
    final target = widget.style == JourneyConfettiStyle.burst
        ? (elapsed.inMicroseconds / 1000 / 16).floor()
        : (elapsed.inMicroseconds / 1000 / HtmlJourneyTokens.obCfFrame).floor();
    while (frames < target) {
      for (final bit in bits) {
        bit.advance(widget.style);
      }
      frames++;
    }
    final alive = bits.any((bit) => bit.y < HtmlJourneyTokens.obCfHeight + 30);
    if (elapsed >= limit || !alive) {
      ticker.stop();
      setState(() => done = true);
      return;
    }
    repaint.value++;
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    ticker.dispose();
    repaint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (done) return const SizedBox.shrink();
    return IgnorePointer(
      child: CustomPaint(
        painter: _ConfettiPainter(
          bits: bits,
          style: widget.style,
          repaint: repaint,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

List<_Bit> _burstBits(math.Random random) {
  const colors = [
    HtmlJourneyTokens.obCf0,
    HtmlJourneyTokens.obCf1,
    HtmlJourneyTokens.obCf2,
    HtmlJourneyTokens.obCf3,
    HtmlJourneyTokens.obCf4,
    HtmlJourneyTokens.obCf5,
    HtmlJourneyTokens.obCf6,
    HtmlJourneyTokens.obCf7,
    HtmlJourneyTokens.obCf8,
    HtmlJourneyTokens.obCf9,
  ];
  return [
    for (var i = 0; i < 180; i++)
      _Bit(
        x: HtmlJourneyTokens.obCfWidth / 2,
        y: HtmlJourneyTokens.obCfHeight * HtmlJourneyTokens.edgeFadeStop,
        vx: (random.nextDouble() - 0.5) * 12.0,
        vy: -random.nextDouble() * 11.0 - 4.0,
        width:
            HtmlJourneyTokens.obCfW0 +
            random.nextDouble() * HtmlJourneyTokens.obCfWRange,
        height:
            HtmlJourneyTokens.obCfH0 +
            random.nextDouble() * HtmlJourneyTokens.obCfHRange,
        rotation: random.nextDouble() * math.pi * 2,
        spin: (random.nextDouble() - 0.5) * HtmlJourneyTokens.obCfSpin,
        flip: random.nextDouble() * math.pi * 2,
        flipSpeed:
            HtmlJourneyTokens.obCfFlip0 +
            random.nextDouble() * HtmlJourneyTokens.obCfFlipRange,
        round: random.nextDouble() < HtmlJourneyTokens.obCfRound,
        color: colors[random.nextInt(colors.length)],
      ),
  ];
}

List<_Bit> _celebrationBits(math.Random random) {
  const colors = [
    HtmlJourneyTokens.obCf0,
    HtmlJourneyTokens.obCf1,
    HtmlJourneyTokens.obCf2,
    HtmlJourneyTokens.obCf3,
    HtmlJourneyTokens.obCf4,
    HtmlJourneyTokens.obCf5,
    HtmlJourneyTokens.obCf6,
    HtmlJourneyTokens.obCf7,
    HtmlJourneyTokens.obCf8,
    HtmlJourneyTokens.obCf9,
  ];
  final bits = <_Bit>[];
  void add(
    double x,
    double y,
    int count,
    double a0,
    double a1,
    double v0,
    double v1,
  ) {
    for (var i = 0; i < count; i++) {
      final angle = (a0 + random.nextDouble() * (a1 - a0)) * math.pi / 180;
      final speed = v0 + random.nextDouble() * (v1 - v0);
      bits.add(
        _Bit(
          x: x,
          y: y,
          vx: math.cos(angle) * speed,
          vy: math.sin(angle) * speed,
          width:
              HtmlJourneyTokens.obCfW0 +
              random.nextDouble() * HtmlJourneyTokens.obCfWRange,
          height:
              HtmlJourneyTokens.obCfH0 +
              random.nextDouble() * HtmlJourneyTokens.obCfHRange,
          rotation: random.nextDouble() * math.pi * 2,
          spin: (random.nextDouble() - 0.5) * HtmlJourneyTokens.obCfSpin,
          flip: random.nextDouble() * math.pi * 2,
          flipSpeed:
              HtmlJourneyTokens.obCfFlip0 +
              random.nextDouble() * HtmlJourneyTokens.obCfFlipRange,
          round: random.nextDouble() < HtmlJourneyTokens.obCfRound,
          color: colors[random.nextInt(colors.length)],
        ),
      );
    }
  }

  add(
    -HtmlJourneyTokens.obCfSideOut,
    HtmlJourneyTokens.obCfSideY,
    HtmlJourneyTokens.obCfSideCount,
    HtmlJourneyTokens.obCfLeftA0,
    HtmlJourneyTokens.obCfLeftA1,
    HtmlJourneyTokens.obCfSideV0,
    HtmlJourneyTokens.obCfSideV1,
  );
  add(
    HtmlJourneyTokens.obCfWidth + HtmlJourneyTokens.obCfSideOut,
    HtmlJourneyTokens.obCfSideY,
    HtmlJourneyTokens.obCfSideCount,
    HtmlJourneyTokens.obCfRightA0,
    HtmlJourneyTokens.obCfRightA1,
    HtmlJourneyTokens.obCfSideV0,
    HtmlJourneyTokens.obCfSideV1,
  );
  add(
    HtmlJourneyTokens.obCfWidth / 2,
    HtmlJourneyTokens.obCfTopY,
    HtmlJourneyTokens.obCfTopCount,
    HtmlJourneyTokens.obCfTopA0,
    HtmlJourneyTokens.obCfTopA1,
    HtmlJourneyTokens.obCfTopV0,
    HtmlJourneyTokens.obCfTopV1,
  );
  return bits;
}

/// One particle, simulated in the HTML's 402 x 874 space.
class _Bit {
  _Bit({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.width,
    required this.height,
    required this.spin,
    required this.flip,
    required this.round,
    required this.color,
    this.rotation = 0,
    this.flipSpeed = 0,
  });

  double x, y, vx, vy, rotation, flip;
  final double width, height, spin, flipSpeed;
  final bool round;
  final Color color;

  void advance(JourneyConfettiStyle style) {
    if (style == JourneyConfettiStyle.burst) {
      vx *= 0.985;
      vy = vy * 0.985 + 0.28;
    } else {
      vx *= HtmlJourneyTokens.obCfDrag;
      vy = vy * HtmlJourneyTokens.obCfDrag + HtmlJourneyTokens.obCfGravity;
    }
    x += vx;
    y += vy;
    rotation += spin;
    flip += flipSpeed;
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.bits,
    required this.style,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<_Bit> bits;
  final JourneyConfettiStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / HtmlJourneyTokens.obCfWidth;
    final sy = size.height / HtmlJourneyTokens.obCfHeight;
    for (final bit in bits) {
      canvas.save();
      canvas.translate(bit.x * sx, bit.y * sy);
      canvas.rotate(bit.rotation);
      canvas.scale(sx, sx * math.cos(bit.flip));
      final paint = Paint()..color = bit.color;
      if (bit.round) {
        canvas.drawCircle(Offset.zero, bit.width / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: bit.width,
            height: bit.height,
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => false;
}
