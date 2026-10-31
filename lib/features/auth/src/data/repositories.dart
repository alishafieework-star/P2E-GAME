import 'package:mygame_p2e/core/errors/app_failure.dart';

import '../domain/identifier.dart';
import '../domain/models.dart';
import '../domain/repositories.dart';
import 'sources.dart';

Future<Result<T>> _map<T, D>(
  Future<D> Function() request,
  T Function(D) map,
) async {
  try {
    return Success(map(await request()));
  } on AuthDataException catch (e) {
    return Failure(switch (e.fault) {
      AuthDataFault.blocked => ValidationFailure({'identifier': 'blocked'}),
      AuthDataFault.invalidCode => ValidationFailure({'otp': 'invalid'}),
      AuthDataFault.invalidPassword => ValidationFailure({
        'password': 'invalid',
      }),
      AuthDataFault.rateLimited => ValidationFailure({
        'identifier': 'rate_limited',
      }),
      AuthDataFault.offline => const OfflineFailure(),
      AuthDataFault.server => const ServerFailure(),
      AuthDataFault.notConfigured => const BusinessFailure(
        'backend_not_configured',
      ),
      AuthDataFault.unavailable => const BusinessFailure('social_unavailable'),
      AuthDataFault.cancelled => const BusinessFailure('cancelled'),
    });
  } catch (_) {
    return const Failure(UnknownFailure());
  }
}

final class WelcomeOfferRepositoryImpl implements WelcomeOfferRepository {
  const WelcomeOfferRepositoryImpl(this.source);
  final WelcomeOfferSource source;
  @override
  Future<Result<WelcomeOffer>> load({AuthCancellation? cancellation}) =>
      _map(() => source.load(cancellation), (dto) => dto.toDomain());
}

final class PhoneSignInRepositoryImpl implements PhoneSignInRepository {
  const PhoneSignInRepositoryImpl(this.source);
  final PhoneSignInSource source;
  @override
  Future<Result<PhoneAccountStatus>> checkPhone(
    Phone phone, {
    AuthCancellation? cancellation,
  }) => _map(
    () => source.checkPhone(phone.e164, cancellation),
    (dto) => dto.toDomain(),
  );
  @override
  Future<Result<void>> signInPhone(
    Phone phone,
    String password, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => _map<void, void>(
    () => source.signIn(phone.e164, password, rememberDevice, cancellation),
    (_) {},
  );
  @override
  Future<Result<OtpChallenge>> requestPhoneReset(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => _map(
    () => source.requestReset(phone.e164, rememberDevice, cancellation),
    (dto) => dto.toDomain(),
  );
  @override
  Future<Result<OtpChallenge>> resendPhoneReset(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => _map(
    () => source.resendReset(phone.e164, rememberDevice, cancellation),
    (dto) => dto.toDomain(),
  );
  @override
  Future<Result<void>> verifyPhoneReset(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) => _map<void, void>(
    () => source.verifyReset(challenge.challengeId, code, cancellation),
    (_) {},
  );
  @override
  Future<Result<void>> createPhonePassword(
    Phone phone,
    String password, {
    AuthCancellation? cancellation,
  }) => _map<void, void>(
    () => source.createPassword(phone.e164, password, cancellation),
    (_) {},
  );
  @override
  Future<Result<OtpChallenge>> requestOtp(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => _map(
    () => source.requestOtp(phone.e164, rememberDevice, cancellation),
    (dto) => dto.toDomain(),
  );
  @override
  Future<Result<OtpChallenge>> resendOtp(
    Phone phone, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => _map(
    () => source.resendOtp(phone.e164, rememberDevice, cancellation),
    (dto) => dto.toDomain(),
  );
  @override
  Future<Result<void>> verifyOtp(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) => _map<void, void>(
    () => source.verifyOtp(challenge.challengeId, code, cancellation),
    (_) {},
  );
}

final class EmailSignInRepositoryImpl implements EmailSignInRepository {
  const EmailSignInRepositoryImpl(this.source);
  final EmailSignInSource source;
  @override
  Future<Result<EmailAccountStatus>> checkEmail(
    Email email, {
    AuthCancellation? cancellation,
  }) => _map(
    () => source.checkEmail(email.normalized, cancellation),
    (dto) => dto.toDomain(),
  );
  @override
  Future<Result<void>> signIn(
    Email email,
    String password, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => _map<void, void>(
    () =>
        source.signIn(email.normalized, password, rememberDevice, cancellation),
    (_) {},
  );
  @override
  Future<Result<OtpChallenge>> requestReset(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => _map(
    () => source.requestReset(email.normalized, rememberDevice, cancellation),
    (dto) => dto.toDomain(),
  );
  @override
  Future<Result<OtpChallenge>> resendReset(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => _map(
    () => source.resendReset(email.normalized, rememberDevice, cancellation),
    (dto) => dto.toDomain(),
  );
  @override
  Future<Result<void>> verifyReset(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) => _map<void, void>(
    () => source.verifyReset(challenge.challengeId, code, cancellation),
    (_) {},
  );
  @override
  Future<Result<void>> createPassword(
    Email email,
    String password, {
    AuthCancellation? cancellation,
  }) => _map<void, void>(
    () => source.createPassword(email.normalized, password, cancellation),
    (_) {},
  );
  @override
  Future<Result<OtpChallenge>> requestVerification(
    Email email, {
    required bool rememberDevice,
    AuthCancellation? cancellation,
  }) => _map(
    () => source.requestVerification(
      email.normalized,
      rememberDevice,
      cancellation,
    ),
    (dto) => dto.toDomain(),
  );
  @override
  Future<Result<void>> verifyRegistration(
    OtpChallenge challenge,
    String code, {
    AuthCancellation? cancellation,
  }) => _map<void, void>(
    () => source.verifyRegistration(challenge.challengeId, code, cancellation),
    (_) {},
  );
}

final class AccountSetupRepositoryImpl implements AccountSetupRepository {
  const AccountSetupRepositoryImpl(this.source);
  final AccountSetupSource source;
  @override
  Future<Result<UsernameCheck>> checkUsername(
    String username, {
    AuthCancellation? cancellation,
  }) => _map(
    () => source.checkUsername(username, cancellation),
    (dto) => dto.toDomain(),
  );
  @override
  Future<Result<List<String>>> usernameIdeas(
    String base, {
    AuthCancellation? cancellation,
  }) => _map(() => source.usernameIdeas(base, cancellation), (names) => names);
  @override
  Future<Result<void>> complete({
    required String username,
    required String password,
    String? email,
    String? phone,
    int avatarCharacter = 0,
    int avatarTheme = 0,
    AuthCancellation? cancellation,
  }) => _map<void, void>(
    () => source.complete({
      'username': username,
      'password': password,
      'email': ?email,
      'phone': ?phone,
      'avatarCharacter': avatarCharacter,
      'avatarTheme': avatarTheme,
    }, cancellation),
    (_) {},
  );
}

final class SocialSignInRepositoryImpl implements SocialSignInRepository {
  const SocialSignInRepositoryImpl(this.source);
  final SocialSignInSource source;
  @override
  Future<Result<void>> start(
    SocialProvider provider, {
    AuthCancellation? cancellation,
  }) => _map<void, SocialStartDto>(
    () => source.start(provider, cancellation),
    (_) {},
  );
}
