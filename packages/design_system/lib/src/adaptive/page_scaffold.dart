import 'package:flutter/material.dart';

import '../identity/element_identity.dart';
import '../theme/skin_theme.dart';
import '../tokens/generated/adaptive_tokens.g.dart';
import 'page_motion.dart';
import 'size_class.dart';

enum PageScaffoldLayout { scrolling, viewport }

/// Provisional engineering scaffold, without navigation chrome (D-039).
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.elementId,
    required this.child,
    this.runtimeLocator,
    this.layout = PageScaffoldLayout.scrolling,
    this.appBar,
  });
  final String elementId;
  final UiRuntimeLocator? runtimeLocator;
  final Widget child;
  final PreferredSizeWidget? appBar;

  /// D-056: bounded viewport for edge-to-edge hero and keyboard-pinned actions.
  /// The default retains the original SafeArea/scroll/content-cap behavior.
  final PageScaffoldLayout layout;
  @override
  Widget build(BuildContext context) {
    final sizeClass = SizeClass.of(context);
    final motion = PageMotionScope.maybeOf(context);
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'layout.page-scaffold',
      structureRef: 'layout.page-scaffold',
      fileKey: '',
      variantId: null,
      componentSetId: null,
      rawSetName: '',
      rawVariantName: '',
      variants: {
        'sizeClass': sizeClass.name,
        if (layout == PageScaffoldLayout.viewport) 'layout': layout.name,
      },
      resolved: {'sizeClass': sizeClass.name},
      declared: const {},
      child: Scaffold(
        appBar: appBar == null || motion == null
            ? appBar
            : PreferredSize(
                preferredSize: appBar!.preferredSize,
                child: PageBarMotion(child: appBar!),
              ),
        // D-145: while a route moves, the page below must stay visible.
        backgroundColor: motion != null
            ? const Color(0x00000000)
            : layout == PageScaffoldLayout.viewport
            ? SkinTheme.of(context)
                  .valuesFor(Theme.of(context).brightness)
                  .color('Surface/Base')
            : null,
        resizeToAvoidBottomInset: true,
        body: PageBodyMotion(
          child: layout == PageScaffoldLayout.viewport
              ? child
              : SafeArea(
                  top: appBar == null,
                  child: Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: sizeClass == SizeClass.compact
                            ? double.infinity
                            : AdaptiveTokens.contentMaxWidth,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(child: child),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
