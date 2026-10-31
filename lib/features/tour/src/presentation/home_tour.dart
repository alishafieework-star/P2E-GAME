import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/preferences/device_preferences.dart';
import 'package:mygame_p2e/shared/tour/tour_target.dart';
import 'package:p2e_design_system/design_system.dart';

/// One tour stop (HTML `HM_TOUR`). Stops point at layout slots, never at
/// content, so a different game or quest in a slot does not move the frame.
class TourStop {
  const TourStop({
    required this.id,
    required this.pad,
    required this.radius,
    this.full = false,
    this.scrollOffset = HtmlJourneyTokens.trScrollOffset,
  });

  final String id;
  final double pad, radius, scrollOffset;

  /// Edge to edge and flat (the Navigator).
  final bool full;
}

const tourStops = <TourStop>[
  TourStop(
    id: 'wallet',
    pad: HtmlJourneyTokens.trPad,
    radius: HtmlJourneyTokens.trRadius,
  ),
  TourStop(
    id: 'featured',
    pad: HtmlJourneyTokens.trPad,
    radius: HtmlJourneyTokens.trRadius,
  ),
  TourStop(
    id: 'score',
    pad: HtmlJourneyTokens.trPadCard,
    radius: HtmlJourneyTokens.trRadiusCard,
  ),
  TourStop(
    id: 'quests',
    pad: HtmlJourneyTokens.trPad,
    radius: HtmlJourneyTokens.trRadius,
    scrollOffset: HtmlJourneyTokens.trScrollOffsetQuests,
  ),
  TourStop(id: 'navigator', pad: 0, radius: 0, full: true),
];

/// First-run Home tour hosted above the shell Navigator (D-142, D-146).
///
/// The spotlight is measured from the live render box of each slot on every
/// frame, so scrolling, resizing and content changes never leave it behind.
class HomeTour extends ConsumerStatefulWidget {
  const HomeTour({super.key});

  @override
  ConsumerState<HomeTour> createState() => _HomeTourState();
}

