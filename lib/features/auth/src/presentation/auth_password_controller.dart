import 'dart:async';

import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mygame_p2e/shared/preferences/device_preferences.dart';

import '../domain/identifier.dart';
import '../domain/models.dart';
import 'account_setup.dart';
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
    this.changeSerial = 0,
    this.lockSeconds = 0,
  });
  final Email? email;
  final Phone? phone;
  final String label;
  final bool remember;
  final int length;
  final AuthSubmission submission;
  final AuthMessage? fieldError, toast;
  final int toastSerial, resetSerial, welcomeSerial, changeSerial, lockSeconds;
  bool get busy => submission == AuthSubmission.loading;
  bool get canSubmit =>
      (email != null || phone != null) &&
      !busy &&
      length > 0 &&
      lockSeconds <= 0;

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
    int? changeSerial,
    int? lockSeconds,
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
    changeSerial: changeSerial ?? this.changeSerial,
    lockSeconds: lockSeconds ?? this.lockSeconds,
  );
}

/// AutoDispose like the entry and OTP controllers: leaving the screen drops
/// the state, so no stale email or length survives into the next flow.
@riverpod
class AuthPasswordController extends _$AuthPasswordController {
  AuthCancellation? _request;
  Timer? _lock;
  int _revision = 0;

  @override
  AuthPasswordState build() {
    ref.onDispose(() {
      _request?.cancel();
      _lock?.cancel();
    });
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
    if (result is Failure<void> &&
        result.error is BusinessFailure &&
        (result.error as BusinessFailure).code == 'must_change_password') {
      ref
          .read(authFlowProvider.notifier)
          .accept(
            phone != null
                ? PhoneNewPasswordResult(phone, state.remember)
                : EmailNewPasswordResult(email!, state.remember),
          );
      state = state.copyWith(
        submission: AuthSubmission.idle,
        length: 0,
        changeSerial: state.changeSerial + 1,
      );
      return;
    }
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
        if (!ref.mounted || token.isCancelled || revision != _revision) {
          return;
        }
        final handle = await welcomeHandle(ref, cancellation: token);
        if (!ref.mounted || token.isCancelled || revision != _revision) {
          return;
        }
        switch (handle) {
          case Failure(:final error):
            _fail(error);
          case Success(:final value):
            ref
                .read(authFlowProvider.notifier)
                .accept(
                  AccountJourney(AuthStep.welcomeBack, username: value ?? ''),
                );
            state = state.copyWith(
              submission: AuthSubmission.idle,
              welcomeSerial: state.welcomeSerial + 1,
            );
        }
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
    final retry = failure is ValidationFailure
        ? int.tryParse(failure.fields['retry_after'] ?? '')
        : null;
    state = state.copyWith(
      submission: AuthSubmission.failure,
      fieldError: mapped.field,
      toast: mapped.toast,
      toastSerial: state.toastSerial + 1,
      lockSeconds: retry != null && retry > 0 ? retry : 0,
    );
    _lock?.cancel();
    if (retry == null || retry <= 0) return;
    _lock = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!ref.mounted) {
        timer.cancel();
        return;
      }
      final next = state.lockSeconds - 1;
      if (next <= 0) {
        timer.cancel();
        state = state.copyWith(lockSeconds: 0);
      } else {
        state = state.copyWith(lockSeconds: next);
      }
    });
  }

  /// Toast dismissal (auto or by the player): only the toast goes; a visible
  /// field error survives it.
  void dismissToast() {
    if (state.toast == null) return;
    state = state.copyWith(toast: null);
  }
}
