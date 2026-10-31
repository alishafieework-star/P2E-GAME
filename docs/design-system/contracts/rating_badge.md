# RatingBadge contract

- **Status:** contract, not built. Nested in Game Compact Card (R-100).
- **Figma:** detailed `18451:10177` / `18457:14097`; simple `18530:2907` / `18530:2929`. The expand card's rate row is hidden and is not this widget. Evidence `evidence/game_cards.json`.
- **Dart:** `lib/features/games/src/presentation/widgets/rating_badge.dart`, not exported (D-101). Presentational.

## API
`value` (`String`, already formatted) and `layout` (`detailed` or `simple`, from the card).

## Measurements
Row height 22, padding 6 / 2 / 6 / 2, gap 2, radius 8, star 16. The detailed card wraps it in a 6-pixel top and bottom inset.

## Roles
| Card layout | Part | Dark | Light |
|---|---|---|---|
| detailed | surface | Surface Container/Base | Surface Container/High |
| detailed | value | On Surface/Emphasis | On Surface/Variant |
| simple | surface | Surface Container/High | Surface Container/Lowest |
| simple | value | On Surface/Emphasis | On Surface/Base |
| both | star | `Yellow/400` source (E-103) | same |

## Typography
`English/Baseline/Number-Medium`.

## Behavior
Not a button. The value is the semantic label; the star is decorative. The number run stays left-to-right.
