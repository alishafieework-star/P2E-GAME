import 'package:mygame_p2e/shared/backend/json_transport.dart';

final class GameDetailsFetch {
  const GameDetailsFetch(this.status, this.body, this.etag);
  final int status;
  final String body;
  final String? etag;
}

/// GET `{base}/v1/games/{id}` (D-122).
final class HttpGameDetailsSource {
  const HttpGameDetailsSource({
    required this.transport,
    required this.base,
    this.timeout = const Duration(seconds: 8),
  });

  final JsonHttpTransport transport;
  final Uri base;
  final Duration timeout;

  Future<GameDetailsFetch> fetch(
    String id, {
    required String languageCode,
    String? etag,
  }) async {
    final response = await transport.send(
      uri: base.resolve('v1/games/$id'),
      method: JsonMethod.get,
      headers: {
        'accept': 'application/json',
        'accept-language': languageCode,
        'if-none-match': ?etag,
      },
      timeout: timeout,
    );
    return GameDetailsFetch(
      response.status,
      response.body,
      response.header('etag'),
    );
  }
}
