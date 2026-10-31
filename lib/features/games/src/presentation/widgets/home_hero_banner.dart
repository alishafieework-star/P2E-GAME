import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/widgets/cover_image.dart';
import 'package:mygame_p2e/shared/widgets/parallax/app_parallax_canvas.dart';
import 'package:mygame_p2e/shared/widgets/parallax/parallax_layer.dart';
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
///
/// Built on top of the generic [AppParallaxCanvas] (D-143), responding to both
/// vertical scroll and device sensor tilt (accelerometer/gyroscope) in 2D.
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

  @override
  Widget build(BuildContext context) {
    final height = overlap + HomeTokens.heroRowTop;
    final vignette = HomeShadows.heroVignette.resolve(context);
    final box = foregroundBox;

    final layers = <ParallaxLayer>[
      // Background layer: moves slowly with scroll, opposite to tilt
      ParallaxLayer.background(
        scrollFactor: CollectionMotion.heroParallaxBackground,
        tiltFactor: const Offset(-3.0, -1.5),
        child: LayoutBuilder(
          builder: (context, constraints) => Image(
            key: ValueKey('$elementId.background'),
            image: resizedCover(context, background, constraints.maxWidth),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
            excludeFromSemantics: true,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        ),
      ),
      // Vignette layer: stationary overlay, isolated so tilt doesn't repaint GPU blur
      // #region agent log
      if (scrollDebugOmitVignette)
        ParallaxLayer.stationary(child: const SizedBox.shrink())
      else
        // #endregion
        ParallaxLayer.stationary(
          child: RepaintBoundary(
            child: CustomPaint(painter: _VignettePainter(vignette)),
          ),
        ),
      // Foreground layered artwork: moves with scroll and tilt + slight micro-rotation
      if (foreground != null && box != null)
        ParallaxLayer.foreground(
          alignmentBox: Rect.fromLTWH(box.left, box.top, box.width, box.height),
          scrollFactor: CollectionMotion.heroParallaxForeground,
          tiltFactor: const Offset(8.0, 4.0),
          rotationFactor: 0.6,
          child: LayoutBuilder(
            builder: (context, constraints) => Image(
              key: ValueKey('$elementId.foreground'),
              image: resizedCover(
                context,
                foreground!,
                box.width *
                    (constraints.maxWidth / HomeTokens.heroReferenceWidth),
              ),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
    ];

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
        child: AppParallaxCanvas(
          height: height,
          layers: layers,
          scroll: scroll,
          parallaxOffset: parallaxOffset,
          maxSlack: CollectionMotion.heroParallaxMax,
          referenceWidth: HomeTokens.heroReferenceWidth,
          referenceHeight: HomeTokens.heroReferenceHeight,
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
