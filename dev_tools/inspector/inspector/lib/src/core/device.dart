import 'dart:convert';

import 'package:flutter/material.dart';

enum FrameMode { free, fitWindow }

/// OS inputs only. [testSkin] is a separate developer option retained for v1.
@immutable
class FrameSettings {
  factory FrameSettings.fromJson(Map data) {
    final edges = data['insets'] as Map;
    Locale locale(String value) {
      final parts = value.split('-');
      return Locale.fromSubtags(
        languageCode: parts.first,
        scriptCode: parts.length > 1 && parts[1].length == 4 ? parts[1] : null,
        countryCode: parts.length > 2
            ? parts[2]
            : parts.length == 2 && parts[1].length != 4
            ? parts[1]
            : null,
      );
    }

    return FrameSettings(
      size: Size(
        (data['width'] as num).toDouble(),
        (data['height'] as num).toDouble(),
      ),
      insets: EdgeInsets.fromLTRB(
        (edges['left'] as num).toDouble(),
        (edges['top'] as num).toDouble(),
        (edges['right'] as num).toDouble(),
        (edges['bottom'] as num).toDouble(),
      ),
      scale: (data['textScale'] as num).toDouble(),
      brightness: Brightness.values.byName(data['brightness'] as String),
      locales: (data['locales'] as List).cast<String>().map(locale).toList(),
      platform: TargetPlatform.values.byName(data['platform'] as String),
      keyboard: data['keyboard'] as bool,
      keyboardHeight: (data['keyboardHeight'] as num).toDouble(),
      disableAnimations: data['disableAnimations'] as bool,
      boldText: data['boldText'] as bool,
      highContrast: data['highContrast'] as bool,
      testSkin: data['testSkin'] as bool? ?? false,
    );
  }
  const FrameSettings({
    this.size = const Size(402, 874),
    this.insets = const EdgeInsets.fromLTRB(0, 24, 0, 24),
    this.scale = 1,
    this.brightness = Brightness.dark,
    this.locales = const [Locale('fa', 'IR')],
    this.testSkin = false,
    this.keyboard = false,
    this.keyboardHeight = 300,
    this.disableAnimations = false,
    this.boldText = false,
    this.highContrast = false,
    this.platform = TargetPlatform.android,
  });
  final Size size;
  // PHYSICAL: simulated display coordinates; rotate maps physical edges clockwise.
  final EdgeInsets insets;
  final double scale, keyboardHeight;
  final Brightness brightness;
  final List<Locale> locales;
  Locale get locale =>
      locales.isEmpty ? const Locale('en', 'US') : locales.first;
  final bool testSkin, keyboard, disableAnimations, boldText, highContrast;
  final TargetPlatform platform;
  String get sizeClass => size.width < 600
      ? 'compact'
      : size.width < 840
      ? 'medium'
      : 'expanded';
  FrameSettings copyWith({
    Size? size,
    EdgeInsets? insets,
    double? scale,
    Brightness? brightness,
    List<Locale>? locales,
    Locale? locale,
    bool? testSkin,
    bool? keyboard,
    double? keyboardHeight,
    bool? disableAnimations,
    bool? boldText,
    bool? highContrast,
    TargetPlatform? platform,
  }) => FrameSettings(
    size: size ?? this.size,
    insets: insets ?? this.insets,
    scale: scale ?? this.scale,
    brightness: brightness ?? this.brightness,
    locales: List.unmodifiable(
      locales ?? (locale == null ? this.locales : [locale]),
    ),
    testSkin: testSkin ?? this.testSkin,
    keyboard: keyboard ?? this.keyboard,
    keyboardHeight: keyboardHeight ?? this.keyboardHeight,
    disableAnimations: disableAnimations ?? this.disableAnimations,
    boldText: boldText ?? this.boldText,
    highContrast: highContrast ?? this.highContrast,
    platform: platform ?? this.platform,
  );
  MediaQueryData get media => MediaQueryData(
    size: size,
    padding: EdgeInsets.fromLTRB(
      insets.left,
      insets.top,
      insets.right,
      keyboard
          ? (insets.bottom - keyboardHeight).clamp(0, double.infinity)
          : insets.bottom,
    ),
    viewPadding: insets,
    viewInsets: EdgeInsets.only(bottom: keyboard ? keyboardHeight : 0),
    devicePixelRatio: 1,
    platformBrightness: brightness,
    textScaler: TextScaler.linear(scale),
    disableAnimations: disableAnimations,
    boldText: boldText,
    highContrast: highContrast,
  );
  Map<String, Object?> toJson() => {
    'width': size.width,
    'height': size.height,
    'locales': locales.map((e) => e.toLanguageTag()).toList(),
    'brightness': brightness.name,
    'textScale': scale,
    'platform': platform.name,
    'insets': {
      'top': insets.top,
      'bottom': insets.bottom,
      'left': insets.left,
      'right': insets.right,
    },
    'keyboard': keyboard,
    'keyboardHeight': keyboardHeight,
    'disableAnimations': disableAnimations,
    'boldText': boldText,
    'highContrast': highContrast,
    'testSkin': testSkin,
  };
}

