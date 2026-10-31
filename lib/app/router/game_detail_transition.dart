import 'package:flutter/widgets.dart';

/// D-131: entering Game Details squeezes the page below, then slides this
/// page in from the end. Figma defines no motion for the push.
abstract final class GameDetailTransition {
  static const duration = Duration(milliseconds: 320);
  static const squeeze = 0.94;
  static const squeezeEnd = 0.35;
  static const slideStart = 0.22;
}

class GameDetailTransitionPage extends Page<void> {
  const GameDetailTransitionPage({required this.child, super.key});

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) =>
      GameDetailTransitionRoute(this);
}

class GameDetailTransitionRoute extends PageRoute<void> {
  GameDetailTransitionRoute(GameDetailTransitionPage page)
    : super(settings: page);

  GameDetailTransitionPage get page => settings as GameDetailTransitionPage;

  bool get _reduced {
    final context = navigator?.context;
    return context != null && MediaQuery.disableAnimationsOf(context);
  }

  @override
  Duration get transitionDuration =>
      _reduced ? Duration.zero : GameDetailTransition.duration;

  @override
  Duration get reverseTransitionDuration => transitionDuration;

  @override
  DelegatedTransitionBuilder? get delegatedTransition => _squeezePageBelow;

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
    return _SlideIn(animation: animation, child: child);
  }
}

Widget? _squeezePageBelow(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  bool allowSnapshotting,
  Widget? child,
) {
  if (child == null || MediaQuery.disableAnimationsOf(context)) return child;
  return _Squeeze(
    animation: secondaryAnimation,
    alignment: AlignmentDirectional.centerStart.resolve(
      Directionality.of(context),
    ),
    child: child,
  );
}

class _Squeeze extends StatefulWidget {
  const _Squeeze({
    required this.animation,
    required this.alignment,
    required this.child,
  });

  final Animation<double> animation;
  final Alignment alignment;
  final Widget child;

  @override
  State<_Squeeze> createState() => _SqueezeState();
}

class _SqueezeState extends State<_Squeeze> {
  late CurvedAnimation _curved;

  @override
  void initState() {
    super.initState();
    _bind(widget.animation);
  }

  void _bind(Animation<double> parent) {
    _curved = CurvedAnimation(
      parent: parent,
      curve: const Interval(
        0,
        GameDetailTransition.squeezeEnd,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(_Squeeze oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation == widget.animation) return;
    _curved.dispose();
    _bind(widget.animation);
  }

  @override
  void dispose() {
    _curved.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _curved,
    builder: (context, child) {
      final scale = 1 + (GameDetailTransition.squeeze - 1) * _curved.value;
      return Transform.scale(
        scale: scale,
        alignment: widget.alignment,
        child: child,
      );
    },
    child: widget.child,
  );
}

class _SlideIn extends StatefulWidget {
  const _SlideIn({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  State<_SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<_SlideIn> {
  late CurvedAnimation _curved;

  @override
  void initState() {
    super.initState();
    _bind(widget.animation);
  }

  void _bind(Animation<double> parent) {
    _curved = CurvedAnimation(
      parent: parent,
      curve: const Interval(
        GameDetailTransition.slideStart,
        1,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(_SlideIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation == widget.animation) return;
    _curved.dispose();
    _bind(widget.animation);
  }

  @override
  void dispose() {
    _curved.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _curved,
    builder: (context, child) {
      final remaining = 1 - _curved.value;
      final towardEnd = Directionality.of(context) == TextDirection.rtl
          ? -remaining
          : remaining;
      return FractionalTranslation(
        translation: Offset(towardEnd, 0),
        child: child,
      );
    },
    child: widget.child,
  );
}
