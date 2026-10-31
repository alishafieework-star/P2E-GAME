import 'package:flutter/widgets.dart';
import 'package:mygame_p2e/shared/widgets/scroll_debug_log.dart';

final _loggedDecode = <int>{};

/// Physical pixels to decode a cover shown at [logical] points (D-129).
int coverCachePixels(BuildContext context, double logical) {
  final pixels = logical * MediaQuery.devicePixelRatioOf(context);
  if (!pixels.isFinite || pixels < 1) return 1;
  return pixels.round();
}

/// The same picture, decoded at the size it is shown.
ImageProvider resizedCover(
  BuildContext context,
  ImageProvider image,
  double logical,
) {
  final pixels = coverCachePixels(context, logical);
  // #region agent log
  if (_loggedDecode.add(pixels)) {
    scrollDebugLog('C', 'cover_image.dart:resizedCover', 'decode size', {
      'logical': logical.toStringAsFixed(0),
      'dpr': MediaQuery.devicePixelRatioOf(context).toStringAsFixed(2),
      'pixels': pixels,
    });
  }
  // #endregion
  return ResizeImage.resizeIfNeeded(pixels, null, image);
}
