import 'package:mygame_p2e/core/errors/app_failure.dart';

import 'balance.dart';

/// D-102: in-process sample wallet from the Home source (5,325 pts, 150).
final class FakeBalanceRepository implements BalanceRepository {
  const FakeBalanceRepository();
  @override
  Future<Result<Balance>> current() async =>
      const Success(Balance(points: 5325, coins: 150));
}
