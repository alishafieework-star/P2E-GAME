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
        : null,
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
    return const EmailSignInRepositoryImpl(RemoteEmailSignInSource());
  }),
  accountSetupRepositoryProvider.overrideWith((ref) {
    if (_useFake && config.backendMode == BackendMode.fake) {
      return const AccountSetupRepositoryImpl(LocalAccountSetupSource());
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
