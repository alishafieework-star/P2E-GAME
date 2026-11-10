import 'package:flutter/material.dart';

import '../../icons/app_icon.dart';
import '../../identity/element_identity.dart';
import '../../interaction/press_action.dart';
import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';
import '../../tokens/button_motion.dart';

/// Size variants for [AppFilterChip].
enum AppFilterChipSize { small, medium }

/// Roles for [AppFilterChip] per brightness.
abstract final class _FilterChipRoles {
  static const selectedBackground = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Emphasis',
  );

  static const selectedForeground = ThemedRole(
    dark: 'Alpha/Black',
    light: 'Alpha/White',
  );

  static const unselectedBackground = ThemedRole(
    dark: 'Surface Container/Base',
    light: 'Surface Container/Base',
  );

  static const unselectedBorder = ThemedRole(
    dark: 'Outline/Variant',
    light: 'Outline/Variant',
  );

  static const unselectedForeground = ThemedRole(
    dark: 'On Surface/Base',
    light: 'On Surface/Base',
  );

  static const disabledForeground = ThemedRole(
    dark: 'On Surface/Disabled',
    light: 'On Surface/Disabled',
  );
}

/// Typography for [AppFilterChip].
abstract final class _FilterChipText {
  static final mediumSelected = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 18 / 14,
      letterSpacing: -0.56,
    ),
  );

  static final mediumUnselected = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 18 / 14,
      letterSpacing: -0.56,
    ),
  );

  static final smallSelected = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 16 / 12,
      letterSpacing: -0.4,
    ),
  );

  static final smallUnselected = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: -0.4,
    ),
  );
}

/// A compact pill chip for filtering content, categories, tabs, or periods.
///
/// Implements Layer 1 Design System specifications from wireframes
/// (Figma nodes `1:4363`, `1:4364`, `1:4366`).
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.elementId,
    this.runtimeLocator,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.leadingIcon,
    this.count,
    this.enabled = true,
    this.size = AppFilterChipSize.medium,
  });

  /// Identity contract v1.1 identifier.
  final String elementId;

  /// Optional route identity scope override.
  final UiRuntimeLocator? runtimeLocator;

  /// The text label displayed inside the chip.
  final String label;

  /// Whether this chip is currently selected (highlighted).
  final bool selected;

  /// Called when the chip is tapped with the new selection value.
  final ValueChanged<bool>? onSelected;

  /// Optional leading icon in start position.
  final AppIcon? leadingIcon;

  /// Optional count / badge number displayed after the label, e.g. "All (12)".
  final int? count;

  /// Whether the chip is interactive.
  final bool enabled;

  /// Size variant determining height, padding, and text metrics.
  final AppFilterChipSize size;

  @override
  Widget build(BuildContext context) {
    final isInteractive = enabled && onSelected != null;
    final isSmall = size == AppFilterChipSize.small;

    // Tokens resolution
    final Color backgroundColor;
    final Color foregroundColor;
    final BorderSide borderSide;

    if (!enabled) {
      backgroundColor = _FilterChipRoles.unselectedBackground.resolve(context);
      foregroundColor = _FilterChipRoles.disabledForeground.resolve(context);
      borderSide = BorderSide(
        color: _FilterChipRoles.unselectedBorder
            .resolve(context)
            .withValues(alpha: 0.38),
        width: 1.0,
      );
    } else if (selected) {
      backgroundColor = _FilterChipRoles.selectedBackground.resolve(context);
      foregroundColor = _FilterChipRoles.selectedForeground.resolve(context);
      borderSide = BorderSide.none;
    } else {
      backgroundColor = _FilterChipRoles.unselectedBackground.resolve(context);
      foregroundColor = _FilterChipRoles.unselectedForeground.resolve(context);
      borderSide = BorderSide(
        color: _FilterChipRoles.unselectedBorder.resolve(context),
        width: 1.0,
      );
    }

    final TextStyle textStyle;
    if (isSmall) {
      textStyle =
          (selected
                  ? _FilterChipText.smallSelected
                  : _FilterChipText.smallUnselected)
              .copyWith(color: foregroundColor);
    } else {
      textStyle =
          (selected
                  ? _FilterChipText.mediumSelected
                  : _FilterChipText.mediumUnselected)
              .copyWith(color: foregroundColor);
    }

    final hPadding = isSmall ? 10.0 : 14.0;
    final vPadding = isSmall ? 4.0 : 7.0;
    final internalGap = isSmall ? 4.0 : 6.0;
    final iconSize = isSmall ? 14.0 : 16.0;

    Widget chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          IconTheme.merge(
            data: IconThemeData(size: iconSize, color: foregroundColor),
            child: leadingIcon!.forControl(
              selected ? AppIconStyle.fill : AppIconStyle.outline,
            ),
          ),
          SizedBox(width: internalGap),
        ],
        Text(
          label,
          style: textStyle,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (count != null) ...[
          SizedBox(width: internalGap),
          () {
            final countLabel = '($count)';
            return Text(
              countLabel,
              style: textStyle.copyWith(
                fontWeight: FontWeight.w400,
                color: foregroundColor.withValues(alpha: 0.75),
              ),
              textAlign: TextAlign.start,
            );
          }(),
        ],
      ],
    );

    final visualPill = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadiusDirectional.all(Radius.circular(100)),
        border: borderSide != BorderSide.none
            ? Border.fromBorderSide(borderSide)
            : null,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: hPadding,
          vertical: vPadding,
        ),
        child: chipContent,
      ),
    );

    final touchBoundary = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
      child: Center(child: visualPill),
    );

    final Widget interactiveWidget;
    if (isInteractive) {
      interactiveWidget = PressAction(
        onPressed: () => onSelected!(!selected),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const StadiumBorder(),
        ),
        pressedScale: ButtonMotion.pressedScale,
        child: touchBoundary,
      );
    } else {
      interactiveWidget = Opacity(
        opacity: enabled ? 1.0 : 0.38,
        child: touchBoundary,
      );
    }

    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'chip.filter-chip',
      structureRef: 'chip.filter-chip',
      fileKey: '7BurKbCwclcabEGJ7cLcKz',
      variantId: selected ? '1:4364' : '1:4366',
      componentSetId: null,
      rawSetName: 'Filter Chips',
      rawVariantName: selected ? 'selected' : 'unselected',
      variants: {
        'size': size.name,
        'selected': selected.toString(),
        'enabled': enabled.toString(),
        'hasIcon': (leadingIcon != null).toString(),
        'hasCount': (count != null).toString(),
      },
      declared: {'label': label, 'count': count},
      resolved: {
        'source': selected ? '1:4364' : '1:4366',
        'selected': selected,
      },
      status: 'provisional',
      child: interactiveWidget,
    );
  }
}

