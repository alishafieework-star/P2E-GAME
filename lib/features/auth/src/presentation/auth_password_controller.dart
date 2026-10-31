import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mygame_p2e/shared/preferences/device_preferences.dart';

import '../domain/identifier.dart';
import '../domain/models.dart';
import 'auth_entry_controller.dart';
import 'auth_flow.dart';
import 'auth_messages.dart';
import 'dependencies.dart';

part 'auth_password_controller.g.dart';

const _absent = Object();

final class AuthPasswordState {
  const AuthPasswordState({
    this.email,
    this.phone,
    this.label = '',
    this.remember = false,
    this.length = 0,
    this.submission = AuthSubmission.idle,
    this.fieldError,
    this.toast,
    this.toastSerial = 0,
    this.resetSerial = 0,
    this.welcomeSerial = 0,
  });
  final Email? email;
  final Phone? phone;
  final String label;
  final bool remember;
  final int length;
  final AuthSubmission submission;
  final AuthMessage? fieldError, toast;
  final int toastSerial, resetSerial, welcomeSerial;
  bool get busy => submission == AuthSubmission.loading;
  bool get canSubmit => (email != null || phone != null) && !busy && length > 0;

  AuthPasswordState copyWith({
    Email? email,
    Phone? phone,
    String? label,
    bool? remember,
    int? length,
    AuthSubmission? submission,
    Object? fieldError = _absent,
    Object? toast = _absent,
    int? toastSerial,
    int? resetSerial,
    int? welcomeSerial,
  }) => AuthPasswordState(
    email: email ?? this.email,
    phone: phone ?? this.phone,
    label: label ?? this.label,
    remember: remember ?? this.remember,
    length: length ?? this.length,
    submission: submission ?? this.submission,
    fieldError: identical(fieldError, _absent)
        ? this.fieldError
        : fieldError as AuthMessage?,
    toast: identical(toast, _absent) ? this.toast : toast as AuthMessage?,
    toastSerial: toastSerial ?? this.toastSerial,
    resetSerial: resetSerial ?? this.resetSerial,
    welcomeSerial: welcomeSerial ?? this.welcomeSerial,
  );
}

/// AutoDispose like the entry and OTP controllers: leaving the screen drops
/// the state, so no stale email or length survives into the next flow.
@riverpod
class AuthPasswordController extends _$AuthPasswordController {
  AuthCancellation? _request;
  int _revision = 0;

  @override
  AuthPasswordState build() {
    ref.onDispose(() => _request?.cancel());
    final flow = ref.read(authFlowProvider);
    final email = flow is EmailFlowResult ? flow : null;
    final phone = flow is PhonePasswordFlowResult ? flow : null;
    return AuthPasswordState(
      email: email?.email,
      phone: phone?.phone,
      label: email?.email.normalized ?? phone?.displayDestination ?? '',
      remember: email?.rememberDevice ?? phone?.rememberDevice ?? false,
    );
  }

  void changed(String value) {
    state = state.copyWith(length: value.length, fieldError: null, toast: null);
  }

  void remember(bool value) => state = state.copyWith(remember: value);

  Future<void> submit(String password) async {
    final email = state.email;
    final phone = state.phone;
    if ((email == null && phone == null) || state.busy || password.isEmpty) {
      return;
    }
    final token = AuthCancellation();
    _request?.cancel();
    _request = token;
    final revision = ++_revision;
    state = state.copyWith(
      submission: AuthSubmission.loading,
      fieldError: null,
      toast: null,
    );
    final result = phone != null
        ? await ref
              .read(phoneSignInRepositoryProvider)
              .signInPhone(
                phone,
                password,
                rememberDevice: state.remember,
                cancellation: token,
              )
        : await ref
              .read(emailSignInRepositoryProvider)
              .signIn(
                email!,
                password,
                rememberDevice: state.remember,
                cancellation: token,
              );
    if (!ref.mounted || token.isCancelled || revision != _revision) return;
    switch (result) {
      case Success<void>():
        if (state.remember && state.label.isNotEmpty) {
          final current =
              ref.read(devicePreferencesProvider).value ??
              const DevicePreferences();
          await ref
              .read(devicePreferencesProvider.notifier)
              .save(
                current.copyWith(
                  rememberedRaw: state.label,
                  rememberedLabel: state.label,
                ),
              );
        }
        if (!ref.mounted) return;
        ref
            .read(authFlowProvider.notifier)
            .accept(const AccountJourney(AuthStep.welcomeBack));
        state = state.copyWith(
          submission: AuthSubmission.idle,
          welcomeSerial: state.welcomeSerial + 1,
        );
      case Failure<void>(:final error):
        _fail(error);
    }
  }

  Future<void> forgot() async {
    final email = state.email;
    final phone = state.phone;
    if ((email == null && phone == null) || state.busy) return;
    final token = AuthCancellation();
    _request?.cancel();
    _request = token;
    final revision = ++_revision;
    state = state.copyWith(
      submission: AuthSubmission.loading,
      fieldError: null,
      toast: null,
    );
    final result = phone != null
        ? await ref
              .read(phoneSignInRepositoryProvider)
              .requestPhoneReset(
                phone,
                rememberDevice: state.remember,
                cancellation: token,
              )
        : await ref
              .read(emailSignInRepositoryProvider)
              .requestReset(
                email!,
                rememberDevice: state.remember,
                cancellation: token,
              );
    if (!ref.mounted || token.isCancelled || revision != _revision) return;
    switch (result) {
      case Success<OtpChallenge>(:final value):
        ref
            .read(authFlowProvider.notifier)
            .accept(
              phone != null
                  ? PhoneResetFlowResult(
                      phone,
                      state.label,
                      value,
                      state.remember,
                    )
                  : EmailResetFlowResult(email!, value, state.remember),
            );
        state = state.copyWith(
          submission: AuthSubmission.idle,
          resetSerial: state.resetSerial + 1,
        );
      case Failure<OtpChallenge>(:final error):
        _fail(error);
    }
  }

  void _fail(AppFailure failure) {
    final mapped = AuthFailureMapper.map(failure);
    state = state.copyWith(
      submission: AuthSubmission.failure,
      fieldError: mapped.field,
      toast: mapped.toast,
      toastSerial: state.toastSerial + 1,
    );
  }

  /// Toast dismissal (auto or by the player): only the toast goes; a visible
  /// field error survives it.
  void dismissToast() {
    if (state.toast == null) return;
    state = state.copyWith(toast: null);
  }
}