/// Engineering size probe. Marketing presets stay on [SimulatedDevice.presets].
class FramePreset {
  const FramePreset(this.id, this.size, {this.insets, this.settings});
  final String id;
  final Size size;
  final EdgeInsets? insets;

  /// Full device snapshot for a saved preset. Null for a built-in size probe.
  final FrameSettings? settings;
}

/// Boundary widths and heights the Android emulator does not enumerate.
const engineeringPresets = <FramePreset>[
  FramePreset('navigator-below', Size(251, 800)),
  FramePreset('navigator-min', Size(252, 800)),
  FramePreset('navigator-above', Size(253, 800)),
  FramePreset('compact-edge', Size(599, 800)),
  FramePreset('medium-min', Size(600, 800)),
  FramePreset('medium-above', Size(601, 800)),
  FramePreset('medium-edge', Size(839, 900)),
  FramePreset('expanded-min', Size(840, 900)),
  FramePreset('expanded-above', Size(841, 900)),
  FramePreset('short', Size(360, 300)),
  FramePreset('tall', Size(360, 1400)),
  FramePreset('landscape', Size(874, 402)),
  FramePreset(
    'asymmetric-inset',
    Size(402, 874),
    insets: EdgeInsets.fromLTRB(40, 12, 8, 48),
  ),
];

/// Scriptable state driver. No app callbacks, navigation, or input injection.
class SimulatedDevice extends ChangeNotifier {
  SimulatedDevice([this.settings = const FrameSettings()]);
  FrameSettings settings;
  FrameMode mode = FrameMode.free;
  bool actualSize = false;
  double? zoomOverride;
  static const presets = [
    Size(320, 568),
    Size(360, 800),
    Size(402, 874),
    Size(412, 915),
    Size(600, 960),
    Size(744, 1133),
    Size(800, 1280),
    Size(820, 1180),
    Size(1024, 1366),
  ];
  final List<FramePreset> customPresets = [];
  void apply(FrameSettings value) {
    settings = value.copyWith(
      size: Size(
        value.size.width.clamp(200, 1400),
        value.size.height.clamp(300, 1400),
      ),
      scale: value.scale.clamp(.85, 3),
      insets: EdgeInsets.fromLTRB(
        value.insets.left.clamp(0, 1400),
        value.insets.top.clamp(0, 1400),
        value.insets.right.clamp(0, 1400),
        value.insets.bottom.clamp(0, 1400),
      ),
      keyboardHeight: value.keyboardHeight.clamp(0, 1400),
    );
    notifyListeners();
  }

  void resize(double width, double height) {
    mode = FrameMode.free;
    apply(settings.copyWith(size: Size(width, height)));
  }

  void setMode(FrameMode value) {
    mode = value;
    notifyListeners();
  }

  static EdgeInsets insetsFor(Size value) => value == const Size(320, 568)
      ? const EdgeInsets.fromLTRB(0, 20, 0, 0)
      : value.width < 600
      ? const EdgeInsets.fromLTRB(0, 24, 0, 24)
      : const EdgeInsets.fromLTRB(0, 24, 0, 20);

  void preset(Size value) {
    mode = FrameMode.free;
    apply(settings.copyWith(size: value, insets: insetsFor(value)));
  }

  void applyPreset(FramePreset preset) {
    mode = FrameMode.free;
    final saved = preset.settings;
    if (saved != null) {
      apply(saved);
      return;
    }
    apply(
      settings.copyWith(
        size: preset.size,
        insets: preset.insets ?? insetsFor(preset.size),
      ),
    );
  }

  void rememberPreset(String id) {
    customPresets.removeWhere((preset) => preset.id == id);
    customPresets.add(FramePreset(id, settings.size, settings: settings));
    notifyListeners();
  }

  String exportPresets() => const JsonEncoder.withIndent('  ').convert({
    'format': 'p2e-inspector-presets-v1',
    'presets': [
      for (final preset in customPresets)
        {'id': preset.id, 'settings': preset.settings!.toJson()},
    ],
  });

  void importPresets(String raw) {
    final data = jsonDecode(raw);
    if (data is! Map || data['format'] != 'p2e-inspector-presets-v1') {
      throw const FormatException('Unsupported preset document');
    }
    final presets = data['presets'];
    if (presets is! List) throw const FormatException('Preset list missing');
    for (final item in presets) {
      if (item is! Map) continue;
      final settings = FrameSettings.fromJson(item['settings'] as Map);
      final id = item['id'] as String;
      customPresets.removeWhere((preset) => preset.id == id);
      customPresets.add(FramePreset(id, settings.size, settings: settings));
    }
    notifyListeners();
  }

  void rotate() {
    final i = settings.insets;
    mode = FrameMode.free;
    apply(
      settings.copyWith(
        size: settings.size.flipped,
        insets: EdgeInsets.fromLTRB(i.bottom, i.left, i.top, i.right),
      ),
    );
  }

  double zoomFor(Size viewport) {
    if (actualSize) return 1;
    final w = (viewport.width / settings.size.width).clamp(.01, 1.0);
    final h = (viewport.height / settings.size.height).clamp(.01, 1.0);
    return zoomOverride ?? (w < h ? w : h).toDouble();
  }
}
