import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/core/storage/file_json_store.dart';
import 'package:mygame_p2e/core/storage/memory_json_store.dart';

void main() {
  test('memory store round-trips and rejects unsafe keys', () async {
    final store = MemoryJsonStore();
    await store.write('game/en/clash', '{"ok":true}');
    expect(await store.read('game/en/clash'), '{"ok":true}');
    expect(await store.keys(), ['game/en/clash']);
    await store.delete('game/en/clash');
    expect(await store.read('game/en/clash'), isNull);
    expect(() => store.read('../secret'), throwsArgumentError);
  });

  test('file store keeps keys with slashes', () async {
    final directory = await Directory.systemTemp.createTemp('p2e-json');
    addTearDown(() => directory.delete(recursive: true));
    final store = FileJsonStore(Future.value(directory));
    await store.write('bookmark/ids', '["sifu"]');
    expect(await store.read('bookmark/ids'), '["sifu"]');
    expect(await store.keys(), ['bookmark/ids']);
  });

  test(
    'file store serializes same-key writes and leaves no temporaries',
    () async {
      final directory = await Directory.systemTemp.createTemp('p2e-json');
      addTearDown(() => directory.delete(recursive: true));
      final store = FileJsonStore(Future.value(directory));
      await Future.wait([
        store.write('bookmark/ids', '["a"]'),
        store.write('bookmark/ids', '["b"]'),
        store.write('game/en/clash', '{}'),
      ]);
      // The same-key writes publish in order; the last one wins.
      expect(await store.read('bookmark/ids'), '["b"]');
      expect(await store.read('game/en/clash'), '{}');
      // Every published file is final: no temporary files linger.
      expect(
        directory.listSync().every((entity) => entity.path.endsWith('.json')),
        isTrue,
      );
      // Keys stay sorted, decoded, and limited to published JSON files.
      expect(await store.keys(), ['bookmark/ids', 'game/en/clash']);
    },
  );
}
