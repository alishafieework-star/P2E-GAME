import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
  var loggedDeps = false;
  String? _playedCue;
  Timer? _collapseTimer;
  Timer? _finishTimer;

  static final total =
      HtmlJourneyTokens.splashReveal + HtmlJourneyTokens.splashRevealDuration;

  @override
  void initState() {
    super.initState();
    clock = AnimationController(vsync: this, duration: total)
      ..addListener(_onTick);
    // #region agent log
    _splashLog('B', 'splash created', {
      'hash': identityHashCode(this),
      'durationMs': total.inMilliseconds,
    });
    // #endregion
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = MediaQuery.disableAnimationsOf(context);
    // #region agent log
    if (!loggedDeps) {
      loggedDeps = true;
      _splashLog('C', 'splash dependencies', {
        'hash': identityHashCode(this),
        'reduced': reduced,
        'clock': clock.value,
        'finished': finished,
        'collapsed': collapsed,
        'gate': ref.read(splashGateProvider).name,
      });
    }
    // #endregion
    _begin(reduced);
  }

  void _begin(bool reduced) {
    _collapseTimer?.cancel();
    _finishTimer?.cancel();
    if (reduced) {
      if (clock.isAnimating) clock.stop();
      if (!reducedArmed) {
        reducedArmed = true;
        _finishTimer = Timer(HtmlJourneyTokens.splashReduced, _finishReduced);
      }
      return;
    }
    if (!clock.isAnimating && clock.value == 0 && !finished) {
      clock.forward();
      // Timers keep the gate moving when a host does not tick animations.
      _collapseTimer = Timer(HtmlJourneyTokens.splashCollapse, () {
        if (!mounted || collapsed) return;
        collapsed = true;
        ref.read(splashGateProvider.notifier).collapse();
      });
      _finishTimer = Timer(total, () {
        if (!mounted || finished) return;
        setState(() => finished = true);
      });
    }
  }

  void _restart() {
    // #region agent log
    _splashLog('B', 'splash replay', {
      'cue': _playedCue,
      'hash': identityHashCode(this),
    }, runId: 'post-fix');
    // #endregion
    _collapseTimer?.cancel();
    _finishTimer?.cancel();
    collapsed = false;
    reducedArmed = false;
    clock.stop();
    clock.value = 0;
    setState(() => finished = false);
    _begin(MediaQuery.disableAnimationsOf(context));
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
    if (elapsed >= total && !finished) {
      // #region agent log
      _splashLog('B', 'splash animation finished', {
        'hash': identityHashCode(this),
        'elapsedMs': elapsed.inMilliseconds,
      });
      // #endregion
      setState(() => finished = true);
    }
  }

  void _finishReduced() {
    if (!mounted) return;
    ref.read(splashGateProvider.notifier).collapse();
    setState(() => finished = true);
    // #region agent log
    _splashLog('C', 'splash reduced finished', {
      'hash': identityHashCode(this),
    });
    // #endregion
  }

  void _splashLog(
    String hypothesisId,
    String message,
    Map<String, Object?> data, {
    String runId = 'pre-fix',
  }) {
    // #region agent log
    try {
      File(r'd:\projects\My-Game\.cursor\debug-e2ebb3.log').writeAsStringSync(
        '${jsonEncode({'sessionId': 'e2ebb3', 'runId': runId, 'hypothesisId': hypothesisId, 'location': 'splash_overlay.dart', 'message': message, 'data': data, 'timestamp': DateTime.now().millisecondsSinceEpoch})}\n',
        mode: FileMode.append,
      );
    } catch (_) {}
    // #endregion
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    _finishTimer?.cancel();
    clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cue = ref.watch(splashCueProvider);
    final replay = cue == 'route.startup' || cue == 'startup.session';
    if (replay && cue != _playedCue) {
      _playedCue = cue;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _playedCue != cue) return;
        _restart();
      });
    }
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
