import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/core/errors/retry_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'balance.g.dart';

/// The signed-in player's wallet, shared by the App Bar and the Shop.
final class Balance {
  const Balance({required this.points, required this.coins});
  final int points, coins;
}

abstract interface class BalanceRepository {
  Future<Result<Balance>> current();
}

/// OD-2: no endpoint is invented until the backend contract exists.
final class RemoteBalanceRepository implements BalanceRepository {
  const RemoteBalanceRepository();
  @override
  Future<Result<Balance>> current() async =>
      const Failure(BusinessFailure('not_configured'));
}

@riverpod
BalanceRepository balanceRepository(Ref ref) =>
    throw StateError('Balance composition missing');

@Riverpod(retry: retryTransient)
Future<Balance> balance(Ref ref) async =>
    switch (await ref.watch(balanceRepositoryProvider).current()) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
