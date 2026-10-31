# QuestCard contract

- **Status:** contract, not built. Detached Game Card in Mission and Quest (R-100).
- **Figma:** Dark `18457:13272`, Light `18457:15685`; 370×315. Evidence `evidence/quest_card.json`.
- **Dart:** `lib/features/missions/src/presentation/widgets/quest_card.dart`, missions public API (D-101). It composes `GameInfoRow` (quest), `QuestProgress`, `RewardBadge` (total) and `Countdown`. Presentational.

## API
Game identity and action as in `GameInfoRow`; `progress`; `status` text; optional `statusDetail` digits (the source hides them before a quest starts); `total` reward; `countdown`.

## Measurements
Card radius 20. Body horizontal padding 16. Panel 338×150, radius 16. Status row padding 16, height 58. Footer padding 16, height 80.

## Roles
| Part | Dark | Light |
|---|---|---|
| card surface | Surface Container/Base | Surface Container/Lowest |
| card border | none | Outline/Variant, 1, inside |
| panel | Surface Container/High | Surface Container/High |
| status words and digits | On Surface/Base | On Surface/Muted |

## Typography
Status words `English/Baseline/Label-Small`; status digits `English/Muted/Number-Medium`.

## Behavior
The only action is the quest button. The card also exposes name, status and remaining time as one group. Several cards page through `AppShelf` with `relaxed` spacing.
