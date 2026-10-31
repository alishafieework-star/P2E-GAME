import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/preferences/device_preferences.dart';
import '../../shared/session/session.dart';

part 'startup_controller.g.dart';

enum StartupState { initializing, sessionCheck, onboarding, entry, ready }

enum SplashGate { covering, collapsed }

/// The splash overlay releases the next route when the logo has collapsed.
class SplashGateController extends Notifier<SplashGate> {
  @override
  SplashGate build() => SplashGate.covering;

  void collapse() {
    if (state != SplashGate.collapsed) state = SplashGate.collapsed;
  }
}

final splashGateProvider = NotifierProvider<SplashGateController, SplashGate>(
  SplashGateController.new,
);

/// Architecture §11.3: gates derive only from shared read models.
@riverpod
class StartupController extends _$StartupController {
  int _generation = 0;

  @override
  StartupState build() {
    final session = ref.watch(sessionControllerProvider);
    final splash = ref.watch(splashGateProvider);
    // Only the onboarding flag steers startup; saving other preferences
    // (notifications asked, tour pending) must not restart the gate.
    final onboardingSeen = ref.watch(
      devicePreferencesProvider.select((value) => value.value?.onboardingSeen),
    );
    final generation = ++_generation;
    if (splash != SplashGate.collapsed || onboardingSeen == null) {
      return StartupState.initializing;
    }
    final destination = _destination(session, onboardingSeen);
    scheduleMicrotask(() {
      if (!ref.mounted || generation != _generation) return;
      state = StartupState.sessionCheck;
      scheduleMicrotask(() {
        if (!ref.mounted || generation != _generation) return;
        state = destination;
      });
    });
    return generation == 1
        ? StartupState.initializing
        : StartupState.sessionCheck;
  }
}

StartupState _destination(SessionStatus session, bool onboardingSeen) {
  if (session == SessionStatus.signedIn) return StartupState.ready;
  if (!onboardingSeen) return StartupState.onboarding;
  return StartupState.entry;
}
