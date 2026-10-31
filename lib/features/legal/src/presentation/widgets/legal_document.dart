import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:p2e_design_system/design_system.dart';

import 'legal_type.dart';

/// Copy for one legal document, already localized.
class LegalCopy {
  const LegalCopy({
    required this.updated,
    required this.read,
    required this.summary,
    required this.points,
    required this.sections,
    required this.ending,
  });

  final String updated, read, summary, ending;
  final List<String> points;
  final List<(String, String)> sections;
}

/// One document body: meta line, TL;DR card, contents, sections and the end
/// note (HTML `.lg-doc`). [slide] is -1 or 1 when it arrives from a swipe or
/// tab change; 0 plays the first-open rise of the first five blocks.
class LegalDocument extends StatefulWidget {
  const LegalDocument({
    super.key,
    required this.docId,
    required this.copy,
    required this.slide,
    required this.scroll,
    required this.tldr,
    required this.shortVersion,
    required this.contents,
  });

  final String docId;
  final LegalCopy copy;
  final int slide;
  final ScrollController scroll;
  final String tldr, shortVersion, contents;

  @override
  State<LegalDocument> createState() => _LegalDocumentState();
}

class _LegalDocumentState extends State<LegalDocument>
    with TickerProviderStateMixin {
  late final AnimationController enter;
  late final AnimationController highlight;
  final keys = <GlobalKey>[];
  var highlighted = -1;

  @override
  void initState() {
    super.initState();
    final intro = widget.slide == 0;
    enter = AnimationController(
      vsync: this,
      duration: intro
          ? HtmlJourneyTokens.lgIntroDelayMs +
                HtmlJourneyTokens.lgIntroStepMs * 4 +
                HtmlJourneyTokens.lgIntroMs
          : HtmlJourneyTokens.lgDocMs,
    );
    highlight = AnimationController(
      vsync: this,
      duration: HtmlJourneyTokens.legalHighlight,
    );
    keys.addAll(List.generate(widget.copy.sections.length, (_) => GlobalKey()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      enter.value = 1;
    } else if (!enter.isAnimating && enter.value == 0) {
      enter.forward();
    }
  }

  @override
  void dispose() {
    enter.dispose();
    highlight.dispose();
    super.dispose();
  }

  void jump(int index) {
    setState(() => highlighted = index);
    final reduced = MediaQuery.disableAnimationsOf(context);
    if (reduced) {
      highlight.value = 1;
    } else {
      highlight.forward(from: 0);
    }
    final target = keys[index].currentContext?.findRenderObject();
    final scroll = widget.scroll;
    if (target == null || !scroll.hasClients) return;
    final viewport = RenderAbstractViewport.of(target);
    final offset =
        viewport.getOffsetToReveal(target, 0).offset -
        HtmlJourneyTokens.lgEndTop;
    final to = offset.clamp(0.0, scroll.position.maxScrollExtent);
    if (reduced) {
      scroll.jumpTo(to);
    } else {
      scroll.animateTo(
        to,
        duration: HtmlJourneyTokens.legalEnter,
        curve: HtmlJourneyTokens.ease,
      );
    }
  }

  /// First five blocks rise one after another; later blocks are static.
  Widget _block(int n, Widget child) {
    if (widget.slide != 0 || n > 4) return child;
    final total = enter.duration!.inMilliseconds;
    final start =
        (HtmlJourneyTokens.lgIntroDelayMs.inMilliseconds +
            n * HtmlJourneyTokens.lgIntroStepMs.inMilliseconds) /
        total;
    final end = start + HtmlJourneyTokens.lgIntroMs.inMilliseconds / total;
    final curved = CurvedAnimation(
      parent: enter,
      curve: Interval(
        start,
        end.clamp(0.0, 1.0),
        curve: HtmlJourneyTokens.ease,
      ),
    );
    return FadeTransition(
      opacity: curved,
      child: AnimatedBuilder(
        animation: curved,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, HtmlJourneyTokens.lgIntroRise * (1 - curved.value)),
          child: child,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final copy = widget.copy;
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _block(0, _Meta(updated: copy.updated, read: copy.read, roles: roles)),
        _block(
          1,
          _KeyCard(
            tag: widget.tldr,
            title: widget.shortVersion,
            points: copy.points,
            roles: roles,
          ),
        ),
        _block(
          2,
          _Contents(
            title: widget.contents,
            docId: widget.docId,
            titles: [for (final s in copy.sections) s.$1],
            roles: roles,
            onJump: jump,
          ),
        ),
        for (var i = 0; i < copy.sections.length; i++)
          _block(
            3 + i,
            _Section(
              key: keys[i],
              number: i + 1,
              title: copy.sections[i].$1,
              body: copy.sections[i].$2,
              active: highlighted == i,
              highlight: highlight,
              roles: roles,
            ),
          ),
        _block(3 + copy.sections.length, _End(text: copy.ending, roles: roles)),
      ],
    );
    if (widget.slide == 0) return body;
    final curved = CurvedAnimation(
      parent: enter,
      curve: HtmlJourneyTokens.ease,
    );
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return FadeTransition(
      opacity: curved,
      child: AnimatedBuilder(
        animation: curved,
        builder: (context, child) => Transform.translate(
          offset: Offset(
            widget.slide *
                HtmlJourneyTokens.lgDocShift *
                (1 - curved.value) *
                (rtl ? -1 : 1),
            0,
          ),
          child: child,
        ),
        child: body,
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.updated, required this.read, required this.roles});

  final String updated, read;
  final SkinRoleValues roles;

  @override
  Widget build(BuildContext context) {
    final style = LegalType.medium(
      HtmlJourneyTokens.lgMetaSize,
      HtmlJourneyTokens.lgMetaLine,
      HtmlJourneyTokens.lgMetaSpace,
    ).copyWith(color: roles.onSurfaceVariant);
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: HtmlJourneyTokens.lgMetaInset,
        end: HtmlJourneyTokens.lgMetaInset,
        bottom: HtmlJourneyTokens.lgMetaBottom,
      ),
      child: Row(
        children: [
          Flexible(child: Text(updated, style: style)),
          const SizedBox(width: HtmlJourneyTokens.lgMetaGap),
          DecoratedBox(
            decoration: BoxDecoration(
              color: roles.onSurfaceMuted,
              shape: BoxShape.circle,
            ),
            child: const SizedBox.square(
              dimension: HtmlJourneyTokens.lgMetaDot,
            ),
          ),
          const SizedBox(width: HtmlJourneyTokens.lgMetaGap),
          Text(read, style: style),
        ],
      ),
    );
  }
}

