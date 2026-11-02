import 'package:flutter/services.dart';

/// Lets the hosted product resolve its own asset keys. The inspector library
/// stays unaware of product paths. Redirects product image and brand icon keys
/// to the mygame_p2e package bundle.
final class ProductAssetBridge extends CachingAssetBundle {
  ProductAssetBridge(this.parent);
  final AssetBundle parent;

  static const packagePrefix = 'packages/mygame_p2e/';

  static const allowlistPrefixes = [
    'assets/images/',
    'assets/icons/brands/',
    'assets/icons/platforms/',
  ];

  static const allowlist = {
    'assets/images/auth/entry_illustration.png',
    'assets/icons/brands/playstation.svg',
    'assets/icons/brands/xbox.svg',
    'assets/icons/brands/google.svg',
  };

  String resolve(String key) {
    if (allowlist.contains(key) ||
        allowlistPrefixes.any((prefix) => key.startsWith(prefix))) {
      return '$packagePrefix$key';
    }
    return key;
  }

  @override
  Future<ByteData> load(String key) => parent.load(resolve(key));

  @override
  Future<ImmutableBuffer> loadBuffer(String key) =>
      parent.loadBuffer(resolve(key));
}
