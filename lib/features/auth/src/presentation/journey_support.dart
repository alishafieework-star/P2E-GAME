import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:p2e_design_system/design_system.dart';

import 'auth_flow.dart';

void journeyGo(
  BuildContext context,
  AuthStep step, {
  int? avatarCharacter,
  int? avatarTheme,
  bool? avatarReady,
  bool? notificationsOn,
}) {
  final current = ProviderScope.containerOf(context).read(authFlowProvider);
  final previous = current is AccountJourney ? current : null;
  ProviderScope.containerOf(context)
      .read(authFlowProvider.notifier)
      .accept(
        AccountJourney(
          step,
          email: previous?.email,
          username: previous?.username ?? '',
          phoneRaw: previous?.phoneRaw ?? '',
          avatarCharacter: avatarCharacter ?? previous?.avatarCharacter ?? 0,
          avatarTheme: avatarTheme ?? previous?.avatarTheme ?? 0,
          avatarReady: avatarReady ?? previous?.avatarReady ?? false,
          notificationsOn:
              notificationsOn ?? previous?.notificationsOn ?? false,
          rememberDevice: current?.rememberDevice ?? false,
        ),
      );
  context.go(authStepPath(step));
}

AccountJourney? currentJourney(BuildContext context) {
  final current = ProviderScope.containerOf(context).read(authFlowProvider);
  return current is AccountJourney ? current : null;
}

void showAuthHelp(BuildContext context) {
  final strings = AppLocalizations.of(context);
  AppSheet.show(
    context: context,
    elementId: 'auth.help.sheet',
    child: Builder(
      builder: (context) {
        final roles = SkinTheme.of(context)
            .valuesFor(Theme.of(context).brightness);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.authHelpTitle,
              style: AuthTextTokens.byName['English/Baseline/Headline-Small']!
                  .copyWith(
                    color: roles.color('On Surface/Emphasis'),
                    fontSize: HtmlJourneyTokens.shTitle,
                    height:
                        HtmlJourneyTokens.shTitleLine /
                        HtmlJourneyTokens.shTitle,
                  ),
            ),
            const SizedBox(height: HtmlJourneyTokens.jlTextGap),
            Text(
              strings.authHelpBody,
              style: AuthTextTokens.byName['English/Baseline/Label-Medium']!
                  .copyWith(
                    color: roles.color('On Surface/Base'),
                    fontSize: HtmlJourneyTokens.shBody,
                    height:
                        HtmlJourneyTokens.shBodyLine / HtmlJourneyTokens.shBody,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: HtmlJourneyTokens.shGap),
            AppButton(
              elementId: 'auth.help.close',
              family: AppButtonFamily.fill,
              tone: AppButtonTone.accent,
              label: strings.authHelpClose,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    ),
  );
}

class JourneyStep extends StatelessWidget {
  const JourneyStep({
    super.key,
    required this.elementId,
    required this.title,
    required this.body,
    required this.action,
    required this.enabled,
    required this.onNext,
    required this.child,
    this.secondary,
    this.onSecondary,
  });

  final String elementId, title, body, action;
  final bool enabled;
  final FutureOr<void> Function() onNext;
  final Widget child;
  final String? secondary;
  final FutureOr<void> Function()? onSecondary;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final brightness = Theme.of(context).brightness;
    final roles = SkinTheme.of(context).valuesFor(brightness);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    final bottom = keyboard ? 0.0 : MediaQuery.viewPaddingOf(context).bottom;
    final bar = AppBarSpec.lookup(AppBarCategory.back, brightness) == null
        ? null
        : AppBarScaffoldAdapter(
            content: AppBarContent(
              elementId: '$elementId.app-bar',
              configuration: BackAppBar(
                back: AppBarAction(
                  label: strings.authBack,
                  onPressed: () =>
                      context.canPop() ? context.pop() : context.go('/entry'),
                ),
                help: AppBarAction(
                  label: strings.authOtpHelp,
                  onPressed: () => showAuthHelp(context),
                ),
              ),
            ),
          );
    return PageScaffold(
      elementId: elementId,
      layout: PageScaffoldLayout.viewport,
      appBar: bar,
      child: Padding(
        padding: EdgeInsetsDirectional.only(bottom: bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AuthEntryTokens.pageInset,
                  vertical: AuthEntryTokens.headingGap,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AuthTextTokens
                          .byName['English/Baseline/Headline-Small']!
                          .copyWith(color: roles.color('On Surface/Emphasis')),
                    ),
                    SizedBox(height: AuthEntryTokens.headingGap),
                    Text(
                      body,
                      style: AuthTextTokens
                          .byName['English/Variant/Button-Medium']!
                          .copyWith(color: roles.color('On Surface/Base')),
                    ),
                    SizedBox(height: AuthEntryTokens.formGap),
                    DefaultTextStyle.merge(
                      style: AuthTextTokens
                          .byName['English/Baseline/Label-Medium']!
                          .copyWith(color: roles.color('On Surface/Base')),
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(
                AuthEntryTokens.formInset,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton(
                    elementId: '$elementId.next',
                    family: AppButtonFamily.fill,
                    tone: AppButtonTone.accent,
                    label: action,
                    onPressed: enabled ? () => onNext() : null,
                  ),
                  if (secondary != null)
                    AppButton(
                      elementId: '$elementId.secondary',
                      label: secondary!,
                      type: AppButtonType.text,
                      onPressed: onSecondary == null
                          ? null
                          : () => onSecondary!(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
