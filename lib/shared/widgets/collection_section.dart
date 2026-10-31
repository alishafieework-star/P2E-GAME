import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Product section layout shared by games and missions: a header, full-bleed
/// content and an optional centered footer (page indicator). Source: detached
/// section frame `18533:4266` (D-101: only the header, page indicator and
/// shelf are Design System primitives).
class CollectionSection extends StatelessWidget {
  const CollectionSection({
    super.key,
    required this.elementId,
    required this.header,
    required this.content,
    this.footer,
    this.runtimeLocator,
  });

  final String elementId;
  final Widget header, content;
  final Widget? footer;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) => ElementIdentity(
    elementId: elementId,
    runtimeLocator: UiIdentityScope.resolve(context, override: runtimeLocator),
    componentId: 'collection.section',
    structureRef: 'collection.section',
    fileKey: '7PGTHT5CQzbTsWZQnPIQce',
    variantId: '18533:4266',
    componentSetId: null,
    rawSetName: 'Section',
    rawVariantName: footer == null ? 'plain' : 'paged',
    variants: {'footer': (footer != null).toString()},
    resolved: const {
      'padding': CollectionTokens.sectionPadding,
      'gap': CollectionTokens.sectionContentGap,
    },
    declared: const {},
    child: Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: CollectionTokens.sectionPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: CollectionTokens.sectionPadding,
            ),
            child: header,
          ),
          const SizedBox(height: CollectionTokens.sectionContentGap),
          content,
          if (footer != null) ...[
            const SizedBox(height: CollectionTokens.sectionContentGap),
            Center(child: footer),
          ],
        ],
      ),
    ),
  );
}
