import 'package:flutter/painting.dart';
import 'package:p2e_design_system/design_system.dart';

/// Outfit text for the legal reader. Sizes come from the HTML tokens; family
/// and weights come from the Figma named styles (Auth set).
abstract final class LegalType {
  static TextStyle _style(
    TextStyle base,
    double size,
    double line,
    double spacing,
  ) => base.copyWith(
    fontSize: size,
    height: line / size,
    letterSpacing: spacing * size,
  );

  static TextStyle semibold(double size, double line, double spacing) => _style(
    AuthTextTokens.byName['English/Baseline/Label-Medium']!,
    size,
    line,
    spacing,
  );

  static TextStyle medium(double size, double line, double spacing) => _style(
    AuthTextTokens.byName['English/Variant/Button-Medium']!,
    size,
    line,
    spacing,
  );

  static TextStyle regular(double size, double line, double spacing) => _style(
    AuthTextTokens.byName['English/Muted/Label-Medium']!,
    size,
    line,
    spacing,
  );
}
