# Parallel work notice — Home track — 2026-10-24

On 2026-10-24 the owner paused parallel work. Home is the only active track until it is finished. The reserved identifier gap stays, so a later Auth session does not collide with D-100–D-119. Existing uncommitted Auth files are still not rewritten. Shared files may be edited by the Home track when a step needs them, after re-reading them.

The Home track and the Auth track share one working tree. This notice is the operating agreement. It does not change Auth behavior.

## Shared files the Home build touched (2026-10-24)

Read again before editing; additive except where noted. Auth behavior is unchanged.

- `lib/app/router/app_router.dart`: `/home` is now the five-tab shell (`StatefulShellRoute`) with `/missions`, `/games`, `/leaderboard`, `/shop`, plus pushed `/game/:id` and `/quest/:id` placeholders. A signed-in session may visit any product location; only `/`, `/startup` and `/entry…` redirect to `/home`. The `/home` and `/ready` placeholders were removed; Auth routes are untouched.
- `lib/app/bootstrap.dart`: one line, `...homeBindings(config)`.
- `lib/app/config/app_config.dart`: new `fakeMediaBase` / `FAKE_MEDIA_BASE` (default `http://127.0.0.1:8788`), validated like `FAKE_API_BASE`.
- `l10n/app_en.arb`, `l10n/app_fa.arb`: keys appended (`home*`, `nav*`, `shell*`); no Auth key changed.
- `test/features/auth/otp_screen_test.dart`, `password_screen_test.dart`, `integration_contract_test.dart`: the Home check now finds `ValueKey('home.page')` instead of the removed placeholder text (7 finders, 1 test name). Nothing else changed.
- `tool/check_architecture.dart` and `test/tool/architecture_test.dart`: the `home:games` edge (D-101) and a `missions → games` negative case.
- Generated files refreshed by their generators: `lib/l10n/generated/**` and provider `*.g.dart` hashes.
- Development media origin: `tool/fake_media/media_server.dart` (a new folder, not `tool/fake_backend/**`).

## Home-owned paths

New files only:

- `lib/app/shell/**`, `lib/app/home_bindings.dart`
- `lib/features/home/**`, `lib/features/games/**`, `lib/features/missions/**`
- `lib/shared/navigation/**`, `lib/shared/balance/**`, `lib/shared/profile/**`, `lib/core/time/**`
- new files `lib/shared/widgets/game_info_row.dart` and `lib/shared/widgets/reward_badge.dart`
- new Design System component folders for SectionHeader, PageIndicator and Shelf, plus their generated token file
- new Viewer gallery entries for those three components
- `docs/snapshots/2026-10-24_home/**`, `docs/reports/home/**`
- new Home contracts and `tool/tokens/generate_home.cjs`

## Paths Home does not edit

- `lib/features/auth/**`, `test/features/auth/**`, `test/support/auth_harness.dart`
- `lib/app/auth_bindings.dart`, `lib/app/platform/dev_otp_*`
- `tool/fake_backend/**`, `tool/sms/**`
- Auth assets, Auth goldens, `docs/reports/auth-*`
- existing Design System components, including `AppButton`

## Shared files

Home edits these only at an integration step, append-only, after re-reading the file:

- `lib/app/router/app_router.dart` (the `/home` placeholder and the `StartupState.ready` redirect)
- `lib/app/bootstrap.dart`
- `l10n/app_en.arb` and `l10n/app_fa.arb` (one contiguous Home block)
- `packages/design_system/lib/design_system.dart`
- `tool/check_architecture.dart` and `test/tool/architecture_test.dart`
- the registers and `docs/agents/rules/features-screens.md`
- `.github/workflows/check.yml`
- the single Auth test that expects the Home placeholder text

Do not restructure the `/home` placeholder before that integration edit. Do not run `dart format .` or a repo-wide `--update-goldens`.

## Reserved identifiers

Recorded at the moment of writing, Auth decisions already reach D-074. Errata ends at E-016. Designer requests end at R-015.

Home uses D-100–D-119, E-100–E-109, R-100–R-109 and O-100–O-109. Auth continues at D-075, E-017 and R-016. The gap is intentional so the two tracks do not take the same number.

## Presentational widgets

A widget under `presentation/**/widgets/` or `lib/shared/widgets/` takes display-ready text, formatted numbers, images, enums and callbacks. It does not import Riverpod, go_router, repositories, or `AppLocalizations`. The feature section does. The checker enforcement lands with the Home Design System work. New Auth widgets should follow the same rule; existing Auth widgets already do.
