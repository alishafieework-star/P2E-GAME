import 'dart:async';

import 'package:mygame_p2e/app/platform/agent_debug_log.dart';
import 'package:mygame_p2e/core/diagnostics/app_logger.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:p2e_design_system/design_system.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/identifier.dart';
import '../domain/models.dart';
import '../domain/player_sms_code.dart';
import 'account_setup.dart';
import 'auth_entry_controller.dart';
import 'auth_flow.dart';
import 'auth_messages.dart';
import 'dependencies.dart';
import 'otp_code_listener.dart';

part 'auth_otp_controller.g.dart';

const _absent = Object();

enum AuthOtpAdvance { none, createPassword, username, welcomeBack }

final class AuthOtpState {
  const AuthOtpState({
    this.challenge,
    this.destination = '',
    this.codeLength = 0,
    this.remaining = 0,
    this.submission = AuthSubmission.idle,
    this.fieldError,
    this.toast,
    this.toastSerial = 0,
    this.epoch = 0,
    this.verified = false,
    this.advance = AuthOtpAdvance.none,
  });
  final OtpChallenge? challenge;
  final String destination;
  final int codeLength, remaining;
  final AuthSubmission submission;
  final AuthMessage? fieldError, toast;
  final int toastSerial, epoch;
  final bool verified;
  final AuthOtpAdvance advance;
  bool get busy => submission == AuthSubmission.loading;
  bool get canVerify =>
      challenge != null &&
      !busy &&
      !verified &&
      codeLength == challenge!.codeLength &&
      fieldError != AuthMessage.prefixMismatch &&
      !(fieldError == AuthMessage.rateLimited && remaining > 0);
  bool get canResend =>
      challenge != null && !busy && !verified && remaining <= 0;

  AuthOtpState copyWith({
    OtpChallenge? challenge,
    String? destination,
    int? codeLength,
    int? remaining,
    AuthSubmission? submission,
    Object? fieldError = _absent,
    Object? toast = _absent,
    int? toastSerial,
    int? epoch,
    bool? verified,
    AuthOtpAdvance? advance,
  }) => AuthOtpState(
    challenge: challenge ?? this.challenge,
    destination: destination ?? this.destination,
    codeLength: codeLength ?? this.codeLength,
    remaining: remaining ?? this.remaining,
    submission: submission ?? this.submission,
    fieldError: identical(fieldError, _absent)
        ? this.fieldError
        : fieldError as AuthMessage?,
    toast: identical(toast, _absent) ? this.toast : toast as AuthMessage?,
    toastSerial: toastSerial ?? this.toastSerial,
    epoch: epoch ?? this.epoch,
    verified: verified ?? this.verified,
    advance: advance ?? this.advance,
  );
}

@riverpod
class AuthOtpController extends _$AuthOtpController {
  Timer? _timer, _hold;
  AuthCancellation? _request;
  int _revision = 0;

  @override
  AuthOtpState build() {
    final otpListener = ref.read(otpCodeListenerProvider.notifier);
    ref.onDispose(() {
      _timer?.cancel();
      _hold?.cancel();
      _request?.cancel();
      // The screen is gone (back, advance or flow change); do not leave the
      // SMS retriever armed. A new request re-arms it (D-071).
      otpListener.stop();
    });
    final flow = ref.read(authFlowProvider);
    final challenge = switch (flow) {
      PhoneFlowResult(:final challenge) => challenge,
      PhoneResetFlowResult(:final challenge) => challenge,
      EmailVerifyFlowResult(:final challenge) => challenge,
      EmailResetFlowResult(:final challenge) => challenge,
      AccountJourney(:final challenge) => challenge,
      _ => null,
    };
    final destination = switch (flow) {
      PhoneFlowResult(:final displayDestination) => displayDestination,
      PhoneResetFlowResult(:final displayDestination) => displayDestination,
      EmailVerifyFlowResult(:final email) => email.normalized,
      EmailResetFlowResult(:final email) => email.normalized,
      AccountJourney(:final phoneRaw) => phoneRaw,
      _ => '',
    };
    final remaining = challenge?.resendAfter.inSeconds ?? 0;
    if (challenge != null &&
        RegExp(r'^[A-Za-z]-$').hasMatch(challenge.codePrefix) &&
        !PlayerSmsCode.isSegmented(challenge)) {
      AppLogger().log(
        LogLevel.warning,
        'otp',
        fields: {
          'event': 'code_digits_mismatch',
          'codeDigits': challenge.codeLength,
        },
      );
    }
    _arm(remaining);
    return AuthOtpState(
      challenge: challenge,
      destination: destination,
      remaining: remaining,
    );
  }

