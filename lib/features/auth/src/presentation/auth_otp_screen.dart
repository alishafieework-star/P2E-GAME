import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/formatting/digits.dart';
import '../../../../shared/platform/one_time_code.dart';
import '../../../../shared/preferences/device_preferences.dart';
import 'auth_entry_screen.dart';
import 'account_journey_screens.dart';
import 'auth_flow.dart';
import 'auth_otp_controller.dart';
import 'email_display.dart';
import 'otp_code_listener.dart';
import 'entry/widgets/auth_entry_widgets.dart';
import 'otp/widgets/otp_prompt_row.dart';
import 'otp/sms_access_sheet.dart';

class AuthOtpScreen extends ConsumerStatefulWidget {
  const AuthOtpScreen({super.key});
  @override
  ConsumerState<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends ConsumerState<AuthOtpScreen> {
  final code = TextEditingController();
  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      applySms(ref.read(otpCodeListenerProvider));
      unawaited(offerSmsAccess());
    });
  }

  /// PE-003: explain SMS access once, then ask the OS only if the user agrees.
  Future<void> offerSmsAccess() async {
    final access = ref.read(oneTimeCodeAccessProvider);
    if (await access.granted() || !mounted) return;
    final prefs = ref.read(devicePreferencesProvider);
    if (prefs.value?.smsAccessAsked ?? true) return;
    final allowed = await showSmsAccessSheet(context);
    final current =
        ref.read(devicePreferencesProvider).value ?? const DevicePreferences();
    await ref
        .read(devicePreferencesProvider.notifier)
        .save(current.copyWith(smsAccessAsked: true));
    if (!allowed || !mounted) return;
    if (await access.request() && mounted) {
      ref.read(otpCodeListenerProvider.notifier).arm();
    }
  }

  @override
  void dispose() {
    code.dispose();
    focus.dispose();
    super.dispose();
  }

  /// D-074: a code taken from one SMS fills the field and submits it.
  void applySms(String? next) {
    final current = ref.read(authOtpControllerProvider);
    final length = current.challenge?.codeLength;
    if (next == null ||
        current.verified ||
        current.busy ||
        length == null ||
        next.length != length ||
        next == code.text) {
      return;
    }
    code.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
    final controller = ref.read(authOtpControllerProvider.notifier);
    controller.codeChanged(next);
    unawaited(controller.verify(next));
  }

  void leave() {
    ref.read(otpCodeListenerProvider.notifier).stop();
    ref.read(authFlowProvider.notifier).clear();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/entry');
    }
  }

  String countdown(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final rest = (seconds % 60).toString().padLeft(2, '0');
    return localizedDigits(
      '$minutes:$rest',
      languageCode: Localizations.localeOf(context).languageCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final state = ref.watch(authOtpControllerProvider);
    final controller = ref.read(authOtpControllerProvider.notifier);
    ref.listen(authOtpControllerProvider, (previous, next) {
      if (previous != null && previous.epoch != next.epoch) code.clear();
      if (next.advance != AuthOtpAdvance.none &&
          previous?.advance != next.advance) {
        context.go(switch (next.advance) {
          AuthOtpAdvance.createPassword => authStepPath(
            AuthStep.createPassword,
          ),
          AuthOtpAdvance.username => authStepPath(AuthStep.username),
          AuthOtpAdvance.welcomeBack => authStepPath(AuthStep.welcomeBack),
          AuthOtpAdvance.none => '/entry',
        });
      }
    });
    ref.listen(otpCodeListenerProvider, (previous, next) => applySms(next));
    final flow = ref.watch(authFlowProvider);
    final reset = flow is EmailResetFlowResult;
    final shownDestination = reset
        ? compactEmail(state.destination)
        : state.destination;
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final bar =
        AppBarSpec.lookup(AppBarCategory.back, Theme.of(context).brightness) ==
            null
        ? null
        : AppBarScaffoldAdapter(
            content: AppBarContent(
              elementId: 'auth.otp.app-bar',
              configuration: BackAppBar(
                back: AppBarAction(label: strings.authBack, onPressed: leave),
                help: AppBarAction(
                  label: strings.authOtpHelp,
                  onPressed: () => showAuthHelp(context),
                ),
              ),
            ),
          );
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    final bottom = keyboard ? 0.0 : MediaQuery.viewPaddingOf(context).bottom;
    return PageScaffold(
      elementId: 'auth.otp.page',
      layout: PageScaffoldLayout.viewport,
      appBar: bar,
      child: Padding(
        padding: EdgeInsetsDirectional.only(bottom: bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AuthEntryTokens.pageInset,
                vertical: AuthEntryTokens.headingGap,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.authOtpTitle,
                    style: AuthTextTokens
                        .byName['English/Baseline/Headline-Small']!
                        .copyWith(color: roles.color('On Surface/Emphasis')),
                  ),
                  SizedBox(height: AuthEntryTokens.headingGap),
                  Text.rich(
                    TextSpan(
                      style: AuthTextTokens
                          .byName['English/Variant/Button-Medium']!
                          .copyWith(color: roles.color('On Surface/Base')),
                      children: [
                        TextSpan(text: strings.authOtpSubtitleLead),
                        TextSpan(
                          text: '\u2066$shownDestination\u2069',
                          style: AuthTextTokens
                              .byName['English/Baseline/Label-Small']!
                              .copyWith(
                                color: roles.color('On Surface/Emphasis'),
                              ),
                        ),
                        TextSpan(text: strings.authOtpSubtitleEnd),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(
                  AuthEntryTokens.formInset,
                ),
                child: Column(
                  children: [
                    // D-044: content scrolls instead of clipping at 2.0x;
                    // the CTA cluster stays pinned below it.
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppOtpField(
                              elementId: 'auth.otp.code',
                              label: strings.authOtpLabel,
                              controller: code,
                              focusNode: focus,
                              enabled: !state.busy && !state.verified,
                              readOnly: state.verified,
                              feedbackTone: AppOtpFeedbackTone.status,
                              sourceDivider: true,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[A-Za-z0-9]'),
                                ),
                              ],
                              feedback: state.verified
                                  ? const FieldFeedback.success()
                                  : state.fieldError == null
                                  ? const FieldFeedback.neutral()
                                  : FieldFeedback.error(
                                      message(strings, state.fieldError!),
                                    ),
                              onChanged: controller.codeChanged,
                            ),
                            SizedBox(height: AuthEntryTokens.dividerGap),
                            OtpPromptRow(
                              elementId: 'auth.otp.resend',
                              prompt: strings.authOtpResendPrompt,
                              promptStyleName: 'English/Baseline/Label-Medium',
                              action: state.remaining > 0
                                  ? countdown(state.remaining)
                                  : strings.authOtpResend,
                              actionStyleName: state.remaining > 0
                                  ? 'English/Baseline/Number-Large'
                                  : 'English/Baseline/Button-Medium',
                              onAction: state.canResend
                                  ? () => unawaited(controller.resend())
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    AppButton(
                      elementId: 'auth.otp.verify',
                      key: const ValueKey('auth.otp.verify'),
                      family: AppButtonFamily.fill,
                      tone: AppButtonTone.accent,
                      label: reset
                          ? strings.authResetAction
                          : strings.authOtpVerify,
                      loading: state.busy,
                      loadingSemanticsLabel: reset
                          ? strings.authResetLoading
                          : strings.authOtpLoading,
                      onPressed: state.canVerify
                          ? () => unawaited(controller.verify(code.text))
                          : null,
                    ),
                    SizedBox(height: AuthEntryTokens.dividerGap),
                    OtpPromptRow(
                      elementId: 'auth.otp.change',
                      prompt: reset
                          ? strings.authResetWrongEmail
                          : strings.authOtpWrongPhone,
                      promptStyleName: 'English/Baseline/Label-Small',
                      action: strings.authOtpChange,
                      actionStyleName: 'English/Baseline/Label-Small',
                      onAction: state.busy || state.verified ? null : leave,
                    ),
                    if (state.toast != null)
                      AppToast(
                        key: ValueKey(state.toastSerial),
                        elementId: 'auth.otp.toast',
                        message: message(strings, state.toast!),
                        onDismiss: controller.dismissToast,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
