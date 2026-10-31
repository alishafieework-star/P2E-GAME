import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_product_host/product_asset_bridge.dart';

void main() {
  test(
    'only listed product keys are redirected to the product package',
    () async {
      final parent = _RecordingBundle();
      final bridge = ProductAssetBridge(parent);
      await bridge.load('assets/icons/brands/playstation.svg');
      await bridge.loadBuffer('assets/images/auth/entry_illustration.png');
      await bridge.load('assets/fonts/other.ttf');
      expect(parent.keys, [
        'packages/mygame_p2e/assets/icons/brands/playstation.svg',
        'packages/mygame_p2e/assets/images/auth/entry_illustration.png',
        'assets/fonts/other.ttf',
      ]);
    },
  );
}

final class _RecordingBundle extends AssetBundle {
  final keys = <String>[];
  @override
  Future<ByteData> load(String key) async {
    keys.add(key);
    return ByteData(0);
  }

  @override
  Future<ImmutableBuffer> loadBuffer(String key) async {
    keys.add(key);
    return ImmutableBuffer.fromUint8List(Uint8List(0));
  }
}