  void _arm(int remaining) {
    _timer?.cancel();
    if (remaining <= 0) return;
    _timer = Timer(const Duration(seconds: 1), () {
      if (!ref.mounted) return;
      final next = state.remaining - 1;
      state = state.copyWith(remaining: next < 0 ? 0 : next);
      if (state.remaining > 0) _arm(state.remaining);
    });
  }

  void codeChanged(String value) {
    if (state.verified) return;
    final challenge = state.challenge;
    final segmented = challenge != null && PlayerSmsCode.isSegmented(challenge);
    state = state.copyWith(
      codeLength: segmented ? PlayerSmsCode.digitsIn(value) : value.length,
      fieldError:
          challenge != null && PlayerSmsCode.letterMismatch(value, challenge)
          ? AuthMessage.prefixMismatch
          : null,
      toast: null,
    );
  }

  Future<void> resend() async {
    // #region agent log
    agentDebugLog(
      location: 'auth_otp_controller.dart:resend',
      message: 'resend tapped',
      hypothesisId: 'R1',
      data: {
        'canResend': state.canResend,
        'remaining': state.remaining,
        'busy': state.busy,
        'verified': state.verified,
        'hasChallenge': state.challenge != null,
      },
    );
    // #endregion
    if (!state.canResend) return;
    final flow = ref.read(authFlowProvider);
    _hold?.cancel();
    if (flow is PhoneFlowResult) {
      ref.read(otpCodeListenerProvider.notifier).arm();
    }
    final token = AuthCancellation();
    _request?.cancel();
    _request = token;
    final revision = ++_revision;
    state = state.copyWith(
      submission: AuthSubmission.loading,
      fieldError: null,
      toast: null,
      advance: AuthOtpAdvance.none,
    );
    final result = await _resend(flow, token);
    if (!ref.mounted || token.isCancelled || revision != _revision) return;
    switch (result) {
      case Success<OtpChallenge>(:final value):
        // #region agent log
        agentDebugLog(
          location: 'auth_otp_controller.dart:resend',
          message: 'resend succeeded',
          hypothesisId: 'R2',
          data: {
            'newRemaining': value.resendAfter.inSeconds,
            'digitCount': value.codeLength,
            'prefixShape': RegExp(r'^[A-Za-z]-$').hasMatch(value.codePrefix)
                ? 'letter-dash'
                : 'other',
          },
        );
        // #endregion
        final remaining = value.resendAfter.inSeconds;
        state = state.copyWith(
          challenge: value,
          remaining: remaining,
          submission: AuthSubmission.idle,
          codeLength: 0,
          epoch: state.epoch + 1,
        );
        _arm(remaining);
      case Failure<OtpChallenge>(:final error):
        // #region agent log
        agentDebugLog(
          location: 'auth_otp_controller.dart:resend',
          message: 'resend failed',
          hypothesisId: 'R2',
          data: {'fault': error.runtimeType.toString()},
        );
        // #endregion
        ref.read(otpCodeListenerProvider.notifier).invalidate();
        _fail(error);
    }
  }

  Future<void> verify(String code) async {
    final challenge = state.challenge;
    final wire = challenge == null
        ? null
        : PlayerSmsCode.wireDigits(code, challenge);
    if (challenge == null || wire == null || state.busy || state.verified) {
      return;
    }
    _hold?.cancel();
    final token = AuthCancellation();
    _request?.cancel();
    _request = token;
    final revision = ++_revision;
    state = state.copyWith(
      submission: AuthSubmission.loading,
      fieldError: null,
      toast: null,
      advance: AuthOtpAdvance.none,
    );
    final flow = ref.read(authFlowProvider);
    final result = await _verify(flow, challenge, wire, token);
    if (!ref.mounted || token.isCancelled || revision != _revision) return;
    switch (result) {
      case Success<void>():
        ref.read(otpCodeListenerProvider.notifier).invalidate();
        state = state.copyWith(
          submission: AuthSubmission.idle,
          verified: true,
          fieldError: null,
        );
        _hold?.cancel();
        _hold = Timer(AuthOtpMotion.successHold, () async {
          if (!ref.mounted || revision != _revision || !state.verified) return;
          final current = ref.read(authFlowProvider);
          if (current is EmailResetFlowResult) {
            ref
                .read(authFlowProvider.notifier)
                .accept(
                  EmailNewPasswordResult(current.email, current.rememberDevice),
                );
            state = state.copyWith(advance: AuthOtpAdvance.createPassword);
            return;
          }
          if (current is PhoneResetFlowResult) {
            ref
                .read(authFlowProvider.notifier)
                .accept(
                  PhoneNewPasswordResult(current.phone, current.rememberDevice),
                );
            state = state.copyWith(advance: AuthOtpAdvance.createPassword);
            return;
          }
          if (current is EmailFlowResult &&
              current.accountStatus == EmailAccountStatus.notRegistered) {
            ref
                .read(authFlowProvider.notifier)
                .accept(
                  AccountJourney(
                    AuthStep.username,
                    email: current.email,
                    rememberDevice: current.rememberDevice,
                  ),
                );
            state = state.copyWith(advance: AuthOtpAdvance.username);
            return;
          }
          if (current is PhoneFlowResult && current.registration) {
            ref
                .read(authFlowProvider.notifier)
                .accept(
                  AccountJourney(
                    AuthStep.username,
                    phoneRaw: current.displayDestination,
                    rememberDevice: current.rememberDevice,
                  ),
                );
            state = state.copyWith(advance: AuthOtpAdvance.username);
            return;
          }
          final handle = await welcomeHandle(ref);
          if (!ref.mounted || revision != _revision || !state.verified) {
            return;
          }
          switch (handle) {
            case Failure(:final error):
              state = state.copyWith(verified: false);
              _fail(error);
            case Success(:final value):
              ref
                  .read(authFlowProvider.notifier)
                  .accept(
                    AccountJourney(AuthStep.welcomeBack, username: value ?? ''),
                  );
              state = state.copyWith(advance: AuthOtpAdvance.welcomeBack);
          }
        });
      case Failure<void>(:final error):
        _fail(error);
    }
  }

