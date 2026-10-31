import 'package:flutter/material.dart';

import '../../identity/element_identity.dart';
import '../../tokens/generated/collection_tokens.g.dart';

enum AppShelfLayout { scroll, paged }

/// Source gaps: [regular] 12 (compact and expand sliders), [relaxed] 16 (quest
/// slider). E-107.
enum AppShelfSpacing { regular, relaxed }

/// Provisional horizontal shelf. Children keep their own identity.
/// Source: detached Games Slider frames (D-101, D-102, R-101).
///
/// Place it full-bleed: source sliders do not clip, so content scrolls to the
/// screen edge while resting at the section inset. Height follows the tallest
/// child, so cards grow with text scale. [AppShelfLayout.paged] sizes every
/// child to the inset width and snaps one child per page.
class AppShelf extends StatefulWidget {
  const AppShelf({
    super.key,
    required this.elementId,
    required this.children,
    this.layout = AppShelfLayout.scroll,
    this.spacing = AppShelfSpacing.regular,
    this.pageIndex = 0,
    this.onPageChanged,
    this.runtimeLocator,
  });

  final String elementId;
  final List<Widget> children;
  final AppShelfLayout layout;
  final AppShelfSpacing spacing;
  final int pageIndex;
  final ValueChanged<int>? onPageChanged;
  final UiRuntimeLocator? runtimeLocator;

  @override
  State<AppShelf> createState() => _AppShelfState();
}

class _AppShelfState extends State<AppShelf> {
  final _scroll = ScrollController();
  late int _page = widget.pageIndex;
  double _pageExtent = 0;

  bool get _paged => widget.layout == AppShelfLayout.paged;

  @override
  void didUpdateWidget(AppShelf oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_paged || widget.pageIndex == _page) return;
    _page = widget.pageIndex;
    if (!_scroll.hasClients || _pageExtent == 0) return;
    final target = _page * _pageExtent;
    if (MediaQuery.disableAnimationsOf(context)) {
      _scroll.jumpTo(target);
    } else {
      _scroll.animateTo(
        target,
        duration: CollectionMotion.pageDuration,
        curve: CollectionMotion.pageCurve,
      );
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollUpdateNotification notification) {
    if (!_paged || _pageExtent == 0 || notification.depth != 0) return false;
    final page = (notification.metrics.pixels / _pageExtent).round().clamp(
      0,
      widget.children.length - 1,
    );
    if (page != _page) {
      _page = page;
      widget.onPageChanged?.call(page);
    }
    return false;
  }

  /// Keeps the current page aligned after the width changes (resize or
  /// rotation) and honors a nonzero initial page.
  void _align(double extent) {
    if (extent == _pageExtent) return;
    _pageExtent = extent;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) _scroll.jumpTo(_page * _pageExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gap = widget.spacing == AppShelfSpacing.regular
        ? CollectionTokens.shelfGapRegular
        : CollectionTokens.shelfGapRelaxed;
    final source = switch ((widget.layout, widget.spacing)) {
      (AppShelfLayout.scroll, _) => '18457:13119',
      (AppShelfLayout.paged, AppShelfSpacing.regular) => '18457:13147',
      (AppShelfLayout.paged, AppShelfSpacing.relaxed) => '18457:13162',
    };
    final children = widget.children;
    return ElementIdentity(
      elementId: widget.elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: widget.runtimeLocator,
      ),
      componentId: 'collection.shelf',
      structureRef: 'collection.shelf',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: source,
      componentSetId: null,
      rawSetName: 'Games Slider',
      rawVariantName: widget.layout.name,
      variants: {'layout': widget.layout.name, 'spacing': widget.spacing.name},
      resolved: {'gap': gap, 'inset': CollectionTokens.sectionPadding},
      declared: const {},
      child: children.isEmpty
          ? const SizedBox.shrink()
          : LayoutBuilder(
              builder: (context, constraints) {
                assert(
                  constraints.hasBoundedWidth,
                  'AppShelf needs a bounded width; place it full-bleed.',
                );
                final pageWidth =
                    constraints.maxWidth - CollectionTokens.sectionPadding * 2;
                if (_paged) _align(pageWidth + gap);
                // A loose parent must not shrink the viewport to its content.
                return NotificationListener<ScrollUpdateNotification>(
                  onNotification: _onScroll,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: SingleChildScrollView(
                      key: ValueKey(widget.spacing),
                      controller: _scroll,
                      scrollDirection: Axis.horizontal,
                      physics: _paged ? _ShelfPagePhysics(gap) : null,
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: CollectionTokens.sectionPadding,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < children.length; i++) ...[
                            if (i > 0) SizedBox(width: gap),
                            _paged
                                ? SizedBox(width: pageWidth, child: children[i])
                                : children[i],
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/// Page snapping for pages narrower than the viewport, following
/// [PageScrollPhysics]. The page extent is derived from the live viewport, so
/// it stays correct after a resize. The parent comes from the app scroll
/// behavior.
class _ShelfPagePhysics extends ScrollPhysics {
  const _ShelfPagePhysics(this.gap, {super.parent});
  final double gap;

  @override
  _ShelfPagePhysics applyTo(ScrollPhysics? ancestor) =>
      _ShelfPagePhysics(gap, parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final extent =
        position.viewportDimension - CollectionTokens.sectionPadding * 2 + gap;
    if (extent <= 0) return super.createBallisticSimulation(position, velocity);
    final tolerance = toleranceFor(position);
    var page = position.pixels / extent;
    if (velocity < -tolerance.velocity) {
      page -= .5;
    } else if (velocity > tolerance.velocity) {
      page += .5;
    }
    final target = (page.roundToDouble() * extent).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (target == position.pixels) return null;
    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
  }

  @override
  bool get allowImplicitScrolling => false;
}
