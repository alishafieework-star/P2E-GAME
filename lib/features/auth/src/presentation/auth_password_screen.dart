import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../../../l10n/generated/app_localizations.dart';
import 'auth_entry_screen.dart';
import 'account_journey_screens.dart';
import 'auth_flow.dart';
import 'auth_password_controller.dart';
import 'entry/widgets/auth_entry_widgets.dart';
import 'password/widgets/password_account_card.dart';
import 'password/widgets/password_action_row.dart';

class AuthPasswordScreen extends ConsumerStatefulWidget {
  const AuthPasswordScreen({super.key});
  @override
  ConsumerState<AuthPasswordScreen> createState() => _AuthPasswordScreenState();
}

class _AuthPasswordScreenState extends ConsumerState<AuthPasswordScreen> {
  final password = TextEditingController();
  final focus = FocusNode();

  @override
  void dispose() {
    password.dispose();
    focus.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthPasswordController controller) async {
    final value = password.text;
    password.clear();
    controller.changed('');
    await controller.submit(value);
  }

  void leave() {
    ref.read(authFlowProvider.notifier).clear();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/entry');
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final state = ref.watch(authPasswordControllerProvider);
    final controller = ref.read(authPasswordControllerProvider.notifier);
    ref.listen(authPasswordControllerProvider, (previous, next) {
      if (previous != null && next.resetSerial != previous.resetSerial) {
        context.push('/entry/forgot-password');
      }
      if (previous != null && next.welcomeSerial != previous.welcomeSerial) {
        context.go(authStepPath(AuthStep.welcomeBack));
      }
      if (previous != null && next.changeSerial != previous.changeSerial) {
        password.clear();
        context.go(authStepPath(AuthStep.createPassword));
      }
    });
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final bar =
        AppBarSpec.lookup(AppBarCategory.back, Theme.of(context).brightness) ==
            null
        ? null
        : AppBarScaffoldAdapter(
            content: AppBarContent(
              elementId: 'auth.password.app-bar',
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
    final email = state.label.isNotEmpty
        ? state.label
        : state.email?.normalized ?? '';
    return PageScaffold(
      elementId: 'auth.password.page',
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
                    strings.authPasswordTitle,
                    style: AuthTextTokens
                        .byName['English/Baseline/Headline-Small']!
                        .copyWith(color: roles.color('On Surface/Emphasis')),
                  ),
                  SizedBox(height: AuthEntryTokens.headingGap),
                  Text(
                    strings.authPasswordSubtitle,
                    style: AuthTextTokens
                        .byName['English/Variant/Button-Medium']!
                        .copyWith(color: roles.color('On Surface/Base')),
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
                      PasswordAccountCard(
                        email: email,
                        loggingInLabel: strings.authPasswordLoggingIn,
                        changeLabel: strings.authPasswordChange,
                        onChange: state.busy ? null : leave,
                      ),
                      SizedBox(height: AuthEntryTokens.formGap),
                      AppPasswordField(
                        elementId: 'auth.password.field',
                        label: strings.authPasswordLabel,
                        showPasswordLabel: strings.authPasswordShow,
                        hidePasswordLabel: strings.authPasswordHide,
                        options: FieldInputOptions(
                          controller: password,
                          focusNode: focus,
                          hint: strings.authPasswordHint,
                          enabled: !state.busy,
                          keyboardType: TextInputType.visiblePassword,
                          autofillHints: const [AutofillHints.password],
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          enableSuggestions: false,
                          identifierPrivacy: true,
                          feedback: state.fieldError == null
                              ? const FieldFeedback.neutral()
                              : FieldFeedback.error(
                                  message(strings, state.fieldError!),
                                ),
                          onChanged: controller.changed,
                          onSubmitted: state.canSubmit
                              ? (_) => unawaited(_submit(controller))
                              : null,
                        ),
                      ),
                      SizedBox(height: AuthEntryTokens.fieldGap),
                      PasswordActionRow(
                        rememberLabel: strings.authPasswordRemember,
                        forgotLabel: strings.authPasswordForgot,
                        remember: state.remember,
                        enabled: !state.busy,
                        onRemember: controller.remember,
                        onForgot: () => unawaited(controller.forgot()),
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
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AppButton(
                    elementId: 'auth.password.login',
                    key: const ValueKey('auth.password.login'),
                    family: AppButtonFamily.fill,
                    tone: AppButtonTone.accent,
                    label: strings.authPasswordLogin,
                    loading: state.busy,
                    loadingSemanticsLabel: strings.authLoading,
                    onPressed: state.canSubmit
                        ? () => unawaited(_submit(controller))
                        : null,
                  ),
                  if (state.toast != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionalTranslation(
                        translation: const Offset(0, 1),
                        child: AppToast(
                          key: ValueKey(state.toastSerial),
                          elementId: 'auth.password.toast',
                          message: message(strings, state.toast!),
                          onDismiss: controller.dismissToast,
                        ),
                      ),
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
