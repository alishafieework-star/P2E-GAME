import 'dart:convert';
import 'dart:math';

import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/shared/backend/json_transport.dart';

import '../../domain/models.dart';
import '../sources.dart';

/// D-152: the player panel's UsersService calls. No endpoint is added.
///
/// Success is HTTP 2xx and envelope `status` in 2xx. Cookies stay on the
/// transport client. This object only remembers challenge ids for this process.
final class UsersApiClient {
  UsersApiClient({
    required this.base,
    required this.transport,
    this.origin = '',
    this.clearSession = _noop,
    this.nextRequestId,
  });

  final Uri base;

  /// Browser origin the Users policy allow-lists (D-153). Empty omits the header.
  final String origin;
  final JsonHttpTransport transport;
  final void Function() clearSession;

  /// Test seam. Production leaves this null and generates an id.
  final String Function()? nextRequestId;

  static void _noop() {}

  String? registrationChallengeId;
  String? changeTicket;
  bool? identifierExists;
  String? wireIdentifier;
  String? maskedDestination;
  bool remember = false;
  final _prefixes = <String, String>{};
  final _purposes = <String, String>{};

  static const _playerAuth = '1';

  Uri _uri(String path) {
    final root = base.path.endsWith('/') ? base.path : '${base.path}/';
    return base.replace(path: '$root$path');
  }

