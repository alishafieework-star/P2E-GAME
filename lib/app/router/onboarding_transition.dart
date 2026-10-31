import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:p2e_design_system/design_system.dart';

/// HTML soft-out on the leaving Onboarding route (D-138).
class OnboardingTransitionPage extends Page<void> {
  const OnboardingTransitionPage({required this.child, super.key});

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) =>
      OnboardingTransitionRoute(this);
}

class OnboardingTransitionRoute extends PageRoute<void> {
  OnboardingTransitionRoute(OnboardingTransitionPage page)
    : super(settings: page);

  OnboardingTransitionPage get page => settings as OnboardingTransitionPage;

  bool get _reduced {
    final context = navigator?.context;
    return context != null && MediaQuery.disableAnimationsOf(context);
  }

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Duration get reverseTransitionDuration =>
      _reduced ? Duration.zero : HtmlJourneyTokens.softIn;

  @override
  DelegatedTransitionBuilder? get delegatedTransition => _softInBelow;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get fullscreenDialog => false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Semantics(scopesRoute: true, explicitChildNodes: true, child: page.child);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return _SoftOut(animation: animation, child: child);
  }
}

Widget? _softInBelow(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  bool allowSnapshotting,
  Widget? child,
) {
  if (child == null || MediaQuery.disableAnimationsOf(context)) return child;
  return _SoftIn(animation: secondaryAnimation, child: child);
}

class _SoftOut extends StatelessWidget {
  const _SoftOut({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final span =
            HtmlJourneyTokens.softOut.inMilliseconds /
            HtmlJourneyTokens.softIn.inMilliseconds;
        final leave = (1 - animation.value).clamp(0.0, 1.0);
        final t = (leave / span).clamp(0.0, 1.0);
        final scale = lerpDouble(1, HtmlJourneyTokens.softOutScale, t)!;
        final blur = lerpDouble(0, HtmlJourneyTokens.softOutBlur, t)!;
        return Opacity(
          opacity: (1 - t).clamp(0.0, 1.0),
          child: ImageFiltered(
            enabled: blur > 0,
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: child,
    );
  }
}

class _SoftIn extends StatelessWidget {
  const _SoftIn({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final reveal = (1 - animation.value).clamp(0.0, 1.0);
        final start =
            HtmlJourneyTokens.softInDelay.inMilliseconds /
            HtmlJourneyTokens.softIn.inMilliseconds;
        final delayed = reveal <= start
            ? 0.0
            : ((reveal - start) / (1 - start)).clamp(0.0, 1.0);
        final t = HtmlJourneyTokens.ease.transform(delayed);
        final scale = lerpDouble(HtmlJourneyTokens.softInScale, 1, t)!;
        final blur = lerpDouble(HtmlJourneyTokens.softInBlur, 0, t)!;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: ImageFiltered(
            enabled: blur > 0,
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: child,
    );
  }
}
