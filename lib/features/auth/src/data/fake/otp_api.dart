import 'dart:convert';
import 'dart:math';

import '../../domain/models.dart';
import '../sources.dart';

/// D-068: pure development OTP contract. No socket and no logging of the body.
final class OtpApiRequest {
  const OtpApiRequest({
    required this.method,
    required this.path,
    required this.body,
  });
  final String method, path, body;
}

final class OtpApiResponse {
  const OtpApiResponse(this.status, this.body);
  final int status;
  final String body;
}

/// Feature data calls this. The socket implementation stays in app/platform.
abstract interface class DevOtpTransport {
  Future<OtpApiResponse> post(
    Uri uri,
    String jsonBody,
    AuthCancellation? cancellation,
  );
}

abstract final class DevOtpApi {
  static const acceptedCode = 'P12345';
  static const resendSeconds = 94;
  static const port = 8787;

  /// Replaceable in tests so suggestion output is deterministic.
  static Random random = Random();

  /// HTML `suggest()`: up to three free names built from [base].
  static List<String> suggest(String base) {
    final cleaned = base.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
    final short = cleaned.length > 11 ? cleaned.substring(0, 11) : cleaned;
    final root = short.isEmpty ? 'player' : short;
    final candidates = <String>{
      '${root}_r',
      '${root}_${1000 + random.nextInt(8999)}',
      '${root}_rash',
      '${root}_gg',
      '$root${10 + random.nextInt(89)}',
    };
    return [
      for (final name in candidates)
        if (name.length >= 3 && name.length <= 16 && !takenNames.contains(name))
          name,
    ].take(3).toList();
  }

  /// Emails that have set a password. Others still accept [acceptedCode].
  static final passwords = <String, String>{};

  /// HTML taken names. Suggestions are derived from the rejected name.
  static final takenNames = <String>{
    'ardeshir',
    'ardeshir_r',
    'admin',
    'player',
    'gamer',
    'nova',
    'test',
  };

  static const maxAttempts = 5;
  static const lockDuration = Duration(seconds: 30);
  static final _attempts = <String, int>{};
  static final _lockedUntil = <String, DateTime>{};

  /// Phones ending in 1111 have a password. Phones ending in 2222 are new.
  static PhoneAccountStatus phoneStatus(String e164) {
    if (e164.endsWith('1111')) {
      return PhoneAccountStatus.registeredWithPassword;
    }
    if (e164.endsWith('2222')) return PhoneAccountStatus.notRegistered;
    return PhoneAccountStatus.registered;
  }

  static const phonePassword = 'Play123!';

  static void debugReset() {
    passwords.clear();
    _attempts.clear();
    _lockedUntil.clear();
    takenNames
      ..clear()
      ..addAll({
        'ardeshir',
        'ardeshir_r',
        'admin',
        'player',
        'gamer',
        'nova',
        'test',
      });
  }

  static String passwordFor(String email) => passwords[email] ?? acceptedCode;

  static bool passwordAcceptable(String password) =>
      password.length >= 8 &&
      RegExp('[0-9]').hasMatch(password) &&
      RegExp('[a-z]').hasMatch(password) &&
      RegExp('[A-Z]').hasMatch(password) &&
      RegExp('[^A-Za-z0-9]').hasMatch(password);

