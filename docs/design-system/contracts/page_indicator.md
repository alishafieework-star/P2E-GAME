# AppPageIndicator contract

- **Status:** provisional. Detached Pagination (D-013, R-100).
- **Figma:** Dark `18457:13149`; Light `18457:14936`. Evidence `evidence/collections.json`.
- **Dart:** `packages/design_system/lib/src/components/collections/app_page_indicator.dart`

## API
| Parameter | Type | Values / default |
|---|---|---|
| elementId | `String` | required |
| count | `int` | at least 1 |
| index | `int` | 0 .. count-1 |
| semanticLabel | `String?` | caller-localized position |

The indicator does not change pages. `AppShelf` owns paging.

## Measurements
Active dot 7.5, inactive dot 5, gap 5. Each dot sits in a 7.5 square so the row height is stable.

## Roles
| Part | Dark | Light |
|---|---|---|
| active | On Surface/Emphasis | On Surface/Variant |
| inactive | On Surface/Muted | On Surface/Muted |

## Behavior
Dots ignore pointers. With a label, one semantic node reports the position. No text scale effect.

## Inspector spec
```json
{"component": "AppPageIndicator", "componentId": "collection.page-indicator", "status": "provisional", "figma": {"dark": "18457:13149", "light": "18457:14936"}}
```
