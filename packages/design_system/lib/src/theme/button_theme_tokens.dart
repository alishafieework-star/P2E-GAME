import 'package:flutter/foundation.dart' show mapEquals;
import 'package:flutter/material.dart';

import '../tokens/generated/button_tokens.g.dart';

/// Scoped Button foundations, addressed by full raw Figma names.
/// Missing Light/Dark counterparts remain absent, never substituted.
@immutable
class ButtonThemeTokens extends ThemeExtension<ButtonThemeTokens> {
  const ButtonThemeTokens({required this.colors, required this.textStyles});

  factory ButtonThemeTokens.forBrightness(Brightness brightness) {
    final source = brightness == Brightness.light
        ? ColorTokens.light
        : ColorTokens.dark;
    return ButtonThemeTokens(
      colors: Map.unmodifiable(source.map((k, v) => MapEntry(k, v.value))),
      textStyles: Map.unmodifiable(
        TypographyTokens.byName.map((k, v) => MapEntry(k, v.style)),
      ),
    );
  }

  final Map<String, Color> colors;
  final Map<String, TextStyle> textStyles;

  Color color(String figmaName) {
    final value = colors[figmaName];
    if (value == null) {
      throw StateError('No Button color in this theme: $figmaName');
    }
    return value;
  }

  @override
  ButtonThemeTokens copyWith({
    Map<String, Color>? colors,
    Map<String, TextStyle>? textStyles,
  }) => ButtonThemeTokens(
    colors: Map.unmodifiable(colors ?? this.colors),
    textStyles: Map.unmodifiable(textStyles ?? this.textStyles),
  );

  @override
  ButtonThemeTokens lerp(covariant ButtonThemeTokens? other, double t) {
    if (other == null) return this;
    // Availability changes discretely. Never manufacture a missing counterpart.
    final selected = t < 0.5 ? this : other;
    return ButtonThemeTokens(
      colors: Map.unmodifiable({
        for (final key in selected.colors.keys)
          key: colors.containsKey(key) && other.colors.containsKey(key)
              ? Color.lerp(colors[key], other.colors[key], t)!
              : selected.colors[key]!,
      }),
      textStyles: Map.unmodifiable({
        for (final key in selected.textStyles.keys)
          key: TextStyle.lerp(textStyles[key], other.textStyles[key], t)!,
      }),
    );
  }

  // The ThemeExtension contract: structurally equal tokens compare equal, so
  // rebuilt-but-identical themes do not invalidate the widget tree.
  @override
  bool operator ==(Object other) =>
      other is ButtonThemeTokens &&
      mapEquals(colors, other.colors) &&
      mapEquals(textStyles, other.textStyles);

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(
      colors.entries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
    Object.hashAllUnordered(
      textStyles.entries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
  );
}
