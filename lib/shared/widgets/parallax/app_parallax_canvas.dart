import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../../core/sensors/device_tilt_service.dart';
import 'parallax_layer.dart';

/// Reusable, multi-layer 2D parallax canvas responding to vertical scroll
/// and device sensor tilt (accelerometer/gyroscope) along both X and Y axes.
///
/// Hardware-accelerated: transformations are applied directly via GPU matrix
/// inside [RepaintBoundary], ensuring 60/120 FPS performance with zero widget
/// rebuilds during scroll or tilt.
class AppParallaxCanvas extends StatefulWidget {
  const AppParallaxCanvas({
    super.key,
    required this.height,
    required this.layers,
    this.scroll,
    this.parallaxOffset = 0.0,
    this.maxSlack = 48.0,
    this.referenceWidth = 402.0,
    this.referenceHeight = 343.0,
    this.enableSensor = true,
    this.enablePointerHover = true,
    this.clipBehavior = Clip.hardEdge,
  });

  /// Total container height in pixels.
  final double height;

  /// Ordered list of layers rendered from back to front.
  final List<ParallaxLayer> layers;

  /// Live page scroll controller.
  final ScrollController? scroll;

  /// Direct pixel offset (used for testing or fixed offsets).
  final double parallaxOffset;

  /// Maximum vertical lag (slack) from page scroll.
  final double maxSlack;

  /// Reference Figma frame width (default: 402.0).
  final double referenceWidth;

  /// Reference Figma frame height (default: 343.0).
  final double referenceHeight;

  /// Whether to listen to device orientation / accelerometer sensors.
  final bool enableSensor;

  /// Whether to simulate 2D tilt when hovering with mouse/pointer (useful on desktop/emulator).
  final bool enablePointerHover;

  /// Canvas clipping mode.
  final Clip clipBehavior;

  @override
  State<AppParallaxCanvas> createState() => _AppParallaxCanvasState();
}

class _AppParallaxCanvasState extends State<AppParallaxCanvas> {
  late final Listenable _listenable;

  @override
  void initState() {
    super.initState();
    if (widget.enableSensor) {
      DeviceTiltService.instance.init();
    }
    _listenable = Listenable.merge([
      if (widget.scroll != null) widget.scroll!,
      DeviceTiltService.instance.tiltNotifier,
    ]);
  }

  Widget _buildTransformedLayer(
    BuildContext context,
    ParallaxLayer layer,
    Widget child,
  ) {
    final layerContent = layer.key != null
        ? KeyedSubtree(key: layer.key, child: child)
        : child;

    return ListenableBuilder(
      listenable: _listenable,
      child: RepaintBoundary(child: layerContent),
      builder: (context, cachedChild) {
        final disableAnimations = MediaQuery.disableAnimationsOf(context);
        final scrollOffset =
            (widget.scroll != null && widget.scroll!.hasClients)
            ? widget.scroll!.offset
            : widget.parallaxOffset;
        final tilt = disableAnimations
            ? Offset.zero
            : DeviceTiltService.instance.tilt;

        final scrollShiftY = (disableAnimations || scrollOffset <= 0)
            ? 0.0
            : math.min(scrollOffset * layer.scrollFactor, widget.maxSlack);

        final tiltShiftX = disableAnimations
            ? 0.0
            : tilt.dx * layer.tiltFactor.dx;
        final tiltShiftY = disableAnimations
            ? 0.0
            : tilt.dy * layer.tiltFactor.dy;

        final rotationRad = (disableAnimations || layer.rotationFactor == 0.0)
            ? 0.0
            : (tilt.dx * layer.rotationFactor * (math.pi / 180.0));

        final totalX = tiltShiftX;
        final totalY = scrollShiftY + tiltShiftY;

        if (totalX == 0.0 && totalY == 0.0 && rotationRad == 0.0) {
          return cachedChild!;
        }

        final matrix = Matrix4.translationValues(totalX, totalY, 0.0);
        if (rotationRad != 0.0) {
          matrix.rotateZ(rotationRad);
        }

        return Transform(
          transform: matrix,
          alignment: Alignment.center,
          child: cachedChild,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / widget.referenceWidth;
          final frameTop = widget.height - widget.referenceHeight * scale;
          final backgroundTop = math.min(frameTop, 0.0);
          final slack = widget.maxSlack;
          // Extra horizontal slack to avoid edge cut-offs during sideways tilt:
          const horizontalSlack = 12.0;

          return ClipRect(
            clipBehavior: widget.clipBehavior,
            child: Stack(
              fit: StackFit.expand,
              children: [
                for (final layer in widget.layers)
                  _buildLayerPositioned(
                    context: context,
                    layer: layer,
                    scale: scale,
                    frameTop: frameTop,
                    backgroundTop: backgroundTop,
                    slack: slack,
                    horizontalSlack: horizontalSlack,
                    totalHeight: widget.height,
                  ),
              ],
            ),
          );
        },
      ),
    );

    if (widget.enablePointerHover) {
      content = MouseRegion(
        onHover: (event) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null && renderBox.hasSize) {
            final size = renderBox.size;
            if (size.width > 0 && size.height > 0) {
              final normX = ((event.localPosition.dx / size.width) * 2.0 - 1.0)
                  .clamp(-1.0, 1.0);
              final normY = ((event.localPosition.dy / size.height) * 2.0 - 1.0)
                  .clamp(-1.0, 1.0);
              DeviceTiltService.instance.setSimulatedTilt(Offset(normX, normY));
            }
          }
        },
        onExit: (_) {
          DeviceTiltService.instance.clearSimulation();
          DeviceTiltService.instance.reset();
        },
        child: content,
      );
    }

    return content;
  }

  Widget _buildLayerPositioned({
    required BuildContext context,
    required ParallaxLayer layer,
    required double scale,
    required double frameTop,
    required double backgroundTop,
    required double slack,
    required double horizontalSlack,
    required double totalHeight,
  }) {
    final box = layer.alignmentBox;
    final layerWidget = _buildTransformedLayer(context, layer, layer.child);

    if (box != null) {
      // Positioned with explicit artwork alignment box:
      return Positioned(
        left: box.left * scale,
        top: frameTop + box.top * scale,
        width: box.width * scale,
        height: box.height * scale,
        child: layerWidget,
      );
    }

    if (layer.scrollFactor > 0 || layer.tiltFactor != Offset.zero) {
      // Full-bleed moving layer (e.g. background) with slack to cover edges:
      return Positioned(
        left: -horizontalSlack,
        right: -horizontalSlack,
        top: backgroundTop - slack,
        height: totalHeight - backgroundTop + slack * 2,
        child: layerWidget,
      );
    }

    // Stationary layer (e.g. vignette, stationary overlays):
    return Positioned.fill(child: layerWidget);
  }
}
