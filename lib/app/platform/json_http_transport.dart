import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../core/diagnostics/app_logger.dart';
import '../../core/errors/app_failure.dart';
import '../../shared/backend/json_transport.dart';
import 'session_cookie_store.dart';

/// Development and product JSON GET/POST. Failures stay frontend types (D-122).
///
/// D-154: one client keeps a host-only jar for `AuthToken`, `AuthRemember`
/// and `PlayerPreAuth`. After every response those cookies are written to
/// [cookies]. [ready] finishes restoring them before the first request.
/// [clearSession] drops the jar and the store. A 401 on a request that sent
/// `AuthToken` does the same and calls [onUnauthorized]. Bodies, `Cookie`
/// and token values are not logged.
final class IoJsonTransport implements JsonHttpTransport {
  IoJsonTransport({
    HttpClient? client,
    SessionCookieStore? cookies,
    this.onUnauthorized,
    AppLogger? logger,
  }) : _client = client ?? HttpClient(),
       _cookies = cookies,
       _logger = logger ?? AppLogger() {
    _ready = _restore();
  }

  HttpClient _client;
  final SessionCookieStore? _cookies;
  final void Function()? onUnauthorized;
  final AppLogger _logger;
  final Map<String, Map<String, String>> _jar = {};
  late final Future<void> _ready;

  /// Completes after durable cookies are back in the jar.
  Future<void> get ready => _ready;

  void close() => _client.close(force: true);

  /// D-154: forget the in-memory jar and the secure store.
  Future<void> clearSession() async {
    _jar.clear();
    _client.close(force: true);
    _client = HttpClient();
    await _cookies?.clear();
  }

  Future<void> _restore() async {
    final stored = await _cookies?.readAll() ?? const {};
    for (final host in stored.entries) {
      final kept = {
        for (final name in sessionCookieNames)
          if (host.value[name] != null) name: host.value[name]!,
      };
      if (kept.isNotEmpty) _jar[host.key] = kept;
    }
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
    await _ready;
    final limit = timeout ?? const Duration(seconds: 8);
    final deadline = DateTime.now().add(limit);
    Future<T> within<T>(Future<T> step) {
      final remaining = deadline.difference(DateTime.now());
      return step.timeout(
        remaining <= Duration.zero
            ? const Duration(milliseconds: 1)
            : remaining,
      );
    }

    final hadSession = _jar[uri.host]?['AuthToken']?.isNotEmpty ?? false;
    try {
      final request = await within(
        method == JsonMethod.post ? _client.postUrl(uri) : _client.getUrl(uri),
      );
      headers.forEach(request.headers.set);
      _attachCookies(request, uri.host);
      if (body != null && method == JsonMethod.post) {
        request.headers.contentType = ContentType.json;
        request.write(body is String ? body : jsonEncode(body));
      }
      void abort() => request.abort();
      attachAbort?.call(abort);
      final response = await within(request.close());
      await _absorb(uri.host, response);
      final text = await within(utf8.decoder.bind(response).join());
      if (response.statusCode == 401 && hadSession) {
        await clearSession();
        onUnauthorized?.call();
      }
      return JsonHttpResponse(
        status: response.statusCode,
        body: text,
        headers: {
          for (final name in ['etag', 'content-language', 'retry-after'])
            name: ?_singleHeader(response.headers, name),
        },
      );
    } on TimeoutException {
      throw const TimeoutFailure();
    } on SocketException {
      throw const OfflineFailure();
    } on HandshakeException {
      throw const NetworkFailure();
    } on HttpException {
      throw const NetworkFailure();
    } on AppFailure {
      rethrow;
    } on Exception catch (error) {
      logTransportFailure(_logger, error);
      throw const NetworkFailure();
    }
  }

  void _attachCookies(HttpClientRequest request, String host) {
    final saved = _jar[host];
    if (saved == null || saved.isEmpty) return;
    for (final name in sessionCookieNames) {
      final value = saved[name];
      if (value == null || value.isEmpty) continue;
      request.cookies.add(Cookie(name, value));
    }
  }

  Future<void> _absorb(String host, HttpClientResponse response) async {
    final jar = _jar.putIfAbsent(host, () => {});
    var changed = false;
    for (final cookie in response.cookies) {
      if (!sessionCookieNames.contains(cookie.name)) continue;
      final expired =
          cookie.expires != null &&
          !cookie.expires!.isAfter(DateTime.now().toUtc());
      if (expired || cookie.value.isEmpty) {
        changed = jar.remove(cookie.name) != null || changed;
        continue;
      }
      if (jar[cookie.name] != cookie.value) {
        jar[cookie.name] = cookie.value;
        changed = true;
      }
    }
    if (jar.isEmpty) _jar.remove(host);
    if (changed) await _cookies?.writeAll(_jar);
  }
}

/// Failure logs keep the type only. The message may echo a body or a cookie.
void logTransportFailure(AppLogger logger, Object error) {
  logger.log(
    LogLevel.warning,
    'Unrecognized transport failure',
    fields: {'type': error.runtimeType.toString()},
  );
}

/// First value only. `headers.value` throws when a name is repeated, and
/// `Set-Cookie` is left to the client jar instead of being folded into one
/// string (D-152).
String? _singleHeader(HttpHeaders headers, String name) {
  final values = headers[name];
  if (values == null || values.isEmpty) return null;
  return values.first;
}
