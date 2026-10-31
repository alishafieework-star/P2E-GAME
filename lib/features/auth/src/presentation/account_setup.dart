import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories.dart';

/// Overridden in app composition. Screens read it only while setting up an account.
final accountSetupRepositoryProvider = Provider<AccountSetupRepository>(
  (ref) => throw StateError('Auth composition missing'),
);
