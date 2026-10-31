// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gamesRepository)
final gamesRepositoryProvider = GamesRepositoryProvider._();

final class GamesRepositoryProvider
    extends
        $FunctionalProvider<GamesRepository, GamesRepository, GamesRepository>
    with $Provider<GamesRepository> {
  GamesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gamesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gamesRepositoryHash();

  @$internal
  @override
  $ProviderElement<GamesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GamesRepository create(Ref ref) {
    return gamesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GamesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GamesRepository>(value),
    );
  }
}

String _$gamesRepositoryHash() => r'cc04fcc6042a9d576d4edc7d594e08512312806d';

@ProviderFor(homeGamesFeed)
final homeGamesFeedProvider = HomeGamesFeedProvider._();

final class HomeGamesFeedProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeGamesFeed>,
          HomeGamesFeed,
          FutureOr<HomeGamesFeed>
        >
    with $FutureModifier<HomeGamesFeed>, $FutureProvider<HomeGamesFeed> {
  HomeGamesFeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: retryTransient,
        name: r'homeGamesFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeGamesFeedHash();

  @$internal
  @override
  $FutureProviderElement<HomeGamesFeed> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HomeGamesFeed> create(Ref ref) {
    return homeGamesFeed(ref);
  }
}

String _$homeGamesFeedHash() => r'd4343473c57b9f012b87ee7e08bde2ef73996742';
