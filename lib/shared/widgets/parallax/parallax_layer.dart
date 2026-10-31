import 'package:flutter/widgets.dart';

/// Configuration for an individual layer inside `AppParallaxCanvas`.
@immutable
class ParallaxLayer {
  const ParallaxLayer({
    required this.child,
    this.tiltFactor = Offset.zero,
    this.scrollFactor = 0.0,
    this.rotationFactor = 0.0,
    this.scaleFactor = 0.0,
    this.alignmentBox,
    this.key,
  });

  /// Factory for a background layer.
  ///
  /// Backgrounds typically move slightly opposite to tilt (negative tilt factor)
  /// and at a lower scroll rate than foregrounds.
  factory ParallaxLayer.background({
    Key? key,
    required Widget child,
    Offset tiltFactor = const Offset(-2.0, -1.5),
    double scrollFactor = 0.25,
  }) {
    return ParallaxLayer(
      key: key,
      child: child,
      tiltFactor: tiltFactor,
      scrollFactor: scrollFactor,
    );
  }

  /// Factory for a stationary layer (e.g. vignettes, borders, fixed overlays).
  factory ParallaxLayer.stationary({Key? key, required Widget child}) {
    return ParallaxLayer(
      key: key,
      child: child,
      tiltFactor: Offset.zero,
      scrollFactor: 0.0,
    );
  }

  /// Factory for a foreground / hero object layer.
  ///
  /// Foregrounds move in the direction of tilt (positive tilt factor),
  /// lag further on scroll, and can have micro-rotation and scale on tilt.
  factory ParallaxLayer.foreground({
    Key? key,
    required Widget child,
    Offset tiltFactor = const Offset(5.0, 3.0),
    double scrollFactor = 0.55,
    double rotationFactor = 0.6,
    Rect? alignmentBox,
  }) {
    return ParallaxLayer(
      key: key,
      child: child,
      tiltFactor: tiltFactor,
      scrollFactor: scrollFactor,
      rotationFactor: rotationFactor,
      alignmentBox: alignmentBox,
    );
  }

  /// Widget content of this layer.
  final Widget child;

  /// Multiplier for device sensor tilt along X and Y (in pixels).
  ///
  /// Tilt coordinates are normalized to [-1.0, 1.0].
  /// Resulting translation is `tilt.dx * tiltFactor.dx` and `tilt.dy * tiltFactor.dy`.
  final Offset tiltFactor;

  /// Multiplier for vertical page scroll offset (in pixels).
  ///
  /// Resulting translation is `min(scrollOffset * scrollFactor, maxSlack)`.
  final double scrollFactor;

  /// Micro-rotation factor in degrees around Z-axis driven by horizontal tilt.
  ///
  /// Rotation angle = `tilt.dx * rotationFactor * (pi / 180)`.
  final double rotationFactor;

  /// Optional scale factor added to layer scale on scroll/tilt.
  final double scaleFactor;

  /// Optional coordinate box (left, top, width, height) relative to reference frame.
  final Rect? alignmentBox;

  /// Optional key for this layer widget.
  final Key? key;
}
