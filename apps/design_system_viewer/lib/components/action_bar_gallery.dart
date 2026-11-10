import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Interactive gallery for [AppStickyActionBar].
class ActionBarGallery extends StatefulWidget {
  const ActionBarGallery({super.key});

  @override
  State<ActionBarGallery> createState() => _ActionBarGalleryState();
}

class _ActionBarGalleryState extends State<ActionBarGallery> {
  String lastAction = '';

  @override
  Widget build(BuildContext context) {
    final isPersian = Directionality.of(context) == TextDirection.rtl;

    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        UiIdentityScope(
          routeName: 'gallery.action-bar',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSectionHeader(
                elementId: 'gallery.action-bar.title',
                title: isPersian
                    ? 'نوارهای اقدام چسبان پایین صفحه (Sticky Action Bars)'
                    : 'Sticky Action Bars (Fixed Bottom CTAs)',
                actionLabel: lastAction.isNotEmpty ? lastAction : null,
                actionChevron: false,
              ),
              const SizedBox(height: 16),
              Text(
                isPersian
                    ? '۱. حالت تک‌دکمه تمام‌عرض (Single Full-width CTA):'
                    : '1. Single Full-width CTA Mode:',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadiusDirectional.all(
                    Radius.circular(16),
                  ),
                  border: Border.all(
                    color: SkinTheme.of(context)
                        .valuesFor(Theme.of(context).brightness)
                        .color('Outline/Variant'),
                  ),
                ),
                child: AppStickyActionBar(
                  elementId: 'gallery.bar.single-demo',
                  useSafeArea: false,
                  hasTopBorder: false,
                  primaryAction: AppButton(
                    elementId: 'gallery.btn.submit-ticket',
                    label: isPersian
                        ? 'ارسال تیکت پشتیبانی'
                        : 'Submit Support Ticket',
                    size: AppButtonSize.large,
                    onPressed: () => setState(
                      () => lastAction = isPersian
                          ? 'تیکت ارسال شد'
                          : 'Ticket Submitted!',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                isPersian
                    ? '۲. حالت دکمه‌های دوقلو (Dual Buttons - Primary & Secondary):'
                    : '2. Dual Buttons Mode (Primary & Secondary):',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadiusDirectional.all(
                    Radius.circular(16),
                  ),
                  border: Border.all(
                    color: SkinTheme.of(context)
                        .valuesFor(Theme.of(context).brightness)
                        .color('Outline/Variant'),
                  ),
                ),
                child: AppStickyActionBar(
                  elementId: 'gallery.bar.dual-demo',
                  useSafeArea: false,
                  hasTopBorder: false,
                  secondaryAction: AppButton(
                    elementId: 'gallery.btn.cancel-dual',
                    label: isPersian ? 'انصراف' : 'Cancel',
                    type: AppButtonType.outlined,
                    onPressed: () => setState(
                      () => lastAction = isPersian
                          ? 'انصراف انتخاب شد'
                          : 'Cancelled!',
                    ),
                  ),
                  primaryAction: AppButton(
                    elementId: 'gallery.btn.confirm-dual',
                    label: isPersian ? 'تایید و ادامه' : 'Confirm & Proceed',
                    onPressed: () => setState(
                      () => lastAction = isPersian ? 'تایید شد' : 'Confirmed!',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                isPersian
                    ? '۳. حالت خلاصه سبد خرید + دکمه پرداخت (Summary + CTA):'
                    : '3. Summary + CTA Mode (Checkout & Pay):',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadiusDirectional.all(
                    Radius.circular(16),
                  ),
                  border: Border.all(
                    color: SkinTheme.of(context)
                        .valuesFor(Theme.of(context).brightness)
                        .color('Outline/Variant'),
                  ),
                ),
                child: AppStickyActionBar(
                  elementId: 'gallery.bar.summary-demo',
                  useSafeArea: false,
                  hasTopBorder: false,
                  summaryTitle: isPersian
                      ? 'مبلغ قابل پرداخت:'
                      : 'Total Amount:',
                  summarySubtitle: isPersian ? '۴۹,۵۰۰ تومان' : '49,500 Toman',
                  primaryAction: AppButton(
                    elementId: 'gallery.btn.pay-demo',
                    label: isPersian ? 'پرداخت آنلاین' : 'Pay Online',
                    onPressed: () => setState(
                      () => lastAction = isPersian
                          ? 'درگاه بانک باز شد'
                          : 'Payment Gateway Opened!',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
