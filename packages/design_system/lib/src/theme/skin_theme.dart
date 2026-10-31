import 'package:flutter/material.dart';

import '../tokens/generated/product_skin.g.dart';
import '../tokens/generated/skin_roles.g.dart';

/// Independent skin axis; source geometry, typography and identity stay intact.
class SkinTheme extends ThemeExtension<SkinTheme> {
  const SkinTheme(this.definition);
  final SkinDefinition definition;
  static SkinDefinition of(BuildContext context) =>
      Theme.of(context).extension<SkinTheme>()?.definition ?? productSkin;
  @override
  SkinTheme copyWith({SkinDefinition? definition}) =>
      SkinTheme(definition ?? this.definition);
  @override
  SkinTheme lerp(covariant SkinTheme? other, double t) =>
      t < .5 ? this : other ?? this;

  // The ThemeExtension contract: skins with identical role values compare
  // equal, so a rebuilt-but-identical skin does not invalidate the tree.
  // Role maps are cached on first use, so the comparison is cheap after that.
  @override
  bool operator ==(Object other) {
    if (other is! SkinTheme) return false;
    if (identical(definition, other.definition)) return true;
    if (definition.id != other.definition.id) return false;
    for (final brightness in Brightness.values) {
      final a = definition.valuesFor(brightness).byName;
      final b = other.definition.valuesFor(brightness).byName;
      if (a.length != b.length) return false;
      for (final entry in a.entries) {
        if (b[entry.key] != entry.value) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    definition.id,
    Object.hashAllUnordered(
      definition
          .valuesFor(Brightness.light)
          .byName
          .entries
          .map((entry) => Object.hash(entry.key, entry.value)),
    ),
    Object.hashAllUnordered(
      definition
          .valuesFor(Brightness.dark)
          .byName
          .entries
          .map((entry) => Object.hash(entry.key, entry.value)),
    ),
  );
}

/// Keep original source floats untouched for product. For alternate skins,
/// resolve by the bound raw role, never by matching a hex value. Unbound source
/// paints use the existing Outline/Variant role as an explicit diagnostic paint.
Color skinPaint(
  SkinDefinition? skin,
  Brightness brightness,
  Color source, {
  String? role,
  double opacity = 1,
}) {
  if (skin == null || identical(skin, productSkin)) return source;
  final color = skin.valuesFor(brightness).color(role ?? 'Outline/Variant');
  return color.withValues(alpha: color.a * opacity);
}
