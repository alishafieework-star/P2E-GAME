import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:p2e_design_system/design_system.dart';

import 'widgets/legal_document.dart';
import 'widgets/legal_type.dart';

/// In-app Terms and Privacy reader (D-141, rebuilt after the HTML `openLegal`).
class LegalReaderScreen extends StatefulWidget {
  const LegalReaderScreen({super.key, required this.doc});

  final String doc;

  @override
  State<LegalReaderScreen> createState() => _LegalReaderScreenState();
}

class _LegalReaderScreenState extends State<LegalReaderScreen> {
  late var terms = widget.doc != 'privacy';
  final scroll = ScrollController();
  var slide = 0;
  var progress = 0.0;
  var deep = false;
  var scrolled = false;
  Offset? drag;

  @override
  void initState() {
    super.initState();
    scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!scroll.hasClients) return;
    final max = scroll.position.maxScrollExtent;
    final next = max <= 0 ? 1.0 : (scroll.offset / max).clamp(0.0, 1.0);
    final far = scroll.offset > HtmlJourneyTokens.legalTopThreshold;
    final head = scroll.offset > HtmlJourneyTokens.lgScrolledAt;
    if (next != progress || far != deep || head != scrolled) {
      setState(() {
        progress = next;
        deep = far;
        scrolled = head;
      });
    }
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  void show(bool next) {
    if (next == terms) return;
    setState(() {
      slide = next ? -1 : 1;
      terms = next;
      progress = 0;
      deep = false;
      scrolled = false;
    });
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  void onPointerUp(PointerUpEvent event) {
    final origin = drag;
    drag = null;
    if (origin == null) return;
    final dx = event.position.dx - origin.dx;
    final dy = event.position.dy - origin.dy;
    if (dx.abs() <= HtmlJourneyTokens.legalSwipeThreshold ||
        dx.abs() <= dy.abs() * HtmlJourneyTokens.legalSwipeDominance) {
      return;
    }
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final towardStart = rtl ? dx > 0 : dx < 0;
    // Swiping toward the start moves on to Privacy.
    show(!towardStart);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final reduced = MediaQuery.disableAnimationsOf(context);
    final padding = MediaQuery.paddingOf(context);
    final copy = _copy(strings, terms);
    return PageScaffold(
      elementId: 'legal.reader',
      layout: PageScaffoldLayout.viewport,
      child: Column(
        children: [
          AnimatedContainer(
            duration: reduced ? Duration.zero : HtmlJourneyTokens.lgFadeMs,
            decoration: BoxDecoration(
              color: roles.color('Surface/Base'),
              boxShadow: scrolled
                  ? [
                      BoxShadow(
                        color: HtmlJourneyTokens.playNowHover.withValues(
                          alpha: HtmlJourneyTokens.lgShadowAlpha,
                        ),
                        blurRadius: HtmlJourneyTokens.lgShadowBlur,
                        offset: const Offset(0, HtmlJourneyTokens.lgShadowDy),
                      ),
                    ]
                  : const [],
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: padding.top),
              child: Column(
                children: [
                  _Bar(
                    title: strings.legalTitle,
                    closeLabel: strings.authBack,
                    onClose: () => context.pop(),
                    roles: roles,
                  ),
                  _Tabs(
                    terms: terms,
                    termsLabel: strings.legalTerms,
                    privacyLabel: strings.legalPrivacy,
                    onChanged: show,
                    roles: roles,
                  ),
                  SizedBox(
                    height: HtmlJourneyTokens.legalProgressExtent,
                    child: ColoredBox(
                      color: roles.outlineVariant,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: FractionallySizedBox(
                          widthFactor: progress,
                          heightFactor: 1,
                          child: const ColoredBox(
                            color: HtmlJourneyTokens.splashGradientMid,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Listener(
                    onPointerDown: (event) => drag = event.position,
                    onPointerUp: onPointerUp,
                    onPointerCancel: (_) => drag = null,
                    child: SingleChildScrollView(
                      controller: scroll,
                      padding: const EdgeInsetsDirectional.only(
                        top: HtmlJourneyTokens.lgScrollTop,
                        start: HtmlJourneyTokens.lgScrollH,
                        end: HtmlJourneyTokens.lgScrollH,
                        bottom: HtmlJourneyTokens.lgScrollBottom,
                      ),
                      child: LegalDocument(
                        key: ValueKey(terms),
                        docId: terms ? 'terms' : 'privacy',
                        copy: copy,
                        slide: slide,
                        scroll: scroll,
                        tldr: strings.legalTldr,
                        shortVersion: strings.legalSummary,
                        contents: strings.legalContents,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  child: _Footer(
                    deep: deep,
                    topLabel: strings.legalTop,
                    gotItLabel: strings.legalGotIt,
                    bottomInset: padding.bottom,
                    onTop: () => reduced
                        ? scroll.jumpTo(0)
                        : scroll.animateTo(
                            0,
                            duration: HtmlJourneyTokens.legalEnter,
                            curve: HtmlJourneyTokens.ease,
                          ),
                    onClose: () => context.pop(),
                    roles: roles,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// HTML `.lg-bar`: close, centered title, and a slot that balances the close.
class _Bar extends StatelessWidget {
  const _Bar({
    required this.title,
    required this.closeLabel,
    required this.onClose,
    required this.roles,
  });

  final String title, closeLabel;
  final VoidCallback onClose;
  final SkinRoleValues roles;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: HtmlJourneyTokens.lgBar,
    child: Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: HtmlJourneyTokens.lgBarInset,
      ),
      child: Row(
        children: [
          AppButton(
            elementId: 'legal.close',
            label: closeLabel,
            family: AppButtonFamily.icon,
            size: AppButtonSize.small,
            type: AppButtonType.tonal,
            icon: const AssetAppIcon(AppIconId.close),
            iconMode: ButtonIconMode.fill,
            onPressed: onClose,
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: LegalType.semibold(
                  HtmlJourneyTokens.lgTitleSize,
                  HtmlJourneyTokens.lgTitleLine,
                  HtmlJourneyTokens.lgTitleSpace,
                ).copyWith(color: roles.onSurfaceEmphasis),
              ),
            ),
          ),
          // Balances the close button so the title stays centered.
          const SizedBox.square(dimension: HtmlJourneyTokens.lgBar / 2),
        ],
      ),
    ),
  );
}

/// HTML `.lg-tabs`: two labels over a sliding pill.
class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.terms,
    required this.termsLabel,
    required this.privacyLabel,
    required this.onChanged,
    required this.roles,
  });

  final bool terms;
  final String termsLabel, privacyLabel;
  final ValueChanged<bool> onChanged;
  final SkinRoleValues roles;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: HtmlJourneyTokens.lgTabsInsetH,
        end: HtmlJourneyTokens.lgTabsInsetH,
        bottom: HtmlJourneyTokens.lgTabsBottom,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: roles.surfaceContainerBase,
          borderRadius: BorderRadius.circular(HtmlJourneyTokens.lgTabsRadius),
        ),
        child: SizedBox(
          height: HtmlJourneyTokens.lgTabsHeight,
          child: Padding(
            padding: const EdgeInsetsDirectional.all(
              HtmlJourneyTokens.lgTabsPad,
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  key: const ValueKey('legal.indicator'),
                  alignment: terms
                      ? AlignmentDirectional.centerStart
                      : AlignmentDirectional.centerEnd,
                  duration: reduced
                      ? Duration.zero
                      : HtmlJourneyTokens.legalIndicator,
                  curve: HtmlJourneyTokens.spring,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: roles.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(
                          HtmlJourneyTokens.lgIndRadius,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _Tab(
                        key: const ValueKey('legal.terms'),
                        label: termsLabel,
                        selected: terms,
                        onPressed: () => onChanged(true),
                        roles: roles,
                      ),
                    ),
                    Expanded(
                      child: _Tab(
                        key: const ValueKey('legal.privacy'),
                        label: privacyLabel,
                        selected: !terms,
                        onPressed: () => onChanged(false),
                        roles: roles,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatefulWidget {
  const _Tab({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
    required this.roles,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final SkinRoleValues roles;

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  var hover = false, down = false;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final color = widget.selected
        ? widget.roles.onSurfaceEmphasis
        : hover
        ? HtmlJourneyTokens.lgKeyText
        : widget.roles.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.label,
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
            scale: down && !reduced ? ButtonMotion.pressedScale : 1,
            duration: reduced ? Duration.zero : ButtonMotion.pressDuration,
            curve: HtmlJourneyTokens.ease,
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: reduced ? Duration.zero : HtmlJourneyTokens.lgFadeMs,
                style: LegalType.semibold(
                  HtmlJourneyTokens.lgTabSize,
                  HtmlJourneyTokens.lgTabLine,
                  HtmlJourneyTokens.lgTabSpace,
                ).copyWith(color: color),
                child: Text(widget.label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// HTML `.lg-foot`: a gradient with Got it and, after 480px, Back to top.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.deep,
    required this.topLabel,
    required this.gotItLabel,
    required this.bottomInset,
    required this.onTop,
    required this.onClose,
    required this.roles,
  });

  final bool deep;
  final String topLabel, gotItLabel;
  final double bottomInset;
  final VoidCallback onTop, onClose;
  final SkinRoleValues roles;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final base = roles.color('Surface/Base');
    final duration = reduced ? Duration.zero : HtmlJourneyTokens.lgTopBtnMs;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [base.withValues(alpha: 0), base, base],
          stops: const [0, 0.4, 1],
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: HtmlJourneyTokens.lgFootH,
          end: HtmlJourneyTokens.lgFootH,
          top: HtmlJourneyTokens.lgFootTop,
          bottom: math.max(HtmlJourneyTokens.lgFootBottom, bottomInset),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: duration,
              curve: HtmlJourneyTokens.ease,
              height: HtmlJourneyTokens.lgTopBtn,
              width: deep
                  ? HtmlJourneyTokens.lgTopBtn + HtmlJourneyTokens.lgFootGap
                  : 0,
              child: ClipRect(
                child: OverflowBox(
                  alignment: AlignmentDirectional.centerStart,
                  minWidth: 0,
                  minHeight: HtmlJourneyTokens.lgTopBtn,
                  maxHeight: HtmlJourneyTokens.lgTopBtn,
                  maxWidth:
                      HtmlJourneyTokens.lgTopBtn + HtmlJourneyTokens.lgFootGap,
                  child: AnimatedScale(
                    scale: deep ? 1 : 0.6,
                    duration: duration,
                    curve: HtmlJourneyTokens.ease,
                    child: AnimatedOpacity(
                      opacity: deep ? 1 : 0,
                      duration: duration,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          end: HtmlJourneyTokens.lgFootGap,
                        ),
                        child: IgnorePointer(
                          ignoring: !deep,
                          child: AppButton(
                            elementId: 'legal.top',
                            label: topLabel,
                            family: AppButtonFamily.icon,
                            size: AppButtonSize.large,
                            type: AppButtonType.tonal,
                            icon: const AssetAppIcon(AppIconId.arrowUp),
                            iconMode: ButtonIconMode.fill,
                            onPressed: onTop,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: AppButton(
                elementId: 'legal.got-it',
                label: gotItLabel,
                family: AppButtonFamily.fill,
                tone: AppButtonTone.accent,
                onPressed: onClose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

LegalCopy _copy(AppLocalizations strings, bool terms) {
  if (terms) {
    return LegalCopy(
      updated: strings.legalUpdated,
      read: strings.legalReadTerms,
      summary: strings.legalTermsSummary,
      points: [
        strings.legalTermsPoint1,
        strings.legalTermsPoint2,
        strings.legalTermsPoint3,
        strings.legalTermsPoint4,
      ],
      sections: [
        (strings.legalTermsTitle1, strings.legalTermsBody1),
        (strings.legalTermsTitle2, strings.legalTermsBody2),
        (strings.legalTermsTitle3, strings.legalTermsBody3),
        (strings.legalTermsTitle4, strings.legalTermsBody4),
        (strings.legalTermsTitle5, strings.legalTermsBody5),
        (strings.legalTermsTitle6, strings.legalTermsBody6),
        (strings.legalTermsTitle7, strings.legalTermsBody7),
        (strings.legalTermsTitle8, strings.legalTermsBody8),
        (strings.legalTermsTitle9, strings.legalTermsBody9),
      ],
      ending: strings.legalTermsEnd,
    );
  }
  return LegalCopy(
    updated: strings.legalUpdated,
    read: strings.legalReadPrivacy,
    summary: strings.legalPrivacySummary,
    points: [
      strings.legalPrivacyPoint1,
      strings.legalPrivacyPoint2,
      strings.legalPrivacyPoint3,
      strings.legalPrivacyPoint4,
    ],
    sections: [
      (strings.legalPrivacyTitle1, strings.legalPrivacyBody1),
      (strings.legalPrivacyTitle2, strings.legalPrivacyBody2),
      (strings.legalPrivacyTitle3, strings.legalPrivacyBody3),
      (strings.legalPrivacyTitle4, strings.legalPrivacyBody4),
      (strings.legalPrivacyTitle5, strings.legalPrivacyBody5),
      (strings.legalPrivacyTitle6, strings.legalPrivacyBody6),
      (strings.legalPrivacyTitle7, strings.legalPrivacyBody7),
      (strings.legalPrivacyTitle8, strings.legalPrivacyBody8),
    ],
    ending: strings.legalPrivacyEnd,
  );
}
