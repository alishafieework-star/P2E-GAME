import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/app/config/app_config.dart';
import 'package:mygame_p2e/features/auth/auth_data.dart';
import 'package:mygame_p2e/shared/backend/json_transport.dart';

void main() {
  test('remote base is validated and does not select fake', () {
    expect(
      AppConfig.fromValues({'APP_ENV': 'prod', 'BACKEND_MODE': 'remote'})
          .remoteApiBase,
      isEmpty,
    );
    expect(
      () => AppConfig.fromValues({
        'REMOTE_API_BASE': 'http://127.0.0.1:4029/api/users/',
      }),
      throwsFormatException,
    );
    expect(
      AppConfig.fromValues({
        'APP_ENV': 'stage',
        'REMOTE_API_BASE': 'http://127.0.0.1:4029/api/users',
        'REMOTE_API_ORIGIN': 'https://player.dev.p2e.example.com',
      }).remoteApiOrigin,
      'https://player.dev.p2e.example.com',
    );
    expect(
      () => AppConfig.fromValues({
        'REMOTE_API_ORIGIN': 'https://player.dev.p2e.example.com/',
      }),
      throwsFormatException,
    );
  });

  test(
    'registration uses SendCode, full OTP and Complete password only',
    () async {
      final transport = _Script();
      final client = UsersApiClient(
        base: Uri.parse('http://127.0.0.1:4029/api/users'),
        origin: 'https://player.dev.p2e.example.com',
        transport: transport,
        nextRequestId: () => '00000000-0000-4000-8000-000000000000',
      );
      transport.enqueue(
        200,
        _ok({'exists': false, 'identifierKind': 1, 'canUseOtp': false}),
      );
      final status = await client.resolvePhone('+989121234567', null);
      expect(status.status, PhoneAccountStatus.notRegistered);

      transport.enqueue(
        200,
        _ok({
          'challengeId': 'ch-1',
          'codePrefix': 'GAME-',
          'codeDigits': 8,
          'resendAfterSeconds': 30,
          'expiresAtUtc': '2026-11-09T12:00:00Z',
        }),
      );
      final challenge = await client.sendPhoneCode('+989121234567', true, null);
      expect(challenge.prefix, 'GAME-');
      expect(challenge.length, 8);
      expect(challenge.toDomain().codeLength, 8);
      final send = transport.calls.last;
      expect(send.uri.path, '/api/users/general/player-registration/SendCode');
      expect(send.body, {
        'mobile': '9121234567',
        'requestId': '00000000-0000-4000-8000-000000000000',
      });
      expect(send.headers['x-player-auth'], '1');
      expect(send.headers['origin'], 'https://player.dev.p2e.example.com');

      transport.enqueue(200, _ok(null));
      await client.verifyLoginCode('ch-1', '12345678', null);
      expect(transport.calls.last.body, {
        'challengeId': 'ch-1',
        'code': 'GAME-12345678',
      });

      transport.enqueue(
        200,
        _ok({
          'available': false,
          'suggestions': ['nova_r'],
        }),
      );
      final names = await client.checkUsername('Nova', null);
      expect(names.available, isFalse);
      expect(names.suggestions, ['nova_r']);
      expect(transport.calls.last.body, {
        'challengeId': 'ch-1',
        'userName': 'nova',
      });

      transport.enqueue(200, _ok(null));
      transport.enqueue(200, _ok({'registered': true, 'loginRequired': true}));
      await client.completeRegistration({
        'username': 'Nova',
        'password': 'Abcdefghijk1!',
        'email': 'skip@example.com',
        'avatarCharacter': 2,
      }, null);
      expect(
        transport.calls[transport.calls.length - 2].uri.path,
        endsWith('SaveUserName'),
      );
      expect(transport.calls.last.uri.path, endsWith('Complete'));
      expect(transport.calls.last.body, {
        'challengeId': 'ch-1',
        'password': 'Abcdefghijk1!',
      });
    },
  );

  test('password login and OTP login stay on PlayerLogin', () async {
    final transport = _Script();
    final client = UsersApiClient(
      base: Uri.parse('https://player.example/api/users'),
      transport: transport,
    );
    transport.enqueue(200, _ok({'mustChangePassword': false}));
    await client.signIn('9121234567', 'secret-pass', true, null);
    expect(transport.calls.single.body, {
      'method': 1,
      'identifier': '9121234567',
      'password': 'secret-pass',
      'remember': true,
    });

    transport.enqueue(
      200,
      _ok({
        'challengeId': 'ch-2',
        'codePrefix': 'GAME-',
        'codeDigits': 8,
        'resendAfterSeconds': 1,
        'expiresAtUtc': '2026-11-09T12:00:00Z',
      }),
    );
    await client.sendLoginCode('ada@example.com', false, null);
    transport.enqueue(200, _ok({'mustChangePassword': false}));
    await client.verifyLoginCode('ch-2', '12345678', null);
    expect(transport.calls.last.body, {
      'method': 2,
      'challengeId': 'ch-2',
      'code': 'GAME-12345678',
      'remember': false,
    });
  });

  test(
    'reset stays not configured and forced password change does not sign in',
    () async {
      final source = RemotePhoneSignInSource.connected(
        UsersApiClient(
          base: Uri.parse('https://player.example/api/users'),
          transport: _Script(),
        ),
      );
      await expectLater(
        source.requestReset('+989121234567', false, null),
        throwsA(
          isA<AuthDataException>().having(
            (error) => error.fault,
            'fault',
            AuthDataFault.notConfigured,
          ),
        ),
      );
      final transport = _Script()
        ..enqueue(
          200,
          _ok({'mustChangePassword': true, 'changeTicket': 'ticket-1'}),
        );
      final client = UsersApiClient(
        base: Uri.parse('https://player.example/api/users'),
        transport: transport,
      );
      await expectLater(
        client.signIn('ada@example.com', 'secret-pass', false, null),
        throwsA(
          isA<AuthDataException>().having(
            (error) => error.fault,
            'fault',
            AuthDataFault.server,
          ),
        ),
      );
      transport.enqueue(
        200,
        _ok({'mustChangePassword': false, 'loginRequired': true}),
      );
      await client.createPassword('Abcdefghijk1!', null);
      expect(transport.calls.last.body, {
        'changeTicket': 'ticket-1',
        'newPassword': 'Abcdefghijk1!',
        'remember': false,
      });
    },
  );

  test('Me restores only userType 4 and maps panel errors', () async {
    final transport = _Script();
    final client = UsersApiClient(
      base: Uri.parse('https://player.example/api/users'),
      transport: transport,
    );
    transport.enqueue(200, _ok({'id': 7, 'userType': 4, 'fullName': 'Ada'}));
    expect(await client.restorePlayer(), isTrue);
    expect(transport.calls.single.method, JsonMethod.get);

    transport.enqueue(200, _ok({'id': 7, 'userType': 1, 'fullName': 'Ada'}));
    expect(await client.restorePlayer(), isFalse);
    transport.enqueue(401, _fail('INVALID_CREDENTIALS'));
    expect(await client.restorePlayer(), isFalse);

    transport.enqueue(400, _fail('INVALID_OR_EXPIRED_CODE'));
    expect(
      () => client.signIn('ada@example.com', 'x', false, null),
      throwsA(
        isA<AuthDataException>().having(
          (error) => error.fault,
          'fault',
          AuthDataFault.invalidCode,
        ),
      ),
    );
    transport.enqueue(
      429,
      _fail('PLAYER_RATE_LIMIT'),
      headers: const {'retry-after': '2'},
    );
    expect(
      () => client.signIn('ada@example.com', 'x', false, null),
      throwsA(
        isA<AuthDataException>().having(
          (error) => error.fault,
          'fault',
          AuthDataFault.rateLimited,
        ),
      ),
    );
    transport.enqueue(200, jsonEncode({'status': 1, 'data': {}}));
    expect(
      () => client.signIn('ada@example.com', 'x', false, null),
      throwsA(isA<AuthDataException>()),
    );
  });

  test('logout posts then clears the transport session', () async {
    var cleared = 0;
    final transport = _Script()..enqueue(200, _ok(null));
    final client = UsersApiClient(
      base: Uri.parse('https://player.example/api/users'),
      transport: transport,
      clearSession: () => cleared++,
    );
    await client.logout();
    expect(transport.calls.single.uri.path, endsWith('Logout'));
    expect(cleared, 1);
  });
}

String _ok(Object? data) => jsonEncode({'status': 200, 'data': data});

String _fail(String code) => jsonEncode({'status': 400, 'errorCode': code});

final class _Call {
  _Call(this.method, this.uri, this.body, this.headers);
  final JsonMethod method;
  final Uri uri;
  final Object? body;
  final Map<String, String> headers;
}

final class _Script implements JsonHttpTransport {
  final calls = <_Call>[];
  final _responses = <JsonHttpResponse>[];

  void enqueue(
    int status,
    String body, {
    Map<String, String> headers = const {},
  }) {
    _responses.add(
      JsonHttpResponse(status: status, body: body, headers: headers),
    );
  }

  @override
  Future<JsonHttpResponse> send({
    required Uri uri,
    required JsonMethod method,
    Map<String, String> headers = const {},
    Object? body,
    Duration? timeout,
    void Function(void Function() abort)? attachAbort,
  }) async {
    calls.add(_Call(method, uri, body, headers));
    return _responses.removeAt(0);
  }
}
