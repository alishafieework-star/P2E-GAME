import 'package:flutter/material.dart';
import 'package:p2e_design_system/design_system.dart';

/// Interactive gallery for [AppKeyValueRow].
class KeyValueGallery extends StatefulWidget {
  const KeyValueGallery({super.key});

  @override
  State<KeyValueGallery> createState() => _KeyValueGalleryState();
}

class _KeyValueGalleryState extends State<KeyValueGallery> {
  String copiedText = '';

  @override
  Widget build(BuildContext context) {
    final isPersian = Directionality.of(context) == TextDirection.rtl;

    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        UiIdentityScope(
          routeName: 'gallery.key-value',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSectionHeader(
                elementId: 'gallery.kv.invoice-title',
                title: isPersian
                    ? 'نمونه فاکتور تسویه حساب (Shop Checkout)'
                    : 'Checkout Invoice Summary (Shop)',
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
                  children: [
                    AppKeyValueRow(
                      elementId: 'gallery.kv.subtotal',
                      label: isPersian ? 'مبلغ بسته سکه' : 'Coin Pack Price',
                      value: isPersian ? '۵۰,۰۰۰ تومان' : '50,000 Toman',
                    ),
                    AppKeyValueRow(
                      elementId: 'gallery.kv.discount',
                      label: isPersian ? 'تخفیف شگفت‌انگیز' : 'Promo Discount',
                      value: isPersian ? '-۵,۰۰۰ تومان' : '-5,000 Toman',
                    ),
                    AppKeyValueRow(
                      elementId: 'gallery.kv.vat',
                      label: isPersian
                          ? 'مالیات بر ارزش افزوده (۱۰٪)'
                          : 'VAT (10%)',
                      value: isPersian ? '۴,۵۰۰ تومان' : '4,500 Toman',
                      variant: AppKeyValueVariant.subtle,
                    ),
                    AppKeyValueRow(
                      elementId: 'gallery.kv.status',
                      label: isPersian ? 'وضعیت تراکنش' : 'Transaction Status',
                      valueWidget: AppStatusChip(
                        elementId: 'gallery.kv.status-chip',
                        label: isPersian ? 'تایید شده' : 'Confirmed',
                        status: AppStatusType.success,
                      ),
                    ),
                    AppKeyValueRow(
                      elementId: 'gallery.kv.total',
                      label: isPersian
                          ? 'مبلغ کل پرداختی'
                          : 'Total Payable Amount',
                      value: isPersian ? '۴۹,۵۰۰ تومان' : '49,500 Toman',
                      variant: AppKeyValueVariant.total,
                      hasTopDivider: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AppSectionHeader(
                elementId: 'gallery.kv.receipt-title',
                title: isPersian
                    ? 'رسید جزئیات سفارش (با قابلیت کلیک و کپی)'
                    : 'Order Details (Clickable Rows)',
                actionLabel: copiedText.isNotEmpty ? copiedText : null,
                actionChevron: false,
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
                  children: [
                    AppKeyValueRow(
                      elementId: 'gallery.kv.order-id',
                      label: isPersian ? 'شناسه سفارش' : 'Order ID',
                      value: '#ORD-2026-9981',
                      onTap: () => setState(
                        () => copiedText = isPersian
                            ? 'شناسه کپی شد!'
                            : 'Order ID copied!',
                      ),
                    ),
                    AppKeyValueRow(
                      elementId: 'gallery.kv.tracking',
                      label: isPersian ? 'کد رهگیری بانک' : 'Bank Reference',
                      value: 'TRK-98127391',
                      onTap: () => setState(
                        () => copiedText = isPersian
                            ? 'کد رهگیری کپی شد!'
                            : 'Reference copied!',
                      ),
                    ),
                    AppKeyValueRow(
                      elementId: 'gallery.kv.method',
                      label: isPersian ? 'روش پرداخت' : 'Payment Method',
                      value: isPersian
                          ? 'پرداخت مستقیم همراه اول (DCB)'
                          : 'Direct Carrier Billing',
                    ),
                    AppKeyValueRow(
                      elementId: 'gallery.kv.datetime',
                      label: isPersian ? 'زمان ثبت' : 'Timestamp',
                      value: '2026-11-08 11:35:20',
                      variant: AppKeyValueVariant.subtle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
