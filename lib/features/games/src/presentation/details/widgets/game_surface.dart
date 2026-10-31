import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Shared Game Details card: Dark has no stroke, Light has an inside stroke.
class GameSurface extends StatelessWidget {
  const GameSurface({
    super.key,
    required this.child,
    this.padding = EdgeInsetsDirectional.zero,
    this.radius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final corners = BorderRadiusDirectional.all(
      Radius.circular(radius ?? GameDetailsTokens.cardRadius),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: corners,
        border: GameDetailsStrokes.card.resolve(context),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: GameDetailsRoles.card.resolve(context),
          borderRadius: corners,
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
