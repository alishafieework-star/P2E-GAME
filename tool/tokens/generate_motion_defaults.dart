import 'dart:io';

import 'generate_buttons.dart' as helpers;

Future<void> main(List<String> args) async {
  const source = 'design/engineering/button_motion.json';
  final data = helpers.readJson(source);
  final curve = _cubic(data['curve']);
  final spring = _cubic(data['spring']);
  if (data['restScale'] != 1 ||
      data['pressedScale'] >= 1 ||
      data['pressedScale'] <= 0 ||
      data['iconPressedScale'] >= 1 ||
      data['iconPressedScale'] <= 0) {
    throw StateError('Unsupported engineering motion defaults');
  }
  final text = await helpers.format('''
// GENERATED – do not edit
// Source: $source. D-136; HTML prototype, NOT Figma-extracted.
import 'package:flutter/animation.dart';
abstract final class ButtonMotion {
  static const pressedScale = ${data['pressedScale']};
  static const iconPressedScale = ${data['iconPressedScale']};
  static const quietPressedScale = ${data['quietPressedScale']};
  static const quietPressedOpacity = ${data['quietPressedOpacity']};
  static const rowPressedScale = ${data['rowPressedScale']};
  static const togglePressedScale = ${data['togglePressedScale']};
  static const restScale = ${data['restScale']};
  static const pressDuration = Duration(milliseconds: ${data['pressMilliseconds']});
  static const releaseDuration = Duration(milliseconds: ${data['releaseMilliseconds']});
  static const hoverDuration = Duration(milliseconds: ${data['hoverMilliseconds']});
  static const curve = Cubic(${curve.join(', ')});
  static const spring = Cubic(${spring.join(', ')});
  static const socialHoverLift = ${data['socialHoverLift']};
  static const socialHoverBrightness = ${data['socialHoverBrightness']};
  static const playNowPressedScale = ${data['playNowPressedScale']};
  static const viewMorePressedScale = ${data['viewMorePressedScale']};
  static const viewMoreHoverAlpha = ${data['viewMoreHoverAlpha']};
  static const indicatorPressedScale = ${data['indicatorPressedScale']};
  static const expandImageHoverScale = ${data['expandImageHoverScale']};
  static const expandHoverDuration = Duration(milliseconds: ${data['expandHoverMilliseconds']});
}
''');
  final file = File(
    'packages/design_system/lib/src/tokens/generated/button_motion.g.dart',
  );
  if (args.contains('--check')) {
    if (!file.existsSync() || file.readAsStringSync() != text) {
      throw StateError('Stale engineering motion tokens');
    }
  } else {
    file.writeAsStringSync(text);
  }
}

List<num> _cubic(Object? value) {
  if (value is! List || value.length != 4 || value.any((e) => e is! num)) {
    throw StateError('Motion curve must be four numbers');
  }
  return value.cast<num>();
}
