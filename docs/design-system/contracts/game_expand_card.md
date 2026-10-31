# GameExpandCard contract

- **Status:** contract, not built. Source-backed set.
- **Figma set:** `18457:14486`: Dark `18457:12229`, Light `18457:14487`, 370×226. Evidence `evidence/game_cards.json`.
- **Dart:** `lib/features/games/src/presentation/widgets/game_expand_card.dart`, games public API (D-101). Presentational.

## API
`image`, `icon` (`ImageProvider`); `name`, `creator`, `rewardAmount`, `rewardUnit`, `actionLabel` (`String`); `showMark`; `onAction`; `caption` (In-app Purchases).

## Measurements
Card radius 16. Banner 370×150 with RewardBadge overlay. Below it, `GameInfoRow` with the `card` layout. The hidden Rate row is not built.

## Roles
| Part | Dark | Light |
|---|---|---|
| card surface | Surface Container/Base | Surface Container/Lowest |
| card border | none | Outline/Variant, 1, inside |

## Behavior
The only action is the Small Tonal button in the row. The banner is decorative. Text scale 2.0 grows the card vertically.