  String _requestId() {
    final supplied = nextRequestId?.call();
    if (supplied != null && supplied.isNotEmpty) return supplied;
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  /// National mobile `9xxxxxxxxx`. The panel sends that form to SendCode.
  static String wirePhone(String e164) {
    const prefix = '+98';
    if (e164.startsWith(prefix) && e164.length == prefix.length + 10) {
      return e164.substring(prefix.length);
    }
    return e164;
  }

  Future<PhoneStatusDto> resolvePhone(
    String e164,
    AuthCancellation? cancellation,
  ) async {
    final wire = wirePhone(e164);
    final data = await _data(
      JsonMethod.post,
      'general/auth/ResolvePlayerIdentifier',
      {'identifier': wire},
      cancellation,
    );
    return PhoneStatusDto(_rememberIdentifier(wire, data));
  }

  Future<EmailStatusDto> resolveEmail(
    String email,
    AuthCancellation? cancellation,
  ) async {
    final data = await _data(
      JsonMethod.post,
      'general/auth/ResolvePlayerIdentifier',
      {'identifier': email},
      cancellation,
    );
    final status = _rememberIdentifier(email, data);
    return EmailStatusDto(status != PhoneAccountStatus.notRegistered);
  }

  Future<OtpChallengeDto> sendPhoneCode(
    String e164,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async {
    remember = rememberDevice;
    final wire = wireIdentifier ?? wirePhone(e164);
    if (identifierExists == false) {
      return _registrationCode(wire, cancellation);
    }
    return _loginCode(wire, cancellation);
  }

  Future<OtpChallengeDto> sendLoginCode(
    String identifier,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async {
    remember = rememberDevice;
    wireIdentifier = identifier;
    return _loginCode(identifier, cancellation);
  }

  Future<void> verifyLoginCode(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async {
    if (_purposes[challengeId] == 'registration') {
      await verifyRegistration(challengeId, code, cancellation);
      return;
    }
    final data = await _data(JsonMethod.post, 'general/auth/PlayerLogin', {
      'method': 2,
      'challengeId': challengeId,
      'code': _fullCode(challengeId, code),
      'remember': remember,
    }, cancellation);
    _afterLogin(data);
  }

  Future<void> signIn(
    String identifier,
    String password,
    bool rememberDevice,
    AuthCancellation? cancellation,
  ) async {
    remember = rememberDevice;
    final data = await _data(JsonMethod.post, 'general/auth/PlayerLogin', {
      'method': 1,
      'identifier': identifier,
      'password': password,
      'remember': rememberDevice,
    }, cancellation);
    _afterLogin(data);
  }

  Future<void> verifyRegistration(
    String challengeId,
    String code,
    AuthCancellation? cancellation,
  ) async {
    await _data(JsonMethod.post, 'general/player-registration/VerifyCode', {
      'challengeId': challengeId,
      'code': _fullCode(challengeId, code),
    }, cancellation);
    registrationChallengeId = challengeId;
  }

  Future<UsernameCheckDto> checkUsername(
    String username,
    AuthCancellation? cancellation,
  ) async {
    final id = await _registrationId(cancellation);
    final data = await _data(
      JsonMethod.post,
      'general/player-registration/CheckUserName',
      {'challengeId': id, 'userName': username.toLowerCase()},
      cancellation,
    );
    return _username(data);
  }

  Future<List<String>> usernameIdeas(
    String baseName,
    AuthCancellation? cancellation,
  ) async {
    final checked = await checkUsername(baseName, cancellation);
    return checked.suggestions;
  }

  Future<void> completeRegistration(
    Map<String, Object?> body,
    AuthCancellation? cancellation,
  ) async {
    final id = await _registrationId(cancellation);
    final username = body['username'];
    final password = body['password'];
    if (username is! String || password is! String || username.isEmpty) {
      throw const AuthDataException(AuthDataFault.server);
    }
    await _data(JsonMethod.post, 'general/player-registration/SaveUserName', {
      'challengeId': id,
      'userName': username.toLowerCase(),
    }, cancellation);
    final data = await _data(
      JsonMethod.post,
      'general/player-registration/Complete',
      {'challengeId': id, 'password': password},
      cancellation,
    );
    if (data?['registered'] != true) {
      throw const AuthDataException(AuthDataFault.server);
    }
  }

  /// Registration stores the password on Complete. A forced change uses the
  /// ticket from PlayerLogin. Reset has no endpoint and stays not configured.
  Future<void> createPassword(
    String password,
    AuthCancellation? cancellation,
  ) async {
    if (registrationChallengeId != null) return;
    final ticket = changeTicket;
    if (ticket == null || ticket.isEmpty) {
      throw const AuthDataException(AuthDataFault.notConfigured);
    }
    final data = await _data(
      JsonMethod.post,
      'general/auth/ChangeInitialPassword',
      {'changeTicket': ticket, 'newPassword': password, 'remember': remember},
      cancellation,
    );
    changeTicket = null;
    _afterLogin(data, allowLoginRequired: true);
  }

  /// Cold start only. `userType` 4 is a player. 401 and network failures are
  /// signed-out, not a startup error.
  Future<bool> restorePlayer() async {
    try {
      final response = await _send(
        JsonMethod.get,
        'general/auth/Me',
        null,
        null,
      );
      if (response.status == 401) return false;
      final data = _require(response);
      final id = data?['id'];
      return data?['userType'] == 4 &&
          id is num &&
          id > 0 &&
          data?['fullName'] is String;
    } on AuthDataException {
      return false;
    } on AppFailure {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _data(JsonMethod.post, 'general/auth/Logout', null, null);
    } finally {
      registrationChallengeId = null;
      changeTicket = null;
      identifierExists = null;
      wireIdentifier = null;
      clearSession();
    }
  }

  PhoneAccountStatus _rememberIdentifier(
    String wire,
    Map<String, Object?>? data,
  ) {
    final exists = data?['exists'];
    final kind = data?['identifierKind'];
    if (exists is! bool || kind is! int || kind < 1 || kind > 3) {
      throw const AuthDataException(AuthDataFault.server);
    }
    wireIdentifier = wire;
    identifierExists = exists;
    final masked = data?['otpDestination'];
    maskedDestination = masked is String && masked.isNotEmpty ? masked : wire;
    if (!exists) return PhoneAccountStatus.notRegistered;
    return PhoneAccountStatus.registeredWithPassword;
  }

  Future<OtpChallengeDto> _registrationCode(
    String mobile,
    AuthCancellation? cancellation,
  ) async {
    final data = await _data(
      JsonMethod.post,
      'general/player-registration/SendCode',
      {'mobile': mobile, 'requestId': _requestId()},
      cancellation,
    );
    return _code(data, 'registration');
  }

  Future<OtpChallengeDto> _loginCode(
    String identifier,
    AuthCancellation? cancellation,
  ) async {
    final data = await _data(
      JsonMethod.post,
      'general/auth/SendPlayerLoginCode',
      {'identifier': identifier, 'requestId': _requestId()},
      cancellation,
    );
    return _code(data, 'login');
  }

  OtpChallengeDto _code(Map<String, Object?>? data, String purpose) {
    final id = data?['challengeId'];
    final prefix = data?['codePrefix'];
    final digits = data?['codeDigits'];
    final resend = data?['resendAfterSeconds'];
    final expires = data?['expiresAtUtc'];
    if (id is! String ||
        prefix is! String ||
        digits is! int ||
        resend is! int ||
        expires is! String) {
      throw const AuthDataException(AuthDataFault.server);
    }
    final DateTime expiresAt;
    try {
      expiresAt = DateTime.parse(expires);
    } on FormatException {
      throw const AuthDataException(AuthDataFault.server);
    }
    _prefixes[id] = prefix;
    _purposes[id] = purpose;
    if (purpose == 'registration') registrationChallengeId = id;
    return OtpChallengeDto(
      id: id,
      prefix: prefix,
      length: digits,
      resendSeconds: resend,
      expires: expiresAt,
      destination: maskedDestination ?? wireIdentifier ?? '',
    );
  }

  String _fullCode(String challengeId, String digits) =>
      '${_prefixes[challengeId] ?? ''}$digits';

  void _afterLogin(
    Map<String, Object?>? data, {
    bool allowLoginRequired = false,
  }) {
    if (data?['mustChangePassword'] is! bool) {
      throw const AuthDataException(AuthDataFault.server);
    }
    if (data?['mustChangePassword'] == true) {
      final ticket = data?['changeTicket'];
      if (ticket is! String || ticket.isEmpty) {
        throw const AuthDataException(AuthDataFault.server);
      }
      changeTicket = ticket;
      // The current screens have no change-ticket step. Do not treat this as
      // a signed-in login. Reset stays notConfigured (D-152).
      throw const AuthDataException(AuthDataFault.server);
    }
    if (data?['loginRequired'] == true && !allowLoginRequired) {
      throw const AuthDataException(AuthDataFault.server);
    }
  }

  UsernameCheckDto _username(Map<String, Object?>? data) {
    final available = data?['available'];
    final suggestions = data?['suggestions'];
    if (available is! bool || suggestions is! List) {
      throw const AuthDataException(AuthDataFault.server);
    }
    return UsernameCheckDto(
      available: available,
      suggestions: [
        for (final name in suggestions)
          if (name is String) name,
      ],
    );
  }

  Future<String> _registrationId(AuthCancellation? cancellation) async {
    final known = registrationChallengeId;
    if (known != null && known.isNotEmpty) return known;
    final data = await _data(
      JsonMethod.get,
      'general/player-registration/Current',
      null,
      cancellation,
    );
    final found = data?['found'] == true;
    final id = found ? data!['challengeId'] : null;
    if (id is! String || id.isEmpty) {
      throw const AuthDataException(AuthDataFault.notConfigured);
    }
    registrationChallengeId = id;
    final prefix = data?['codePrefix'];
    if (prefix is String) _prefixes[id] = prefix;
    return id;
  }

  Future<Map<String, Object?>?> _data(
    JsonMethod method,
    String path,
    Object? body,
    AuthCancellation? cancellation,
  ) async {
    final response = await _send(method, path, body, cancellation);
    return _require(response);
  }

  Future<JsonHttpResponse> _send(
    JsonMethod method,
    String path,
    Object? body,
    AuthCancellation? cancellation,
  ) async {
    if (cancellation?.isCancelled ?? false) {
      throw const AuthDataException(AuthDataFault.cancelled);
    }
    void Function()? abort;
    void cancel() => abort?.call();
    cancellation?.onCancel(cancel);
    try {
      final response = await transport.send(
        uri: _uri(path),
        method: method,
        headers: {
          'accept': 'application/json',
          'x-player-auth': _playerAuth,
          if (origin.isNotEmpty) 'origin': origin,
        },
        body: body,
        attachAbort: (next) => abort = next,
      );
      if (cancellation?.isCancelled ?? false) {
        throw const AuthDataException(AuthDataFault.cancelled);
      }
      return response;
    } on AuthDataException {
      rethrow;
    } on OfflineFailure {
      throw const AuthDataException(AuthDataFault.offline);
    } on TimeoutFailure {
      throw const AuthDataException(AuthDataFault.offline);
    } on NetworkFailure {
      if (cancellation?.isCancelled ?? false) {
        throw const AuthDataException(AuthDataFault.cancelled);
      }
      throw const AuthDataException(AuthDataFault.offline);
    } on AppFailure {
      throw const AuthDataException(AuthDataFault.server);
    } finally {
      cancellation?.removeListener(cancel);
    }
  }

  Map<String, Object?>? _require(JsonHttpResponse response) {
    Map<String, Object?>? envelope;
    if (response.body.isNotEmpty) {
      final Object? decoded;
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        throw const AuthDataException(AuthDataFault.server);
      }
      if (decoded is Map) {
        envelope = {
          for (final entry in decoded.entries)
            if (entry.key is String) entry.key as String: entry.value,
        };
      }
    }
    final status = envelope?['status'];
    final httpOk = response.status >= 200 && response.status < 300;
    final envelopeOk = status is num && status >= 200 && status < 300;
    if (httpOk && envelopeOk) {
      final data = envelope?['data'];
      if (data == null) return null;
      if (data is Map) {
        return {
          for (final entry in data.entries)
            if (entry.key is String) entry.key as String: entry.value,
        };
      }
      throw const AuthDataException(AuthDataFault.server);
    }
    final code = envelope?['errorCode'];
    throw AuthDataException(
      faultFor(
        code is String ? code : null,
        response.status,
        response.header('retry-after'),
      ),
    );
  }
}

/// Panel `errorCode` values. Retry-After marks a limit even when the code is
/// absent. The fault itself carries no delay; the screens already show the
/// rate-limited message.
AuthDataFault faultFor(String? code, int httpStatus, String? retryAfter) {
  if (code == 'PLAYER_RATE_LIMIT' || httpStatus == 429 || retryAfter != null) {
    return AuthDataFault.rateLimited;
  }
  return switch (code) {
    'INVALID_CREDENTIALS' ||
    'PASSWORD_LENGTH_11_TO_128' ||
    'COMMON_PASSWORD' ||
    'INVALID_PASSWORD_UNICODE' ||
    'CREDENTIALS_CHANGED' => AuthDataFault.invalidPassword,
    'INVALID_OR_EXPIRED_CODE' => AuthDataFault.invalidCode,
    'PLAYER_MOBILE_REGISTERED' ||
    'PLAYER_CONTACT_REGISTERED' ||
    'PLAYER_EMAIL_REGISTERED' ||
    'PLAYER_IDENTITY_TAKEN_OR_PROOF_USED' ||
    'PLAYER_IDENTIFIER_AMBIGUOUS' ||
    'PLAYER_OTP_UNAVAILABLE' ||
    'ORIGIN_OR_CSRF_REJECTED' => AuthDataFault.blocked,
    _ =>
      httpStatus == 401 ? AuthDataFault.invalidPassword : AuthDataFault.server,
  };
}
