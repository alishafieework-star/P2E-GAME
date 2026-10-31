import 'package:flutter/services.dart';

/// Lets the hosted product resolve its own asset keys. The inspector library
/// stays unaware of product paths. Only the listed keys are redirected to the
/// product package; every other key stays on the host bundle.
final class ProductAssetBridge extends CachingAssetBundle {
  ProductAssetBridge(this.parent);
  final AssetBundle parent;

  static const packagePrefix = 'packages/mygame_p2e/';

  /// Keys the product requests without a package name.
  static const allowlist = {
    'assets/images/auth/entry_illustration.png',
    'assets/icons/brands/playstation.svg',
    'assets/icons/brands/xbox.svg',
    'assets/icons/brands/google.svg',
  };

  String resolve(String key) =>
      allowlist.contains(key) ? '$packagePrefix$key' : key;

  @override
  Future<ByteData> load(String key) => parent.load(resolve(key));

  @override
  Future<ImmutableBuffer> loadBuffer(String key) =>
      parent.loadBuffer(resolve(key));
}
