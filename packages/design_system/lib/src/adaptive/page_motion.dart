import 'package:flutter/widgets.dart';

import '../tokens/generated/html_journey_tokens.g.dart';

/// HTML page-to-page motion (D-145). The route publishes its two animations;
/// [PageBodyMotion] moves only the page body while the app bar stays put, as in
/// the prototype (`.in-fwd > .body`, `.out-fwd > .body`, `.in-back`, `.out-back`).
class PageMotionScope extends InheritedWidget {
  const PageMotionScope({
    super.key,
    required Animation<double> this.animation,
    required Animation<double> this.secondaryAnimation,
    required super.child,
  });

  /// Stops an outer route's motion from reaching pages in a nested navigator.
  const PageMotionScope.none({super.key, required super.child})
    : animation = null,
      secondaryAnimation = null;

  final Animation<double>? animation;
  final Animation<double>? secondaryAnimation;

  static PageMotionScope? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PageMotionScope>();
    return scope?.animation == null ? null : scope;
  }

  /// Whole route time: the delayed entrance is the longest part.
  static Duration get duration =>
      HtmlJourneyTokens.pgInDelayMs + HtmlJourneyTokens.pgInMs;

  @override
  bool updateShouldNotify(PageMotionScope old) =>
      old.animation != animation ||
      old.secondaryAnimation != secondaryAnimation;
}

/// The state of one page during a transition.
class _PageMotionFrame {
  const _PageMotionFrame({
    required this.opacity,
    required this.shift,
    required this.scale,
    required this.barVisible,
  });

  final double opacity, shift, scale;
  final bool barVisible;

  static _PageMotionFrame of(PageMotionScope scope) {
    final total = PageMotionScope.duration.inMilliseconds;
    final start = HtmlJourneyTokens.pgInDelayMs.inMilliseconds / total;
    final out = HtmlJourneyTokens.pgOutMs.inMilliseconds / total;
    double enter(double t) => HtmlJourneyTokens.ease.transform(
      ((t - start) / (1 - start)).clamp(0.0, 1.0),
    );
    double leave(double t) =>
        HtmlJourneyTokens.easeIn.transform((t / out).clamp(0.0, 1.0));

    var opacity = 1.0, shift = 0.0, scale = 1.0;
    var barVisible = true;

    final own = scope.animation!;
    if (own.status == AnimationStatus.reverse) {
      // `outB`: the popped page leaves toward the end side.
      final p = leave(1 - own.value);
      opacity *= 1 - p;
      shift += HtmlJourneyTokens.pgOutShift * p;
      scale *= 1 - (1 - HtmlJourneyTokens.pgOutScale) * p;
      barVisible = false;
    } else if (own.value < 1) {
      // `inF`: the new page arrives from the end side.
      final q = enter(own.value);
      opacity *= q;
      shift += HtmlJourneyTokens.pgInShift * (1 - q);
    }

    final under = scope.secondaryAnimation!;
    if (under.value > 0) {
      if (under.status == AnimationStatus.reverse) {
        // `inB`: the page below returns from the start side.
        final q = enter(1 - under.value);
        opacity *= q;
        shift -= HtmlJourneyTokens.pgInShift * (1 - q);
      } else {
        // `outF`: the page below leaves toward the start side.
        final p = leave(under.value);
        opacity *= 1 - p;
        shift -= HtmlJourneyTokens.pgOutShift * p;
        scale *= 1 - (1 - HtmlJourneyTokens.pgOutScale) * p;
        barVisible = false;
      }
    }
    return _PageMotionFrame(
      opacity: opacity,
      shift: shift,
      scale: scale,
      barVisible: barVisible,
    );
  }
}

/// Wraps a page body. Without a [PageMotionScope] (or with reduced motion) it
/// is transparent.
class PageBodyMotion extends StatelessWidget {
  const PageBodyMotion({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = PageMotionScope.maybeOf(context);
    if (scope == null || MediaQuery.disableAnimationsOf(context)) return child;
    final direction = Directionality.of(context);
    return AnimatedBuilder(
      animation: Listenable.merge([
        scope.animation!,
        scope.secondaryAnimation!,
      ]),
      child: child,
      builder: (context, child) {
        final frame = _PageMotionFrame.of(scope);
        if (frame.opacity >= 1 && frame.shift == 0 && frame.scale == 1) {
          return child!;
        }
        return IgnorePointer(
          ignoring: frame.opacity < 1,
          child: Opacity(
            opacity: frame.opacity.clamp(0.0, 1.0),
            child: Transform(
              alignment: Alignment.center,
              // PHYSICAL: x is mirrored by hand so "end" follows RTL.
              transform: Matrix4.identity()
                ..translateByDouble(
                  direction == TextDirection.rtl ? -frame.shift : frame.shift,
                  0,
                  0,
                  1,
                )
                ..scaleByDouble(frame.scale, frame.scale, 1, 1),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Hides the app bar of a page that is leaving, as `.out-fwd > .appbar`.
class PageBarMotion extends StatelessWidget {
  const PageBarMotion({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = PageMotionScope.maybeOf(context);
    if (scope == null || MediaQuery.disableAnimationsOf(context)) return child;
    return AnimatedBuilder(
      animation: Listenable.merge([
        scope.animation!,
        scope.secondaryAnimation!,
      ]),
      child: child,
      builder: (context, child) => Visibility(
        visible: _PageMotionFrame.of(scope).barVisible,
        maintainState: true,
        maintainSize: true,
        maintainAnimation: true,
        child: child!,
      ),
    );
  }
}
