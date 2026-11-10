import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/auth_data.dart';
import 'transports.dart';

/// Base URL plus the allow-listed browser origin (D-153).
final class UsersApiBind {
  const UsersApiBind(this.base, this.origin);
  final String base;
  final String origin;

  @override
  bool operator ==(Object other) =>
      other is UsersApiBind && other.base == base && other.origin == origin;

  @override
  int get hashCode => Object.hash(base, origin);
}

/// One client per bind so registration challenge state is shared (D-152).
final usersApiClientProvider = Provider.family<UsersApiClient, UsersApiBind>((
  ref,
  bind,
) {
  final transport = ref.watch(jsonHttpTransportProvider);
  return UsersApiClient(
    base: Uri.parse(bind.base),
    origin: bind.origin,
    transport: transport,
    clearSession: transport.clearSession,
  );
});
