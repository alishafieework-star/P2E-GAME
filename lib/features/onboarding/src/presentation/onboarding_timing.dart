import 'package:flutter/widgets.dart';
import 'package:p2e_design_system/design_system.dart';

/// HTML durations play 1.45 times slower (D-138).
Duration slowed(Duration base) => Duration(
  milliseconds: (base.inMilliseconds * HtmlJourneyTokens.onboardingPlayback)
      .round(),
);

/// Progress of a base-time window, 0 before [start] and 1 after the end.
double window(double base, Duration start, Duration length, [Curve? curve]) {
  final span = length.inMilliseconds;
  final raw = span == 0
      ? (base >= start.inMilliseconds ? 1.0 : 0.0)
      : ((base - start.inMilliseconds) / span).clamp(0.0, 1.0);
  return curve == null ? raw : curve.transform(raw);
}

/// Piecewise-linear value over keyframe [stops], like WAAPI keyframes.
double keyframes(double t, List<double> stops, List<double> values) {
  if (t <= stops.first) return values.first;
  for (var i = 1; i < stops.length; i++) {
    if (t <= stops[i]) {
      final k = (t - stops[i - 1]) / (stops[i] - stops[i - 1]);
      return values[i - 1] + (values[i] - values[i - 1]) * k;
    }
  }
  return values.last;
}

/// Outfit text for the onboarding scenes. Sizes come from HTML tokens; the
/// family and weights come from the Figma named styles (Auth set).
abstract final class OnboardingType {
  static TextStyle get _semibold =>
      AuthTextTokens.byName['English/Baseline/Label-Medium']!;
  static TextStyle get _medium =>
      AuthTextTokens.byName['English/Variant/Button-Medium']!;
  static TextStyle get _regular =>
      AuthTextTokens.byName['English/Muted/Label-Medium']!;

  static TextStyle semibold(double size, double line, {double spacing = 0}) =>
      _semibold.copyWith(
        fontSize: size,
        height: line / size,
        letterSpacing: spacing * size,
      );

  static TextStyle medium(double size, double line, {double spacing = 0}) =>
      _medium.copyWith(
        fontSize: size,
        height: line / size,
        letterSpacing: spacing * size,
      );

  static TextStyle regular(double size, double line, {double spacing = 0}) =>
      _regular.copyWith(
        fontSize: size,
        height: line / size,
        letterSpacing: spacing * size,
      );
}

const _loopSeconds = 3600;

/// One scene clock (HTML timeline, played slower) plus a free-running loop for
/// the endless decorations.
class ScenePlayer {
  ScenePlayer({required TickerProvider vsync, required this.length})
    : clock = AnimationController(vsync: vsync, duration: slowed(length)),
      loop = AnimationController.unbounded(vsync: vsync);

  final Duration length;
  final AnimationController clock;
  final AnimationController loop;

  /// Elapsed scene time in unslowed (HTML) milliseconds.
  double get base => clock.value * length.inMilliseconds;

  Listenable get listenable => Listenable.merge([clock, loop]);

  /// 0..1 inside one repeating cycle of [period] (HTML length, played slower).
  double cycle(Duration period) {
    final seconds = slowed(period).inMilliseconds / 1000;
    return (loop.value / seconds) % 1;
  }

  void sync(
    BuildContext context, {
    required bool active,
    required bool restart,
  }) {
    if (MediaQuery.disableAnimationsOf(context)) {
      clock.value = 1;
      loop.stop();
      return;
    }
    if (!active) {
      clock.stop();
      clock.value = 0;
      loop.stop();
      return;
    }
    if (restart || (!clock.isAnimating && clock.value == 0)) {
      clock.forward(from: 0);
    }
    if (!loop.isAnimating) {
      // The loop value counts seconds, so every cycle reads it directly.
      loop.repeat(
        min: 0,
        max: _loopSeconds.toDouble(),
        period: const Duration(seconds: _loopSeconds),
      );
    }
  }

  void dispose() {
    clock.dispose();
    loop.dispose();
  }
}
