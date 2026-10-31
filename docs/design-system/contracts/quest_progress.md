# QuestProgress contract

- **Status:** contract, not built. Detached progress in the quest card (R-100).
- **Figma:** Dark `18457:13272`, Light `18457:15685`. Evidence `evidence/quest_card.json`.
- **Dart:** `lib/features/missions/src/presentation/widgets/quest_progress.dart`, not exported (D-101). Presentational.

## API
`steps` (at least 2) and `completedCount`. Each step has a formatted reward amount, unit and a role: `start`, `done`, `waiting`, `end`. Icons: crown, verified, workspace premium 2, trophy.

## Measurements
Track 306×12, radius 4. Marker 28, radius 8, padding 4, icon 20. Step RewardBadge (`step`) 34 above its marker. Header padding 56 / 16 / 24 / 16 with a 1.5 bottom divider.

## Roles
| Part | Dark | Light |
|---|---|---|
| completed segment | `Green/500` source (E-103) | `Green/500` |
| incomplete segment | raw `#404040` 70% (E-104) | raw `#404040` 20% |
| start and done marker | Surface Container/Highest | `Green/600` source (E-105) |
| end marker | Surface Container/Highest | Surface Container/Highest |
| start and done icon | On Surface/Emphasis | Alpha/White |
| end icon | On Surface/Base | On Surface/Muted |
| divider | Outline/Base | Outline/Base |

## Behavior
One semantic description covers completed count and the next reward. Markers ignore pointers. Text scale 2.0 grows markers and rewards without clipping. The first step stays at the start in RTL.
