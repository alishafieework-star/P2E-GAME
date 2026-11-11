import 'dart:convert';
import 'dart:io';

/// Temporary session logger. Posts one NDJSON event and keeps no OTP text.
void agentDebugLog({
  required String location,
  required String message,
  required String hypothesisId,
  Map<String, Object?> data = const {},
}) {
  // #region agent log
  final line = jsonEncode({
    'sessionId': '7a284d',
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'location': location,
    'message': message,
    'data': data,
    'hypothesisId': hypothesisId,
    'runId': 'pre-fix',
  });
  Future<void>(() async {
    try {
      final client = HttpClient();
      final request = await client.postUrl(
        Uri.parse(
          'http://127.0.0.1:7487/ingest/57401562-e6e5-44da-a848-254a45405401',
        ),
      );
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set('X-Debug-Session-Id', '7a284d');
      request.add(utf8.encode(line));
      await request.close();
      client.close(force: true);
    } catch (_) {}
  });
  // #endregion
}
