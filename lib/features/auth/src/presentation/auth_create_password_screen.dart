import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:p2e_design_system/design_system.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../domain/identifier.dart';
import '../domain/models.dart';
import 'auth_entry_controller.dart';
import 'auth_entry_screen.dart';
import 'account_journey_screens.dart';
import 'account_setup.dart';
import 'auth_flow.dart';
import 'auth_messages.dart';
import 'dependencies.dart';
import 'entry/widgets/auth_entry_widgets.dart';
import 'password/password_rules.dart';
import 'password/widgets/password_strength.dart';

part 'auth_create_password_screen.g.dart';

const _absent = Object();

final class AuthCreatePasswordState {
  const AuthCreatePasswordState({
    this.email,
    this.phone,
    this.password = '',
    this.confirm = '',
    this.submission = AuthSubmission.idle,
    this.toast,
    this.toastSerial = 0,
    this.createdSerial = 0,
  });
  final Email? email;
  final Phone? phone;
  final String password, confirm;
  final AuthSubmission submission;
  final AuthMessage? toast;
  final int toastSerial, createdSerial;
  bool get busy => submission == AuthSubmission.loading;
  bool get canSubmit =>
      (email != null || phone != null) &&
      !busy &&
      PasswordRules.acceptable(password, confirm);

  AuthCreatePasswordState copyWith({
    Email? email,
    Phone? phone,
    String? password,
    String? confirm,
    AuthSubmission? submission,
    Object? toast = _absent,
    int? toastSerial,
    int? createdSerial,
  }) => AuthCreatePasswordState(
    email: email ?? this.email,
    phone: phone ?? this.phone,
    password: password ?? this.password,
    confirm: confirm ?? this.confirm,
    submission: submission ?? this.submission,
    toast: identical(toast, _absent) ? this.toast : toast as AuthMessage?,
    toastSerial: toastSerial ?? this.toastSerial,
    createdSerial: createdSerial ?? this.createdSerial,
  );
}

/// AutoDispose: leaving the screen drops the raw password/confirm strings
/// instead of retaining plaintext secrets for the app lifetime.
@riverpod
class AuthCreatePasswordController extends _$AuthCreatePasswordController {
  AuthCancellation? _request;
  int _revision = 0;

  @override
  AuthCreatePasswordState build() {
    ref.onDispose(() => _request?.cancel());
    final flow = ref.read(authFlowProvider);
    final email = switch (flow) {
      AccountJourney(:final email) => email,
      EmailFlowResult(:final email) => email,
      EmailNewPasswordResult(:final email) => email,
      _ => null,
    };
    final phone = switch (flow) {
      PhoneNewPasswordResult(:final phone) => phone,
      AccountJourney(:final phoneRaw) => () {
        final parsed = IdentifierClassifier.classify(phoneRaw);
        return parsed is Phone ? parsed : null;
      }(),
      _ => null,
    };
    return AuthCreatePasswordState(
      email: email,
      phone: email == null ? phone : null,
    );
  }

  void passwordChanged(String value) =>
      state = state.copyWith(password: value, toast: null);
  void confirmChanged(String value) =>
      state = state.copyWith(confirm: value, toast: null);

  Future<void> submit() async {
    final email = state.email;
    final phone = state.phone;
    if ((email == null && phone == null) || !state.canSubmit) return;
    final token = AuthCancellation();
    _request?.cancel();
    _request = token;
    final revision = ++_revision;
    state = state.copyWith(submission: AuthSubmission.loading, toast: null);
    final result = phone != null
        ? await ref
              .read(phoneSignInRepositoryProvider)
              .createPhonePassword(phone, state.password, cancellation: token)
        : await ref
              .read(emailSignInRepositoryProvider)
              .createPassword(email!, state.password, cancellation: token);
    if (!ref.mounted || token.isCancelled || revision != _revision) return;
    switch (result) {
      case Success<void>():
        final journey = ref.read(authFlowProvider);
        final registration = journey is AccountJourney;
        if (registration && journey.username.isNotEmpty) {
          try {
            await ref
                .read(accountSetupRepositoryProvider)
                .complete(
                  username: journey.username,
                  password: state.password,
                  email: state.email?.normalized,
                  phone: state.phone?.e164,
                  avatarCharacter: journey.avatarCharacter,
                  avatarTheme: journey.avatarTheme,
                );
          } on StateError {
            // The screen still advances when setup is not composed.
          }
          if (!ref.mounted || token.isCancelled || revision != _revision) {
            return;
          }
        }
        ref
            .read(authFlowProvider.notifier)
            .accept(
              registration
                  ? AccountJourney(
                      AuthStep.avatar,
                      email: state.email,
                      username: journey.username,
                      phoneRaw: journey.phoneRaw,
                      rememberDevice: journey.rememberDevice,
                    )
                  : AccountJourney(
                      AuthStep.welcomeBack,
                      rememberDevice: journey?.rememberDevice ?? false,
                    ),
            );
        state = state.copyWith(
          submission: AuthSubmission.idle,
          createdSerial: state.createdSerial + 1,
        );
      case Failure<void>(:final error):
        final mapped = AuthFailureMapper.map(error);
        state = state.copyWith(
          submission: AuthSubmission.failure,
          toast: mapped.toast ?? mapped.field ?? AuthMessage.unknown,
          toastSerial: state.toastSerial + 1,
        );
    }
  }

