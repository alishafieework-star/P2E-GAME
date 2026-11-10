import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Interactive gallery for [AppSegmentedTabs].
class TabsGallery extends StatefulWidget {
  const TabsGallery({super.key});

  @override
  State<TabsGallery> createState() => _TabsGalleryState();
}

class _TabsGalleryState extends State<TabsGallery> {
  int tabIndex1 = 0;
  int tabIndex2 = 1;
  int tabIndex3 = 0;

  @override
  Widget build(BuildContext context) {
    final isPersian = Directionality.of(context) == TextDirection.rtl;

    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        UiIdentityScope(
          routeName: 'gallery.tabs',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSectionHeader(
                elementId: 'gallery.tabs.title-2',
                title: isPersian
                    ? 'تب‌های دوگانه (شاپ: سکه‌ها و جوایز)'
                    : 'Dual Segmented Tabs (Shop: Coins & Rewards)',
              ),
              const SizedBox(height: 12),
              AppSegmentedTabs(
                elementId: 'gallery.tabs.demo-2',
                selectedIndex: tabIndex1,
                onChanged: (idx) => setState(() => tabIndex1 = idx),
                tabs: [
                  AppSegmentedTabItem(
                    label: isPersian ? 'سکه‌ها' : 'Coins',
                    badge: isPersian ? 'ویژه' : 'Hot',
                  ),
                  AppSegmentedTabItem(
                    label: isPersian ? 'جوایز و بسته‌ها' : 'Rewards',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  isPersian
                      ? 'تب فعال: ${tabIndex1 == 0 ? "بخش سکه‌ها" : "بخش جوایز"}'
                      : 'Active: ${tabIndex1 == 0 ? "Coins Store" : "Rewards Store"}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AppSectionHeader(
                elementId: 'gallery.tabs.title-3',
                title: isPersian
                    ? 'تب‌های سه‌گانه (لیدربورد: رتبه‌بندی)'
                    : 'Triple Segmented Tabs (Leaderboard)',
              ),
              const SizedBox(height: 12),
              AppSegmentedTabs(
                elementId: 'gallery.tabs.demo-3',
                selectedIndex: tabIndex2,
                onChanged: (idx) => setState(() => tabIndex2 = idx),
                tabs: [
                  AppSegmentedTabItem(
                    label: isPersian ? 'کل کاربران' : 'Overall',
                  ),
                  AppSegmentedTabItem(
                    label: isPersian ? 'بازی‌های شما' : 'Your Games',
                    badge: '5',
                  ),
                  AppSegmentedTabItem(
                    label: isPersian ? 'لیگ برتر' : 'Top League',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AppSectionHeader(
                elementId: 'gallery.tabs.title-4',
                title: isPersian
                    ? 'تب‌های چهارگانه بازه زمانی (Periods)'
                    : '4-Segment Period Switcher',
              ),
              const SizedBox(height: 12),
              AppSegmentedTabs(
                elementId: 'gallery.tabs.demo-4',
                selectedIndex: tabIndex3,
                onChanged: (idx) => setState(() => tabIndex3 = idx),
                tabs: [
                  AppSegmentedTabItem(label: isPersian ? 'امروز' : 'Today'),
                  AppSegmentedTabItem(label: isPersian ? 'این هفته' : 'Week'),
                  AppSegmentedTabItem(label: isPersian ? 'این ماه' : 'Month'),
                  AppSegmentedTabItem(label: isPersian ? 'همیشه' : 'All Time'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
