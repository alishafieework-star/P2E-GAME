import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

import '../features/auth/auth.dart';
import '../features/auth/auth_data.dart';
import '../core/diagnostics/app_logger.dart';
import 'config/app_config.dart';
import '../shared/platform/external_links.dart';
import '../shared/platform/one_time_code.dart';
import 'platform/external_link_adapter.dart';
import 'platform/one_time_code_adapter.dart';
import 'platform/transports.dart';
import 'platform/users_api_provider.dart';

/// Compile-time dead branch in remote builds: fake factories/marker are removed.
const _useFake =
    String.fromEnvironment(
      'BACKEND_MODE',
      defaultValue:
          String.fromEnvironment('APP_ENV', defaultValue: 'dev') == 'dev'
          ? 'fake'
          : 'remote',
    ) ==
    'fake';

List<Override> authBindings(AppConfig config) => [
  externalLinkPortProvider.overrideWithValue(SystemExternalLinks(config)),
  oneTimeCodePortProvider.overrideWithValue(const PlatformOneTimeCode()),
  oneTimeCodeAccessProvider.overrideWithValue(
    const PlatformOneTimeCodeAccess(),
  ),
  otpSmsFormatProvider.overrideWith(
    (_) => _useFake && config.backendMode == BackendMode.fake
        ? const DevOtpSmsFormat()
        : const PlayerSmsCodeFormat(),
  ),
  welcomeOfferRepositoryProvider.overrideWith((ref) {
    if (_useFake && config.backendMode == BackendMode.fake) {
      final env = FakeAuthEnvironment(
        scenario: () => ref.read(fakeAuthScenarioProvider),
        log: (scenario) => AppLogger().log(
          LogLevel.debug,
          'Auth fake',
          fields: {'scenario': scenario},
        ),
      );
      return WelcomeOfferRepositoryImpl(FakeWelcomeOfferSource(env));
    }
    return const WelcomeOfferRepositoryImpl(RemoteWelcomeOfferSource());
  }),
  phoneSignInRepositoryProvider.overrideWith((ref) {
    if (_useFake && config.backendMode == BackendMode.fake) {
      return PhoneSignInRepositoryImpl(
        HttpPhoneSignInSource(
          transport: ref.read(devOtpTransportProvider),
          base: Uri.parse(config.fakeApiBase),
        ),
      );
    }
    if (_remote(config)) {
      return PhoneSignInRepositoryImpl(
        RemotePhoneSignInSource.connected(
          ref.watch(usersApiClientProvider(_bind(config))),
        ),
      );
    }
    return const PhoneSignInRepositoryImpl(RemotePhoneSignInSource());
  }),
  emailSignInRepositoryProvider.overrideWith((ref) {
    if (_useFake && config.backendMode == BackendMode.fake) {
      final environment = FakeAuthEnvironment(
        scenario: () => ref.read(fakeAuthScenarioProvider),
      );
      return EmailSignInRepositoryImpl(
        DevEmailSignInSource(
          local: FakeEmailSignInSource(environment),
          remote: HttpEmailAuthSource(
            transport: ref.read(devOtpTransportProvider),
            base: Uri.parse(config.fakeApiBase),
          ),
        ),
      );
    }
    if (_remote(config)) {
      return EmailSignInRepositoryImpl(
        RemoteEmailSignInSource.connected(
          ref.watch(usersApiClientProvider(_bind(config))),
        ),
      );
    }
    return const EmailSignInRepositoryImpl(RemoteEmailSignInSource());
  }),
  playerSessionCheckProvider.overrideWith((ref) {
    if (_useFake && config.backendMode == BackendMode.fake) {
      return const LocalPlayerSessionCheck();
    }
    if (_remote(config)) {
      return RemotePlayerSessionCheck(
        ref.watch(usersApiClientProvider(_bind(config))),
      );
    }
    return const ClosedPlayerSessionCheck();
  }),
  accountSetupRepositoryProvider.overrideWith((ref) {
    if (_useFake && config.backendMode == BackendMode.fake) {
      return const AccountSetupRepositoryImpl(LocalAccountSetupSource());
    }
    if (_remote(config)) {
      return AccountSetupRepositoryImpl(
        RemoteAccountSetupSource.connected(
          ref.watch(usersApiClientProvider(_bind(config))),
        ),
      );
    }
    return const AccountSetupRepositoryImpl(RemoteAccountSetupSource());
  }),
  socialSignInRepositoryProvider.overrideWith((ref) {
    if (_useFake && config.backendMode == BackendMode.fake) {
      return SocialSignInRepositoryImpl(
        FakeSocialSignInSource(
          FakeAuthEnvironment(
            scenario: () => ref.read(fakeAuthScenarioProvider),
          ),
        ),
      );
    }
    return const SocialSignInRepositoryImpl(RemoteSocialSignInSource());
  }),
];

bool _remote(AppConfig config) =>
    config.backendMode == BackendMode.remote && config.remoteApiBase.isNotEmpty;

UsersApiBind _bind(AppConfig config) =>
    UsersApiBind(config.remoteApiBase, config.remoteApiOrigin);