/// A horizontal scrollable or fixed container for a sequence of [AppFilterChip]s.
///
/// Implements Layer 1 Design System specifications from wireframes
/// (Figma node `1:4363`).
class AppFilterBar extends StatelessWidget {
  const AppFilterBar({
    super.key,
    required this.elementId,
    this.runtimeLocator,
    required this.chips,
    this.padding = const EdgeInsetsDirectional.symmetric(horizontal: 16),
    this.gap = 8.0,
    this.isScrollable = true,
  });

  /// Identity contract v1.1 identifier.
  final String elementId;

  /// Optional route identity scope override.
  final UiRuntimeLocator? runtimeLocator;

  /// The list of [AppFilterChip] widgets to layout.
  final List<Widget> chips;

  /// Outer padding around the chips list.
  final EdgeInsetsDirectional padding;

  /// Horizontal gap between consecutive chips.
  final double gap;

  /// Whether the bar scrolls horizontally when content overflows.
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];
    for (int i = 0; i < chips.length; i++) {
      if (i > 0) {
        items.add(SizedBox(width: gap));
      }
      items.add(chips[i]);
    }

    final row = Row(
      mainAxisSize: isScrollable ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: items,
    );

    final Widget barContent;
    if (isScrollable) {
      barContent = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: padding,
        child: row,
      );
    } else {
      barContent = Padding(padding: padding, child: row);
    }

    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'chip.filter-bar',
      structureRef: 'chip.filter-bar',
      fileKey: '7BurKbCwclcabEGJ7cLcKz',
      variantId: '1:4363',
      componentSetId: null,
      rawSetName: 'Filter Chips',
      rawVariantName: 'row',
      variants: {
        'scrollable': isScrollable.toString(),
        'chipCount': chips.length.toString(),
      },
      declared: const {},
      resolved: const {'source': '1:4363'},
      status: 'provisional',
      child: barContent,
    );
  }
}
