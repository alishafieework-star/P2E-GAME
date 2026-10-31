---
id: p2e-app-platform
description: Rules for the app composition root and platform layer in lib/app (bootstrap, router, shell, platform). Apply when editing lib/app.
globs:
  - "lib/app/**"
---
# App and platform

- iOS and Android behave the same. Only `lib/app/platform` may inspect the platform, and only for an approved entry in
  `docs/agents/registers/platform-exceptions.md`. Mark code with `// PLATFORM(PE-###): reason`.
- Approved now: PE-001 scroll physics (iOS bounce, Android stretch), PE-002 system back (Android back/predictive back,
  iOS edge-swipe back), PE-003 OTP SMS (Android SMS Retriever fills the field; iOS keeps the oneTimeCode
  keyboard suggestion). Page transitions are one shared transition on both platforms.
- Set page transitions (`PageTransitionsTheme`, same builder for every platform) and scroll behavior (`ScrollBehavior`, PE-001)
  once in `MaterialApp`. Per-platform behavior built into Flutter widgets (text selection handles, context menu, keyboard)
  is accepted; if one changes look or motion in a way the owner would notice, propose a PE entry instead of patching it.
- `MaterialApp.router` sets `theme`, `darkTheme`, `themeMode` (provisional Dark, D-065),
  locale (provisional `en` until Persian is ready, D-065; `fa` stays supported) and a text
  scaler clamped to 2.0× using TextScaler.clamp (D-044).
- Orientation: phones portrait-only; tablets (Medium/Expanded) portrait and landscape.
- `lib/main.dart` is the release entrypoint and never imports `lib/dev`. `lib/main_dev.dart` wraps the same app with the Inspector.

## D-019 / D-020 migration

The root product has no dev entrypoint after D-019. The Windows Debug runner is moved to the independent viewer; do not infer product platform support.

## D-037–D-042 Entry foundation

D-065 supersedes D-041's fa default: product locale is en and themeMode is Dark until Persian is ready and the owner restores System. `fa` stays supported. No picker/preferences screen yet. D-044 supports product text through 2.0; App Bar text and Navigator labels alone use chromeTextScaleCap=1.3. PageScaffold inherits scale. Bootstrap exposes neutral wrapper/provider-override hooks, unused by production main. Optional host tools are isolated under removable dev_tools/; no app, package, pubspec, workspace or CI reference is allowed. D-019 retains the independent Viewer. No product main_dev or Inspector is authorized.

D-043 uses Riverpod runtime 3.x with generator ^4.0.9, annotation ^4.0.7 and lint ^3.1.9. Enable `riverpod_lint` in the top-level `plugins` section of analysis_options.yaml for packages defining providers; run `dart analyze`. The legacy custom_lint runner/configuration is removed.

D-068: `tool/fake_backend/server.dart` is a development process and is not part of the APK. `FAKE_API_BASE` defaults to `http://127.0.0.1:8787`. The Android emulator uses `http://10.0.2.2:8787`. Cleartext HTTP is allowed only in the debug and profile Android manifests.

D-071 / PE-003: Android OTP listening uses SMS Retriever through `lib/app/platform`. Debug and profile also receive `SMS_RECEIVED` so an emulator SMS reaches the same parser. Release does not request that permission. iOS does not read the inbox. The development SMS tools in `tool/sms/` are not packaged.

D-073: the product theme uses one `PageTransitionsTheme` builder on every platform. Auth routes except startup use that horizontal slide. Back reverses it. Reduced motion shows the destination immediately. Figma defines no page motion for the auth back bars or primary buttons. Where those routes go is D-139.

D-131: opening Game Details squeezes the page underneath toward the start edge, then slides the details page in from the end. Back reverses that motion. Reduced motion is immediate. Other routes keep the D-073 slide. Figma defines no motion for this push. The Onboarding exit uses the same Flutter delegatedTransition hook, but its motion is the HTML soft-out and soft-in (D-138), not this squeeze.

D-137: the splash overlay is built in the `MaterialApp.router` builder, above the navigator, so the next route is visible through the logo hole. Startup waits for the collapse signal before that route is built. Reduced motion holds a static logo for 600ms. The Android launch background and the iOS LaunchScreen use `#0a0a0a`.

D-138: startup order is splash, then onboarding when `onboardingSeen` is false, otherwise Auth Entry. `/entry/onboarding` sits above `/entry`. Leaving onboarding plays the HTML soft-out on that route and the HTML soft-in on Auth Entry through delegatedTransition.

D-139: `/entry/verify`, `/entry/username`, `/entry/avatar`, `/entry/notifications`, `/entry/all-set` and `/entry/welcome-back` stay inside the existing auth redirect. The session becomes signed in only from All Set or Welcome Back.

D-140: notification permission is requested only from `lib/app/platform`, behind the shared port. `POST_NOTIFICATIONS` is declared for Android 13 and later. The only new package is `permission_handler`.

D-141: `/legal/:doc` is reachable in every startup state. Auth legal links open it. The page enters over 460ms and leaves over 300ms.

D-142: the shell hosts the Home tour above the Navigator. `lib/app` may import the tour feature. The tour does not import games, missions or home.
