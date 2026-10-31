import 'package:mygame_p2e/core/errors/app_failure.dart';

import 'profile.dart';

/// D-102: in-process sample player; the Home source shows the initial "A".
final class FakeProfileRepository implements ProfileRepository {
  const FakeProfileRepository();
  @override
  Future<Result<Profile>> current() async =>
      const Success(Profile(displayName: 'Alex'));
}
