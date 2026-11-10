import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../core/diagnostics/app_logger.dart';
import '../../core/errors/app_failure.dart';
import '../../shared/backend/json_transport.dart';

/// Development and product JSON GET/POST. Failures stay frontend types (D-122).
///
/// D-152: one client stores `Set-Cookie` (`AuthToken`, `PlayerPreAuth`) for
/// this process only. [clearSession] drops that memory. No secure storage.
final class IoJsonTransport implements JsonHttpTransport {
  IoJsonTransport([HttpClient? client]) : _client = client ?? HttpClient();
  HttpClient _client;

  void close() => _client.close(force: true);

  /// D-152: forget in-memory cookies after logout. Not durable storage.
  void clearSession() {
    _client.close(force: true);
    _client = HttpClient();
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
    final limit = timeout ?? const Duration(seconds: 8);
    // One deadline spans connect, response and body: three fresh timeouts
    // would multiply the real worst-case latency.
    final deadline = DateTime.now().add(limit);
    Future<T> within<T>(Future<T> step) {
      final remaining = deadline.difference(DateTime.now());
      return step.timeout(
        remaining <= Duration.zero
            ? const Duration(milliseconds: 1)
            : remaining,
      );
    }

    try {
      final request = await within(
        method == JsonMethod.post ? _client.postUrl(uri) : _client.getUrl(uri),
      );
      headers.forEach(request.headers.set);
      if (body != null && method == JsonMethod.post) {
        request.headers.contentType = ContentType.json;
        request.write(body is String ? body : jsonEncode(body));
      }
      void abort() => request.abort();
      attachAbort?.call(abort);
      final response = await within(request.close());
      final text = await within(utf8.decoder.bind(response).join());
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
      // Unknown client-side failures keep the network classification so the
      // read-model retry policy behaves as before, but they are logged
      // instead of silently masked.
      AppLogger().log(
        LogLevel.warning,
        'Unrecognized transport failure',
        fields: {'error': error.toString()},
      );
      throw const NetworkFailure();
    }
  }
}

/// First value only. `headers.value` throws when a name is repeated, and
/// `Set-Cookie` is left to the client jar instead of being folded into one
/// string (D-152).
String? _singleHeader(HttpHeaders headers, String name) {
  final values = headers[name];
  if (values == null || values.isEmpty) return null;
  return values.first;
}