  /// Toast dismissal (auto or by the player): only the toast goes.
  void dismissToast() {
    if (state.toast == null) return;
    state = state.copyWith(toast: null);
  }
}

class AuthCreatePasswordScreen extends ConsumerStatefulWidget {
  const AuthCreatePasswordScreen({super.key});
  @override
  ConsumerState<AuthCreatePasswordScreen> createState() =>
      _AuthCreatePasswordScreenState();
}

class _AuthCreatePasswordScreenState
    extends ConsumerState<AuthCreatePasswordScreen> {
  final password = TextEditingController();
  final confirm = TextEditingController();
  final passwordFocus = FocusNode();
  final confirmFocus = FocusNode();

  @override
  void dispose() {
    password.dispose();
    confirm.dispose();
    passwordFocus.dispose();
    confirmFocus.dispose();
    super.dispose();
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
    final state = ref.watch(authCreatePasswordControllerProvider);
    final controller = ref.read(authCreatePasswordControllerProvider.notifier);
    ref.listen(authCreatePasswordControllerProvider, (previous, next) {
      if (previous != null && next.createdSerial != previous.createdSerial) {
        context.go(authStepPath(AuthStep.avatar));
      }
    });
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final level = switch (PasswordRules.level(state.password)) {
      1 => strings.authPasswordWeak,
      2 => strings.authPasswordFair,
      3 => strings.authPasswordGood,
      4 => strings.authPasswordStrong,
      _ => '',
    };
    final bar =
        AppBarSpec.lookup(AppBarCategory.back, Theme.of(context).brightness) ==
            null
        ? null
        : AppBarScaffoldAdapter(
            content: AppBarContent(
              elementId: 'auth.create.app-bar',
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
      elementId: 'auth.create.page',
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
                    strings.authCreateTitle,
                    style: AuthTextTokens
                        .byName['English/Baseline/Headline-Small']!
                        .copyWith(color: roles.color('On Surface/Emphasis')),
                  ),
                  SizedBox(height: AuthEntryTokens.headingGap),
                  Text(
                    strings.authCreateSubtitle,
                    style: AuthTextTokens
                        .byName['English/Variant/Button-Medium']!
                        .copyWith(color: roles.color('On Surface/Base')),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.all(
                  AuthEntryTokens.formInset,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppPasswordField(
                      elementId: 'auth.create.password',
                      label: strings.authCreatePasswordLabel,
                      showPasswordLabel: strings.authPasswordShow,
                      hidePasswordLabel: strings.authPasswordHide,
                      options: FieldInputOptions(
                        controller: password,
                        focusNode: passwordFocus,
                        hint: strings.authCreatePasswordHint,
                        enabled: !state.busy,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        enableSuggestions: false,
                        identifierPrivacy: true,
                        onChanged: controller.passwordChanged,
                      ),
                    ),
                    SizedBox(height: AuthEntryTokens.formGap),
                    AppPasswordField(
                      elementId: 'auth.create.confirm',
                      label: strings.authCreateConfirmLabel,
                      showPasswordLabel: strings.authPasswordShow,
                      hidePasswordLabel: strings.authPasswordHide,
                      options: FieldInputOptions(
                        controller: confirm,
                        focusNode: confirmFocus,
                        hint: strings.authCreateConfirmHint,
                        enabled: !state.busy,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        autocorrect: false,
                        enableSuggestions: false,
                        identifierPrivacy: true,
                        onChanged: controller.confirmChanged,
                        onSubmitted: state.canSubmit
                            ? (_) => unawaited(controller.submit())
                            : null,
                      ),
                    ),
                    SizedBox(height: AuthEntryTokens.formGap),
                    PasswordStrength(
                      password: state.password,
                      strengthLabel: strings.authPasswordStrength,
                      level: level,
                      longLabel: strings.authPasswordRuleLength,
                      numberLabel: strings.authPasswordRuleNumber,
                      caseLabel: strings.authPasswordRuleCase,
                      symbolLabel: strings.authPasswordRuleSymbol,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AuthEntryTokens.formInset,
                AuthEntryTokens.formGap,
                AuthEntryTokens.formInset,
                AuthEntryTokens.formInset,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AppButton(
                    elementId: 'auth.create.submit',
                    key: const ValueKey('auth.create.submit'),
                    family: AppButtonFamily.fill,
                    tone: AppButtonTone.accent,
                    label: strings.authCreateSubmit,
                    loading: state.busy,
                    loadingSemanticsLabel: strings.authLoading,
                    onPressed: state.canSubmit
                        ? () => unawaited(controller.submit())
                        : null,
                  ),
                  if (state.toast != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionalTranslation(
                        translation: const Offset(0, 1),
                        child: AppToast(
                          key: ValueKey(state.toastSerial),
                          elementId: 'auth.create.toast',
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
