import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2e_design_system/design_system.dart';

import 'animated_logo.dart';
import 'startup_controller.dart';

/// Covers the router until the logo hole reveals the next page (D-137).
class SplashOverlay extends ConsumerStatefulWidget {
  const SplashOverlay({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<SplashOverlay> createState() => _SplashOverlayState();
}

class _SplashOverlayState extends ConsumerState<SplashOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController clock;
  var finished = false;
  var collapsed = false;
  var reducedArmed = false;

  static final total =
      HtmlJourneyTokens.splashReveal + HtmlJourneyTokens.splashRevealDuration;

  @override
  void initState() {
    super.initState();
    clock = AnimationController(vsync: this, duration: total)
      ..addListener(_onTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = MediaQuery.disableAnimationsOf(context);
    if (reduced) {
      if (clock.isAnimating) clock.stop();
      if (!reducedArmed) {
        reducedArmed = true;
        Future<void>.delayed(HtmlJourneyTokens.splashReduced, _finishReduced);
      }
      return;
    }
    if (!clock.isAnimating && clock.value == 0 && !finished) {
      clock.forward();
      // Timers keep the gate moving when a host does not tick animations.
      Future<void>.delayed(HtmlJourneyTokens.splashCollapse, () {
        if (!mounted || collapsed) return;
        collapsed = true;
        ref.read(splashGateProvider.notifier).collapse();
      });
      Future<void>.delayed(total, () {
        if (!mounted || finished) return;
        setState(() => finished = true);
      });
    }
  }

  void _onTick() {
    if (!mounted || finished) return;
    final elapsed = total * clock.value;
    if (!collapsed && elapsed >= HtmlJourneyTokens.splashCollapse) {
      collapsed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(splashGateProvider.notifier).collapse();
      });
    }
    if (elapsed >= total) setState(() => finished = true);
  }

  void _finishReduced() {
    if (!mounted) return;
    ref.read(splashGateProvider.notifier).collapse();
    setState(() => finished = true);
  }

  @override
  void dispose() {
    clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(ignoring: !finished, child: widget.child),
        if (!finished)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: clock,
              builder: (context, _) => ExcludeSemantics(
                child: AnimatedLogo(
                  elapsed: total * clock.value,
                  reduced: reduced,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
