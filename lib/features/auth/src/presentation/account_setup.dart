import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';

import '../domain/models.dart';
import '../domain/repositories.dart';

/// Overridden in app composition. Screens read it only while setting up an account.
final accountSetupRepositoryProvider = Provider<AccountSetupRepository>(
  (ref) => throw StateError('Auth composition missing'),
);

/// Demo and widget tests have no Users session. Remote composition replaces
/// this with `GET Me` (D-155).
final playerSessionCheckProvider = Provider<PlayerSessionCheck>(
  (ref) => const LocalPlayerSessionCheck(),
);

/// Fake and widget-test journeys. Remote builds override this with `GET Me`.
final class LocalPlayerSessionCheck implements PlayerSessionCheck {
  const LocalPlayerSessionCheck();

  @override
  Future<bool> allowsHome() async => true;

  @override
  Future<Result<String>?> publicName({AuthCancellation? cancellation}) async =>
      null;
}

/// D-158. Null inside [Success] keeps the journey username. A [Failure] means
/// Mine failed and Welcome Back must stay closed.
Future<Result<String?>> welcomeHandle(
  Ref ref, {
  AuthCancellation? cancellation,
}) async {
  final result = await ref
      .read(playerSessionCheckProvider)
      .publicName(cancellation: cancellation);
  if (result == null) return const Success(null);
  return switch (result) {
    Success(:final value) =>
      value.isEmpty ? const Failure(ServerFailure()) : Success(value),
    Failure(:final error) => Failure(error),
  };
}
