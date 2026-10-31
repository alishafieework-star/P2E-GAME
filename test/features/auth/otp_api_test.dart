import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/platform/dev_otp_server.dart';
import 'package:mygame_p2e/app/platform/dev_otp_transport.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/features/auth/auth_data.dart';

void main() {
  test('username endpoint is case-insensitive and suggests free names', () {
    final taken = DevOtpApi.handle(
      const OtpApiRequest(
        method: 'POST',
        path: '/auth/account/username',
        body: '{"username":"Ardeshir"}',
      ),
    );
    expect(taken.body.contains('"suggestions":['), isTrue);
    expect(taken.body.contains('"suggestions":[]'), isFalse);
    final ideas = DevOtpApi.suggest('ardeshir');
    expect(ideas.length, inInclusiveRange(1, 3));
    expect(ideas.every((n) => !DevOtpApi.takenNames.contains(n)), isTrue);
  });
  test('handler accepts only P12345 and does not echo the code', () {
    final rejected = DevOtpApi.handle(
      const OtpApiRequest(
        method: 'POST',
        path: '/auth/otp/verify',
        body: '{"challengeId":"dev-challenge-1","code":"P00000"}',
      ),
    );
    expect(rejected.status, 422);
    expect(rejected.body, '{"error":"invalid_code"}');
    expect(rejected.body.contains('P00000'), isFalse);
    final accepted = DevOtpApi.handle(
      const OtpApiRequest(
        method: 'POST',
        path: '/auth/otp/verify',
        body: '{"challengeId":"dev-challenge-1","code":"P12345"}',
      ),
    );
    expect(accepted.status, 200);
    expect(accepted.body, '{"verified":true}');
    final wrongPassword = DevOtpApi.handle(
      const OtpApiRequest(
        method: 'POST',
        path: '/auth/email/password',
        body: '{"email":"user@example.com","password":"nope"}',
      ),
    );
    expect(wrongPassword.status, 422);
    expect(wrongPassword.body.contains('nope'), isFalse);
    final password = DevOtpApi.handle(
      const OtpApiRequest(
        method: 'POST',
        path: '/auth/email/password',
        body: '{"email":"user@example.com","password":"P12345"}',
      ),
    );
    expect(password.status, 200);
    expect(password.body.contains('P12345'), isFalse);
    final reset = DevOtpApi.handle(
      const OtpApiRequest(
        method: 'POST',
        path: '/auth/email/reset/request',
        body: '{"destination":"user@example.com"}',
      ),
    );
    expect(reset.status, 200);
    expect(reset.body.contains('user@example.com'), isFalse);
    expect(reset.body.contains('u•••@example.com'), isTrue);
    final created = DevOtpApi.handle(
      const OtpApiRequest(
        method: 'POST',
        path: '/auth/email/password/create',
        body: '{"email":"new.person@example.com","password":"GoodPass1!"}',
      ),
    );
    expect(created.status, 200);
    expect(created.body.contains('GoodPass1!'), isFalse);
    final oldCode = DevOtpApi.handle(
      const OtpApiRequest(
        method: 'POST',
        path: '/auth/email/password',
        body: '{"email":"new.person@example.com","password":"P12345"}',
      ),
    );
    expect(oldCode.status, 422);
    final signedIn = DevOtpApi.handle(
      const OtpApiRequest(
        method: 'POST',
        path: '/auth/email/password',
        body: '{"email":"new.person@example.com","password":"GoodPass1!"}',
      ),
    );
    expect(signedIn.status, 200);
    DevOtpApi.passwords.clear();
  });

  test('loopback server issues and checks an OTP challenge', () async {
    final server = await bindDevOtpServer(port: 0);
    final transport = IoDevOtpTransport(
      HttpOverrides.runWithHttpOverrides(HttpClient.new, _RealHttp()),
    );
    addTearDown(() async {
      transport.close();
      try {
        await server.close(force: true);
      } catch (_) {}
    });
    final repository = PhoneSignInRepositoryImpl(
      HttpPhoneSignInSource(
        transport: transport,
        base: Uri.parse('http://127.0.0.1:${server.port}'),
      ),
    );
    final phone = IdentifierClassifier.classify('09123456789') as Phone;
    final requested = await repository.requestOtp(phone, rememberDevice: false);
    final challenge = (requested as Success<OtpChallenge>).value;
    expect(challenge.codeLength, 6);
    expect(challenge.resendAfter, const Duration(seconds: 94));
    expect(challenge.maskedDestination, isNot(contains(phone.e164)));
    expect(
      await repository.verifyOtp(challenge, 'P00000'),
      isA<Failure<void>>().having(
        (failure) => failure.error,
        'error',
        isA<ValidationFailure>(),
      ),
    );
    expect(
      await repository.verifyOtp(challenge, 'P12345'),
      isA<Success<void>>(),
    );
    expect(
      await repository.resendOtp(phone, rememberDevice: true),
      isA<Success<OtpChallenge>>(),
    );
    await server.close(force: true);
    expect(
      (await repository.requestOtp(
        phone,
        rememberDevice: false,
      ) as Failure).error,
      isA<OfflineFailure>(),
    );
  });
}

final class _RealHttp extends HttpOverrides {}
