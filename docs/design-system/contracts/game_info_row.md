# GameInfoRow contract

- **Status:** provisional. The same row is detached in three geometries (E-106, R-100).
- **Figma:** featured Dark `18457:13097`, Light `18457:14898` (also `18533:4252`); card row in `18457:12229` / `18457:14487`; quest header in `18457:13272` / `18457:15685`. Evidence `evidence/collections.json`, `game_cards.json`, `quest_card.json`.
- **Dart:** `lib/shared/widgets/game_info_row.dart`
- **Placement:** shared, because games and missions both use it and missions cannot import games (D-101). Presentational.

## API
| Parameter | Type | Values / default |
|---|---|---|
| layout | `GameInfoLayout` | `featured`, `card`, `quest` |
| icon | `ImageProvider` | required; a failed image keeps the empty icon box |
| name, creator, actionLabel | `String` | required, display-ready |
| showMark | `bool` | true (® Sign) |
| onAction | `VoidCallback?` | null disables the button |
| caption | `String?` | null hides it |

The button is the existing Small Tonal `AppButton`.

## Measurements
| Layout | icon | padding | gap | name/creator gap | title | min height |
|---|---|---|---|---|---|---|
| featured | 54, r10 | 12 | 14 | 0 | Title-Medium | 78, surface r20 |
| card | 48, r10 | 14 | 14 | 0 | Title-Small | — |
| quest | 46, r10 | 16 | 12 | 2 | Title-Medium | 85 |

Creator to ® gap 2. Button to caption gap 4.

## Roles
| Part | Dark | Light |
|---|---|---|
| featured surface | Surface Container/Base | Surface Container/Lowest |
| featured shadow | none | drop shadow `#000000` 20%, blur 10, offset 0 |
| featured name | On Surface/Emphasis | On Surface/Emphasis |
| card and quest name | On Surface/Emphasis | On Surface/Base |
| creator, ® and caption | On Surface/Base | On Surface/Muted |

## Typography
Name per layout; creator `English/Baseline/Label-Small`; caption is unstyled Outfit SemiBold 10, letter spacing −4% (E-102).

## Behavior
The button label is the only control semantics; the icon is decorative. Text scale 2.0 grows the row. RTL uses start/end.

## Inspector spec
```json
{"component": "GameInfoRow", "componentId": "game.info-row", "status": "provisional", "placement": "shared", "figma": {"featured": "18533:4252", "card": "18457:12229", "quest": "18457:13272"}}
```
