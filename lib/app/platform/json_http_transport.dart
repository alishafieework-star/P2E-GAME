import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../core/diagnostics/app_logger.dart';
import '../../core/errors/app_failure.dart';
import '../../shared/backend/json_transport.dart';

/// Development and product JSON GET. Failures stay frontend types (D-122).
final class IoJsonTransport implements JsonHttpTransport {
  IoJsonTransport([HttpClient? client]) : _client = client ?? HttpClient();
  final HttpClient _client;

  void close() => _client.close(force: true);

  @override
  Future<JsonHttpResponse> send({
    required Uri uri,
    required JsonMethod method,
    Map<String, String> headers = const {},
    Duration? timeout,
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
      final request = await within(_client.getUrl(uri));
      headers.forEach(request.headers.set);
      final response = await within(request.close());
      final body = await within(utf8.decoder.bind(response).join());
      return JsonHttpResponse(
        status: response.statusCode,
        body: body,
        headers: {
          for (final name in ['etag', 'content-language'])
            if (response.headers.value(name) != null)
              name: response.headers.value(name)!,
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
