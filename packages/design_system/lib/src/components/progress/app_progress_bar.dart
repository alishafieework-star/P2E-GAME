import 'package:flutter/material.dart';

import '../../identity/element_identity.dart';
import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';

/// Heights for [AppProgressBar].
enum AppProgressHeight { sm, md, lg }

/// Color tones for [AppProgressBar].
enum AppProgressTone { primary, emerald, amber, teal, purple }

/// Semantic role mappings for [AppProgressBar] per brightness.
abstract final class _ProgressRoles {
  static ThemedRole fillFor(AppProgressTone tone) => switch (tone) {
    AppProgressTone.primary => const ThemedRole(
      dark: 'Primary/Pink',
      light: 'Primary/Pink',
    ),
    AppProgressTone.emerald => const ThemedRole(
      dark: 'Primary/Emerald',
      light: 'Primary/Emerald',
    ),
    AppProgressTone.amber => const ThemedRole(
      dark: 'On Surface/Emphasis',
      light: 'On Surface/Emphasis',
    ),
    AppProgressTone.teal => const ThemedRole(
      dark: 'Primary/Teal',
      light: 'Primary/Teal',
    ),
    AppProgressTone.purple => const ThemedRole(
      dark: 'Primary/Purple',
      light: 'Primary/Purple',
    ),
  };

  static const track = ThemedRole(
    dark: 'Surface Container/Highest',
    light: 'Surface Container/High',
  );

  static const headerLabel = ThemedRole(
    dark: 'On Surface/Base',
    light: 'On Surface/Base',
  );

  static const trailingLabel = ThemedRole(
    dark: 'On Surface/Emphasis',
    light: 'On Surface/Emphasis',
  );

  static const footerLabel = ThemedRole(
    dark: 'On Surface/Muted',
    light: 'On Surface/Muted',
  );
}

/// Typography for [AppProgressBar].
abstract final class _ProgressText {
  static final header = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: -0.3,
    ),
  );

  static final footer = BundledTypography.resolve(
    const TextStyle(
      fontFamily: 'Outfit',
      package: 'p2e_design_system',
      fontSize: 11,
      fontWeight: FontWeight.w400,
      height: 14 / 11,
      letterSpacing: -0.2,
    ),
  );
}

