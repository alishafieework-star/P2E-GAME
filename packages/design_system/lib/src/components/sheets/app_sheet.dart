import 'package:flutter/material.dart';

import '../../identity/element_identity.dart';
import '../../theme/skin_theme.dart';
import '../../tokens/generated/html_journey_tokens.g.dart';

/// Provisional sheet. Figma has no sheet component (D-140, R-004).
class AppSheet extends StatelessWidget {
  const AppSheet({
    super.key,
    required this.elementId,
    required this.runtimeLocator,
    required this.child,
  });

  final String elementId;
  final UiRuntimeLocator? runtimeLocator;
  final Widget child;

  static Future<T?> show<T>({
    required BuildContext context,
    required String elementId,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    final locator = UiIdentityScope.resolve(context);
    final scrim = HtmlJourneyTokens.launchBackground.withValues(alpha: 0.55);
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        barrierDismissible: barrierDismissible,
        barrierColor: scrim,
        transitionDuration: HtmlJourneyTokens.sheetEnter,
        reverseTransitionDuration: HtmlJourneyTokens.sheetExit,
        // The sheet is its own route, so its content needs its own scope.
        pageBuilder: (context, _, _) => UiIdentityScope(
          routeName: elementId,
          child: AppSheet(
            elementId: elementId,
            runtimeLocator: locator,
            child: child,
          ),
        ),
        transitionsBuilder: (context, animation, _, sheet) {
          if (MediaQuery.disableAnimationsOf(context)) return sheet;
          final curved = CurvedAnimation(
            parent: animation,
            curve: HtmlJourneyTokens.ease,
            reverseCurve: HtmlJourneyTokens.easeIn,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: sheet,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: runtimeLocator,
      componentId: 'sheet.app',
      structureRef: 'sheet.app',
      fileKey: '',
      variantId: null,
      componentSetId: null,
      rawSetName: 'App Sheet',
      rawVariantName: 'provisional',
      variants: const {'status': 'provisional'},
      declared: const {'source': 'html-prototype'},
      resolved: const {},
      status: 'provisional',
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: roles.surfaceContainerBase,
          borderRadius: const BorderRadiusDirectional.vertical(
            top: Radius.circular(HtmlJourneyTokens.sheetTopRadius),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.sizeOf(context).height *
                  HtmlJourneyTokens.shMaxFraction,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: HtmlJourneyTokens.shPadTop),
                  Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: roles.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const SizedBox(
                        width: HtmlJourneyTokens.shGrabW,
                        height: HtmlJourneyTokens.shGrabH,
                      ),
                    ),
                  ),
                  const SizedBox(height: HtmlJourneyTokens.shGap),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsetsDirectional.only(
                        start: HtmlJourneyTokens.shPadH,
                        end: HtmlJourneyTokens.shPadH,
                        bottom: HtmlJourneyTokens.shPadBottom,
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
