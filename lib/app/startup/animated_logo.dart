import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p2e_design_system/design_system.dart';

const _logoLayers = [
  'assets/images/brand/logo/bg.svg',
  'assets/images/brand/logo/g_00.svg',
  'assets/images/brand/logo/g_01.svg',
  'assets/images/brand/logo/g_02.svg',
  'assets/images/brand/logo/g_03.svg',
  'assets/images/brand/logo/g_04.svg',
  'assets/images/brand/logo/g_05.svg',
  'assets/images/brand/logo/g_06.svg',
  'assets/images/brand/logo/g_07.svg',
  'assets/images/brand/logo/g_08.svg',
  'assets/images/brand/logo/g_09.svg',
  'assets/images/brand/logo/g_10.svg',
  'assets/images/brand/logo/g_11.svg',
  'assets/images/brand/logo/m.svg',
  'assets/images/brand/logo/ring.svg',
  'assets/images/brand/logo/hole.svg',
];

// HTML easing names: --ease, --spring, CSS `ease`, and the two cubic curves
// used by the collapse and reveal (P2E - v1.0.html lines 412-460).
const _ease = Cubic(0.22, 1, 0.36, 1);
const _spring = Cubic(0.34, 1.56, 0.64, 1);
const _cssEase = Cubic(0.25, 0.1, 0.25, 1);
const _inOut = Cubic(0.65, 0, 0.35, 1);
const _move = Cubic(0.45, 0, 0.2, 1);
const _easeInOut = Cubic(0.42, 0, 0.58, 1);

