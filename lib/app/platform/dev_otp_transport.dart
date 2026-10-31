import 'dart:convert';
import 'dart:io';

import '../../features/auth/auth_data.dart';

/// D-068: development socket for the local OTP fake. Not used by production.
final class IoDevOtpTransport implements DevOtpTransport {
  IoDevOtpTransport([HttpClient? client]) : _client = client ?? HttpClient();
  final HttpClient _client;

  void close() => _client.close(force: true);

  @override
  Future<OtpApiResponse> post(
    Uri uri,
    String jsonBody,
    AuthCancellation? cancellation,
  ) async {
    if (cancellation?.isCancelled ?? false) {
      throw const AuthDataException(AuthDataFault.cancelled);
    }
    final request = await _client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    request.write(jsonBody);
    void cancel() => request.abort();
    cancellation?.onCancel(cancel);
    try {
      final response = await request.close().timeout(
        const Duration(seconds: 8),
      );
      // The body read must honor the same budget; a stalled fake server used
      // to hang the OTP request forever despite the closed-response timeout.
      final text = await utf8.decoder
          .bind(response)
          .join()
          .timeout(const Duration(seconds: 8));
      if (cancellation?.isCancelled ?? false) {
        throw const AuthDataException(AuthDataFault.cancelled);
      }
      return OtpApiResponse(response.statusCode, text);
    } on AuthDataException {
      rethrow;
    } catch (_) {
      if (cancellation?.isCancelled ?? false) {
        throw const AuthDataException(AuthDataFault.cancelled);
      }
      throw const AuthDataException(AuthDataFault.offline);
    } finally {
      cancellation?.removeListener(cancel);
    }
  }
}
