import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One-shot cold-start redirect onto an in-progress registration step (D-154).
class RegistrationResumeLock extends Notifier<bool> {
  @override
  bool build() => false;

  void engage() => state = true;
}

final registrationResumeLockProvider =
    NotifierProvider<RegistrationResumeLock, bool>(RegistrationResumeLock.new);
