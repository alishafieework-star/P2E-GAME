import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2e_design_system/design_system.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/games/games.dart';
import '../l10n/generated/app_localizations.dart';
import '../core/platform/device_inputs.dart';
import 'router/app_router.dart';
import 'router/auth_transition.dart';
import 'platform/system_chrome.dart';
import 'startup/splash_overlay.dart';
part 'app.g.dart';

// D-065: English until Persian product copy is ready.
@Riverpod(keepAlive: true)
Locale appLocale(Ref ref) {
  // D-052: observe OS changes. D-065 does not follow them.
  ref.watch(deviceLocalesProvider);
  return const Locale('en');
}

// D-046: neutral hosts may override this; product has no skin picker.
@Riverpod(keepAlive: true)
SkinDefinition appSkin(Ref ref) => productSkin;

/// Cached Material themes. The token-heavy build is cached inside
/// [AppThemeFactory]; these keepAlive providers stop P2EApp rebuilds (locale,
/// mouse-drag flag) from re-running the copyWith work, and rebuild only when
/// the skin or the platform target actually changes.
@Riverpod(keepAlive: true)
ThemeData appLightTheme(Ref ref) =>
    AppThemeFactory.build(
      brightness: Brightness.light,
      skin: ref.watch(appSkinProvider),
    ).copyWith(
      platform: ref.watch(deviceTargetPlatformProvider),
      pageTransitionsTheme: sharedAuthPageTransitions,
    );

@Riverpod(keepAlive: true)
ThemeData appDarkTheme(Ref ref) =>
    AppThemeFactory.build(
      brightness: Brightness.dark,
      skin: ref.watch(appSkinProvider),
    ).copyWith(
      platform: ref.watch(deviceTargetPlatformProvider),
      pageTransitionsTheme: sharedAuthPageTransitions,
    );

class P2EApp extends ConsumerWidget {
  const P2EApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mouseDrag = ref.watch(deviceMouseDragProvider);
    ref.watch(gameDetailsSessionProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: ref.watch(appLightThemeProvider),
      darkTheme: ref.watch(appDarkThemeProvider),
      themeMode:
          ThemeMode.dark, // D-065: provisional dark until System returns.
      locale: ref.watch(appLocaleProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, child) {
        final page = AppSystemChrome(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.textScalerOf(context)
                  .clamp(maxScaleFactor: contentTextScaleCap),
            ),
            child: SplashOverlay(
              // D-145: pages move over a solid surface, not a bare window.
              child: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: child!,
              ),
            ),
          ),
        );
        if (!mouseDrag) return page;
        final behavior = ScrollConfiguration.of(context);
        return ScrollConfiguration(
          behavior: behavior.copyWith(
            dragDevices: {...behavior.dragDevices, PointerDeviceKind.mouse},
          ),
          child: page,
        );
      },
    );
  }
}
