// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_password_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AutoDispose like the entry and OTP controllers: leaving the screen drops
/// the state, so no stale email or length survives into the next flow.

@ProviderFor(AuthPasswordController)
final authPasswordControllerProvider = AuthPasswordControllerProvider._();

/// AutoDispose like the entry and OTP controllers: leaving the screen drops
/// the state, so no stale email or length survives into the next flow.
final class AuthPasswordControllerProvider
    extends $NotifierProvider<AuthPasswordController, AuthPasswordState> {
  /// AutoDispose like the entry and OTP controllers: leaving the screen drops
  /// the state, so no stale email or length survives into the next flow.
  AuthPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authPasswordControllerHash();

  @$internal
  @override
  AuthPasswordController create() => AuthPasswordController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthPasswordState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthPasswordState>(value),
    );
  }
}

String _$authPasswordControllerHash() =>
    r'6248dac25f3d1b6466f20a38d8d2a2dcba8d0da4';

/// AutoDispose like the entry and OTP controllers: leaving the screen drops
/// the state, so no stale email or length survives into the next flow.

abstract class _$AuthPasswordController extends $Notifier<AuthPasswordState> {
  AuthPasswordState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthPasswordState, AuthPasswordState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthPasswordState, AuthPasswordState>,
              AuthPasswordState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