class _HomeTourState extends ConsumerState<HomeTour>
    with TickerProviderStateMixin {
  var step = 0;
  var placed = false;
  var moving = false;
  var closing = false;
  var busy = false;
  var started = false;

  /// While the page scrolls to the next slot the frame rides along with the
  /// slot it already shows (HTML `onSc`). Null otherwise.
  int? holding;
  Rect? from;
  Rect? lastHole;

  late final AnimationController move;
  late final AnimationController pulse;
  late final AnimationController fade;
  late final AnimationController appear;
  late final AnimationController tip;
  late final Ticker ticker;
  final frame = ValueNotifier<int>(0);
  Rect? lastLive;
  Timer? pulseTimer;
  Timer? tipTimer;

  @override
  void initState() {
    super.initState();
    move = AnimationController(
      vsync: this,
      duration: HtmlJourneyTokens.tourIntro,
    );
    pulse = AnimationController(
      vsync: this,
      duration: HtmlJourneyTokens.tourPulse,
    );
    fade = AnimationController(
      vsync: this,
      duration: HtmlJourneyTokens.tourFade,
    );
    appear = AnimationController(
      vsync: this,
      duration: HtmlJourneyTokens.tourFade,
    );
    tip = AnimationController(
      vsync: this,
      duration: HtmlJourneyTokens.sheetEnter,
    );
    ticker = createTicker((_) {
      if (!placed) return;
      final live = measure(tourStops[holding ?? step]);
      if (live != lastLive) {
        lastLive = live;
        frame.value++;
      }
    });
  }

  @override
  void dispose() {
    pulseTimer?.cancel();
    tipTimer?.cancel();
    ticker.dispose();
    frame.dispose();
    move.dispose();
    pulse.dispose();
    fade.dispose();
    appear.dispose();
    tip.dispose();
    super.dispose();
  }

  bool get reduced => MediaQuery.disableAnimationsOf(context);

  BuildContext? slot(TourStop stop) {
    final target = stop.id == 'wallet'
        ? AppBarAnchors.wallet.currentContext
        : TourTarget.contextFor(stop.id);
    return target != null && target.mounted ? target : null;
  }

  /// The slot's live box in the overlay's own coordinates, with its padding.
  Rect? measure(TourStop stop) {
    final target = slot(stop);
    final box = target?.findRenderObject();
    final here = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    if (here is! RenderBox || !here.attached) return null;
    final raw = box.localToGlobal(Offset.zero, ancestor: here) & box.size;
    final width = here.size.width;
    if (stop.full) return Rect.fromLTWH(0, raw.top, width, raw.height);
    final left = math.max(HtmlJourneyTokens.trHoleEdge, raw.left - stop.pad);
    final right = math.min(
      width - HtmlJourneyTokens.trHoleEdge,
      raw.right + stop.pad,
    );
    return Rect.fromLTRB(
      left,
      raw.top - stop.pad,
      right,
      raw.bottom + stop.pad,
    );
  }

  Rect? currentHole() {
    if (!placed) return null;
    final stop = tourStops[holding ?? step];
    final live = measure(stop) ?? lastHole;
    if (live == null) return null;
    Rect result = live;
    if (holding == null && moving && from != null) {
      final t = HtmlJourneyTokens.easeInOut.transform(move.value);
      result = Rect.lerp(from, live, t) ?? live;
    }
    lastHole = result;
    return result;
  }

  /// HTML scroll rule: bring the slot into the readable band first. The
  /// vertical page scroll is resolved through the axis filter because slots
  /// like the first Recommended card live inside horizontal shelves; the
  /// nearest Scrollable would be that shelf, and moving it loses the card.
  Future<void> bringIntoView(TourStop stop) async {
    final target = slot(stop);
    if (target == null) return;
    final scrollable = Scrollable.maybeOf(target, axis: Axis.vertical);
    final box = target.findRenderObject();
    final here = context.findRenderObject();
    if (scrollable == null ||
        box is! RenderBox ||
        here is! RenderBox ||
        !box.attached) {
      return;
    }
    final top = box.localToGlobal(Offset.zero, ancestor: here).dy;
    final bottom = top + box.size.height;
    final minY = HtmlJourneyTokens.trScrollMin;
    final maxY =
        here.size.height -
        HtmlJourneyTokens.trScrollNavReserve -
        HtmlJourneyTokens.trScrollTipReserve;
    if (top >= minY && bottom <= maxY) return;
    final position = scrollable.position;
    final destination = (position.pixels + (top - stop.scrollOffset)).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (reduced) {
      position.jumpTo(destination);
      return;
    }
    tip.value = 0;
    await position.animateTo(
      destination,
      duration: HtmlJourneyTokens.trScrollMs,
      curve: HtmlJourneyTokens.ease,
    );
  }

  Future<void> go(int next) async {
    if (busy || closing) return;
    if (next >= tourStops.length) {
      await close();
      return;
    }
    final stop = tourStops[next];
    if (slot(stop) == null) {
      // A slot that does not exist today is skipped, like the HTML.
      await go(next + 1);
      return;
    }
    busy = true;
    if (!ticker.isActive) ticker.start();
    pulseTimer?.cancel();
    pulse.stop();
    final first = !placed;
    final previous = placed ? step : null;
    setState(() {
      step = next;
      holding = previous;
      moving = false;
      if (first) holding = null;
    });
    await bringIntoView(stop);
    if (!mounted) return;
    // Let layout settle one frame so the slot reports its final box.
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    final target = measure(stop);
    if (target == null) {
      busy = false;
      await go(next + 1);
      return;
    }
    final shown = first
        ? target.inflate(HtmlJourneyTokens.tourIntroInset)
        : (currentHole() ?? target);
    setState(() {
      holding = null;
      from = shown;
      placed = true;
      moving = !reduced;
    });
    _showTip();
    if (first && !reduced) appear.forward(from: 0);
    if (first && reduced) appear.value = 1;
    if (!moving) {
      move.value = 1;
      busy = false;
      return;
    }
    move.duration = first
        ? HtmlJourneyTokens.tourIntro
        : HtmlJourneyTokens.tourMove;
    await move.forward(from: 0);
    if (!mounted) return;
    setState(() => moving = false);
    busy = false;
    if (!stop.full) {
      pulseTimer = Timer(HtmlJourneyTokens.tourPulseDelay, () {
        if (mounted && !moving) pulse.repeat();
      });
    }
  }

  void _showTip() {
    tipTimer?.cancel();
    tip.value = 0;
    if (reduced) {
      tip.value = 1;
      return;
    }
    tipTimer = Timer(HtmlJourneyTokens.softInDelay * 0.82, () {
      if (mounted) tip.forward(from: 0);
    });
  }

  Future<void> close() async {
    if (closing) return;
    final home = TourTarget.contextFor('featured');
    final homePosition = home == null
        ? null
        : Scrollable.maybeOf(home, axis: Axis.vertical)?.position;
    setState(() => closing = true);
    if (!reduced) await fade.forward();
    if (!mounted) return;
    final current =
        ref.read(devicePreferencesProvider).value ?? const DevicePreferences();
    await ref
        .read(devicePreferencesProvider.notifier)
        .save(current.copyWith(homeTourPending: false));
    pulseTimer?.cancel();
    pulse.stop();
    if (ticker.isActive) ticker.stop();
    if (homePosition != null && homePosition.hasPixels && !reduced) {
      await homePosition.animateTo(
        0,
        duration: HtmlJourneyTokens.tourMove,
        curve: HtmlJourneyTokens.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(devicePreferencesProvider).value;
    if (prefs?.homeTourPending != true) return const SizedBox.shrink();
    if (!started) {
      started = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(go(0));
      });
    }
    final strings = AppLocalizations.of(context);
    final copy = [
      (strings.tourWalletTitle, strings.tourWalletBody),
      (strings.tourFeaturedTitle, strings.tourFeaturedBody),
      (strings.tourScoreTitle, strings.tourScoreBody),
      (strings.tourQuestsTitle, strings.tourQuestsBody),
      (strings.tourNavTitle, strings.tourNavBody),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return AnimatedBuilder(
          animation: Listenable.merge([move, pulse, fade, appear, tip, frame]),
          builder: (context, _) {
            final hole = currentHole();
            final stop = tourStops[step];
            final opacity =
                appear.value * (closing ? 1 - fade.value : 1).clamp(0.0, 1.0);
            return Opacity(
              opacity: opacity,
              child: Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        onVerticalDragUpdate: (_) {},
                        child: TourSpotlight(
                          hole: hole,
                          pulse: moving || stop.full ? 0 : pulse.value,
                          flat: stop.full,
                          radius: stop.radius,
                        ),
                      ),
                    ),
                    if (hole != null)
                      _Tip(
                        hole: hole,
                        screen: size,
                        title: copy[step].$1,
                        body: copy[step].$2,
                        step: step,
                        count: tourStops.length,
                        clock: tip.value,
                        last: step == tourStops.length - 1,
                        onSkip: close,
                        onNext: () => go(step + 1),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Tooltip card: centered on the spotlight, clamped to the margins, below the
/// frame when there is room and above it otherwise.
class _Tip extends StatelessWidget {
  const _Tip({
    required this.hole,
    required this.screen,
    required this.title,
    required this.body,
    required this.step,
    required this.count,
    required this.clock,
    required this.last,
    required this.onSkip,
    required this.onNext,
  });

  final Rect hole;
  final Size screen;
  final String title, body;
  final int step, count;
  final double clock;
  final bool last;
  final VoidCallback onSkip, onNext;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final width = HtmlJourneyTokens.tourTooltipWidth;
    final margin = HtmlJourneyTokens.trMargin;
    final gap = HtmlJourneyTokens.tourTooltipGap;
    final below =
        hole.bottom + gap + HtmlJourneyTokens.trTipFit <
        screen.height - HtmlJourneyTokens.trMargin - 4;
    final left = (hole.center.dx - width / 2)
        .clamp(margin, math.max(margin, screen.width - margin - width))
        .toDouble();
    final arrow = (hole.center.dx - left)
        .clamp(
          HtmlJourneyTokens.trArrowEdge,
          width - HtmlJourneyTokens.trArrowEdge,
        )
        .toDouble();
    final t = HtmlJourneyTokens.spring.transform(clock.clamp(0.0, 1.0));
    final visible = Curves.easeOut.transform((clock * 1.4).clamp(0.0, 1.0));
    final rise = (1 - t) * HtmlJourneyTokens.trTipRise * (below ? 1 : -1);
    final titleStyle = AuthTextTokens.byName['English/Variant/Title-Small']!
        .copyWith(
          color: roles.onSurfaceEmphasis,
          fontSize: HtmlJourneyTokens.trTitle,
          height: HtmlJourneyTokens.trTitleLine / HtmlJourneyTokens.trTitle,
          fontWeight: FontWeight.w600,
        );
    final bodyStyle = AuthTextTokens.byName['English/Baseline/Label-Medium']!
        .copyWith(
          color: roles.onSurfaceBase,
          fontSize: HtmlJourneyTokens.trBody,
          height: HtmlJourneyTokens.trBodyLine / HtmlJourneyTokens.trBody,
          fontWeight: FontWeight.w500,
        );
    // PHYSICAL: the card is positioned by the spotlight's absolute x.
    return Positioned(
      left: left,
      width: width,
      top: below ? hole.bottom + gap : null,
      bottom: below ? null : screen.height - hole.top + gap,
      child: Opacity(
        opacity: visible,
        child: Transform.translate(
          offset: Offset(0, rise),
          child: Transform.scale(
            scale: 0.97 + 0.03 * t,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // PHYSICAL: the arrow points at the spotlight's center.
                Positioned(
                  left: arrow - HtmlJourneyTokens.tourArrowExtent / 2,
                  top: below ? -HtmlJourneyTokens.tourArrowOutset : null,
                  bottom: below ? null : -HtmlJourneyTokens.tourArrowOutset,
                  child: Transform.rotate(
                    angle: math.pi / 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: roles.surfaceContainerBase,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const SizedBox.square(
                        dimension: HtmlJourneyTokens.tourArrowExtent,
                      ),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: roles.surfaceContainerBase,
                    borderRadius: BorderRadius.circular(
                      HtmlJourneyTokens.trTipRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: HtmlJourneyTokens.playNowHover.withValues(
                          alpha: 0.55,
                        ),
                        blurRadius: HtmlJourneyTokens.trShadowBlur,
                        offset: const Offset(0, HtmlJourneyTokens.trShadowY),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(
                      HtmlJourneyTokens.trTipPad,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: titleStyle),
                        const SizedBox(height: HtmlJourneyTokens.trBodyGap),
                        Text(body, style: bodyStyle),
                        const SizedBox(height: HtmlJourneyTokens.trFootGap),
                        Row(
                          children: [
                            _Progress(step: step, count: count),
                            const Spacer(),
                            _TourButton(
                              elementId: 'tour.skip',
                              label: strings.onboardingSkip,
                              fill: HtmlJourneyTokens.launchBackground,
                              color: roles.onSurfaceBase,
                              onTap: onSkip,
                            ),
                            const SizedBox(width: HtmlJourneyTokens.trBtnGap),
                            _TourButton(
                              elementId: 'tour.next',
                              label: last
                                  ? strings.tourGotIt
                                  : strings.onboardingNext,
                              fill: HtmlJourneyTokens.splashGradientMid,
                              color: HtmlJourneyTokens.obWhite,
                              minWidth: HtmlJourneyTokens.trNextMin,
                              onTap: onNext,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// HTML `.tour-n`: finished stops are dark cyan, the current one is wide.
class _Progress extends StatelessWidget {
  const _Progress({required this.step, required this.count});
  final int step, count;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    return Semantics(
      label: '${step + 1} / $count',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: HtmlJourneyTokens.trPillGap,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: HtmlJourneyTokens.legalIndicator,
              curve: HtmlJourneyTokens.ease,
              width: i == step
                  ? HtmlJourneyTokens.trPillOnW
                  : HtmlJourneyTokens.trPillW,
              height: HtmlJourneyTokens.trPillH,
              decoration: BoxDecoration(
                color: i == step
                    ? HtmlJourneyTokens.splashGradientMid
                    : i < step
                    ? HtmlJourneyTokens.jlCyanDone
                    : roles.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}

class _TourButton extends StatefulWidget {
  const _TourButton({
    required this.elementId,
    required this.label,
    required this.fill,
    required this.color,
    required this.onTap,
    this.minWidth = 0,
  });
  final String elementId, label;
  final Color fill, color;
  final double minWidth;
  final VoidCallback onTap;

  @override
  State<_TourButton> createState() => _TourButtonState();
}

class _TourButtonState extends State<_TourButton> {
  var down = false;

  @override
  Widget build(BuildContext context) {
    final style = AuthTextTokens.byName['English/Baseline/Button-Medium']!
        .copyWith(
          color: widget.color,
          fontSize: HtmlJourneyTokens.trBody,
          height: HtmlJourneyTokens.trBodyLine / HtmlJourneyTokens.trBody,
          fontWeight: FontWeight.w600,
        );
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      onTap: widget.onTap,
      child: GestureDetector(
        key: ValueKey(widget.elementId),
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => down = true),
        onTapUp: (_) => setState(() => down = false),
        onTapCancel: () => setState(() => down = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: down ? 0.95 : 1,
          duration: HtmlJourneyTokens.badgePop ~/ 2,
          curve: HtmlJourneyTokens.ease,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.fill,
              borderRadius: BorderRadius.circular(
                HtmlJourneyTokens.trBtnRadius,
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: widget.minWidth,
                minHeight: HtmlJourneyTokens.trBtnH,
              ),
              child: Center(
                widthFactor: 1,
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: HtmlJourneyTokens.trBtnPadH,
                  ),
                  child: Text(widget.label, style: style),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The moving spotlight. Tests read [hole] while it lerps.
class TourSpotlight extends StatelessWidget {
  const TourSpotlight({
    super.key,
    required this.hole,
    required this.pulse,
    required this.flat,
    required this.radius,
  });

  final Rect? hole;
  final double pulse;
  final bool flat;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HolePainter(
        hole: hole,
        pulse: pulse,
        flat: flat,
        radius: radius,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _HolePainter extends CustomPainter {
  const _HolePainter({
    required this.hole,
    required this.pulse,
    required this.flat,
    required this.radius,
  });

  final Rect? hole;
  final double pulse;
  final bool flat;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final overlay = Path()..addRect(Offset.zero & size);
    final cut = hole == null
        ? overlay
        : Path.combine(
            PathOperation.difference,
            overlay,
            Path()..addRRect(
              RRect.fromRectAndRadius(hole!, Radius.circular(radius)),
            ),
          );
    canvas.drawPath(
      cut,
      Paint()
        ..color = HtmlJourneyTokens.playNowHover.withValues(
          alpha: HtmlJourneyTokens.overlayAlpha,
        ),
    );
    if (hole == null) return;
    final border = HtmlJourneyTokens.obWhite.withValues(
      alpha: HtmlJourneyTokens.tourHoleBorderAlpha,
    );
    if (flat) {
      canvas.drawLine(
        hole!.topLeft,
        hole!.topRight,
        Paint()
          ..color = border
          ..strokeWidth = HtmlJourneyTokens.cbBorder,
      );
      return;
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        hole!,
        Radius.circular(radius),
      ).inflate(HtmlJourneyTokens.cbBorder / 2),
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = HtmlJourneyTokens.cbBorder,
    );
    if (pulse == 0 || hole!.width == 0 || hole!.height == 0) return;
    final peak = HtmlJourneyTokens.edgeFadeStop;
    final opacity = pulse < peak ? pulse / peak : (1 - pulse) / (1 - peak);
    final grow = HtmlJourneyTokens.tourPulsePad * 2;
    final sx = 1 + grow / hole!.width;
    final sy = 1 + grow / hole!.height;
    final scale = 1 + (sx - 1) * pulse;
    final scaleY = 1 + (sy - 1) * pulse;
    canvas.save();
    canvas.translate(hole!.center.dx, hole!.center.dy);
    canvas.scale(scale, scaleY);
    canvas.translate(-hole!.center.dx, -hole!.center.dy);
    canvas.drawRRect(
      RRect.fromRectAndRadius(hole!, Radius.circular(radius)),
      Paint()
        ..color = HtmlJourneyTokens.splashGradientMid.withValues(
          alpha: HtmlJourneyTokens.tourPulseAlpha * opacity.clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = HtmlJourneyTokens.cbBorder,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HolePainter old) =>
      old.hole != hole ||
      old.pulse != pulse ||
      old.flat != flat ||
      old.radius != radius;
}
