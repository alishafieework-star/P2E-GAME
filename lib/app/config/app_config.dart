import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

enum AppEnvironment { dev, stage, prod }

enum BackendMode { fake, remote }

/// Compile-time environment selection; never contains secrets.
final class AppConfig {
  const AppConfig({
    required this.environment,
    BackendMode? backendMode,
    this.termsUrl = '',
    this.privacyUrl = '',
    this.fakeApiBase = 'http://127.0.0.1:8787',
    this.fakeMediaBase = 'http://127.0.0.1:8788',
    this.remoteApiBase = '',
    this.remoteApiOrigin = '',
  }) : backendMode =
           backendMode ??
           (environment == AppEnvironment.dev
               ? BackendMode.fake
               : BackendMode.remote);
  final AppEnvironment environment;
  final BackendMode backendMode;
  final String termsUrl, privacyUrl;

  /// D-068: development OTP origin. Production never selects the fake mode.
  final String fakeApiBase;

  /// D-102: development origin for sample Home artwork; never bundled.
  final String fakeMediaBase;

  /// D-152: UsersService origin without a trailing slash.
  /// Empty keeps remote sources unconfigured. It does not select the fake mode.
  final String remoteApiBase;

  /// D-153: `Origin` header the Users policy allow-lists. No path.
  final String remoteApiOrigin;

  factory AppConfig.fromValues(Map<String, String> values) {
    final environment = AppEnvironment.values.firstWhere(
      (e) => e.name == (values['APP_ENV'] ?? 'dev'),
      orElse: () => throw const FormatException('Invalid APP_ENV'),
    );
    final mode = BackendMode.values.firstWhere(
      (e) =>
          e.name ==
          (values['BACKEND_MODE'] ??
              (environment == AppEnvironment.dev ? 'fake' : 'remote')),
      orElse: () => throw const FormatException('Invalid BACKEND_MODE'),
    );
    if (environment == AppEnvironment.prod && mode == BackendMode.fake) {
      throw const FormatException('Production cannot use fake backend');
    }
    final fakeApiBase = values['FAKE_API_BASE'] ?? 'http://127.0.0.1:8787';
    final fakeMediaBase = values['FAKE_MEDIA_BASE'] ?? 'http://127.0.0.1:8788';
    final remoteApiBase = values['REMOTE_API_BASE'] ?? '';
    if (remoteApiBase.isNotEmpty) {
      if (remoteApiBase.endsWith('/')) {
        throw const FormatException('REMOTE_API_BASE must not end with /');
      }
      final remoteUri = Uri.tryParse(remoteApiBase);
      if (remoteUri == null ||
          (remoteUri.scheme != 'http' && remoteUri.scheme != 'https') ||
          remoteUri.host.isEmpty) {
        throw const FormatException('Invalid REMOTE_API_BASE');
      }
    }
    final remoteApiOrigin = values['REMOTE_API_ORIGIN'] ?? '';
    if (remoteApiOrigin.isNotEmpty) {
      if (remoteApiOrigin.endsWith('/')) {
        throw const FormatException('REMOTE_API_ORIGIN must not end with /');
      }
      final originUri = Uri.tryParse(remoteApiOrigin);
      if (originUri == null ||
          (originUri.scheme != 'http' && originUri.scheme != 'https') ||
          originUri.host.isEmpty ||
          originUri.path.isNotEmpty ||
          originUri.hasQuery ||
          originUri.hasFragment) {
        throw const FormatException('Invalid REMOTE_API_ORIGIN');
      }
    }
    for (final (key, value) in [
      ('FAKE_API_BASE', fakeApiBase),
      ('FAKE_MEDIA_BASE', fakeMediaBase),
    ]) {
      final fakeUri = Uri.tryParse(value);
      if (fakeUri == null ||
          (fakeUri.scheme != 'http' && fakeUri.scheme != 'https') ||
          fakeUri.host.isEmpty) {
        throw FormatException('Invalid $key');
      }
    }
    for (final key in ['TERMS_URL', 'PRIVACY_URL']) {
      final url = values[key] ?? '';
      if (url.isNotEmpty) {
        final uri = Uri.tryParse(url);
        if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
          throw FormatException('Invalid $key');
        }
      }
    }
    return AppConfig(
      environment: environment,
      backendMode: mode,
      termsUrl: values['TERMS_URL'] ?? '',
      privacyUrl: values['PRIVACY_URL'] ?? '',
      fakeApiBase: fakeApiBase,
      fakeMediaBase: fakeMediaBase,
      remoteApiBase: remoteApiBase,
      remoteApiOrigin: remoteApiOrigin,
    );
  }
  factory AppConfig.fromEnvironment() {
    final config = AppConfig.fromValues({
      'APP_ENV': const String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
      'BACKEND_MODE': const String.fromEnvironment(
        'BACKEND_MODE',
        defaultValue:
            String.fromEnvironment('APP_ENV', defaultValue: 'dev') == 'dev'
            ? 'fake'
            : 'remote',
      ),
      'TERMS_URL': const String.fromEnvironment('TERMS_URL'),
      'PRIVACY_URL': const String.fromEnvironment('PRIVACY_URL'),
      'FAKE_API_BASE': const String.fromEnvironment(
        'FAKE_API_BASE',
        defaultValue: 'http://127.0.0.1:8787',
      ),
      'FAKE_MEDIA_BASE': const String.fromEnvironment(
        'FAKE_MEDIA_BASE',
        defaultValue: 'http://127.0.0.1:8788',
      ),
      'REMOTE_API_BASE': const String.fromEnvironment('REMOTE_API_BASE'),
      'REMOTE_API_ORIGIN': const String.fromEnvironment('REMOTE_API_ORIGIN'),
    });
    if (config.backendMode == BackendMode.remote &&
        config.remoteApiBase.isEmpty) {
      throw const FormatException(
        'REMOTE_API_BASE is required when BACKEND_MODE is remote',
      );
    }
    if (config.backendMode == BackendMode.remote &&
        config.remoteApiOrigin.isEmpty) {
      throw const FormatException(
        'REMOTE_API_ORIGIN is required when BACKEND_MODE is remote',
      );
    }
    return config;
  }
}

@Riverpod(keepAlive: true, dependencies: [])
AppConfig appConfig(Ref ref) =>
    throw StateError('AppConfig must be supplied by bootstrap');
