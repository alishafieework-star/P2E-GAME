import 'package:flutter/material.dart';

import '../../icons/app_icon.dart';
import '../../identity/element_identity.dart';
import '../../interaction/press_action.dart';
import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';
import '../../tokens/button_motion.dart';

/// Semantic status types for [AppStatusChip].
enum AppStatusType { success, error, warning, info, live, pending, neutral }

/// Visual appearance treatments for [AppStatusChip].
enum AppStatusAppearance { subtle, outlined, filled }

/// Size variants for [AppStatusChip].
enum AppStatusSize { small, medium }

/// Roles mapped to semantic statuses per brightness.
abstract final class _StatusRoles {
  static (ThemedRole fg, ThemedRole bg) rolesFor(AppStatusType type) =>
      switch (type) {
        AppStatusType.success => const (
          ThemedRole(dark: 'Primary/Emerald', light: 'Primary/Emerald'),
          ThemedRole(dark: 'Countainer/Emerald', light: 'Countainer/Emerald'),
        ),
        AppStatusType.error => const (
          ThemedRole(
            dark: 'Actions/Error/On Surface',
            light: 'Actions/Error/On Surface',
          ),
          ThemedRole(
            dark: 'Actions/Error/On Container',
            light: 'Actions/Error/On Container',
          ),
        ),
        AppStatusType.warning => const (
          ThemedRole(dark: 'On Surface/Emphasis', light: 'On Surface/Emphasis'),
          ThemedRole(dark: 'Countainer/Purple', light: 'Countainer/Purple'),
        ),
        AppStatusType.info => const (
          ThemedRole(dark: 'Primary/Teal', light: 'Primary/Teal'),
          ThemedRole(dark: 'Countainer/Teal', light: 'Countainer/Teal'),
        ),
        AppStatusType.live => const (
          ThemedRole(dark: 'Primary/Emerald', light: 'Primary/Emerald'),
          ThemedRole(dark: 'Countainer/Emerald', light: 'Countainer/Emerald'),
        ),
        AppStatusType.pending => const (
          ThemedRole(dark: 'On Surface/Base', light: 'On Surface/Base'),
          ThemedRole(
            dark: 'Surface Container/Base',
            light: 'Surface Container/Base',
          ),
        ),
        AppStatusType.neutral => const (
          ThemedRole(dark: 'On Surface/Muted', light: 'On Surface/Muted'),
          ThemedRole(
            dark: 'Surface Container/High',
            light: 'Surface Container/High',
          ),
        ),
      };
}

/// Typography for [AppStatusChip].
abstract final class _StatusText {
  static final small = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 14 / 11,
      letterSpacing: -0.3,
    ),
  );

  static final medium = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 16 / 13,
      letterSpacing: -0.4,
    ),
  );
}

/// A semantic badge / chip displaying entity and system status.
///
/// Implements Layer 1 Design System specifications from wireframes
/// (Figma nodes `1:2263`, `1:2273`, `1:2296`, `1:2308`, `1:2727`, `1:2741`, `1:2951`, `1:4363`).
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.elementId,
    this.runtimeLocator,
    required this.label,
    required this.status,
    this.appearance = AppStatusAppearance.subtle,
    this.size = AppStatusSize.small,
    this.hasDot,
    this.leadingIcon,
    this.onTap,
  });

  /// Identity contract v1.1 identifier.
  final String elementId;

  /// Optional route identity scope override.
  final UiRuntimeLocator? runtimeLocator;

  /// The text label displayed inside the status chip.
  final String label;

  /// The semantic status category.
  final AppStatusType status;

  /// The surface appearance treatment.
  final AppStatusAppearance appearance;

  /// Size variant determining height, padding, and text metrics.
  final AppStatusSize size;

  /// Whether to display a status dot indicator at the start.
  /// If null, defaults to `true` for [AppStatusType.live] and `false` otherwise.
  final bool? hasDot;

  /// Optional leading icon in start position.
  final AppIcon? leadingIcon;

  /// Optional interactive tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final showDot = hasDot ?? (status == AppStatusType.live);
    final isSmall = size == AppStatusSize.small;
    final (fgRole, bgRole) = _StatusRoles.rolesFor(status);

    final resolvedFg = fgRole.resolve(context);
    final resolvedBg = bgRole.resolve(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor;
    final Color foregroundColor;
    final BorderSide? border;

    switch (appearance) {
      case AppStatusAppearance.subtle:
        backgroundColor = resolvedBg;
        foregroundColor = resolvedFg;
        border = null;
        break;
      case AppStatusAppearance.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = resolvedFg;
        border = BorderSide(color: resolvedFg, width: 1.0);
        break;
      case AppStatusAppearance.filled:
        backgroundColor = resolvedFg;
        foregroundColor = isDark ? Colors.black : Colors.white;
        border = null;
        break;
    }

    final hPadding = isSmall ? 8.0 : 10.0;
    final vPadding = isSmall ? 3.0 : 5.0;
    final gap = isSmall ? 4.0 : 6.0;
    final dotSize = isSmall ? 6.0 : 8.0;
    final iconSize = isSmall ? 12.0 : 14.0;

    final textStyle = (isSmall ? _StatusText.small : _StatusText.medium)
        .copyWith(color: foregroundColor);

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showDot) ...[
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: foregroundColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: gap),
        ] else if (leadingIcon != null) ...[
          IconTheme.merge(
            data: IconThemeData(size: iconSize, color: foregroundColor),
            child: leadingIcon!.forControl(AppIconStyle.fill),
          ),
          SizedBox(width: gap),
        ],
        Text(
          label,
          style: textStyle,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    final visualPill = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadiusDirectional.all(Radius.circular(100)),
        border: border != null ? Border.fromBorderSide(border) : null,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: hPadding,
          vertical: vPadding,
        ),
        child: content,
      ),
    );

    final Widget childWidget;
    if (onTap != null) {
      childWidget = ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
        child: Center(
          child: PressAction(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder(),
            ),
            pressedScale: ButtonMotion.pressedScale,
            child: visualPill,
          ),
        ),
      );
    } else {
      childWidget = visualPill;
    }

    final variantFigmaId = switch (status) {
      AppStatusType.success => '1:2263',
      AppStatusType.error => '1:2296',
      AppStatusType.warning => '1:2273',
      AppStatusType.pending => '1:2308',
      AppStatusType.neutral => '1:2951',
      AppStatusType.info => '1:2741',
      AppStatusType.live => '1:4363',
    };

    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'badge.status-chip',
      structureRef: 'badge.status-chip',
      fileKey: '7BurKbCwclcabEGJ7cLcKz',
      variantId: variantFigmaId,
      componentSetId: null,
      rawSetName: 'Status Badge',
      rawVariantName: status.name,
      variants: {
        'status': status.name,
        'appearance': appearance.name,
        'size': size.name,
        'hasDot': showDot.toString(),
        'hasIcon': (leadingIcon != null).toString(),
      },
      declared: {'label': label},
      resolved: {'source': variantFigmaId},
      status: 'provisional',
      child: childWidget,
    );
  }
}
