import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/core/storage/memory_json_store.dart';
import 'package:mygame_p2e/features/games/games.dart';
import 'package:mygame_p2e/features/games/games_data.dart';
import 'package:mygame_p2e/shared/backend/json_transport.dart';

void main() {
  test('parser rejects a bad version and a missing field', () {
    expect(
      () => parseGameDetails('{"schemaVersion":2}'),
      throwsFormatException,
    );
    expect(() => parseGameDetails('[]'), throwsFormatException);
  });

  test('cache serves fresh data, then 304, then offline', () async {
    final store = MemoryJsonStore();
    final transport = _ScriptedTransport();
    final repository = CachedGameDetailsRepository(
      source: HttpGameDetailsSource(
        transport: transport,
        base: Uri.parse('http://example.test/'),
      ),
      store: store,
    );
    final body = _body;
    transport.enqueue(
      const JsonHttpResponse(
        status: 200,
        body: _body,
        headers: {'etag': '"one"'},
      ),
    );
    final first = await repository.details('sample', languageCode: 'en');
    final loaded = (first as Success<GameDetailsSnapshot>).value;
    expect(loaded.details.name, 'Sample');
    expect(loaded.offline, isFalse);

    transport.enqueue(const JsonHttpResponse(status: 304, body: ''));
    final second = await repository.details('sample', languageCode: 'en');
    expect((second as Success).value.offline, isFalse);
    expect(transport.lastEtag, '"one"');

    transport.fail(const OfflineFailure());
    final third = await repository.details('sample', languageCode: 'en');
    expect((third as Success<GameDetailsSnapshot>).value.offline, isTrue);

    await repository.clear();
    transport.fail(const OfflineFailure());
    final gone = await repository.details('sample', languageCode: 'en');
    expect(gone, isA<Failure<GameDetailsSnapshot>>());
    expect((gone as Failure).error, isA<OfflineFailure>());

    transport.enqueue(const JsonHttpResponse(status: 404, body: ''));
    final missing = await repository.details('sample', languageCode: 'en');
    expect((missing as Failure).error, isA<NotFoundFailure>());
    expect(body, isNotEmpty);
  });
}

const _body = '''
{
  "schemaVersion": 1,
  "id": "sample",
  "kind": "downloadable",
  "name": "Sample",
  "icon": {"url": "https://example.test/icon.png", "width": 8, "height": 8, "alt": "icon"},
  "access": "freeToPlay",
  "studio": {
    "id": "studio",
    "name": "Studio",
    "registeredMark": false,
    "tagline": "Tag",
    "logo": {"url": "https://example.test/logo.png", "width": 8, "height": 8, "alt": "logo"},
    "cover": {"url": "https://example.test/cover.jpg", "width": 8, "height": 8, "alt": "cover"}
  },
  "rating": {"average": 0, "count": 0, "distribution": {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0}},
  "downloads": 0,
  "installSizeBytes": 1,
  "install": {"method": "external", "url": "https://example.test/install"},
  "media": [],
  "about": {"description": "Short.", "updatedOn": "2026-11-14", "platforms": []},
  "events": [],
  "reviews": {"aiSummary": null, "total": 0, "items": []},
  "similar": [],
  "moreByStudio": []
}
''';

final class _ScriptedTransport implements JsonHttpTransport {
  final _responses = <JsonHttpResponse>[];
  AppFailure? _failure;
  String? lastEtag;

  void enqueue(JsonHttpResponse response) {
    _failure = null;
    _responses.add(response);
  }

  void fail(AppFailure failure) {
    _responses.clear();
    _failure = failure;
  }

  @override
  Future<JsonHttpResponse> send({
    required Uri uri,
    required JsonMethod method,
    Map<String, String> headers = const {},
    Duration? timeout,
  }) async {
    lastEtag = headers['if-none-match'];
    final failure = _failure;
    if (failure != null) throw failure;
    return _responses.removeAt(0);
  }
}
