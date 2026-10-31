import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

import '../l10n/generated/viewer_localizations.dart';

/// Provisional collection primitives. Not a product screen.
class CollectionsGallery extends StatefulWidget {
  const CollectionsGallery({super.key});

  @override
  State<CollectionsGallery> createState() => _CollectionsGalleryState();
}

class _CollectionsGalleryState extends State<CollectionsGallery> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final strings = ViewerLocalizations.of(context);
    final tile = SkinTheme.of(context)
        .valuesFor(Theme.of(context).brightness)
        .color('Surface Container/High');
    return ListView(
      padding: const EdgeInsetsDirectional.all(12),
      children: [
        UiIdentityScope(
          routeName: 'gallery.collections',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSectionHeader(
                elementId: 'gallery.collections.header',
                title: strings.collectionsSampleTitle,
                actionLabel: strings.collectionsSampleAction,
                onAction: () {},
              ),
              const SizedBox(height: 12),
              AppSectionHeader(
                elementId: 'gallery.collections.split',
                lead: strings.collectionsSampleLead,
                subject: strings.collectionsSampleSubject,
                showMark: true,
                actionLabel: strings.collectionsSampleAction,
                actionChevron: false,
                onAction: () {},
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: AppShelf(
                  elementId: 'gallery.collections.scroll',
                  children: [
                    for (var index = 0; index < 4; index++)
                      SizedBox(width: 120, child: ColoredBox(color: tile)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: AppShelf(
                  elementId: 'gallery.collections.paged',
                  layout: AppShelfLayout.paged,
                  spacing: AppShelfSpacing.relaxed,
                  pageIndex: page,
                  onPageChanged: (value) => setState(() => page = value),
                  children: [
                    for (var index = 0; index < 3; index++)
                      ColoredBox(color: tile),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: AppPageIndicator(
                  elementId: 'gallery.collections.pages',
                  count: 3,
                  index: page,
                  semanticLabel: strings.collectionsPageLabel(page + 1, 3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
