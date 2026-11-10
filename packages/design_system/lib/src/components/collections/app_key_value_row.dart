import 'package:flutter/material.dart';

import '../../icons/app_icon.dart';
import '../../identity/element_identity.dart';
import '../../interaction/press_action.dart';
import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';

/// Style variants for [AppKeyValueRow].
enum AppKeyValueVariant { regular, total, subtle }

/// Semantic roles for [AppKeyValueRow] per brightness.
abstract final class _KeyValueRoles {
  static const regularLabel = ThemedRole(
    dark: 'On Surface/Base',
    light: 'On Surface/Base',
  );

  static const regularValue = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Emphasis',
  );

  static const totalLabel = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Emphasis',
  );

  static const totalValue = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Emphasis',
  );

  static const subtleLabel = ThemedRole(
    dark: 'On Surface/Muted',
    light: 'On Surface/Muted',
  );

  static const subtleValue = ThemedRole(
    dark: 'On Surface/Muted',
    light: 'On Surface/Muted',
  );

  static const divider = ThemedRole(
    dark: 'Outline/Variant',
    light: 'Outline/Variant',
  );
}

/// Typography for [AppKeyValueRow].
abstract final class _KeyValueText {
  static final regularLabel = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 18 / 14,
      letterSpacing: -0.3,
    ),
  );

  static final regularValue = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 18 / 14,
      letterSpacing: -0.3,
    ),
  );

  static final totalLabel = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 20 / 16,
      letterSpacing: -0.4,
    ),
  );

  static final totalValue = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 20 / 16,
      letterSpacing: -0.4,
    ),
  );

  static final subtle = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 16 / 12,
      letterSpacing: -0.2,
    ),
  );
}

/// A structured key-value line item for invoice summaries, specs, and receipt breakdowns.
///
/// Implements Layer 1 Design System specifications from wireframes
/// (Figma nodes `1:1981`, `1:2001`, `1:2195`, `1:2263`, `1:4335`).
class AppKeyValueRow extends StatelessWidget {
  const AppKeyValueRow({
    super.key,
    required this.elementId,
    this.runtimeLocator,
    required this.label,
    this.value,
    this.valueWidget,
    this.variant = AppKeyValueVariant.regular,
    this.leadingIcon,
    this.trailingIcon,
    this.hasTopDivider = false,
    this.hasBottomDivider = false,
    this.padding = const EdgeInsetsDirectional.symmetric(vertical: 8.0),
    this.onTap,
  }) : assert(
         value != null || valueWidget != null,
         'AppKeyValueRow requires either value or valueWidget.',
       );

  /// Identity contract v1.1 identifier.
  final String elementId;

  /// Optional route identity scope override.
  final UiRuntimeLocator? runtimeLocator;

  /// Start-side descriptor label (e.g. "Order ID", "Subtotal").
  final String label;

  /// Optional end-side text value (e.g. "50,000 Toman").
  final String? value;

  /// Optional custom widget slot on end side (e.g. an `AppStatusChip`).
  final Widget? valueWidget;

  /// Visual emphasis variant.
  final AppKeyValueVariant variant;

  /// Optional icon placed before the label at the start.
  final AppIcon? leadingIcon;

  /// Optional icon placed after the value at the end.
  final AppIcon? trailingIcon;

  /// Whether to render a horizontal divider above this row.
  final bool hasTopDivider;

  /// Whether to render a horizontal divider below this row.
  final bool hasBottomDivider;

  /// Directional row insets.
  final EdgeInsetsDirectional padding;

  /// Optional tap callback for interactive rows.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (
      labelRole,
      valueRole,
      baseLabelStyle,
      baseValueStyle,
    ) = switch (variant) {
      AppKeyValueVariant.regular => (
        _KeyValueRoles.regularLabel,
        _KeyValueRoles.regularValue,
        _KeyValueText.regularLabel,
        _KeyValueText.regularValue,
      ),
      AppKeyValueVariant.total => (
        _KeyValueRoles.totalLabel,
        _KeyValueRoles.totalValue,
        _KeyValueText.totalLabel,
        _KeyValueText.totalValue,
      ),
      AppKeyValueVariant.subtle => (
        _KeyValueRoles.subtleLabel,
        _KeyValueRoles.subtleValue,
        _KeyValueText.subtle,
        _KeyValueText.subtle,
      ),
    };

    final labelColor = labelRole.resolve(context);
    final valueColor = valueRole.resolve(context);
    final dividerColor = _KeyValueRoles.divider.resolve(context);

    final iconSize = variant == AppKeyValueVariant.total ? 18.0 : 16.0;

    final labelStyle = baseLabelStyle.copyWith(color: labelColor);
    final valueStyle = baseValueStyle.copyWith(color: valueColor);

    final Widget labelSection = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          IconTheme.merge(
            data: IconThemeData(size: iconSize, color: labelColor),
            child: leadingIcon!.forControl(AppIconStyle.outline),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(label, style: labelStyle, textAlign: TextAlign.start),
        ),
      ],
    );

    final Widget valueSection = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (value != null)
          Flexible(
            child: Text(value!, style: valueStyle, textAlign: TextAlign.end),
          ),
        if (valueWidget != null) ...[
          if (value != null) const SizedBox(width: 8),
          valueWidget!,
        ],
        if (trailingIcon != null) ...[
          const SizedBox(width: 6),
          IconTheme.merge(
            data: IconThemeData(size: iconSize, color: valueColor),
            child: trailingIcon!.forControl(AppIconStyle.outline),
          ),
        ],
      ],
    );

    Widget rowContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(flex: 3, child: labelSection),
        const SizedBox(width: 8),
        Flexible(
          flex: 4,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: valueSection,
          ),
        ),
      ],
    );

    if (onTap != null) {
      rowContent = PressAction(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 36),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: rowContent,
      );
    }

    final columnChildren = <Widget>[];

    if (hasTopDivider) {
      columnChildren.add(Divider(height: 1, thickness: 1, color: dividerColor));
      columnChildren.add(const SizedBox(height: 6));
    }

    columnChildren.add(Padding(padding: padding, child: rowContent));

    if (hasBottomDivider) {
      columnChildren.add(const SizedBox(height: 6));
      columnChildren.add(Divider(height: 1, thickness: 1, color: dividerColor));
    }

    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'collection.key-value-row',
      structureRef: 'collection.key-value-row',
      fileKey: '7BurKbCwclcabEGJ7cLcKz',
      variantId: variant == AppKeyValueVariant.total ? '1:2001' : '1:1981',
      componentSetId: null,
      rawSetName: 'Data Row',
      rawVariantName: variant.name,
      variants: {
        'variant': variant.name,
        'hasTopDivider': hasTopDivider.toString(),
        'hasBottomDivider': hasBottomDivider.toString(),
        'hasLeadingIcon': (leadingIcon != null).toString(),
        'hasTrailingIcon': (trailingIcon != null).toString(),
        'isClickable': (onTap != null).toString(),
      },
      declared: {'label': label, 'value': value},
      resolved: {
        'source': variant == AppKeyValueVariant.total ? '1:2001' : '1:1981',
      },
      status: 'provisional',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren,
      ),
    );
  }
}
