import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/games/games_data.dart';

import '../../tool/fake_backend/game_catalog.dart';

void main() {
  final fixtures = Directory('tool/fake_backend/fixtures/games');

  test('catalog serves, substitutes media, and answers 304 and 404', () {
    final ok = handleGameCatalog(
      const CatalogRequest(
        method: 'GET',
        path: '/v1/games/clash_of_clans',
        headers: {},
        mediaBase: 'http://10.0.2.2:8788/',
      ),
      fixtures: fixtures,
    );
    expect(ok.status, 200);
    expect(ok.body, contains('http://10.0.2.2:8788/home/'));
    expect(ok.body, isNot(contains('{{media}}')));
    expect(ok.headers['content-language'], 'en');
    final etag = ok.headers['etag'];
    final cached = handleGameCatalog(
      CatalogRequest(
        method: 'GET',
        path: '/v1/games/clash_of_clans',
        headers: {'If-None-Match': etag!},
        mediaBase: 'http://127.0.0.1:8788',
      ),
      fixtures: fixtures,
    );
    expect(cached.status, 304);
    expect(cached.body, isEmpty);
    final missing = handleGameCatalog(
      const CatalogRequest(
        method: 'GET',
        path: '/v1/games/missing',
        headers: {},
        mediaBase: 'http://127.0.0.1:8788',
      ),
      fixtures: fixtures,
    );
    expect(missing.status, 404);
    expect(
      handleGameCatalog(
        const CatalogRequest(
          method: 'POST',
          path: '/v1/games/clash_of_clans',
          headers: {},
          mediaBase: 'http://127.0.0.1:8788',
        ),
        fixtures: fixtures,
      ).status,
      405,
    );
  });

  test('every fixture parses and points at a real asset and game id', () {
    final files = fixtures
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.json'))
        .toList();
    expect(files.length, greaterThanOrEqualTo(18));
    final ids = <String>{};
    for (final file in files) {
      final raw = file.readAsStringSync().replaceAll(
        '{{media}}',
        'https://example.test',
      );
      final details = parseGameDetails(raw);
      ids.add(details.id);
      expect(file.uri.pathSegments.last, '${details.id}.json');
    }
    for (final file in files) {
      final details = parseGameDetails(
        file.readAsStringSync().replaceAll('{{media}}', 'https://example.test'),
      );
      for (final related in [...details.similar, ...details.moreByStudio]) {
        expect(ids, contains(related.id), reason: details.id);
      }
      for (final item in details.media) {
        final url = item.image?.url ?? item.thumbnail!.url;
        expect(url.host, 'example.test');
        final name = url.pathSegments.last;
        expect(
          File('docs/snapshots/2026-10-24_home/assets/$name').existsSync(),
          isTrue,
          reason: name,
        );
      }
    }
  });
}
