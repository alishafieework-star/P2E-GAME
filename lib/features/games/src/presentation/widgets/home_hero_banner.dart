import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/widgets/cover_image.dart';
import 'package:mygame_p2e/shared/widgets/scroll_debug_log.dart';
import 'package:p2e_design_system/design_system.dart';

/// Foreground artwork box inside the hero reference frame (402×343). The box
/// belongs to the artwork: each source theme places different sample art.
@immutable
class HeroArtworkBox {
  const HeroArtworkBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
  final double left, top, width, height;
}

/// Presentational Hero Section Banner `18533:4246`. It runs behind the chrome
/// above it ([overlap]: status bar and App Bar) and ends where the featured row
/// starts. The reference frame is scaled to the width and anchored to the
/// bottom. [parallaxOffset] is the page scroll in pixels; reduced motion
/// keeps both layers still (D-102, D-104). The artwork is decorative.
class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({
    super.key,
    required this.elementId,
    required this.background,
    required this.overlap,
    this.foreground,
    this.foregroundBox,
    this.parallaxOffset = 0,
    this.scroll,
    this.runtimeLocator,
  }) : assert((foreground == null) == (foregroundBox == null)),
       assert(overlap >= 0),
       assert(parallaxOffset >= 0);

  final String elementId;
  final ImageProvider background;
  final ImageProvider? foreground;
  final HeroArtworkBox? foregroundBox;
  final double overlap;

  /// Page scroll, in pixels. Each layer travels by its own factor, capped.
  /// Live Home passes [scroll] instead, so a frame does not rebuild the art.
  final double parallaxOffset;
  final ScrollController? scroll;
  final UiRuntimeLocator? runtimeLocator;

  /// Downward lag inside the banner. Zero while motion is reduced.
  double _shift(BuildContext context, double offset, double factor) {
    if (MediaQuery.disableAnimationsOf(context) || offset <= 0) return 0;
    return math.min(offset * factor, CollectionMotion.heroParallaxMax);
  }

  static var _shiftTicks = 0;

  /// Moves [child] without rebuilding it when [scroll] ticks (D-129).
  Widget _moved(BuildContext context, double factor, Widget child) {
    final art = RepaintBoundary(child: child);
    final scroll = this.scroll;
    if (scroll == null) {
      return Transform.translate(
        offset: Offset(0, _shift(context, parallaxOffset, factor)),
        child: art,
      );
    }
    return ListenableBuilder(
      listenable: scroll,
      child: art,
      builder: (context, cached) {
        final offset = scroll.hasClients ? scroll.offset : 0.0;
        // #region agent log
        _shiftTicks++;
        if (_shiftTicks % 30 == 0) {
          scrollDebugLog(
            'E',
            'home_hero_banner.dart:shift',
            'parallax transform',
            {'ticks': _shiftTicks, 'offset': offset.toStringAsFixed(1)},
          );
        }
        // #endregion
        return Transform.translate(
          offset: Offset(0, _shift(context, offset, factor)),
          child: cached,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = overlap + HomeTokens.heroRowTop;
    final vignette = HomeShadows.heroVignette.resolve(context);
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'game.hero-banner',
      structureRef: 'game.hero-banner',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: '18533:4246',
      componentSetId: null,
      rawSetName: 'Hero Section Banner',
      rawVariantName: foreground == null ? 'background' : 'layered',
      variants: const {},
      resolved: {'height': height},
      declared: const {},
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale =
                  constraints.maxWidth / HomeTokens.heroReferenceWidth;
              final frameTop = height - HomeTokens.heroReferenceHeight * scale;
              final backgroundTop = math.min(frameTop, 0.0);
              final slack = CollectionMotion.heroParallaxMax;
              final box = foregroundBox;
              return ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // PHYSICAL: artwork composition is not mirrored in RTL.
                    // The extra slack keeps the crop covered while the layer lags.
                    Positioned(
                      left: 0,
                      right: 0,
                      top: backgroundTop - slack,
                      height: height - backgroundTop + slack,
                      child: _moved(
                        context,
                        CollectionMotion.heroParallaxBackground,
                        Image(
                          key: ValueKey('$elementId.background'),
                          image: resizedCover(
                            context,
                            background,
                            constraints.maxWidth,
                          ),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                          excludeFromSemantics: true,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    // Isolated so the parallax shifts do not repaint the
                    // expensive blurred vignette every scroll frame.
                    // #region agent log
                    if (scrollDebugOmitVignette)
                      const SizedBox.shrink()
                    else
                      // #endregion
                      RepaintBoundary(
                        child: CustomPaint(painter: _VignettePainter(vignette)),
                      ),
                    if (foreground != null && box != null)
                      // PHYSICAL: the foreground keeps its place on the art.
                      Positioned(
                        left: box.left * scale,
                        top: frameTop + box.top * scale,
                        width: box.width * scale,
                        height: box.height * scale,
                        child: _moved(
                          context,
                          CollectionMotion.heroParallaxForeground,
                          Image(
                            key: ValueKey('$elementId.foreground'),
                            image: resizedCover(
                              context,
                              foreground!,
                              box.width * scale,
                            ),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                            excludeFromSemantics: true,
                            errorBuilder: (_, _, _) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Source inner shadows: blurred edges painted inward, clipped to the box.
class _VignettePainter extends CustomPainter {
  _VignettePainter(this.shadows);
  final List<({Color color, double blur})> shadows;

  static var _paints = 0;

  @override
  void paint(Canvas canvas, Size size) {
    // #region agent log
    _paints++;
    if (_paints <= 3 || _paints % 20 == 0) {
      scrollDebugLog('D', 'home_hero_banner.dart:vignette', 'vignette paint', {
        'paints': _paints,
        'blurLayers': shadows.length,
        'width': size.width.toStringAsFixed(0),
        'height': size.height.toStringAsFixed(0),
      });
    }
    // #endregion
    final rect = Offset.zero & size;
    canvas
      ..save()
      ..clipRect(rect);
    for (final shadow in shadows) {
      final ring = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(rect.inflate(shadow.blur * 2))
        ..addRect(rect);
      canvas.drawPath(
        ring,
        Paint()
          ..color = shadow.color
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            Shadow.convertRadiusToSigma(shadow.blur),
          ),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_VignettePainter oldDelegate) =>
      !listEquals(oldDelegate.shadows, shadows);
}