  Future<Result<OtpChallenge>> _resend(
    AuthFlowResult? flow,
    AuthCancellation token,
  ) {
    if (flow is PhoneFlowResult || flow is PhoneResetFlowResult) {
      final shown = flow is PhoneFlowResult
          ? flow.displayDestination
          : (flow as PhoneResetFlowResult).displayDestination;
      final phone = IdentifierClassifier.classify(shown);
      if (phone is! Phone || flow == null) {
        return Future.value(const Failure(UnknownFailure()));
      }
      final remember = flow.rememberDevice;
      return flow is PhoneResetFlowResult
          ? ref
                .read(phoneSignInRepositoryProvider)
                .resendPhoneReset(
                  phone,
                  rememberDevice: remember,
                  cancellation: token,
                )
          : ref
                .read(phoneSignInRepositoryProvider)
                .resendOtp(
                  phone,
                  rememberDevice: remember,
                  cancellation: token,
                );
    }
    if (flow is EmailResetFlowResult) {
      return ref
          .read(emailSignInRepositoryProvider)
          .resendReset(
            flow.email,
            rememberDevice: flow.rememberDevice,
            cancellation: token,
          );
    }
    if (flow is EmailVerifyFlowResult) {
      return ref
          .read(emailSignInRepositoryProvider)
          .requestVerification(
            flow.email,
            rememberDevice: flow.rememberDevice,
            cancellation: token,
          );
    }
    return Future.value(const Failure(UnknownFailure()));
  }

  Future<Result<void>> _verify(
    AuthFlowResult? flow,
    OtpChallenge challenge,
    String code,
    AuthCancellation token,
  ) {
    if (flow is EmailResetFlowResult) {
      return ref
          .read(emailSignInRepositoryProvider)
          .verifyReset(challenge, code, cancellation: token);
    }
    if (flow is EmailVerifyFlowResult) {
      return ref
          .read(emailSignInRepositoryProvider)
          .verifyRegistration(challenge, code, cancellation: token);
    }
    if (flow is PhoneResetFlowResult) {
      return ref
          .read(phoneSignInRepositoryProvider)
          .verifyPhoneReset(challenge, code, cancellation: token);
    }
    if (flow is AccountJourney) {
      return ref
          .read(phoneSignInRepositoryProvider)
          .verifyOtp(challenge, code, cancellation: token);
    }
    return ref
        .read(phoneSignInRepositoryProvider)
        .verifyOtp(challenge, code, cancellation: token);
  }

  void _fail(AppFailure failure) {
    final mapped = AuthFailureMapper.map(failure);
    final retry = _retrySeconds(failure);
    state = state.copyWith(
      submission: AuthSubmission.failure,
      fieldError: mapped.field,
      toast: mapped.toast,
      toastSerial: state.toastSerial + 1,
      remaining: retry ?? state.remaining,
    );
    if (retry != null && retry > 0) _arm(retry);
  }

  int? _retrySeconds(AppFailure failure) {
    if (failure is! ValidationFailure) return null;
    final seconds = int.tryParse(failure.fields['retry_after'] ?? '');
    if (seconds == null || seconds <= 0) return null;
    return seconds;
  }

  /// Toast dismissal (auto or by the player): only the toast goes; a visible
  /// field error survives it.
  void dismissToast() {
    if (state.toast == null) return;
    state = state.copyWith(toast: null);
  }
}
