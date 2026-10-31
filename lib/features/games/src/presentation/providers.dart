import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/core/errors/retry_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/models.dart';
import '../domain/repositories.dart';

part 'providers.g.dart';

@riverpod
GamesRepository gamesRepository(Ref ref) =>
    throw StateError('Games composition missing');

@Riverpod(retry: retryTransient)
Future<HomeGamesFeed> homeGamesFeed(Ref ref) async =>
    switch (await ref.watch(gamesRepositoryProvider).homeFeed()) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