/// A directional progress bar with smooth animation and optional header/footer labels.
///
/// Implements Layer 1 Design System specifications from wireframes
/// (Figma nodes `1:7706`, `1:1981`, `1:4335`).
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.elementId,
    this.runtimeLocator,
    this.value,
    this.height = AppProgressHeight.md,
    this.tone = AppProgressTone.primary,
    this.label,
    this.trailingLabel,
    this.minLabel,
    this.maxLabel,
    this.animated = true,
  });

  /// Identity contract v1.1 identifier.
  final String elementId;

  /// Optional route identity scope override.
  final UiRuntimeLocator? runtimeLocator;

  /// Progress fraction between `0.0` and `1.0`.
  /// If null, an indeterminate animation is displayed.
  final double? value;

  /// Height scale for the track.
  final AppProgressHeight height;

  /// Semantic tone of the progress fill.
  final AppProgressTone tone;

  /// Optional leading label displayed above the track.
  final String? label;

  /// Optional trailing label displayed above the track (e.g. "75%" or "3/5").
  final String? trailingLabel;

  /// Optional min label displayed below the track (e.g. "0").
  final String? minLabel;

  /// Optional max label displayed below the track (e.g. "100").
  final String? maxLabel;

  /// Whether progress value transitions animate smoothly.
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final trackHeight = switch (height) {
      AppProgressHeight.sm => 6.0,
      AppProgressHeight.md => 8.0,
      AppProgressHeight.lg => 12.0,
    };
    final radius = trackHeight / 2;

    final fillColor = _ProgressRoles.fillFor(tone).resolve(context);
    final trackColor = _ProgressRoles.track.resolve(context);
    final isIndeterminate = value == null;

    final hasHeader = label != null || trailingLabel != null;
    final hasFooter = minLabel != null || maxLabel != null;

    final headerStyle = _ProgressText.header.copyWith(
      color: _ProgressRoles.headerLabel.resolve(context),
    );
    final trailingStyle = _ProgressText.header.copyWith(
      fontWeight: FontWeight.w600,
      color: _ProgressRoles.trailingLabel.resolve(context),
    );
    final footerStyle = _ProgressText.footer.copyWith(
      color: _ProgressRoles.footerLabel.resolve(context),
    );

    Widget buildTrack(double progress) {
      return ClipRRect(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(radius))
            .resolve(Directionality.of(context)),
        child: Container(
          height: trackHeight,
          width: double.infinity,
          color: trackColor,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(height: trackHeight, color: fillColor),
            ),
          ),
        ),
      );
    }

    final Widget trackWidget;
    if (isIndeterminate) {
      trackWidget = _IndeterminateProgressBar(
        height: trackHeight,
        radius: radius,
        fillColor: fillColor,
        trackColor: trackColor,
      );
    } else if (animated) {
      trackWidget = TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: value!.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        builder: (context, val, _) => buildTrack(val),
      );
    } else {
      trackWidget = buildTrack(value!.clamp(0.0, 1.0));
    }

    final columnChildren = <Widget>[];

    if (hasHeader) {
      columnChildren.add(
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (label != null)
                Text(label!, style: headerStyle, textAlign: TextAlign.start)
              else
                const SizedBox.shrink(),
              if (trailingLabel != null)
                Text(
                  trailingLabel!,
                  style: trailingStyle,
                  textAlign: TextAlign.end,
                ),
            ],
          ),
        ),
      );
    }

    columnChildren.add(trackWidget);

    if (hasFooter) {
      columnChildren.add(
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (minLabel != null)
                Text(minLabel!, style: footerStyle, textAlign: TextAlign.start)
              else
                const SizedBox.shrink(),
              if (maxLabel != null)
                Text(maxLabel!, style: footerStyle, textAlign: TextAlign.end),
            ],
          ),
        ),
      );
    }

    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'progress.bar',
      structureRef: 'progress.bar',
      fileKey: '7BurKbCwclcabEGJ7cLcKz',
      variantId: '1:7706',
      componentSetId: null,
      rawSetName: 'Progress Bar',
      rawVariantName: tone.name,
      variants: {
        'height': height.name,
        'tone': tone.name,
        'hasHeader': hasHeader.toString(),
        'hasFooter': hasFooter.toString(),
        'isIndeterminate': isIndeterminate.toString(),
      },
      declared: {
        'value': value,
        'label': label,
        'trailingLabel': trailingLabel,
      },
      resolved: {'source': '1:7706', 'progress': value},
      status: 'provisional',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren,
      ),
    );
  }
}

class _IndeterminateProgressBar extends StatefulWidget {
  const _IndeterminateProgressBar({
    required this.height,
    required this.radius,
    required this.fillColor,
    required this.trackColor,
  });

  final double height;
  final double radius;
  final Color fillColor;
  final Color trackColor;

  @override
  State<_IndeterminateProgressBar> createState() =>
      _IndeterminateProgressBarState();
}

class _IndeterminateProgressBarState extends State<_IndeterminateProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animValue = _controller.value;
        // Directional sliding span: from -0.3 to 1.0
        final startFactor = (animValue * 1.4 - 0.3).clamp(0.0, 1.0);
        final endFactor = (animValue * 1.4).clamp(0.0, 1.0);
        final widthFactor = (endFactor - startFactor).clamp(0.0, 1.0);

        return ClipRRect(
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(widget.radius),
          ).resolve(Directionality.of(context)),
          child: Container(
            height: widget.height,
            width: double.infinity,
            color: widget.trackColor,
            child: Align(
              alignment: AlignmentDirectional(-1.0 + startFactor * 2.0, 0.0),
              child: FractionallySizedBox(
                widthFactor: widthFactor,
                child: Container(
                  height: widget.height,
                  color: widget.fillColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
