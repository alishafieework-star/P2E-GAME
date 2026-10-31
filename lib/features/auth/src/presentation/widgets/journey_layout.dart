import 'dart:async';

import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

SkinRoleValues _roles(BuildContext context) =>
    SkinTheme.of(context).valuesFor(Theme.of(context).brightness);

TextStyle _style(String name) => AuthTextTokens.byName[name]!;

/// HTML `.bellc`: a 96px circle tinted with the primary container.
class JourneyCircle extends StatelessWidget {
  const JourneyCircle({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: HtmlJourneyTokens.jlCircle,
    child: DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: HtmlJourneyTokens.splashGradientMid.withValues(alpha: 0.1),
      ),
      child: Center(child: child),
    ),
  );
}

/// HTML `.ch`: lead widget, centered title and one centered sentence.
class JourneyHeader extends StatelessWidget {
  const JourneyHeader({
    super.key,
    required this.lead,
    required this.title,
    this.body,
    this.bodyText,
    this.large = false,
    this.topPad = HtmlJourneyTokens.jlHeadTop,
  });

  final Widget lead;
  final String title;
  final String? bodyText;

  /// Rich body (for `Welcome to the game, @name`). Wins over [bodyText].
  final InlineSpan? body;
  final bool large;
  final double topPad;

  @override
  Widget build(BuildContext context) {
    final roles = _roles(context);
    final bodyStyle = _style('English/Baseline/Label-Medium').copyWith(
      color: roles.color('On Surface/Base'),
      fontSize: HtmlJourneyTokens.jlBody,
      height: HtmlJourneyTokens.jlBodyLine / HtmlJourneyTokens.jlBody,
      fontWeight: FontWeight.w500,
    );
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: topPad,
        start: HtmlJourneyTokens.jlHeadH,
        end: HtmlJourneyTokens.jlHeadH,
        bottom: HtmlJourneyTokens.jlHeadGap,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          lead,
          const SizedBox(height: HtmlJourneyTokens.jlHeadGap),
          Text(
            title,
            textAlign: TextAlign.center,
            style: _style('English/Baseline/Headline-Small').copyWith(
              color: roles.color('On Surface/Emphasis'),
              fontSize: large
                  ? HtmlJourneyTokens.jlTitleLg
                  : HtmlJourneyTokens.jlTitle,
              height: large
                  ? HtmlJourneyTokens.jlTitleLgLine /
                        HtmlJourneyTokens.jlTitleLg
                  : HtmlJourneyTokens.jlTitleLine / HtmlJourneyTokens.jlTitle,
            ),
          ),
          if (body != null || bodyText != null) ...[
            SizedBox(height: large ? 0 : HtmlJourneyTokens.jlTextGap),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: HtmlJourneyTokens.jlBodyMax,
              ),
              child: Text.rich(
                body ?? TextSpan(text: bodyText),
                textAlign: TextAlign.center,
                style: bodyStyle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// HTML `.item`: a 52px icon tile and a text card.
class JourneyItem extends StatelessWidget {
  const JourneyItem({
    super.key,
    required this.icon,
    required this.text,
    this.raised = false,
  });
  final Widget icon;
  final String text;

  /// Lift the tiles one level (used on sheets, whose surface is the base tone).
  final bool raised;

  @override
  Widget build(BuildContext context) {
    final roles = _roles(context);
    final radius = BorderRadius.circular(HtmlJourneyTokens.jlItemRadius);
    return Row(
      children: [
        SizedBox.square(
          dimension: HtmlJourneyTokens.jlItemIc,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: raised
                  ? roles.surfaceContainerHigh
                  : roles.surfaceContainerBase,
              borderRadius: radius,
            ),
            child: Center(child: icon),
          ),
        ),
        const SizedBox(width: HtmlJourneyTokens.jlItemGap),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: raised
                  ? roles.surfaceContainerHigh
                  : roles.surfaceContainerBase,
              borderRadius: radius,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(
                HtmlJourneyTokens.jlItemPad,
              ),
              child: Text(
                text,
                style: _style('English/Baseline/Label-Medium').copyWith(
                  color: roles.color('On Surface/Base'),
                  fontSize: HtmlJourneyTokens.jlBody,
                  height:
                      HtmlJourneyTokens.jlBodyLine / HtmlJourneyTokens.jlBody,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// HTML `.items`: the stack of [JourneyItem] rows.
class JourneyItems extends StatelessWidget {
  const JourneyItems({super.key, required this.children, this.padding = true});
  final List<Widget> children;
  final bool padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsDirectional.all(
      padding ? HtmlJourneyTokens.jlItemsPad : 0,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: HtmlJourneyTokens.jlItemsGap),
          children[i],
        ],
      ],
    ),
  );
}

/// A page made of a centered header, rows and a bottom call to action
/// (HTML `.body` with `.ch`, `.items` and `.ctaw`). No app bar.
class JourneyPage extends StatelessWidget {
  const JourneyPage({
    super.key,
    required this.elementId,
    required this.header,
    this.items,
    required this.actions,
    this.overlay,
  });

  final String elementId;
  final Widget header;
  final Widget? items;
  final List<Widget> actions;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    return PageScaffold(
      elementId: elementId,
      layout: PageScaffoldLayout.viewport,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [header, ?items]),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: HtmlJourneyTokens.jlCtaPad,
                  end: HtmlJourneyTokens.jlCtaPad,
                  top: HtmlJourneyTokens.jlCtaPad,
                  bottom: HtmlJourneyTokens.jlCtaPad + bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0)
                        const SizedBox(height: HtmlJourneyTokens.jlCtaGap),
                      actions[i],
                    ],
                  ],
                ),
              ),
            ],
          ),
          ?overlay,
        ],
      ),
    );
  }
}

/// HTML rise: fade and lift in, optionally after [delay].
class JourneyRise extends StatefulWidget {
  const JourneyRise({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });
  final Widget child;
  final Duration delay;

  @override
  State<JourneyRise> createState() => _JourneyRiseState();
}

class _JourneyRiseState extends State<JourneyRise>
    with SingleTickerProviderStateMixin {
  late final AnimationController clock;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      clock.value = 1;
    } else if (clock.value == 0 && timer == null) {
      timer = Timer(widget.delay, () {
        if (mounted) clock.forward();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: clock,
    builder: (context, child) {
      final t = HtmlJourneyTokens.ease.transform(clock.value);
      return Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - t) * HtmlJourneyTokens.jlItemsGap),
          child: child,
        ),
      );
    },
    child: widget.child,
  );
}
