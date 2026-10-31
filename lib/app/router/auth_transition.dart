import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

import 'onboarding_transition.dart';

/// D-073: one page transition for every platform. Figma defines none.
/// Dialogs and other routes still use this theme; auth pages use the HTML
/// motion below (D-145).
const sharedAuthPageTransitions = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
    TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
    TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
  },
);

class AuthTransitionPage extends Page<void> {
  const AuthTransitionPage({
    required this.child,
    this.wholePage = false,
    super.key,
  });
  final Widget child;

  /// A page that has no PageScaffold (the tab shell) moves as one piece.
  final bool wholePage;

  @override
  Route<void> createRoute(BuildContext context) => AuthTransitionRoute(this);
}

class AuthTransitionRoute extends PageRoute<void> {
  AuthTransitionRoute(AuthTransitionPage page) : super(settings: page);

  AuthTransitionPage get page => settings as AuthTransitionPage;

  bool get _reduced {
    final context = navigator?.context;
    return context != null && MediaQuery.disableAnimationsOf(context);
  }

  @override
  Duration get transitionDuration =>
      _reduced ? Duration.zero : PageMotionScope.duration;

  @override
  Duration get reverseTransitionDuration => transitionDuration;

  var _underOnboarding = false;

  @override
  void didChangeNext(Route<dynamic>? nextRoute) {
    super.didChangeNext(nextRoute);
    _underOnboarding = nextRoute is OnboardingTransitionRoute;
  }

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
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) =>
      nextRoute is PageRoute &&
      !nextRoute.fullscreenDialog &&
      (nextRoute is AuthTransitionRoute ||
          nextRoute is OnboardingTransitionRoute);

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) =>
      previousRoute is PageRoute && !fullscreenDialog;

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
    // The onboarding hand-off keeps its own soft-in below (D-138).
    final under = _underOnboarding
        ? kAlwaysDismissedAnimation
        : secondaryAnimation;
    return PageMotionScope(
      animation: animation,
      secondaryAnimation: under,
      child: page.wholePage
          ? PageBodyMotion(child: PageMotionScope.none(child: child))
          : child,
    );
  }
}
