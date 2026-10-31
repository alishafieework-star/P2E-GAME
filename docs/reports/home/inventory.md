# Home component inventory — 2026-10-24

Read-only source: Figma copy `7PGTHT5CQzbTsWZQnPIQce`, EN page `16458:11`. Evidence is `docs/snapshots/2026-10-24_home`. No designer named version is available. This inventory does not approve pixels.

## What already exists

| Source | Code |
|---|---|
| App Bar Container `18422:12447`, Home Dark and `Home- Light` | `HomeAppBar` |
| Navigator Bar Container `18422:11475` | `AppNavigationBar` |
| Small Button Tonal, Dark `18436:1673` and Light `18436:1704` | `AppButton` |
| Fill icons Crown, Poker Chip, Add Larg, Chevron Right, Verified, Trophy, Workspace Premium 2, Home, Star | existing `AppIconId` values, including `pokerChip` and `addLarge` |
| Outline icons Help, Target Check, Stadia Controller, Leaderboard, Store | existing `AppIconId` values |

Navigator source order is Home (Fill, active), Mission (Target Check), Games (Stadia Controller), Leaderboard, Shop (Store). Status bar, Home Slider and the hidden keyboard are OS chrome and are not built.

## Placement agreed for the twelve missing families

Presentational widgets take only display-ready values. Sections own providers, formatting, copy and navigation. See D-100 and D-101.

| Family | Source | Placement |
|---|---|---|
| `AppSectionHeader` | detached, inside `18533:4266` | Design System, provisional, built |
| `AppPageIndicator` | detached Pagination | Design System, provisional, built |
| `AppShelf` | detached Games Slider | Design System, provisional, built |
| GameInfoRow | `18533:4252`, also inside the expand card and the quest card | `lib/shared/widgets`, new file, built |
| RewardBadge | overlay, step and total appearances | `lib/shared/widgets`, new file, built |
| GameCompactCard | set `18457:14096` | `features/games` public API |
| GameExpandCard | set `18457:14486` | `features/games` public API |
| HeroBanner | `18533:4246` | `features/games` public API |
| RatingBadge | inside the compact card | `features/games`, not exported |
| QuestCard | `18457:13272` | `features/missions` public API |
| QuestProgress | inside the quest card | `features/missions`, not exported |
| Countdown | inside the quest card | `features/missions`, not exported |

`home` only orders the sections. Event and Offer Card and Comment stay out of this task and belong to `games` later.

## Source facts that code must not normalize away

- Game Compact Card `Theme` mixes layout and brightness. Code uses `detailed` (204) or `simple` (178); brightness comes from the theme. E-100.
- Light section `18457:15141` is named Competition Games but its title text `18457:15144` says Recommended for You. Dark text `18457:13127` says Competition Games. Code uses Competition Games in both themes. E-101.
- Captions Free to Play and In-app Purchases have no text style (Outfit SemiBold 10 / auto). E-102.
- Sky/500, Green/500, Green/600 and Yellow/400 are used directly. E-103. R-100.
- The incomplete progress segment is raw `#404040` at 70% opacity in Dark and 20% in Light. E-104.
- A completed quest marker is neutral in Dark and Green/600 in Light. Each theme keeps its own source color. E-105.
- GameInfoRow has three source geometries: featured icon 54 / Title-Medium, card icon 48 / Title-Small, quest icon 46 / Title-Medium. E-106.

Every value used by code is generated from `docs/snapshots/2026-10-24_home/evidence` by `tool/tokens/generate_home.cjs`. The generator fails on a missing path, an inconsistent value, or a palette color without an approved role.

Direct instance counts in the first pass were 30 per frame. The complete query counts 44 because App Bar and Navigator contain 14 nested instances. Both numbers are in `instances.json`.