  static OtpApiResponse handle(
    OtpApiRequest request, {
    DateTime Function()? clock,
  }) {
    if (request.method != 'POST') {
      return const OtpApiResponse(405, '{"error":"method"}');
    }
    final payload = _decode(request.body);
    if (payload == null) {
      return const OtpApiResponse(400, '{"error":"invalid_json"}');
    }
    final now = (clock ?? DateTime.now)();
    switch (request.path) {
      case '/auth/otp/request':
      case '/auth/otp/resend':
      case '/auth/email/reset/request':
      case '/auth/email/reset/resend':
        final destination = payload['destination'];
        if (destination is! String || destination.isEmpty) {
          return const OtpApiResponse(400, '{"error":"destination"}');
        }
        if (destination.endsWith('0000')) {
          return const OtpApiResponse(422, '{"error":"blocked"}');
        }
        final emailReset = request.path.startsWith('/auth/email/');
        return OtpApiResponse(
          200,
          jsonEncode({
            'challengeId': 'dev-challenge-1',
            'length': 6,
            'resendSeconds': resendSeconds,
            'expiresAt': now
                .toUtc()
                .add(const Duration(minutes: 5))
                .toIso8601String(),
            'maskedDestination': emailReset
                ? maskEmail(destination)
                : mask(destination),
          }),
        );
      case '/auth/email/password':
        final email = payload['email'];
        final password = payload['password'];
        if (email is! String || email.isEmpty || password is! String) {
          return const OtpApiResponse(400, '{"error":"destination"}');
        }
        return _secret(email, password == passwordFor(email), now);
      case '/auth/phone/status':
        final phone = payload['phone'];
        if (phone is! String || phone.isEmpty) {
          return const OtpApiResponse(400, '{"error":"destination"}');
        }
        return OtpApiResponse(
          200,
          jsonEncode({'status': phoneStatus(phone).name}),
        );
      case '/auth/phone/password':
        final phone = payload['phone'];
        final phoneSecret = payload['password'];
        if (phone is! String || phone.isEmpty || phoneSecret is! String) {
          return const OtpApiResponse(400, '{"error":"destination"}');
        }
        final expected = passwords[phone] ?? phonePassword;
        return _secret(phone, phoneSecret == expected, now);
      case '/auth/phone/password/create':
        final createdPhone = payload['phone'];
        final createdPhonePassword = payload['password'];
        if (createdPhone is! String ||
            createdPhone.isEmpty ||
            createdPhonePassword is! String ||
            !passwordAcceptable(createdPhonePassword)) {
          return const OtpApiResponse(422, '{"error":"invalid_password"}');
        }
        passwords[createdPhone] = createdPhonePassword;
        return const OtpApiResponse(200, '{"created":true}');
      case '/auth/phone/reset/request':
      case '/auth/phone/reset/resend':
        final phoneDestination = payload['destination'];
        if (phoneDestination is! String || phoneDestination.isEmpty) {
          return const OtpApiResponse(400, '{"error":"destination"}');
        }
        return OtpApiResponse(
          200,
          jsonEncode({
            'challengeId': 'dev-challenge-1',
            'length': 6,
            'resendSeconds': resendSeconds,
            'expiresAt': now
                .toUtc()
                .add(const Duration(minutes: 5))
                .toIso8601String(),
            'maskedDestination': mask(phoneDestination),
          }),
        );
      case '/auth/email/verify/request':
        final verifyEmail = payload['destination'];
        if (verifyEmail is! String || verifyEmail.isEmpty) {
          return const OtpApiResponse(400, '{"error":"destination"}');
        }
        return OtpApiResponse(
          200,
          jsonEncode({
            'challengeId': 'dev-challenge-1',
            'length': 6,
            'resendSeconds': resendSeconds,
            'expiresAt': now
                .toUtc()
                .add(const Duration(minutes: 5))
                .toIso8601String(),
            'maskedDestination': maskEmail(verifyEmail),
          }),
        );
      case '/auth/email/password/create':
        final createdEmail = payload['email'];
        final createdPassword = payload['password'];
        if (createdEmail is! String ||
            createdEmail.isEmpty ||
            createdPassword is! String ||
            !passwordAcceptable(createdPassword)) {
          return const OtpApiResponse(422, '{"error":"invalid_password"}');
        }
        passwords[createdEmail] = createdPassword;
        return const OtpApiResponse(200, '{"created":true}');
      case '/auth/otp/verify':
      case '/auth/email/reset/verify':
      case '/auth/email/verify/confirm':
      case '/auth/phone/reset/verify':
        final challengeId = payload['challengeId'];
        final code = payload['code'];
        if (challengeId is! String || challengeId.isEmpty || code is! String) {
          return const OtpApiResponse(422, '{"error":"invalid_code"}');
        }
        if (_locked(challengeId, now)) {
          return const OtpApiResponse(429, '{"error":"rate_limited"}');
        }
        if (code == acceptedCode) {
          _clear(challengeId);
          return const OtpApiResponse(200, '{"verified":true}');
        }
        return _fail(challengeId, now, 'invalid_code');
      case '/auth/account/username/ideas':
        final base = payload['base'];
        return OtpApiResponse(
          200,
          jsonEncode({'suggestions': suggest(base is String ? base : '')}),
        );
      case '/auth/account/username':
        final rawName = payload['username'];
        if (rawName is! String ||
            !RegExp(r'^[a-zA-Z0-9_]{3,16}$').hasMatch(rawName)) {
          return const OtpApiResponse(422, '{"error":"invalid_username"}');
        }
        final username = rawName.toLowerCase();
        final taken = takenNames.contains(username);
        return OtpApiResponse(
          200,
          jsonEncode({
            'available': !taken,
            'suggestions': taken ? suggest(username) : const <String>[],
          }),
        );
      case '/auth/account/complete':
        final chosen = payload['username'];
        final name = chosen is String ? chosen.toLowerCase() : null;
        if (name == null || takenNames.contains(name)) {
          return const OtpApiResponse(422, '{"error":"invalid_username"}');
        }
        takenNames.add(name);
        final accountEmail = payload['email'];
        final accountPassword = payload['password'];
        if (accountEmail is String &&
            accountEmail.isNotEmpty &&
            accountPassword is String &&
            passwordAcceptable(accountPassword)) {
          passwords[accountEmail] = accountPassword;
        }
        final accountPhone = payload['phone'];
        if (accountPhone is String &&
            accountPhone.isNotEmpty &&
            accountPassword is String &&
            passwordAcceptable(accountPassword)) {
          passwords[accountPhone] = accountPassword;
        }
        return const OtpApiResponse(200, '{"created":true}');
      default:
        return const OtpApiResponse(404, '{"error":"not_found"}');
    }
  }

