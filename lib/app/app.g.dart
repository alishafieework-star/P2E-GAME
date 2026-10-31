// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appLocale)
final appLocaleProvider = AppLocaleProvider._();

final class AppLocaleProvider
    extends $FunctionalProvider<Locale, Locale, Locale>
    with $Provider<Locale> {
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale create(Ref ref) {
    return appLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$appLocaleHash() => r'3fee4ea04339bcd45df9ca5a4c23a458ced8026f';

@ProviderFor(appSkin)
final appSkinProvider = AppSkinProvider._();

final class AppSkinProvider
    extends $FunctionalProvider<SkinDefinition, SkinDefinition, SkinDefinition>
    with $Provider<SkinDefinition> {
  AppSkinProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSkinProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSkinHash();

  @$internal
  @override
  $ProviderElement<SkinDefinition> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SkinDefinition create(Ref ref) {
    return appSkin(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SkinDefinition value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SkinDefinition>(value),
    );
  }
}

String _$appSkinHash() => r'69dd0925201cf108de14600a41df35169ef85648';

/// Cached Material themes. The token-heavy build is cached inside
/// [AppThemeFactory]; these keepAlive providers stop P2EApp rebuilds (locale,
/// mouse-drag flag) from re-running the copyWith work, and rebuild only when
/// the skin or the platform target actually changes.

@ProviderFor(appLightTheme)
final appLightThemeProvider = AppLightThemeProvider._();

/// Cached Material themes. The token-heavy build is cached inside
/// [AppThemeFactory]; these keepAlive providers stop P2EApp rebuilds (locale,
/// mouse-drag flag) from re-running the copyWith work, and rebuild only when
/// the skin or the platform target actually changes.

final class AppLightThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Cached Material themes. The token-heavy build is cached inside
  /// [AppThemeFactory]; these keepAlive providers stop P2EApp rebuilds (locale,
  /// mouse-drag flag) from re-running the copyWith work, and rebuild only when
  /// the skin or the platform target actually changes.
  AppLightThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLightThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLightThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return appLightTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$appLightThemeHash() => r'6f553a802ba96f61e7b7ad78b27019554aba7310';

@ProviderFor(appDarkTheme)
final appDarkThemeProvider = AppDarkThemeProvider._();

final class AppDarkThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  AppDarkThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDarkThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDarkThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return appDarkTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$appDarkThemeHash() => r'431ed3d1d42d5d8ec2f8a92535ac063586e7e0ca';
