# Countdown contract

- **Status:** contract, not built. Detached counter in the quest card (R-100, R-101).
- **Figma:** footer of `18457:13272` (Dark) and `18457:15685` (Light). Evidence `evidence/quest_card.json`.
- **Dart:** `lib/features/missions/src/presentation/widgets/countdown.dart`, not exported (D-101). Presentational: the section turns a server deadline into four digit pairs.

## API
`days`, `hours`, `minutes`, `seconds` (two display characters each) and four localized labels. The widget does not tick.

## Measurements
Units gap 6. Unit 60×48, vertical gap 4. Digit box 28×32, padding 6, radius 5, digit gap 4. Separator dots 2.5, gap 5, bottom inset 20.

## Roles
| Part | Dark | Light |
|---|---|---|
| digit box | Surface Container/High | Surface Container/High |
| digits, labels and dots | On Surface/Emphasis | On Surface/Variant |

## Typography
Digits `English/Baseline/Number-Large`; labels `English/Baseline/Status-Medium`.

## Behavior
One label reads the full remaining time. Digit runs stay left-to-right. What happens at zero is not in Figma (R-101); the widget shows what it receives.
