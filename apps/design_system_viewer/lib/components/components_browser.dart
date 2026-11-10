import 'package:flutter/material.dart';

import '../app_bars/app_bar_browser.dart';
import '../navigation/navigation_browser.dart';
import '../inspection/inspection_record.dart';
import '../l10n/generated/viewer_localizations.dart';
import 'action_bar_gallery.dart';
import 'chips_gallery.dart';
import 'collections_gallery.dart';
import 'key_value_gallery.dart';
import 'page_scaffold_gallery.dart';
import 'progress_gallery.dart';
import 'tabs_gallery.dart';

enum _Category {
  chips,
  progress,
  tabs,
  keyValue,
  actionBars,
  collections,
  appBar,
  navigation,
  adaptive,
}

class ComponentsBrowser extends StatefulWidget {
  const ComponentsBrowser({
    super.key,
    required this.selected,
    required this.onInspect,
  });

  final String? selected;
  final ValueChanged<InspectionRecord?> onInspect;

  @override
  State<ComponentsBrowser> createState() => _ComponentsBrowserState();
}

class _ComponentsBrowserState extends State<ComponentsBrowser> {
  _Category category = _Category.appBar;

  @override
  Widget build(BuildContext context) {
    final l = ViewerLocalizations.of(context);
    final isPersian = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                key: const ValueKey('components-chips'),
                label: Text(
                  isPersian ? 'فیلترها و بج‌های وضعیت' : 'Chips & Badges',
                ),
                selected: category == _Category.chips,
                onSelected: (_) {
                  setState(() => category = _Category.chips);
                  widget.onInspect(null);
                },
              ),
              ChoiceChip(
                key: const ValueKey('components-progress'),
                label: Text(isPersian ? 'نوارهای پیشرفت' : 'Progress Bars'),
                selected: category == _Category.progress,
                onSelected: (_) {
                  setState(() => category = _Category.progress);
                  widget.onInspect(null);
                },
              ),
              ChoiceChip(
                key: const ValueKey('components-tabs'),
                label: Text(isPersian ? 'تب‌های کپسولی' : 'Segmented Tabs'),
                selected: category == _Category.tabs,
                onSelected: (_) {
                  setState(() => category = _Category.tabs);
                  widget.onInspect(null);
                },
              ),
              ChoiceChip(
                key: const ValueKey('components-key-value'),
                label: Text(
                  isPersian ? 'سطرهای داده و فاکتور' : 'Data & Key-Value',
                ),
                selected: category == _Category.keyValue,
                onSelected: (_) {
                  setState(() => category = _Category.keyValue);
                  widget.onInspect(null);
                },
              ),
              ChoiceChip(
                key: const ValueKey('components-action-bars'),
                label: Text(
                  isPersian ? 'نوارهای اقدام چسبان' : 'Sticky Action Bars',
                ),
                selected: category == _Category.actionBars,
                onSelected: (_) {
                  setState(() => category = _Category.actionBars);
                  widget.onInspect(null);
                },
              ),
              ChoiceChip(
                key: const ValueKey('components-collections'),
                label: Text(l.collectionsTitle),
                selected: category == _Category.collections,
                onSelected: (_) {
                  setState(() => category = _Category.collections);
                  widget.onInspect(null);
                },
              ),
              ChoiceChip(
                key: const ValueKey('components-app-bar'),
                label: Text(l.appBarTitle),
                selected: category == _Category.appBar,
                onSelected: (_) {
                  setState(() => category = _Category.appBar);
                  widget.onInspect(null);
                },
              ),
              ChoiceChip(
                key: const ValueKey('components-navigation'),
                label: Text(l.navTitle),
                selected: category == _Category.navigation,
                onSelected: (_) {
                  setState(() => category = _Category.navigation);
                  widget.onInspect(null);
                },
              ),
              ChoiceChip(
                key: const ValueKey('components-adaptive'),
                label: Text(l.pageScaffoldTitle),
                selected: category == _Category.adaptive,
                onSelected: (_) {
                  setState(() => category = _Category.adaptive);
                  widget.onInspect(null);
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: switch (category) {
            _Category.chips => const ChipsGallery(),
            _Category.progress => const ProgressGallery(),
            _Category.tabs => const TabsGallery(),
            _Category.keyValue => const KeyValueGallery(),
            _Category.actionBars => const ActionBarGallery(),
            _Category.collections => const CollectionsGallery(),
            _Category.navigation => NavigationBrowser(
              selected: widget.selected,
              onInspect: widget.onInspect,
            ),
            _Category.appBar => AppBarBrowser(
              selected: widget.selected,
              onInspect: widget.onInspect,
            ),
            _Category.adaptive => const PageScaffoldGallery(),
          },
        ),
      ],
    );
  }
}
