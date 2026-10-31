import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p2e_dev_inspector/inspector.dart';

void main() {
  test('pairwise coverage is complete and stable for one seed', () {
    final first = buildPairwise(environmentFactors, seed: 7);
    final second = buildPairwise(environmentFactors, seed: 7);
    expect(first, second);
    expect(uncoveredPairs(environmentFactors, first), 0);
    expect(
      uncoveredPairs(
        environmentFactors,
        buildPairwise(environmentFactors, seed: 11),
      ),
      0,
    );
    expect(first.length, lessThan(40));
  });

  test('boundary presets and saved presets round-trip', () {
    final device = SimulatedDevice();
    device.applyPreset(
      engineeringPresets.firstWhere((preset) => preset.id == 'navigator-min'),
    );
    expect(device.settings.size, const Size(252, 800));
    device.applyPreset(
      engineeringPresets.firstWhere(
        (preset) => preset.id == 'asymmetric-inset',
      ),
    );
    expect(device.settings.insets, const EdgeInsets.fromLTRB(40, 12, 8, 48));
    device.resize(610, 900);
    device.rememberPreset('desk');
    final copy = SimulatedDevice()..importPresets(device.exportPresets());
    copy.applyPreset(copy.customPresets.single);
    expect(copy.settings.size, const Size(610, 900));
    expect(
      () => copy.importPresets('{"format":"nope"}'),
      throwsFormatException,
    );
    device.dispose();
    copy.dispose();
  });

  test('width probes stay inside the requested limits', () {
    final sizes = sizesFor(
      axis: SweepAxis.width,
      base: const FrameSettings(size: Size(402, 874)),
      minWidth: 590,
      maxWidth: 610,
      minHeight: 300,
      maxHeight: 1400,
    );
    expect(sizes.map((size) => size.size.width), [599, 600, 601]);
  });
}
