// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_otp_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthOtpController)
final authOtpControllerProvider = AuthOtpControllerProvider._();

final class AuthOtpControllerProvider
    extends $NotifierProvider<AuthOtpController, AuthOtpState> {
  AuthOtpControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authOtpControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authOtpControllerHash();

  @$internal
  @override
  AuthOtpController create() => AuthOtpController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthOtpState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthOtpState>(value),
    );
  }
}

String _$authOtpControllerHash() => r'ac1fdfc57e77c41ad30a176c20a7396ed40927f2';

abstract class _$AuthOtpController extends $Notifier<AuthOtpState> {
  AuthOtpState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthOtpState, AuthOtpState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthOtpState, AuthOtpState>,
              AuthOtpState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
