import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Interactive gallery for [AppProgressBar].
class ProgressGallery extends StatefulWidget {
  const ProgressGallery({super.key});

  @override
  State<ProgressGallery> createState() => _ProgressGalleryState();
}

class _ProgressGalleryState extends State<ProgressGallery> {
  double currentProgress = 0.65;
  AppProgressTone selectedTone = AppProgressTone.primary;

  @override
  Widget build(BuildContext context) {
    final isPersian = Directionality.of(context) == TextDirection.rtl;

    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        UiIdentityScope(
          routeName: 'gallery.progress',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSectionHeader(
                elementId: 'gallery.progress.header',
                title: isPersian
                    ? 'نوار پیشرفت تعاملی'
                    : 'Interactive Progress Bar',
                actionLabel: isPersian ? 'تکمیل ۱۰۰٪' : 'Set 100%',
                actionChevron: false,
                onAction: () => setState(() => currentProgress = 1.0),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: SkinTheme.of(context)
                      .valuesFor(Theme.of(context).brightness)
                      .color('Surface Container/Base'),
                  borderRadius: const BorderRadiusDirectional.all(
                    Radius.circular(16),
                  ),
                  border: Border.all(
                    color: SkinTheme.of(context)
                        .valuesFor(Theme.of(context).brightness)
                        .color('Outline/Variant'),
                  ),
                ),
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isPersian
                              ? 'کنترل مقدار درصد:'
                              : 'Control Progress Value:',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${(currentProgress * 100).toInt()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: currentProgress,
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      onChanged: (val) => setState(() => currentProgress = val),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isPersian
                          ? 'انتخاب رنگ سمانتیک (Tone):'
                          : 'Select Semantic Tone:',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final tone in AppProgressTone.values)
                          ChoiceChip(
                            label: Text(tone.name.toUpperCase()),
                            selected: selectedTone == tone,
                            onSelected: (_) =>
                                setState(() => selectedTone = tone),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AppSectionHeader(
                elementId: 'gallery.progress.sizes-title',
                title: isPersian
                    ? 'مقایسه اندازه‌های ۳ گانه'
                    : 'Comparison of 3 Heights',
              ),
              const SizedBox(height: 16),
              AppProgressBar(
                elementId: 'gallery.progress.size-lg',
                value: currentProgress,
                height: AppProgressHeight.lg,
                tone: selectedTone,
                label: isPersian
                    ? 'اندازه بزرگ (12pt) - کارت قهرمان یا سقف اعتبار'
                    : 'Large Height (12pt) - Hero Card or Limit',
                trailingLabel: '${(currentProgress * 100).toInt()}%',
                minLabel: '0 Toman',
                maxLabel: '100,000 Toman',
              ),
              const SizedBox(height: 24),
              AppProgressBar(
                elementId: 'gallery.progress.size-md',
                value: currentProgress,
                height: AppProgressHeight.md,
                tone: selectedTone,
                label: isPersian
                    ? 'اندازه استاندارد (8pt) - پیشرفت ماموریت و تسک‌ها'
                    : 'Medium Height (8pt) - Quest & Task Progress',
                trailingLabel: '3 of 5 completed',
              ),
              const SizedBox(height: 24),
              AppProgressBar(
                elementId: 'gallery.progress.size-sm',
                value: currentProgress,
                height: AppProgressHeight.sm,
                tone: selectedTone,
                label: isPersian
                    ? 'اندازه فشرده (6pt) - سطرهای جدول و لیست فشرده'
                    : 'Small Height (6pt) - Compact Table or List Row',
              ),
              const SizedBox(height: 32),
              AppSectionHeader(
                elementId: 'gallery.progress.indeterminate-title',
                title: isPersian
                    ? 'حالت لودینگ نامعین (Indeterminate)'
                    : 'Indeterminate Loading Track',
              ),
              const SizedBox(height: 16),
              const AppProgressBar(
                elementId: 'gallery.progress.indeterminate-demo',
                value: null,
                label: 'در حال همگام‌سازی امتیازات...',
                tone: AppProgressTone.teal,
                height: AppProgressHeight.md,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
