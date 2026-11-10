import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/session/session.dart';
import '../config/app_config.dart';
import '../platform/users_api_provider.dart';

/// D-152: cold start asks `GET general/auth/Me`. A player (`userType` 4)
/// restores `signedIn`. Network failures stay signed out. A journey that
/// already signed in is left alone (D-139).
class RemoteSessionRestore extends ConsumerStatefulWidget {
  const RemoteSessionRestore({
    required this.config,
    required this.child,
    super.key,
  });

  final AppConfig config;
  final Widget child;

  @override
  ConsumerState<RemoteSessionRestore> createState() =>
      _RemoteSessionRestoreState();
}

class _RemoteSessionRestoreState extends ConsumerState<RemoteSessionRestore> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _restore();
    });
  }

  Future<void> _restore() async {
    final config = widget.config;
    if (config.backendMode != BackendMode.remote ||
        config.remoteApiBase.isEmpty) {
      return;
    }
    if (ref.read(sessionControllerProvider) != SessionStatus.signedOut) return;
    final client = ref.read(
      usersApiClientProvider(
        UsersApiBind(config.remoteApiBase, config.remoteApiOrigin),
      ),
    );
    final signedIn = await client.restorePlayer();
    if (!mounted) return;
    if (ref.read(sessionControllerProvider) != SessionStatus.signedOut) return;
    if (!signedIn) return;
    ref.read(sessionControllerProvider.notifier).update(SessionStatus.signedIn);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
