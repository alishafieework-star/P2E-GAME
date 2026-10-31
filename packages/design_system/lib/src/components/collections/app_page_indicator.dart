import 'package:flutter/material.dart';

import '../../identity/element_identity.dart';
import '../../tokens/generated/collection_tokens.g.dart';

/// Provisional page dots. The shelf owns paging.
/// Source: detached Pagination 18457:13149 (D-101, D-102, R-100).
class AppPageIndicator extends StatelessWidget {
  const AppPageIndicator({
    super.key,
    required this.elementId,
    required this.count,
    required this.index,
    this.semanticLabel,
    this.runtimeLocator,
  }) : assert(count >= 1),
       assert(index >= 0 && index < count),
       assert(semanticLabel == null || semanticLabel != '');

  final String elementId;
  final int count, index;
  final String? semanticLabel;
  final UiRuntimeLocator? runtimeLocator;

  @override
  Widget build(BuildContext context) {
    final active = CollectionRoles.pageActive.resolve(context);
    final inactive = CollectionRoles.pageInactive.resolve(context);
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'collection.page-indicator',
      structureRef: 'collection.page-indicator',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: '18457:13149',
      componentSetId: null,
      rawSetName: 'Pagination',
      rawVariantName: 'detached',
      variants: {'index': '$index', 'count': '$count'},
      resolved: const {'source': '18457:13149'},
      declared: const {},
      child: Semantics(
        container: true,
        label: semanticLabel,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0)
                const SizedBox(width: CollectionTokens.pageIndicatorGap),
              _Dot(active: i == index, color: i == index ? active : inactive),
            ],
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active, required this.color});
  final bool active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = active
        ? CollectionTokens.pageIndicatorActive
        : CollectionTokens.pageIndicatorInactive;
    return IgnorePointer(
      key: ValueKey(
        active ? 'collection.page-dot.active' : 'collection.page-dot',
      ),
      child: SizedBox.square(
        dimension: CollectionTokens.pageIndicatorActive,
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: SizedBox.square(dimension: size),
          ),
        ),
      ),
    );
  }
}
