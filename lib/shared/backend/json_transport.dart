enum JsonMethod { get }

final class JsonHttpResponse {
  const JsonHttpResponse({
    required this.status,
    required this.body,
    this.headers = const {},
  });

  final int status;
  final String body;
  final Map<String, String> headers;

  String? header(String name) {
    final wanted = name.toLowerCase();
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == wanted) return entry.value;
    }
    return null;
  }
}

/// Product HTTP boundary. The IO implementation lives in `lib/app/platform`.
abstract interface class JsonHttpTransport {
  Future<JsonHttpResponse> send({
    required Uri uri,
    required JsonMethod method,
    Map<String, String> headers = const {},
    Duration? timeout,
  });
}
