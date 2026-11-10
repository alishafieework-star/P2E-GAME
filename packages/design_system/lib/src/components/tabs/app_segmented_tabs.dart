import 'package:flutter/material.dart';

import '../../icons/app_icon.dart';
import '../../identity/element_identity.dart';
import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';

/// Item definition for an [AppSegmentedTabs] tab.
class AppSegmentedTabItem {
  const AppSegmentedTabItem({required this.label, this.icon, this.badge});

  /// The text label for this tab.
  final String label;

  /// Optional leading icon.
  final AppIcon? icon;

  /// Optional badge or count text (e.g. "12").
  final String? badge;
}

/// Semantic roles for [AppSegmentedTabs] per brightness.
abstract final class _SegmentedTabsRoles {
  static const container = ThemedRole(
    dark: 'Surface Container/Lowest',
    light: 'Surface Container/High',
  );

  static const containerBorder = ThemedRole(
    dark: 'Outline/Variant',
    light: 'Outline/Variant',
  );

  static const activePill = ThemedRole(
    dark: 'Surface Container/High',
    light: 'Surface/Base',
  );

  static const activeForeground = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Emphasis',
  );

  static const inactiveForeground = ThemedRole(
    dark: 'On Surface/Muted',
    light: 'On Surface/Muted',
  );
}

/// Typography for [AppSegmentedTabs].
abstract final class _SegmentedTabsText {
  static final active = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 18 / 14,
      letterSpacing: -0.4,
    ),
  );

  static final inactive = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 18 / 14,
      letterSpacing: -0.4,
    ),
  );
}

/// A segmented pill tab bar for high-level page and category switching.
///
/// Implements Layer 1 Design System specifications from wireframes
/// (Figma nodes `1:1644`, `1:1645`, `1:4345`).
class AppSegmentedTabs extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AppSegmentedTabs({
    super.key,
    required this.elementId,
    this.runtimeLocator,
    required this.tabs,
    this.selectedIndex = 0,
    this.onChanged,
    this.height = 44.0,
    this.padding = const EdgeInsetsDirectional.all(4.0),
  }) : assert(
         tabs.length >= 2 && tabs.length <= 4,
         'AppSegmentedTabs requires between 2 and 4 tab items.',
       );

  /// Identity contract v1.1 identifier.
  final String elementId;

  /// Optional route identity scope override.
  final UiRuntimeLocator? runtimeLocator;

  /// List of tab definitions.
  final List<AppSegmentedTabItem> tabs;

  /// Index of the currently active tab (0-based).
  final int selectedIndex;

  /// Callback when a tab is selected.
  final ValueChanged<int>? onChanged;

  /// Minimum height of the segmented container.
  final double height;

  /// Internal padding around the tabs.
  final EdgeInsetsDirectional padding;

  @override
  Widget build(BuildContext context) {
    final containerColor = _SegmentedTabsRoles.container.resolve(context);
    final borderColor = _SegmentedTabsRoles.containerBorder
        .resolve(context)
        .withValues(alpha: 0.5);

    final List<Widget> tabWidgets = [];
    for (int i = 0; i < tabs.length; i++) {
      final tab = tabs[i];
      final isSelected = i == selectedIndex;

      final fgColor =
          (isSelected
                  ? _SegmentedTabsRoles.activeForeground
                  : _SegmentedTabsRoles.inactiveForeground)
              .resolve(context);

      final textStyle =
          (isSelected ? _SegmentedTabsText.active : _SegmentedTabsText.inactive)
              .copyWith(color: fgColor);

      final tabPill = AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? _SegmentedTabsRoles.activePill.resolve(context)
              : Colors.transparent,
          borderRadius: const BorderRadiusDirectional.all(Radius.circular(100)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (tab.icon != null) ...[
              IconTheme.merge(
                data: IconThemeData(size: 18, color: fgColor),
                child: tab.icon!.forControl(
                  isSelected ? AppIconStyle.fill : AppIconStyle.outline,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                tab.label,
                style: textStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (tab.badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 6,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: fgColor.withValues(alpha: 0.15),
                  borderRadius: const BorderRadiusDirectional.all(
                    Radius.circular(10),
                  ),
                ),
                child: Text(
                  tab.badge!,
                  style: textStyle.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      );

      tabWidgets.add(
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onChanged != null ? () => onChanged!(i) : null,
            child: tabPill,
          ),
        ),
      );
    }

    final bar = DecoratedBox(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: const BorderRadiusDirectional.all(Radius.circular(100)),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Padding(
        padding: padding,
        child: Row(mainAxisSize: MainAxisSize.max, children: tabWidgets),
      ),
    );

    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'tabs.segmented',
      structureRef: 'tabs.segmented',
      fileKey: '7BurKbCwclcabEGJ7cLcKz',
      variantId: '1:1644',
      componentSetId: null,
      rawSetName: 'Segmented Tabs',
      rawVariantName: tabs.length.toString(),
      variants: {
        'selectedIndex': selectedIndex.toString(),
        'tabCount': tabs.length.toString(),
        'hasIcons': tabs.any((t) => t.icon != null).toString(),
        'hasBadges': tabs.any((t) => t.badge != null).toString(),
      },
      declared: {
        'selectedIndex': selectedIndex,
        'tabLabels': tabs.map((t) => t.label).toList(),
      },
      resolved: const {'source': '1:1644'},
      status: 'provisional',
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: bar,
      ),
    );
  }
}
