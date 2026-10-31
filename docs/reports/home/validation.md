# Home P0 baseline — 2026-10-24

Figma access was read-only. No product code, token or golden was changed. No commit.

## Toolchain

```text
Flutter 3.47.7 • channel [user-branch]
Framework revision abaf9c5237
Dart 3.13.5
```

This matches the pinned project version. The checkout is not on a named official channel. No SDK change was made.

## Analyze

`dart analyze lib test tool` from the repository root: exit 0, `No issues found!`

A broader `flutter analyze --no-pub` and `dart analyze` from the root also walked `dev_tools/` without that package's resolution and reported 98 issues, all under `dev_tools/inspector/`. Those are not product issues and were not changed. The product package itself is clean.

Tests, format and goldens were not run in this evidence step. The Auth track is editing the same tree, and this step does not run `dart format .` or `--update-goldens`.

# Home build — 2026-10-24

Figma access stayed read-only (reads, screenshots and `download_assets` only). No golden baseline was created or updated. No commit.

## What was built

- Games: `GameCompactCard` (Detailed and simple), `GameExpandCard`, `HomeHeroBanner`, internal `RatingBadge`; `FeaturedGameHero` and `GameShelfSection`; fake and remote-stub repositories.
- Missions: `QuestCard` with internal `QuestProgress` and `Countdown`; `QuestHomeSection`; fake and remote-stub repositories; Mission badge read model.
- Home: `HomeScreen` composes the hero (App Bar over the banner) and four sections in source order.
- App: five-tab shell, honest tab and detail placeholders, Home bindings, `FAKE_MEDIA_BASE`.
- Shared: `CollectionSection`, `SectionError`, number formatting, balance and profile read models, `AppLocations`; core clock and second ticker; transient-only retry policy.

## Checks

| Check | Result |
|---|---|
| `dart format --set-exit-if-changed` on every Home path | 0 changed |
| `dart analyze lib test tool` (root), `lib test` (DS, Viewer) | No issues |
| `dart run tool/check_architecture.dart` | passed (adds `home:games`) |
| `dart run tool/agents/sync_agent_files.dart --check` | up to date |
| `node tool/tokens/generate_home.cjs --check` | up to date |
| `flutter test` Design System | 533 passed |
| `flutter test` Viewer | 36 passed |
| `flutter test` product | 526 passed, 10 failed |

The 10 product failures predate the Home build. They are the Light variants that the uncommitted D-065 change (`themeMode: ThemeMode.dark`) can no longer show: `bootstrap_test` "boots en/fa Brightness.light" and 8 `auth-*-light-1.0-402` goldens. Home did not touch them.

## Figma conformance (402 wide, 55 status bar)

`test/features/home/home_screen_test.dart` checks the Home Expand frame: banner 343, App Bar 64 at 55, featured row 78 at 343, sections at 421 (284), 705, 1035.5 (284) and 1319.5 (414.5), compact card 120×204, quest card 370×315. Multiplayer is about 330.5 instead of 325.5 (E-110).

## Device run

Android emulator `emulator-5554` (API 36): signed in through the development OTP and reached Home. Every section, the live countdown, the Mission badge and the sample artwork rendered. Screens: `build/home-review/07_home_top.png`, `08_home_middle.png`, `09_home_bottom.png` (local, not committed).

# بستن کیفیت Home — 2026-10-25

فیگما فقط خواندنی ماند. Golden ساخته نشد. commit نشده. تم محصول طبق D-065 روی Dark است.

## D-104

- اسکرول صفر: تصویر قهرمان پشت نوار وضعیت می‌ماند.
- بعد از اسکرول: نوار `Surface/Base` فقط به ارتفاع inset وضعیت سنجاق می‌شود. App Bar همچنان با صفحه حرکت می‌کند.
- Parallax مهندسی: پس‌زمینه ۰.۲۵ و شیء جلو ۰.۵۵ برابر اسکرول، هر کدام حداکثر ۴۸ پیکسل. reduced motion هر دو را ثابت می‌کند. ضریب‌ها در `design/engineering/home.json` هستند.
- از عرض ۶۰۰ به بالا ستون Home همان ۶۰۰ است و وسط صفحه می‌نشیند. دو طرف `Surface/Base` است.

## تست

`flutter test test/features/home/home_screen_test.dart`: ۱۰ گذشت. هندسه فریم Expand در Dark و Light یکسان است (بنر ۳۴۳، App Bar ۶۴، ردیف ۷۸، بخش‌ها ۲۸۴ / حدود ۳۳۰.۵ / ۲۸۴ / ۴۱۴.۵). اختلاف Multiplayer همان E-110 است.

امولاتور `emulator-5554` بعد از این تغییر: با اسکرول، نوار وضعیت پس‌زمینه تیره دارد و کارت‌ها زیر ساعت نمی‌روند. تصویر: `build/home-review/10_scrolled.png` (محلی، commit نمی‌شود).
