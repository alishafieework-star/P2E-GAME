import 'package:flutter/material.dart';

import '../tokens/generated/skin_roles.g.dart';
import 'skin_theme.dart';

/// Skin role names per brightness, generated from source evidence.
@immutable
class ThemedRole {
  const ThemedRole({required this.dark, required this.light});
  final String dark, light;

  String of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  Color resolve(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return SkinTheme.of(context).valuesFor(brightness).color(of(brightness));
  }
}

/// One theme's source paint: a skin role or an unbound source color.
@immutable
sealed class SourcePaint {
  const SourcePaint();

  Color resolve(SkinDefinition skin, Brightness brightness);
}

final class RolePaint extends SourcePaint {
  const RolePaint(this.role);
  final String role;

  @override
  Color resolve(SkinDefinition skin, Brightness brightness) =>
      skin.valuesFor(brightness).color(role);
}

/// An unbound source color (E-103). The product skin keeps it; other skins
/// resolve [fallbackRole] so a product color cannot leak into them.
final class RawPaint extends SourcePaint {
  const RawPaint(this.color, {this.fallbackRole = 'Outline/Variant'});
  final Color color;
  final String fallbackRole;

  @override
  Color resolve(SkinDefinition skin, Brightness brightness) =>
      skinPaint(skin, brightness, color, role: fallbackRole, opacity: color.a);
}

/// Source paints per brightness. Either theme may be a role or a raw color.
@immutable
class ThemedPaint {
  const ThemedPaint({required this.dark, required this.light});
  final SourcePaint dark, light;

  Color resolve(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return (brightness == Brightness.dark ? dark : light).resolve(
      SkinTheme.of(context),
      brightness,
    );
  }
}

@immutable
class SourceStroke {
  const SourceStroke(this.paint, this.width);
  final SourcePaint paint;
  final double width;
}

/// An inside border per brightness. A theme without a source border is null.
@immutable
class ThemedStroke {
  const ThemedStroke({this.dark, this.light});
  final SourceStroke? dark, light;

  Border? resolve(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final stroke = brightness == Brightness.dark ? dark : light;
    if (stroke == null) return null;
    return Border.fromBorderSide(
      BorderSide(
        color: stroke.paint.resolve(SkinTheme.of(context), brightness),
        width: stroke.width,
      ),
    );
  }
}

/// Source shadows per brightness. A theme without a source shadow is empty.
@immutable
class ThemedShadows {
  const ThemedShadows({required this.dark, required this.light});
  final List<BoxShadow> dark, light;

  List<BoxShadow> of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;
}

/// One source inner shadow: blur only, no offset or spread.
@immutable
class SourceInnerShadow {
  const SourceInnerShadow(this.paint, this.blur);
  final SourcePaint paint;
  final double blur;
}

/// Inner shadows per brightness, painted from the edges inward.
@immutable
class ThemedInnerShadows {
  const ThemedInnerShadows({required this.dark, required this.light});
  final List<SourceInnerShadow> dark, light;

  List<({Color color, double blur})> resolve(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final skin = SkinTheme.of(context);
    return [
      for (final shadow in brightness == Brightness.dark ? dark : light)
        (color: shadow.paint.resolve(skin, brightness), blur: shadow.blur),
    ];
  }
}
