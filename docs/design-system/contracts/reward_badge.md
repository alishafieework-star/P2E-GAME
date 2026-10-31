# RewardBadge contract

- **Status:** provisional. Three detached appearances (R-100).
- **Figma:** overlay in `18451:10177` / `18457:14097`; step and total in the quest card `18457:13272` / `18457:15685`. Evidence `evidence/game_cards.json`, `quest_card.json`.
- **Dart:** `lib/shared/widgets/reward_badge.dart`
- **Placement:** shared (D-101). Presentational. The caller supplies formatted amounts and localized digits (D-049).

## API
| Parameter | Type | Values / default |
|---|---|---|
| appearance | `RewardBadgeAppearance` | `overlay`, `step`, `total` |
| amount, unit | `String` | required |
| emphasis | `RewardBadgeEmphasis` | `active` (default), `upcoming` — step only |
| secondaryAmount | `String?` | total only |

## Measurements
| Appearance | padding start/top/end/bottom | gap | radius | crown |
|---|---|---|---|---|
| overlay | 4 / 4 / 6 / 4 | 4; amount–unit 2 | 16 | plate 18, artwork 14 |
| step | 6 / 2 / 6 / 2 | amount–unit 2 | 16 | none |
| total | 4 / 4 / 8 / 4 | 4; segments 4; secondary–unit 2 | 16 | plate 18, artwork 14 |

Overlay background blur 5.

## Roles
| Part | Dark | Light |
|---|---|---|
| overlay scrim | source `#000000` 50% | source `#ffffff` 80% |
| overlay plate | Countainer/Pink | Primary/Pink |
| overlay crown | Primary/Pink | Countainer/Pink |
| overlay amount | On Surface/Emphasis | On Surface/Emphasis |
| overlay unit | On Surface/Base | On Surface/Variant |
| step surface | Surface Container/Highest | Surface Container/Lowest |
| step amount, active | On Surface/Emphasis | On Surface/Variant |
| step amount, upcoming | On Surface/Variant | On Surface/Muted |
| step unit | On Surface/Variant | On Surface/Muted |
| total surface | Surface Container/Highest | Surface Container/Lowest |
| total plate / crown | Countainer/Pink / Primary/Pink | same |
| total amount | On Surface/Emphasis | On Surface/Base |
| slash | On Surface/Variant | On Surface/Muted |
| secondary amount | On Surface/Base | On Surface/Variant |
| total unit | On Surface/Variant | On Surface/Muted |

Scrims are unbound source paints (E-103). The product skin keeps them; other skins fall back to `Alpha/Black` / `Alpha/White`.

## Typography
Overlay and step amount `English/Baseline/Number-Small`; total amounts `English/Baseline/Number-Medium`; unit and slash `English/Muted/Label-Small`.

## Behavior
One semantic label covers the whole badge. Number runs stay left-to-right inside RTL. Text scale 2.0 grows the badge.

## Inspector spec
```json
{"component": "RewardBadge", "componentId": "reward.badge", "status": "provisional", "placement": "shared", "figma": {"overlay": "18451:10177", "stepAndTotal": "18457:13272"}}
```
