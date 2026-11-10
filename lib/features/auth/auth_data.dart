/// Composition-root entrypoint, never imported by presentation.
library;

export 'src/domain/models.dart';
export 'src/data/sources.dart';
export 'src/data/repositories.dart';
export 'src/data/remote/stub_sources.dart';
export 'src/data/remote/users_api_client.dart';
export 'src/data/fake/fake_sources.dart';
export 'src/data/fake/http_phone_source.dart';
export 'src/data/fake/http_email_source.dart';
export 'src/data/fake/dev_otp_sms_format.dart';
export 'src/data/fake/otp_api.dart';
export 'src/data/fake/scenario_provider.dart';