  static OtpChallengeDto challengeFrom(OtpApiResponse response) {
    final payload = _decode(response.body);
    if (response.status != 200 || payload == null) {
      throw _fault(response);
    }
    final id = payload['challengeId'];
    final length = payload['length'];
    final resend = payload['resendSeconds'];
    final expires = payload['expiresAt'];
    final destination = payload['maskedDestination'];
    if (id is! String ||
        length is! int ||
        resend is! int ||
        expires is! String ||
        destination is! String) {
      throw const AuthDataException(AuthDataFault.server);
    }
    return OtpChallengeDto(
      id: id,
      length: length,
      resendSeconds: resend,
      expires: DateTime.parse(expires),
      destination: destination,
    );
  }

  static bool _locked(String id, DateTime now) {
    final until = _lockedUntil[id];
    if (until == null) return false;
    if (now.isBefore(until)) return true;
    _lockedUntil.remove(id);
    _attempts.remove(id);
    return false;
  }

  static void _clear(String id) {
    _attempts.remove(id);
    _lockedUntil.remove(id);
  }

  static OtpApiResponse _fail(String id, DateTime now, String error) {
    final count = (_attempts[id] ?? 0) + 1;
    if (count >= maxAttempts) {
      _attempts.remove(id);
      _lockedUntil[id] = now.add(lockDuration);
      return const OtpApiResponse(429, '{"error":"rate_limited"}');
    }
    _attempts[id] = count;
    return OtpApiResponse(422, '{"error":"$error"}');
  }

  static OtpApiResponse _secret(String id, bool accepted, DateTime now) {
    if (_locked(id, now)) {
      return const OtpApiResponse(429, '{"error":"rate_limited"}');
    }
    if (accepted) {
      _clear(id);
      return const OtpApiResponse(200, '{"signedIn":true}');
    }
    return _fail(id, now, 'invalid_password');
  }

  static void requireVerified(OtpApiResponse response) {
    if (response.status != 200) throw _fault(response);
  }

  static String maskEmail(String destination) {
    final at = destination.indexOf('@');
    if (at <= 1) return '•••';
    return '${destination.substring(0, 1)}•••${destination.substring(at)}';
  }

  static String mask(String destination) {
    final digits = destination.replaceAll(RegExp(r'\D'), '');
    final tail = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : digits;
    return '+98 ••• ••• $tail';
  }

  static Map<String, Object?>? _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, Object?>) return decoded;
      if (decoded is Map) return Map<String, Object?>.from(decoded);
    } catch (_) {
      return null;
    }
    return null;
  }

  static AuthDataException _fault(OtpApiResponse response) {
    final payload = _decode(response.body);
    final error = payload?['error'];
    return AuthDataException(switch (error) {
      'blocked' => AuthDataFault.blocked,
      'rate_limited' => AuthDataFault.rateLimited,
      'invalid_code' => AuthDataFault.invalidCode,
      'invalid_password' => AuthDataFault.invalidPassword,
      _ => AuthDataFault.server,
    });
  }
}
