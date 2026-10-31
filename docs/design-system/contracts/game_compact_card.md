# GameCompactCard contract

- **Status:** contract, not built. Source-backed set; brightness is not a parameter (E-100).
- **Figma set:** `18457:14096`: Detailed Dark `18451:10177`, Detailed Light `18457:14097` (120×204); Dark `18530:2907`, Light `18530:2929` (120×178). Evidence `evidence/game_cards.json`.
- **Dart:** `lib/features/games/src/presentation/widgets/game_compact_card.dart`, games public API (A6, D-017, D-101). Presentational.

## API
| Parameter | Type | Values / default | Figma source |
|---|---|---|---|
| layout | `GameCompactLayout` | `detailed`, `simple` | Theme value Detailed or plain |
| image | `ImageProvider` | required | Image |
| name | `String` | required | Game Name |
| creator | `String?` | required for `detailed`, absent for `simple` | Game Creator |
| showMark | `bool` | true | ® Sign |
| rewardAmount, rewardUnit | `String` | required | Reward |
| rating | `String` | required | Rate |
| onPressed | `VoidCallback?` | null disables | none |

## Measurements
Column gap 8; image 120, radius 16, RewardBadge overlay at top end with 4 inset. Information padding 4 start and end. Detailed: name, creator, rating with gap 0. Simple: name and rating with gap 4.

## Roles
| Part | Dark | Light |
|---|---|---|
| name | On Surface/Emphasis | On Surface/Base |
| creator and ® | On Surface/Base | On Surface/Muted |

Reward and rating use their contracts.

## Behavior
The whole card is one button whose label includes name, creator, reward and rating. Target at least 48. Text scale 2.0 grows the card.
