import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Interactive gallery for [AppFilterChip], [AppFilterBar], and [AppStatusChip].
class ChipsGallery extends StatefulWidget {
  const ChipsGallery({super.key});

  @override
  State<ChipsGallery> createState() => _ChipsGalleryState();
}

class _ChipsGalleryState extends State<ChipsGallery> {
  int selectedCategory = 0;
  bool isSmall = false;
  int statusTaps = 0;

  @override
  Widget build(BuildContext context) {
    final isPersian = Directionality.of(context) == TextDirection.rtl;

    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        UiIdentityScope(
          routeName: 'gallery.chips',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSectionHeader(
                elementId: 'gallery.chips.filter-title',
                title: isPersian
                    ? 'چیپ‌های فیلتر و ردیف فیلتر'
                    : 'Filter Chips & Filter Bar',
                actionLabel: isSmall
                    ? (isPersian ? 'اندازه متوسط' : 'Medium Size')
                    : (isPersian ? 'اندازه کوچک' : 'Small Size'),
                actionChevron: false,
                onAction: () => setState(() => isSmall = !isSmall),
              ),
              const SizedBox(height: 12),
              AppFilterBar(
                elementId: 'gallery.chips.filter-bar-interactive',
                padding: EdgeInsetsDirectional.zero,
                chips: [
                  AppFilterChip(
                    elementId: 'gallery.filter.all',
                    label: isPersian ? 'همه موارد' : 'All Items',
                    count: 32,
                    size: isSmall
                        ? AppFilterChipSize.small
                        : AppFilterChipSize.medium,
                    selected: selectedCategory == 0,
                    onSelected: (_) => setState(() => selectedCategory = 0),
                  ),
                  AppFilterChip(
                    elementId: 'gallery.filter.popular',
                    label: isPersian ? 'محبوب‌ترین‌ها' : 'Most Popular',
                    size: isSmall
                        ? AppFilterChipSize.small
                        : AppFilterChipSize.medium,
                    selected: selectedCategory == 1,
                    onSelected: (_) => setState(() => selectedCategory = 1),
                  ),
                  AppFilterChip(
                    elementId: 'gallery.filter.quests',
                    label: isPersian ? 'ماموریت‌های روزانه' : 'Daily Quests',
                    count: 5,
                    size: isSmall
                        ? AppFilterChipSize.small
                        : AppFilterChipSize.medium,
                    selected: selectedCategory == 2,
                    onSelected: (_) => setState(() => selectedCategory = 2),
                  ),
                  AppFilterChip(
                    elementId: 'gallery.filter.tournaments',
                    label: isPersian ? 'تورنومنت‌ها' : 'Tournaments',
                    size: isSmall
                        ? AppFilterChipSize.small
                        : AppFilterChipSize.medium,
                    selected: selectedCategory == 3,
                    onSelected: (_) => setState(() => selectedCategory = 3),
                  ),
                  AppFilterChip(
                    elementId: 'gallery.filter.disabled',
                    label: isPersian ? 'غیرفعال' : 'Disabled',
                    size: isSmall
                        ? AppFilterChipSize.small
                        : AppFilterChipSize.medium,
                    enabled: false,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AppSectionHeader(
                elementId: 'gallery.chips.status-title',
                title: isPersian
                    ? 'بج‌های سمانتیک وضعیت (۷ حالت)'
                    : 'Semantic Status Badges (7 States)',
                actionLabel: statusTaps > 0
                    ? (isPersian ? 'کلیک‌ها: $statusTaps' : 'Taps: $statusTaps')
                    : null,
                actionChevron: false,
                onAction: () => setState(() => statusTaps = 0),
              ),
              const SizedBox(height: 16),
              Text(
                isPersian
                    ? 'حالت محو / کانتینردار (Subtle Appearance):'
                    : 'Subtle Container Appearance:',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppStatusChip(
                    elementId: 'gallery.status.live',
                    label: isPersian ? 'زنده' : 'Live',
                    status: AppStatusType.live,
                    onTap: () => setState(() => statusTaps++),
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.success',
                    label: isPersian ? 'پرداخت موفق' : 'Confirmed',
                    status: AppStatusType.success,
                    onTap: () => setState(() => statusTaps++),
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.error',
                    label: isPersian ? 'ناموفق' : 'Failed',
                    status: AppStatusType.error,
                    onTap: () => setState(() => statusTaps++),
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.warning',
                    label: isPersian ? 'مرجوع شده' : 'Refunded',
                    status: AppStatusType.warning,
                    onTap: () => setState(() => statusTaps++),
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.info',
                    label: isPersian ? 'تیکت باز' : 'Open Ticket',
                    status: AppStatusType.info,
                    onTap: () => setState(() => statusTaps++),
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.pending',
                    label: isPersian ? 'در حال فعال‌سازی' : 'Activating',
                    status: AppStatusType.pending,
                    onTap: () => setState(() => statusTaps++),
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.neutral',
                    label: isPersian ? 'بسته شده' : 'Closed',
                    status: AppStatusType.neutral,
                    onTap: () => setState(() => statusTaps++),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                isPersian
                    ? 'حالت حاشیه‌دار (Outlined Appearance):'
                    : 'Outlined Appearance:',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppStatusChip(
                    elementId: 'gallery.status.outline-live',
                    label: isPersian ? 'زنده' : 'Live',
                    status: AppStatusType.live,
                    appearance: AppStatusAppearance.outlined,
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.outline-success',
                    label: isPersian ? 'تکمیل شده' : 'Success',
                    status: AppStatusType.success,
                    appearance: AppStatusAppearance.outlined,
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.outline-error',
                    label: isPersian ? 'لغو شده' : 'Cancelled',
                    status: AppStatusType.error,
                    appearance: AppStatusAppearance.outlined,
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.outline-warning',
                    label: isPersian ? 'در حال داوری' : 'Reviewing',
                    status: AppStatusType.warning,
                    appearance: AppStatusAppearance.outlined,
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.outline-info',
                    label: isPersian ? 'اطلاعات' : 'Info',
                    status: AppStatusType.info,
                    appearance: AppStatusAppearance.outlined,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                isPersian
                    ? 'حالت توپُر و اندازه متوسط (Filled & Medium Size):'
                    : 'Filled Appearance & Medium Size:',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppStatusChip(
                    elementId: 'gallery.status.filled-success',
                    label: isPersian ? 'تایید نهایی' : 'Approved',
                    status: AppStatusType.success,
                    appearance: AppStatusAppearance.filled,
                    size: AppStatusSize.medium,
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.filled-error',
                    label: isPersian ? 'رد شده' : 'Rejected',
                    status: AppStatusType.error,
                    appearance: AppStatusAppearance.filled,
                    size: AppStatusSize.medium,
                  ),
                  AppStatusChip(
                    elementId: 'gallery.status.filled-info',
                    label: isPersian ? 'جدید' : 'New',
                    status: AppStatusType.info,
                    appearance: AppStatusAppearance.filled,
                    size: AppStatusSize.medium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
