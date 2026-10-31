// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_create_password_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AutoDispose: leaving the screen drops the raw password/confirm strings
/// instead of retaining plaintext secrets for the app lifetime.

@ProviderFor(AuthCreatePasswordController)
final authCreatePasswordControllerProvider =
    AuthCreatePasswordControllerProvider._();

/// AutoDispose: leaving the screen drops the raw password/confirm strings
/// instead of retaining plaintext secrets for the app lifetime.
final class AuthCreatePasswordControllerProvider
    extends
        $NotifierProvider<
          AuthCreatePasswordController,
          AuthCreatePasswordState
        > {
  /// AutoDispose: leaving the screen drops the raw password/confirm strings
  /// instead of retaining plaintext secrets for the app lifetime.
  AuthCreatePasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authCreatePasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authCreatePasswordControllerHash();

  @$internal
  @override
  AuthCreatePasswordController create() => AuthCreatePasswordController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthCreatePasswordState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthCreatePasswordState>(value),
    );
  }
}

String _$authCreatePasswordControllerHash() =>
    r'12725174824f60c02eb7811bfca70b0566a372fa';

/// AutoDispose: leaving the screen drops the raw password/confirm strings
/// instead of retaining plaintext secrets for the app lifetime.

abstract class _$AuthCreatePasswordController
    extends $Notifier<AuthCreatePasswordState> {
  AuthCreatePasswordState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AuthCreatePasswordState, AuthCreatePasswordState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthCreatePasswordState, AuthCreatePasswordState>,
              AuthCreatePasswordState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
