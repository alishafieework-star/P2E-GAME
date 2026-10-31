import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/preferences/device_preferences.dart';
import 'package:mygame_p2e/shared/widgets/journey_confetti.dart';
import 'package:p2e_design_system/design_system.dart';

import 'onboarding_climb.dart';
import 'onboarding_quests.dart';
import 'onboarding_timing.dart';
import 'onboarding_wall.dart';

/// Three HTML slides, played 1.45 times slower, then a route soft handoff (D-138).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _count = 3;
  final page = PageController();
  var index = 0;
  var celebration = 0;
  var leaving = false;

  Future<void> finish() async {
    if (leaving) return;
    leaving = true;
    final current =
        ref.read(devicePreferencesProvider).value ?? const DevicePreferences();
    await ref
        .read(devicePreferencesProvider.notifier)
        .save(current.copyWith(onboardingSeen: true));
  }

  void go(int target) {
    final next = target.clamp(0, _count - 1);
    if (next == index) return;
    setState(() => index = next);
    if (MediaQuery.disableAnimationsOf(context)) {
      page.jumpToPage(next);
      return;
    }
    page.animateToPage(
      next,
      duration: slowed(HtmlJourneyTokens.obPageMs),
      curve: HtmlJourneyTokens.obPageCurve,
    );
  }

  @override
  void dispose() {
    page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final padding = MediaQuery.paddingOf(context);
    final slides = [
      (
        strings.onboardingPlayTitle,
        strings.onboardingPlayBody,
        OnboardingWall(active: index == 0),
      ),
      (
        strings.onboardingQuestTitle,
        strings.onboardingQuestBody,
        OnboardingQuests(active: index == 1),
      ),
      (
        strings.onboardingClimbTitle,
        strings.onboardingClimbBody,
        OnboardingClimb(
          active: index == 2,
          onLanded: () => setState(() => celebration++),
        ),
      ),
    ];
    final last = index == slides.length - 1;
    return PopScope(
      canPop: index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) go(index - 1);
      },
      child: PageScaffold(
        elementId: 'onboarding.page',
        layout: PageScaffoldLayout.viewport,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: page,
                        physics: const _SwipePhysics(),
                        itemCount: slides.length,
                        onPageChanged: (value) {
                          if (value != index) setState(() => index = value);
                        },
                        itemBuilder: (context, i) => _Slide(
                          title: slides[i].$1,
                          body: slides[i].$2,
                          active: i == index,
                          art: slides[i].$3,
                        ),
                      ),
                      PositionedDirectional(
                        top: padding.top,
                        end: HtmlJourneyTokens.obSkipEnd,
                        height: HtmlJourneyTokens.obSkipHeight,
                        child: Center(
                          child: AppButton(
                            elementId: 'onboarding.skip',
                            label: strings.onboardingSkip,
                            type: AppButtonType.text,
                            size: AppButtonSize.small,
                            onPressed: finish,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: HtmlJourneyTokens.obTextInsetH,
                    end: HtmlJourneyTokens.obTextInsetH,
                    bottom: HtmlJourneyTokens.obDotsBottom,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _Dots(count: slides.length, index: index),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: HtmlJourneyTokens.obFootInsetH,
                    end: HtmlJourneyTokens.obFootInsetH,
                    bottom: math.max(
                      HtmlJourneyTokens.obFootBottom,
                      padding.bottom,
                    ),
                  ),
                  child: AppButton(
                    elementId: 'onboarding.next',
                    family: AppButtonFamily.fill,
                    tone: AppButtonTone.accent,
                    label: last
                        ? strings.onboardingStart
                        : strings.onboardingNext,
                    onPressed: () {
                      if (last) {
                        finish();
                        return;
                      }
                      go(index + 1);
                    },
                  ),
                ),
              ],
            ),
            if (celebration > 0)
              Positioned.fill(
                child: JourneyConfetti(
                  key: ValueKey(celebration),
                  style: JourneyConfettiStyle.celebration,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.title,
    required this.body,
    required this.active,
    required this.art,
  });

  final String title;
  final String body;
  final bool active;
  final Widget art;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    return LayoutBuilder(
      builder: (context, box) => Column(
        children: [
          Expanded(child: art),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: box.maxHeight * 0.5),
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.only(
                start: HtmlJourneyTokens.obTextInsetH,
                end: HtmlJourneyTokens.obTextInsetH,
                bottom: HtmlJourneyTokens.obTextBottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Rise(
                    active: active,
                    delay: Duration.zero,
                    child: Text(
                      title,
                      style: AuthTextTokens
                          .byName['English/Baseline/Headline-Large']!
                          .copyWith(color: roles.color('On Surface/Emphasis')),
                    ),
                  ),
                  const SizedBox(height: HtmlJourneyTokens.obTextGap),
                  _Rise(
                    active: active,
                    delay: HtmlJourneyTokens.obRiseDelayMs,
                    child: Text(
                      body,
                      style: AuthTextTokens
                          .byName['English/Variant/Title-Small']!
                          .copyWith(color: roles.color('On Surface/Base')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `.ob-slide.on .ob-text > *`: fade in and rise when the slide becomes active.
class _Rise extends StatefulWidget {
  const _Rise({required this.active, required this.delay, required this.child});

  final bool active;
  final Duration delay;
  final Widget child;

  @override
  State<_Rise> createState() => _RiseState();
}

class _RiseState extends State<_Rise> with SingleTickerProviderStateMixin {
  late final AnimationController clock;

  Duration get total => widget.delay + HtmlJourneyTokens.obRiseMs;

  @override
  void initState() {
    super.initState();
    clock = AnimationController(vsync: this, duration: slowed(total));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync(restart: false);
  }

  @override
  void didUpdateWidget(_Rise oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(restart: widget.active && !oldWidget.active);
  }

  void _sync({required bool restart}) {
    if (MediaQuery.disableAnimationsOf(context)) {
      clock.value = 1;
    } else if (!widget.active) {
      clock.value = 0;
    } else if (restart || (!clock.isAnimating && clock.value == 0)) {
      clock.forward(from: 0);
    }
  }

  @override
  void dispose() {
    clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: clock,
      builder: (context, child) {
        final base = clock.value * total.inMilliseconds;
        final fade = window(
          base,
          widget.delay,
          HtmlJourneyTokens.obFadeMs,
          HtmlJourneyTokens.ease,
        );
        final rise = window(
          base,
          widget.delay,
          HtmlJourneyTokens.obRiseMs,
          HtmlJourneyTokens.ease,
        );
        return Opacity(
          opacity: fade,
          child: Transform.translate(
            offset: Offset(0, (1 - rise) * HtmlJourneyTokens.obRise),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// `.ob-dots`: the active dot stretches into a pill.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: HtmlJourneyTokens.obDotsGap),
            AnimatedContainer(
              duration: slowed(HtmlJourneyTokens.obDotMs),
              curve: HtmlJourneyTokens.ease,
              width: i == index
                  ? HtmlJourneyTokens.obDotActive
                  : HtmlJourneyTokens.obDotSize,
              height: HtmlJourneyTokens.obDotSize,
              decoration: BoxDecoration(
                color: i == index
                    ? HtmlJourneyTokens.splashGradientMid
                    : roles.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(
                  HtmlJourneyTokens.obDotSize / 2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SwipePhysics extends PageScrollPhysics {
  const _SwipePhysics({super.parent});

  @override
  double? get dragStartDistanceMotionThreshold =>
      HtmlJourneyTokens.swipeThreshold;

  @override
  _SwipePhysics applyTo(ScrollPhysics? ancestor) =>
      _SwipePhysics(parent: buildParent(ancestor));
}
