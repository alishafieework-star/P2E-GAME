# AppShelf contract

- **Status:** provisional. Detached Games Slider frames (D-013, R-100, R-101).
- **Figma:** scroll `18457:13119` (gap 12); paged `18457:13147` (gap 12) and `18457:13162` (gap 16). Evidence `evidence/collections.json`.
- **Dart:** `packages/design_system/lib/src/components/collections/app_shelf.dart`

## API
| Parameter | Type | Values / default |
|---|---|---|
| elementId | `String` | required |
| children | `List<Widget>` | caller cards; may be empty |
| layout | `AppShelfLayout` | `scroll` (default), `paged` |
| spacing | `AppShelfSpacing` | `regular` 12 (default), `relaxed` 16 (E-107) |
| pageIndex | `int` | paged only |
| onPageChanged | `ValueChanged<int>?` | paged only |

The section, not the shelf, owns the 16 page inset and the 12 vertical section gap.

## Behavior
`scroll` is a horizontal list. `paged` settles on one child and reports the index. A new `pageIndex` animates with `CollectionMotion` (250 ms easeOut, engineering, R-101); reduced motion jumps. No autoplay (D-102). The shelf draws no paint. RTL reverses the scroll direction once. The parent sets the height; at text scale 2.0 the section must give the tallest card its height.

## Inspector spec
```json
{"component": "AppShelf", "componentId": "collection.shelf", "status": "provisional", "figma": {"scroll": "18457:13119", "pagedRegular": "18457:13147", "pagedRelaxed": "18457:13162"}}
```
