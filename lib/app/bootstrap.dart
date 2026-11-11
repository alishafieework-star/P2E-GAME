import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

import '../core/diagnostics/app_logger.dart';
import '../shared/platform/notification_permission.dart';
import '../shared/preferences/device_preferences.dart';
import 'app.dart';
import 'auth_bindings.dart';
import 'config/app_config.dart';
import 'home_bindings.dart';
import 'startup/remote_session_probe.dart';

import 'platform/dev_fake_stack.dart';
import 'platform/notification_permission_adapter.dart';

/// Compile-time dead branch in remote builds: the in-app fake stack is
/// removed (D-150).
const _useFake =
    String.fromEnvironment(
      'BACKEND_MODE',
      defaultValue:
          String.fromEnvironment('APP_ENV', defaultValue: 'dev') == 'dev'
          ? 'fake'
          : 'remote',
    ) ==
    'fake';

/// D-159: dev builds serve the temporary Home catalog from the in-app loopback.
const _devCatalog =
    String.fromEnvironment('APP_ENV', defaultValue: 'dev') == 'dev';

/// Neutral composition seams. Production main uses neither hook.
/// [key] lets a host replace the scope when its override set changes shape.
ProviderScope composeApp({
  Key? key,
  required AppConfig config,
  Widget Function(Widget root)? rootWrapper,
  List<Override> providerOverrides = const [],
  bool includeHomeBindings = true,
}) => ProviderScope(
  key: key,
  overrides: [
    appConfigProvider.overrideWithValue(config),
    ...authBindings(config),
    if (includeHomeBindings) ...homeBindings(config),
    ...providerOverrides,
  ],
  child: RemoteSessionRestore(
    config: config,
    child: rootWrapper?.call(const P2EApp()) ?? const P2EApp(),
  ),
);

void bootstrap({
  Widget Function(Widget root)? rootWrapper,
  List<Override> providerOverrides = const [],
}) {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment();
  if (_devCatalog || (_useFake && config.backendMode == BackendMode.fake)) {
    unawaited(_startDevFakeStack(config));
  }
  AppLogger().log(
    LogLevel.info,
    'Application bootstrap',
    fields: {'environment': config.environment.name},
  );
  runApp(
    composeApp(
      config: config,
      rootWrapper: rootWrapper,
      providerOverrides: [
        devicePreferencesRepositoryProvider.overrideWithValue(
          SharedPrefsDevicePreferences(),
        ),
        notificationPermissionPortProvider.overrideWith(
          (_) => const PermissionHandlerNotificationAdapter(),
        ),
        ...providerOverrides,
      ],
    ),
  );
}

/// D-150: loopback fake API and media origin inside the app process. A bind
/// failure (for example `adb reverse` already owning the port) falls back to
/// whatever already serves that port instead of blocking startup.
Future<void> startDevFakeStack(AppConfig config) => _startDevFakeStack(config);

Future<void> _startDevFakeStack(AppConfig config) async {
  Future<ByteData?> loadAsset(String key) async {
    for (final candidate in [key, 'packages/mygame_p2e/$key']) {
      try {
        return await rootBundle.load(candidate);
      } catch (_) {}
    }
    return null;
  }

  try {
    final api = await bindDevApiServer(
      loadAsset: loadAsset,
      mediaBase: config.fakeMediaBase,
    );
    AppLogger().log(
      LogLevel.info,
      'Dev fake API listening',
      fields: {'port': api.port},
    );
  } catch (error) {
    AppLogger().log(
      LogLevel.warning,
      'Dev fake API unavailable',
      fields: {'error': error.toString()},
    );
  }
  try {
    final media = await bindDevMediaServer(loadAsset: loadAsset);
    AppLogger().log(
      LogLevel.info,
      'Dev fake media listening',
      fields: {'port': media.port},
    );
  } catch (error) {
    AppLogger().log(
      LogLevel.warning,
      'Dev fake media unavailable',
      fields: {'error': error.toString()},
    );
  }
}