/// The HTML wordmark, played on one clock (D-137).
class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key, required this.elapsed, required this.reduced});

  final Duration elapsed;
  final bool reduced;

  static const holeX = 217 / 500;
  static const holeY = 71.8 / 330;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final unit = size.shortestSide / 402;
        final logoW = 220 * unit;
        final logoH = logoW * 330 / 500;
        // Reduced motion shows the finished logo with no collapse.
        final ms = reduced ? 2000.0 : elapsed.inMilliseconds.toDouble();
        final start = HtmlJourneyTokens.splashCollapse.inMilliseconds
            .toDouble();
        // `.sp-logo` transform: .85s (.45,0,.2,1) after .22s.
        final collapse = reduced
            ? 0.0
            : _move.transform(_span(ms, start + 220, 850));
        final reveal = reduced
            ? 0.0
            : _inOut.transform(
                _span(
                  ms,
                  HtmlJourneyTokens.splashReveal.inMilliseconds.toDouble(),
                  HtmlJourneyTokens.splashRevealDuration.inMilliseconds
                      .toDouble(),
                ),
              );
        final scale =
            _mix(1, 2, collapse) +
            (HtmlJourneyTokens.ringRevealScale - 2) * reveal;
        final hole = Offset(logoW * holeX, logoH * holeY);
        final resting = Offset(
          (size.width - logoW) / 2,
          (size.height - logoH) / 2,
        );
        final shift = Offset(
          size.width / 2 - (resting.dx + hole.dx),
          size.height / 2 - (resting.dy + hole.dy),
        );
        final moved = Offset.lerp(Offset.zero, shift, collapse)!;
        final radius = _mix(
          HtmlJourneyTokens.revealStartRadius * unit,
          math.sqrt(size.width * size.width + size.height * size.height),
          reveal,
        );
        final layers = _Layers(
          ms: ms,
          start: start,
          reduced: reduced,
          unit: logoW / 500,
          holeAlign: Alignment(holeX * 2 - 1, holeY * 2 - 1),
        );
        return ClipPath(
          clipper: _HoleClipper(
            center: size.center(Offset.zero),
            radius: radius,
            open: reveal > 0,
          ),
          child: ColoredBox(
            color: HtmlJourneyTokens.launchBackground,
            child: Stack(
              children: [
                _Glow(elapsed: ms, start: start, reduced: reduced),
                Positioned(
                  left: resting.dx + moved.dx,
                  top: resting.dy + moved.dy,
                  width: logoW,
                  height: logoH,
                  child: Transform(
                    alignment: Alignment(holeX * 2 - 1, holeY * 2 - 1),
                    transform: Matrix4.diagonal3Values(scale, scale, 1),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        for (var i = 0; i < _logoLayers.length; i++)
                          layers.layer(i),
                      ],
                    ),
                  ),
                ),
                if (!reduced && reveal == 0)
                  Positioned(
                    left: size.width / 2 - 74 * unit,
                    bottom: 92 * unit,
                    width: 148 * unit,
                    child: _LoadBar(elapsed: ms, start: start, unit: unit),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Per-layer timing. Every layer scales around the hole centre, as the HTML's
/// `transform-origin: 217px 71.8px` does, not around its own centre.
class _Layers {
  const _Layers({
    required this.ms,
    required this.start,
    required this.reduced,
    required this.unit,
    required this.holeAlign,
  });

  final double ms, start, unit;
  final bool reduced;
  final Alignment holeAlign;

  double _out(double delay, double length, Curve curve) => reduced
      ? 0
      : curve.transform(_span(ms, start + delay, length)).clamp(0.0, 1.0);

  Widget layer(int index) {
    final kind = switch (index) {
      0 => 'bg',
      >= 1 && < 13 => 'g',
      13 => 'm',
      14 => 'ring',
      _ => 'hole',
    };
    double intro, opacity, rise = 0, factor = 1;
    Color? tint;
    switch (kind) {
      case 'bg':
        // spBg: 1s spring from opacity 0 and scale .82 after .1s.
        final t = _span(ms, 100, 1000);
        intro = _spring.transform(t);
        opacity = intro.clamp(0.0, 1.0);
        factor =
            _mix(0.82, 1, intro) *
            _mix(1, 0.7, _out(0, 600, _inOut)); // .6s collapse
        opacity *= 1 - _out(0, 400, _cssEase);
      case 'g':
        intro = _ease.transform(_span(ms, 500 + (index - 1) * 35, 600));
        opacity = intro * (1 - _out(0, 350, _cssEase));
        rise = (1 - intro) * 14 * unit;
        factor = _mix(1, 0.35, _out(0, 550, _inOut));
      case 'm':
        intro = _ease.transform(_span(ms, 380, 700));
        opacity = intro * (1 - _out(0, 400, _cssEase));
        rise = (1 - intro) * 14 * unit;
      case 'ring':
        intro = _ease.transform(_span(ms, 380, 700));
        opacity = intro;
        rise = (1 - intro) * 14 * unit;
      default:
        // spHole: 0.7s spring from scale 0 after .55s; fill goes dark at collapse.
        intro = _spring.transform(_span(ms, 550, 700));
        opacity = 1;
        factor = intro.clamp(0.0, 1.5);
        tint = Color.lerp(
          HtmlJourneyTokens.splashGradientMid,
          HtmlJourneyTokens.launchBackground,
          _out(0, 450, _cssEase),
        );
    }
    Widget picture = SvgPicture.asset(
      _logoLayers[index],
      fit: BoxFit.fill,
      excludeFromSemantics: true,
      colorFilter: tint == null
          ? null
          : ColorFilter.mode(tint, BlendMode.srcIn),
    );
    if (kind == 'ring') {
      // The ring gains the white `drop-shadow` glow while the logo collapses.
      final glow = _out(0, 600, _cssEase);
      if (glow > 0) {
        picture = Stack(
          fit: StackFit.expand,
          children: [
            for (final (sigma, alpha) in [(11.0, 0.18), (3.0, 0.55)])
              Opacity(
                opacity: alpha * glow,
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: sigma * unit * 2.27,
                    sigmaY: sigma * unit * 2.27,
                  ),
                  child: picture,
                ),
              ),
            picture,
          ],
        );
      }
    }
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, rise),
        child: Transform.scale(
          scale: factor.clamp(0.001, 2.0),
          alignment: holeAlign,
          child: picture,
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({
    required this.elapsed,
    required this.start,
    required this.reduced,
  });
  final double elapsed, start;
  final bool reduced;

  @override
  Widget build(BuildContext context) {
    // glowIn 1.2s after .15s, then a 3s ease-in-out pulse from 1.35s.
    final appear = _ease.transform(_span(elapsed, 150, 1200));
    final cycle = ((elapsed - 1350).clamp(0, double.infinity) % 3000) / 3000;
    final wave = cycle < 0.5 ? cycle * 2 : (1 - cycle) * 2;
    final pulse = 1 + 0.08 * _easeInOut.transform(wave);
    final out = reduced ? 0.0 : _cssEase.transform(_span(elapsed, start, 550));
    return Align(
      alignment: const Alignment(0, -0.12),
      child: Opacity(
        opacity: (appear * (1 - out)).clamp(0.0, 1.0),
        child: Transform.scale(
          scale: _mix(0.6, 1, appear) * pulse * _mix(1, 0.7, out),
          child: SizedBox.square(
            dimension: 520,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    HtmlJourneyTokens.splashGradientMid.withValues(alpha: 0.13),
                    HtmlJourneyTokens.splashGradientMid.withValues(alpha: 0.05),
                    HtmlJourneyTokens.splashGradientMid.withValues(alpha: 0),
                  ],
                  stops: const [0, 0.45, 0.72],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.sp-load`: dark track, gradient fill, travelling shine and soft glow.
class _LoadBar extends StatelessWidget {
  const _LoadBar({
    required this.elapsed,
    required this.start,
    required this.unit,
  });
  final double elapsed, start, unit;

  @override
  Widget build(BuildContext context) {
    final progress = _load(elapsed);
    final fadeIn = _cssEase.transform(_span(elapsed, 700, 500));
    final fadeOut = _cssEase.transform(_span(elapsed, start, 350));
    final shineT = ((elapsed - 1000).clamp(0, double.infinity) % 1100) / 1100;
    final shine = _easeInOut.transform((shineT / 0.7).clamp(0.0, 1.0));
    return Opacity(
      opacity: (fadeIn * (1 - fadeOut)).clamp(0.0, 1.0),
      child: SizedBox(
        height: 14 * unit,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Blurred glow under the fill (`.sp-load::after`).
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FractionallySizedBox(
                widthFactor: progress,
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: SizedBox(
                    height: 14 * unit,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7 * unit),
                        gradient: RadialGradient(
                          radius: 4,
                          center: Alignment.center,
                          colors: [
                            HtmlJourneyTokens.splashGradientMid.withValues(
                              alpha: 0.35,
                            ),
                            HtmlJourneyTokens.splashGradientMid.withValues(
                              alpha: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 6 * unit,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF171717),
                  borderRadius: BorderRadius.circular(3 * unit),
                  border: Border.all(color: const Color(0x0DFFFFFF)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3 * unit),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      heightFactor: 1,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: [0, 0.6, 1],
                                colors: [
                                  HtmlJourneyTokens.splashGradientStart,
                                  HtmlJourneyTokens.splashGradientMid,
                                  HtmlJourneyTokens.splashGradientEnd,
                                ],
                              ),
                            ),
                          ),
                          // Shine: 36px band that runs from -36px to 100%.
                          LayoutBuilder(
                            builder: (context, box) => Stack(
                              children: [
                                Positioned(
                                  left:
                                      -36 * unit +
                                      (box.maxWidth + 36 * unit) * shine,
                                  width: 36 * unit,
                                  top: 0,
                                  bottom: 0,
                                  child: const DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0x00FFFFFF),
                                          Color(0xA6FFFFFF),
                                          Color(0x00FFFFFF),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoleClipper extends CustomClipper<Path> {
  const _HoleClipper({
    required this.center,
    required this.radius,
    required this.open,
  });
  final Offset center;
  final double radius;
  final bool open;

  @override
  Path getClip(Size size) {
    final full = Path()..addRect(Offset.zero & size);
    if (!open || radius <= 0) return full;
    return Path.combine(
      PathOperation.difference,
      full,
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldReclip(_HoleClipper old) =>
      old.radius != radius || old.center != center || old.open != open;
}

double _mix(num a, num b, double t) => a + (b - a) * t.clamp(0, 1);

double _span(double ms, double start, double length) {
  if (length <= 0) return ms >= start ? 1 : 0;
  return ((ms - start) / length).clamp(0, 1);
}

/// `spLoad`: 0 -> .42 at 35%, .58 at 55%, 1 at the end, eased (.45,0,.25,1).
double _load(double ms) {
  final t = _span(
    ms,
    HtmlJourneyTokens.splashLoadDelay.inMilliseconds.toDouble(),
    HtmlJourneyTokens.splashLoadDuration.inMilliseconds.toDouble(),
  );
  const curve = Cubic(0.45, 0, 0.25, 1);
  double segment(double a, double b, double from, double to) =>
      from + (to - from) * curve.transform((t - a) / (b - a));
  if (t < 0.35) return segment(0, 0.35, 0, 0.42);
  if (t < 0.55) return segment(0.35, 0.55, 0.42, 0.58);
  return segment(0.55, 1, 0.58, 1);
}
