// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(balanceRepository)
final balanceRepositoryProvider = BalanceRepositoryProvider._();

final class BalanceRepositoryProvider
    extends
        $FunctionalProvider<
          BalanceRepository,
          BalanceRepository,
          BalanceRepository
        >
    with $Provider<BalanceRepository> {
  BalanceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'balanceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$balanceRepositoryHash();

  @$internal
  @override
  $ProviderElement<BalanceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BalanceRepository create(Ref ref) {
    return balanceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BalanceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BalanceRepository>(value),
    );
  }
}

String _$balanceRepositoryHash() => r'5b41c8ff0af30b39342960f5a37e06f0c277b87f';

@ProviderFor(balance)
final balanceProvider = BalanceProvider._();

final class BalanceProvider
    extends $FunctionalProvider<AsyncValue<Balance>, Balance, FutureOr<Balance>>
    with $FutureModifier<Balance>, $FutureProvider<Balance> {
  BalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: retryTransient,
        name: r'balanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$balanceHash();

  @$internal
  @override
  $FutureProviderElement<Balance> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Balance> create(Ref ref) {
    return balance(ref);
  }
}

String _$balanceHash() => r'2328c9ba87c7902f9d10d12bbf43d814d42da38d';
