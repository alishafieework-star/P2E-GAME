import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/auth.dart';
import '../../features/auth/auth_data.dart';
import '../../shared/session/session.dart';
import '../config/app_config.dart';
import '../platform/transports.dart';
import '../platform/users_api_provider.dart';
import 'registration_resume.dart';

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
    await ref.read(jsonHttpTransportProvider).ready;
    if (!mounted) return;
    if (ref.read(sessionControllerProvider) != SessionStatus.signedOut) return;
    final client = ref.read(
      usersApiClientProvider(
        UsersApiBind(config.remoteApiBase, config.remoteApiOrigin),
      ),
    );
    final signedIn = await client.restorePlayer();
    if (!mounted) return;
    if (ref.read(sessionControllerProvider) != SessionStatus.signedOut) return;
    if (signedIn) {
      ref
          .read(sessionControllerProvider.notifier)
          .update(SessionStatus.signedIn);
      return;
    }
    final resume = await client.resumeRegistration();
    if (!mounted) return;
    if (ref.read(sessionControllerProvider) != SessionStatus.signedOut) return;
    final flow = resume == null ? null : _resumeFlow(resume);
    if (flow == null) return;
    ref.read(authFlowProvider.notifier).accept(flow);
    ref.read(registrationResumeLockProvider.notifier).engage();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authFlowProvider, (_, _) {});
    return widget.child;
  }
}

AuthFlowResult? _resumeFlow(RegistrationResume resume) {
  if (resume.step <= 2) {
    final challenge = resume.challenge?.toDomain();
    if (challenge == null) return null;
    return AccountJourney(
      AuthStep.verify,
      phoneRaw: resume.maskedMobile,
      challenge: challenge,
    );
  }
  if (resume.step == 3) {
    return AccountJourney(
      AuthStep.username,
      phoneRaw: resume.maskedMobile,
      username: resume.userName,
    );
  }
  if (resume.userName.isEmpty) return null;
  return AccountJourney(
    AuthStep.createPassword,
    phoneRaw: resume.maskedMobile,
    username: resume.userName,
  );
}
