import 'package:flutter/material.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:p2e_design_system/design_system.dart';

import '../widgets/journey_layout.dart';

/// Explains SMS access before the OS prompt (PE-003). Returns true on Allow.
Future<bool> showSmsAccessSheet(BuildContext context) async {
  final strings = AppLocalizations.of(context);
  final allowed = await AppSheet.show<bool>(
    context: context,
    elementId: 'auth.otp.sms-access.sheet',
    child: Builder(
      builder: (context) {
        Widget icon(AppIconId id) => AssetAppIcon(
          id,
          style: AppIconStyle.fill,
          size: HtmlJourneyTokens.avatarLetterLarge,
          color: HtmlJourneyTokens.splashGradientMid,
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            JourneyHeader(
              topPad: 0,
              lead: JourneyCircle(child: icon(AppIconId.mail)),
              title: strings.authSmsTitle,
              bodyText: strings.authSmsBody,
            ),
            JourneyItems(
              padding: false,
              children: [
                JourneyItem(
                  raised: true,
                  icon: icon(AppIconId.verified),
                  text: strings.authSmsItemCode,
                ),
                JourneyItem(
                  raised: true,
                  icon: icon(AppIconId.visibilityOff),
                  text: strings.authSmsItemPrivate,
                ),
                JourneyItem(
                  raised: true,
                  icon: icon(AppIconId.edit),
                  text: strings.authSmsItemManual,
                ),
              ],
            ),
            const SizedBox(height: HtmlJourneyTokens.jlCtaPad),
            AppButton(
              elementId: 'auth.otp.sms-access.allow',
              family: AppButtonFamily.fill,
              tone: AppButtonTone.accent,
              label: strings.authSmsAllow,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: HtmlJourneyTokens.jlItemsGap),
            AppButton(
              elementId: 'auth.otp.sms-access.later',
              label: strings.authSmsLater,
              type: AppButtonType.text,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      },
    ),
  );
  return allowed ?? false;
}