class _KeyCard extends StatelessWidget {
  const _KeyCard({
    required this.tag,
    required this.title,
    required this.points,
    required this.roles,
  });

  final String tag, title;
  final List<String> points;
  final SkinRoleValues roles;

  @override
  Widget build(BuildContext context) {
    const accent = HtmlJourneyTokens.splashGradientMid;
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        bottom: HtmlJourneyTokens.lgKeyBottom,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HtmlJourneyTokens.lgKeyRadius),
          color: roles.surfaceContainerBase,
        ),
        position: DecorationPosition.background,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HtmlJourneyTokens.lgKeyRadius),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                accent.withValues(alpha: HtmlJourneyTokens.lgKeyTint),
                accent.withValues(alpha: 0),
              ],
              stops: const [0, 0.6],
            ),
            border: Border.all(
              color: accent.withValues(alpha: HtmlJourneyTokens.lgKeyRing),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(
              HtmlJourneyTokens.lgKeyPad,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: accent.withValues(
                          alpha: HtmlJourneyTokens.lgTagFill,
                        ),
                        borderRadius: BorderRadius.circular(
                          HtmlJourneyTokens.lgTagRadius,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: HtmlJourneyTokens.lgTagPadH,
                          vertical: HtmlJourneyTokens.lgTagPadV,
                        ),
                        child: Text(
                          tag,
                          style: LegalType.semibold(
                            HtmlJourneyTokens.lgTagSize,
                            HtmlJourneyTokens.lgTagLine,
                            HtmlJourneyTokens.lgTagSpace,
                          ).copyWith(color: accent),
                        ),
                      ),
                    ),
                    const SizedBox(width: HtmlJourneyTokens.lgTagGap),
                    Flexible(
                      child: Text(
                        title,
                        style: LegalType.semibold(
                          HtmlJourneyTokens.lgKeyTitleSize,
                          HtmlJourneyTokens.lgKeyTitleLine,
                          HtmlJourneyTokens.lgKeyTitleSpace,
                        ).copyWith(color: roles.onSurfaceEmphasis),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: HtmlJourneyTokens.lgKeyTitleGap),
                for (var i = 0; i < points.length; i++) ...[
                  if (i > 0)
                    const SizedBox(height: HtmlJourneyTokens.lgKeyListGap),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CheckBadge(),
                      const SizedBox(width: HtmlJourneyTokens.lgKeyItemGap),
                      Expanded(
                        child: Text(
                          points[i],
                          style: LegalType.medium(
                            HtmlJourneyTokens.lgKeyTextSize,
                            HtmlJourneyTokens.lgKeyTextLine,
                            HtmlJourneyTokens.lgKeyTextSpace,
                          ).copyWith(color: HtmlJourneyTokens.lgKeyText),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// HTML `CK`: a faint green disc with a green tick.
class _CheckBadge extends StatelessWidget {
  const _CheckBadge();

  @override
  Widget build(BuildContext context) => const ExcludeSemantics(
    child: CustomPaint(
      size: Size.square(HtmlJourneyTokens.lgCheck),
      painter: _CheckBadgePainter(),
    ),
  );
}

class _CheckBadgePainter extends CustomPainter {
  const _CheckBadgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / HtmlJourneyTokens.obTickViewBox;
    canvas.drawCircle(
      size.center(Offset.zero),
      10 * unit,
      Paint()
        ..color = HtmlJourneyTokens.success.withValues(
          alpha: HtmlJourneyTokens.lgCheckFill,
        ),
    );
    final path = Path()
      ..moveTo(7.5 * unit, 12.3 * unit)
      ..lineTo(10.5 * unit, 15.3 * unit)
      ..lineTo(16.5 * unit, 9 * unit);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 2.2 * unit
        ..color = HtmlJourneyTokens.success,
    );
  }

  @override
  bool shouldRepaint(_CheckBadgePainter old) => false;
}

class _Contents extends StatelessWidget {
  const _Contents({
    required this.title,
    required this.docId,
    required this.titles,
    required this.roles,
    required this.onJump,
  });

  final String title, docId;
  final List<String> titles;
  final SkinRoleValues roles;
  final ValueChanged<int> onJump;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        bottom: HtmlJourneyTokens.lgTocBottom,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: roles.surfaceContainerBase,
          borderRadius: BorderRadius.circular(HtmlJourneyTokens.lgKeyRadius),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(HtmlJourneyTokens.lgTocPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: HtmlJourneyTokens.lgTocHeadPadH,
                  end: HtmlJourneyTokens.lgTocHeadPadH,
                  top: HtmlJourneyTokens.lgTocHeadTop,
                  bottom: HtmlJourneyTokens.lgTocHeadBottom,
                ),
                child: Text(
                  title.toUpperCase(),
                  style: LegalType.semibold(
                    HtmlJourneyTokens.lgTocHeadSize,
                    HtmlJourneyTokens.lgTocHeadLine,
                    HtmlJourneyTokens.lgTocHeadSpace,
                  ).copyWith(color: roles.onSurfaceVariant),
                ),
              ),
              for (var i = 0; i < titles.length; i++)
                _TocRow(
                  key: ValueKey('legal.toc.$docId.$i'),
                  number: i + 1,
                  title: titles[i],
                  roles: roles,
                  rtl: rtl,
                  onPressed: () => onJump(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TocRow extends StatefulWidget {
  const _TocRow({
    super.key,
    required this.number,
    required this.title,
    required this.roles,
    required this.rtl,
    required this.onPressed,
  });

  final int number;
  final String title;
  final SkinRoleValues roles;
  final bool rtl;
  final VoidCallback onPressed;

  @override
  State<_TocRow> createState() => _TocRowState();
}

class _TocRowState extends State<_TocRow> {
  var hover = false, down = false;

  @override
  Widget build(BuildContext context) {
    final roles = widget.roles;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final quick = reduced ? Duration.zero : HtmlJourneyTokens.lgTopBtnMs ~/ 2;
    return Semantics(
      button: true,
      label: '${widget.number}. ${widget.title}',
      excludeSemantics: true,
      onTap: widget.onPressed,
      child: MouseRegion(
        onEnter: (_) => setState(() => hover = true),
        onExit: (_) => setState(() => hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => down = true),
          onTapUp: (_) => setState(() => down = false),
          onTapCancel: () => setState(() => down = false),
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: down && !reduced ? ButtonMotion.rowPressedScale : 1,
            duration: reduced ? Duration.zero : ButtonMotion.pressDuration,
            curve: HtmlJourneyTokens.ease,
            child: AnimatedContainer(
              duration: quick,
              height: HtmlJourneyTokens.lgTocRowH,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: HtmlJourneyTokens.lgTocRowPadH,
              ),
              decoration: BoxDecoration(
                color: hover ? roles.surfaceContainerHigh : null,
                borderRadius: BorderRadius.circular(
                  HtmlJourneyTokens.lgTocRowRadius,
                ),
              ),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: roles.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(
                        HtmlJourneyTokens.lgNumRadius,
                      ),
                    ),
                    child: SizedBox.square(
                      dimension: HtmlJourneyTokens.lgNumSize,
                      child: Center(
                        child: Text(
                          '${widget.number}',
                          style: LegalType.semibold(
                            HtmlJourneyTokens.lgNumTextSize,
                            HtmlJourneyTokens.lgNumTextSize,
                            0,
                          ).copyWith(color: roles.onSurfaceBase),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: HtmlJourneyTokens.lgTocRowGap),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: LegalType.medium(
                        HtmlJourneyTokens.lgTocRowSize,
                        HtmlJourneyTokens.lgTocRowLine,
                        HtmlJourneyTokens.lgTocRowSpace,
                      ).copyWith(color: HtmlJourneyTokens.lgTocText),
                    ),
                  ),
                  AnimatedContainer(
                    duration: quick,
                    transform: Matrix4.translationValues(
                      hover
                          ? HtmlJourneyTokens.lgChevronNudge *
                                (widget.rtl ? -1 : 1)
                          : 0,
                      0,
                      0,
                    ),
                    child: AssetAppIcon(
                      widget.rtl
                          ? AppIconId.chevronLeft
                          : AppIconId.chevronRight,
                      size: HtmlJourneyTokens.lgChevron,
                      color: hover ? roles.onSurfaceBase : roles.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    super.key,
    required this.number,
    required this.title,
    required this.body,
    required this.active,
    required this.highlight,
    required this.roles,
  });

  final int number;
  final String title, body;
  final bool active;
  final Animation<double> highlight;
  final SkinRoleValues roles;

  /// `lgHl`: 0% hidden and short, 15% shown, 75% shown, 100% hidden.
  double _mark(double t) {
    if (t < 0.15) return t / 0.15;
    if (t < 0.75) return 1;
    return 1 - (t - 0.75) / 0.25;
  }

  @override
  Widget build(BuildContext context) {
    const accent = HtmlJourneyTokens.splashGradientMid;
    // The HTML waits .3s before the mark; start from 0.3 / 1.8 of the run.
    const wait = 0.3 / 1.8;
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: HtmlJourneyTokens.lgSecInset,
        end: HtmlJourneyTokens.lgSecInset,
        bottom: HtmlJourneyTokens.lgSecBottom,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  bottom: HtmlJourneyTokens.lgSecTitleBottom,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$number.',
                      style: LegalType.semibold(
                        HtmlJourneyTokens.lgSecTitleSize,
                        HtmlJourneyTokens.lgSecTitleLine,
                        HtmlJourneyTokens.lgSecTitleSpace,
                      ).copyWith(color: accent),
                    ),
                    const SizedBox(width: HtmlJourneyTokens.lgSecGap),
                    Expanded(
                      child: Text(
                        title,
                        style: LegalType.semibold(
                          HtmlJourneyTokens.lgSecTitleSize,
                          HtmlJourneyTokens.lgSecTitleLine,
                          HtmlJourneyTokens.lgSecTitleSpace,
                        ).copyWith(color: roles.onSurfaceEmphasis),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                body,
                style: LegalType.regular(
                  HtmlJourneyTokens.lgSecBodySize,
                  HtmlJourneyTokens.lgSecBodyLine,
                  HtmlJourneyTokens.lgSecBodySpace,
                ).copyWith(color: roles.onSurfaceBase),
              ),
            ],
          ),
          if (active)
            PositionedDirectional(
              start: -HtmlJourneyTokens.lgHlMark,
              top: HtmlJourneyTokens.lgHlWidth - 1,
              bottom: HtmlJourneyTokens.lgHlWidth - 1,
              width: HtmlJourneyTokens.lgHlWidth,
              child: AnimatedBuilder(
                animation: highlight,
                builder: (context, _) {
                  final t = ((highlight.value - wait) / (1 - wait)).clamp(
                    0.0,
                    1.0,
                  );
                  final shown = _mark(t);
                  return Opacity(
                    opacity: shown,
                    child: Transform.scale(
                      scaleY: 0.4 + 0.6 * (t < 0.15 ? t / 0.15 : 1),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(
                            HtmlJourneyTokens.lgHlWidth / 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _End extends StatelessWidget {
  const _End({required this.text, required this.roles});

  final String text;
  final SkinRoleValues roles;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(
      start: HtmlJourneyTokens.lgSecInset,
      end: HtmlJourneyTokens.lgSecInset,
      top: HtmlJourneyTokens.lgEndTop,
    ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: roles.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          top: HtmlJourneyTokens.lgEndPadTop,
        ),
        child: Text(
          text,
          style: LegalType.medium(
            HtmlJourneyTokens.lgEndSize,
            HtmlJourneyTokens.lgEndLine,
            0,
          ).copyWith(color: roles.onSurfaceVariant),
        ),
      ),
    ),
  );
}
