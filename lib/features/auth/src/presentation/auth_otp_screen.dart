import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../../../app/platform/agent_debug_log.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/formatting/digits.dart';
import '../../../../shared/platform/one_time_code.dart';
import '../../../../shared/preferences/device_preferences.dart';
import 'auth_entry_screen.dart';
import 'account_journey_screens.dart';
import 'auth_flow.dart';
import '../domain/player_sms_code.dart';
import 'auth_otp_controller.dart';
import 'email_display.dart';
import 'otp_code_listener.dart';
import 'entry/widgets/auth_entry_widgets.dart';
import 'otp/player_otp_input.dart';
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
  String? _keyboardLogKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      applySms(ref.read(otpCodeListenerProvider));
      seedPrefix();
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

  /// D-074: a development SMS code fills the field and submits it.
  /// D-156: a player SMS code (`P-` plus five digits) only fills the field.
  void applySms(String? next) {
    final current = ref.read(authOtpControllerProvider);
    final challenge = current.challenge;
    if (next == null || current.verified || current.busy || challenge == null) {
      return;
    }
    if (PlayerSmsCode.isSegmented(challenge)) {
      final field = PlayerSmsCode.fieldFor(next, challenge);
      if (field == null || field == code.text) return;
      code.value = TextEditingValue(
        text: field,
        selection: TextSelection.collapsed(offset: field.length),
      );
      ref.read(authOtpControllerProvider.notifier).codeChanged(field);
      return;
    }
    final length = challenge.codeLength;
    if (next.length != length || next == code.text) return;
    code.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
    final controller = ref.read(authOtpControllerProvider.notifier);
    controller.codeChanged(next);
    unawaited(controller.verify(next));
  }

  void seedPrefix() {
    final challenge = ref.read(authOtpControllerProvider).challenge;
    final segmented =
        challenge != null && PlayerSmsCode.isSegmented(challenge);
    final prefix = challenge?.codePrefix ?? '';
    final willSeed = segmented && code.text.isEmpty;
    // #region agent log
    agentDebugLog(
      location: 'auth_otp_screen.dart:seedPrefix',
      message: 'seed prefix decision',
      hypothesisId: 'H1',
      data: {
        'segmented': segmented,
        'prefixLen': prefix.length,
        'prefixShape': RegExp(r'^[A-Za-z]-$').hasMatch(prefix)
            ? 'letter-dash'
            : prefix.isEmpty
            ? 'empty'
            : 'other',
        'textLenBefore': code.text.length,
        'willSeed': willSeed,
      },
    );
    // #endregion
  }

  void leave() {
    ref.read(otpCodeListenerProvider.notifier).invalidate();
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
      if (previous != null && previous.epoch != next.epoch) {
        code.clear();
        seedPrefix();
      }
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
    final segmented =
        state.challenge != null && PlayerSmsCode.isSegmented(state.challenge!);
    final hasLetter = RegExp(r'^[A-Za-z]').hasMatch(code.text);
    final keyboardName = segmented && hasLetter ? 'number' : 'text';
    final keyboardLogKey =
        '$segmented|${code.text.length}|$keyboardName|${state.challenge?.codePrefix.length ?? -1}';
    if (_keyboardLogKey != keyboardLogKey) {
      _keyboardLogKey = keyboardLogKey;
      // #region agent log
      agentDebugLog(
        location: 'auth_otp_screen.dart:build',
        message: 'otp keyboard choice',
        hypothesisId: 'H3',
        data: {
          'segmented': segmented,
          'textLen': code.text.length,
          'keyboard': keyboardName,
          'prefixLabel':
              !segmented && (state.challenge?.codePrefix ?? '').isNotEmpty,
        },
      );
      // #endregion
    }
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!segmented &&
                          (state.challenge?.codePrefix ?? '').isNotEmpty)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            bottom: AuthEntryTokens.dividerGap,
                          ),
                          child: Text(
                            state.challenge!.codePrefix,
                            style: AuthTextTokens
                                .byName['English/Baseline/Label-Small']!
                                .copyWith(
                                  color: roles.color('On Surface/Emphasis'),
                                ),
                          ),
                        ),
                      AppOtpField(
                        elementId: 'auth.otp.code',
                        label: strings.authOtpLabel,
                        length: segmented
                            ? 1 + state.challenge!.codeLength
                            : state.challenge?.codeLength ?? 6,
                        controller: code,
                        focusNode: focus,
                        enabled: !state.busy && !state.verified,
                        readOnly: state.verified,
                        feedbackTone: AppOtpFeedbackTone.status,
                        sourceDivider: true,
                        keyboardType: keyboardName == 'number'
                            ? TextInputType.number
                            : TextInputType.text,
                        inputFormatters: segmented
                            ? [
                                PlayerOtpInputFormatter(
                                  PlayerSmsCode.letterOf(state.challenge!),
                                ),
                              ]
                            : [
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
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AuthEntryTokens.formInset,
                0,
                AuthEntryTokens.formInset,
                AuthEntryTokens.formInset,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
          ],
        ),
      ),
    );
  }
}
