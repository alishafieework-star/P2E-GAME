# Home component contracts — 2026-10-24

Source snapshot: `docs/snapshots/2026-10-24_home`. Evidence for every value is in its `evidence/` folder. Figma access was read-only. Decisions: D-100–D-103. Errata: E-100–E-111. Requests: R-100, R-101.

No golden baseline is authorized. Widgets are presentational: display-ready text, images, enums and callbacks only. Colors come from generated `ThemedRole` values, one role per brightness.

| Contract | Dart | Placement | Status |
|---|---|---|---|
| [section_header.md](section_header.md) | `AppSectionHeader` | Design System | built, provisional |
| [page_indicator.md](page_indicator.md) | `AppPageIndicator` | Design System | built, provisional |
| [app_shelf.md](app_shelf.md) | `AppShelf` | Design System | built, provisional |
| [game_info_row.md](game_info_row.md) | `GameInfoRow` | `lib/shared/widgets` | built, provisional |
| [reward_badge.md](reward_badge.md) | `RewardBadge` | `lib/shared/widgets` | built, provisional |
| [rating_badge.md](rating_badge.md) | `RatingBadge` | `features/games`, not exported | built, provisional |
| [game_compact_card.md](game_compact_card.md) | `GameCompactCard` | `features/games` public API | built, provisional (E-111) |
| [game_expand_card.md](game_expand_card.md) | `GameExpandCard` | `features/games` public API | built, provisional (E-110) |
| [home_hero_banner.md](home_hero_banner.md) | `HomeHeroBanner` | `features/games` public API | built, provisional; parallax static |
| [quest_progress.md](quest_progress.md) | `QuestProgress` | `features/missions`, not exported | built, provisional |
| [countdown.md](countdown.md) | `Countdown` | `features/missions`, not exported | built, provisional |
| [quest_card.md](quest_card.md) | `QuestCard` | `features/missions` public API | built, provisional |
| — | `CollectionSection` | `lib/shared/widgets` | built, provisional (D-103) |

Home screen (`features/home`): App Bar over the hero, then Recommended, Multiplayer, Competition and Mission and Quest, matching the Home Expand frame at 402 wide (`test/features/home/home_screen_test.dart`).

Generated tokens: `CollectionTokens`, `CollectionRoles`, `CollectionText`, `CollectionMotion` (Design System primitives) and `HomeTokens`, `HomeRoles`, `HomeText`, `HomePaints`, `HomeStrokes`, `HomeShadows` (product widgets). Both come from `tool/tokens/generate_home.cjs`. `HomePaints` holds paints that are a raw source color in at least one theme (`RawPaint`, kept for the product skin, resolved to a fallback role for other skins). Engineering values (`design/engineering/home.json`): paging motion and the hero vignette fallback roles.
