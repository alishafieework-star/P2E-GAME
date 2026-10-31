// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clock)
final clockProvider = ClockProvider._();

final class ClockProvider extends $FunctionalProvider<Clock, Clock, Clock>
    with $Provider<Clock> {
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<Clock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Clock create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Clock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Clock>(value),
    );
  }
}

String _$clockHash() => r'55214d6539f7396a3ae1aa23b06eea79fdac0ebe';

/// The current time, refreshed once per second while something watches it.

@ProviderFor(secondTicker)
final secondTickerProvider = SecondTickerProvider._();

/// The current time, refreshed once per second while something watches it.

final class SecondTickerProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime>, DateTime, Stream<DateTime>>
    with $FutureModifier<DateTime>, $StreamProvider<DateTime> {
  /// The current time, refreshed once per second while something watches it.
  SecondTickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secondTickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secondTickerHash();

  @$internal
  @override
  $StreamProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime> create(Ref ref) {
    return secondTicker(ref);
  }
}

String _$secondTickerHash() => r'5cbdd6aafe4a59d7e1f42c11548131e152b17b36';
