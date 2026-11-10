import 'package:flutter/material.dart';

import '../../identity/element_identity.dart';
import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';

/// Semantic roles for [AppStickyActionBar] per brightness.
abstract final class _ActionBarRoles {
  static const background = ThemedRole(
    dark: 'Surface Container/High',
    light: 'Surface Container/Lowest',
  );

  static const topBorder = ThemedRole(
    dark: 'Outline/Variant',
    light: 'Outline/Variant',
  );

  static const summaryTitle = ThemedRole(
    dark: 'On Surface/Muted',
    light: 'On Surface/Muted',
  );

  static const summarySubtitle = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Emphasis',
  );
}

/// Typography for [AppStickyActionBar].
abstract final class _ActionBarText {
  static final summaryTitle = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: -0.3,
    ),
  );

  static final summarySubtitle = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 20 / 16,
      letterSpacing: -0.4,
    ),
  );
}

/// A bottom sticky bar housing primary/secondary actions and optional summary captions.
///
/// Implements Layer 1 Design System specifications from wireframes
/// (Figma nodes `1:3740`, `1:2001`, `1:2544`, `1:7706`).
class AppStickyActionBar extends StatelessWidget {
  const AppStickyActionBar({
    super.key,
    required this.elementId,
    this.runtimeLocator,
    required this.primaryAction,
    this.secondaryAction,
    this.summaryTitle,
    this.summarySubtitle,
    this.summaryWidget,
    this.padding = const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
    this.hasTopBorder = true,
    this.useSafeArea = true,
  });

  /// Identity contract v1.1 identifier.
  final String elementId;

  /// Optional route identity scope override.
  final UiRuntimeLocator? runtimeLocator;

  /// The primary action button (e.g. `AppButton`).
  final Widget primaryAction;

  /// Optional secondary action button (e.g. Cancel or Back).
  final Widget? secondaryAction;

  /// Optional caption displayed above the summary value (e.g. "Total Amount").
  final String? summaryTitle;

  /// Optional emphasized value displayed in the summary slot (e.g. "54,000 Toman").
  final String? summarySubtitle;

  /// Custom widget slot replacing [summaryTitle] and [summarySubtitle].
  final Widget? summaryWidget;

  /// Insets for the action bar content.
  final EdgeInsetsDirectional padding;

  /// Whether to render a top border divider line.
  final bool hasTopBorder;

  /// Whether to wrap the bottom in [SafeArea] for mobile home indicators.
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final hasSummary =
        summaryWidget != null ||
        summaryTitle != null ||
        summarySubtitle != null;
    final hasSecondary = secondaryAction != null;

    final Widget barContent;

    if (hasSummary) {
      final Widget summary =
          summaryWidget ??
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (summaryTitle != null)
                Text(
                  summaryTitle!,
                  style: _ActionBarText.summaryTitle.copyWith(
                    color: _ActionBarRoles.summaryTitle.resolve(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (summarySubtitle != null)
                Text(
                  summarySubtitle!,
                  style: _ActionBarText.summarySubtitle.copyWith(
                    color: _ActionBarRoles.summarySubtitle.resolve(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          );

      barContent = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: summary),
          const SizedBox(width: 16),
          if (hasSecondary) ...[
            Flexible(child: secondaryAction!),
            const SizedBox(width: 8),
          ],
          Flexible(child: primaryAction),
        ],
      );
    } else if (hasSecondary) {
      barContent = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: secondaryAction!),
          const SizedBox(width: 12),
          Expanded(child: primaryAction),
        ],
      );
    } else {
      barContent = SizedBox(width: double.infinity, child: primaryAction);
    }

    Widget bar = DecoratedBox(
      decoration: BoxDecoration(
        color: _ActionBarRoles.background.resolve(context),
        border: hasTopBorder
            ? Border(
                top: BorderSide(
                  color: _ActionBarRoles.topBorder.resolve(context),
                  width: 1.0,
                ),
              )
            : null,
      ),
      child: Padding(padding: padding, child: barContent),
    );

    if (useSafeArea) {
      bar = SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: bar,
      );
    }

    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'navigation.sticky-action-bar',
      structureRef: 'navigation.sticky-action-bar',
      fileKey: '7BurKbCwclcabEGJ7cLcKz',
      variantId: '1:3740',
      componentSetId: null,
      rawSetName: 'Sticky Action Bar',
      rawVariantName: hasSummary
          ? 'summary'
          : hasSecondary
          ? 'dual'
          : 'single',
      variants: {
        'hasSummary': hasSummary.toString(),
        'hasSecondary': hasSecondary.toString(),
        'hasTopBorder': hasTopBorder.toString(),
        'useSafeArea': useSafeArea.toString(),
      },
      declared: {
        'summaryTitle': summaryTitle,
        'summarySubtitle': summarySubtitle,
      },
      resolved: const {'source': '1:3740'},
      status: 'provisional',
      child: bar,
    );
  }
}
