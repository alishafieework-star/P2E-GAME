# AppStatusChip contract

- **Status:** provisional (D-032, D-033, D-034, D-044).
- **Figma:** Wireframes file `7BurKbCwclcabEGJ7cLcKz`, nodes `1:2263` (`Status / Success`), `1:2273` (`Status / Refunded`), `1:2296` (`Status / Failed`), `1:2308` (`Status / Pending`), `1:2727` (`Status / Answered`), `1:2741` (`Status / Open`), `1:2951` (`Status / Closed`), `1:4363` (`Live Badge`).
- **Dart:** `packages/design_system/lib/src/components/badges/app_status_chip.dart`

## API

| Parameter | Type | Values / default | Figma source |
|---|---|---|---|
| `elementId` | `String` | required | identity v1.1 syntax |
| `runtimeLocator` | `UiRuntimeLocator?` | optional context override | route identity |
| `label` | `String` | required | status text (e.g. "Success", "Failed", "Live") |
| `status` | `AppStatusType` | `success`, `error`, `warning`, `info`, `live`, `pending`, `neutral` | semantic state |
| `appearance` | `AppStatusAppearance` | `subtle` (default), `outlined`, `filled` | visual surface treatment |
| `size` | `AppStatusSize` | `small` (default), `medium` | compact vs standard height |
| `hasDot` | `bool?` | null (auto true for `live`, false otherwise) | leading status dot indicator |
| `leadingIcon` | `AppIcon?` | optional | leading icon slot |
| `onTap` | `VoidCallback?` | optional | interactive callback if needed |

Brightness is not a parameter. The status chip resolves its theme colors from `SkinTheme.of(context)` and `Theme.of(context).brightness`.

## Semantic Status Matrix

| `AppStatusType` | Meaning & Wireframe Examples | Dark Foreground | Dark Container (`subtle`) |
|---|---|---|---|
| `success` | Payment completed, Claimed, Confirmed, Answered | `Primary/Emerald` | `Countainer/Emerald` |
| `error` | Payment failed, Cancelled, Expired, Rejected | `Actions/Error/On Surface` | `Actions/Error/On Container` |
| `warning` | Paused, Refunded, Under Review, Expiring Soon | `On Surface/Emphasis` | `Countainer/Purple` |
| `info` | Ready, Open ticket, Details available | `Primary/Teal` | `Countainer/Teal` |
| `live` | Live cup/tournament active, real-time sync | `Primary/Emerald` | `Countainer/Emerald` |
| `pending` | Activating, Calculating, In Progress, Processing | `On Surface/Base` | `Surface Container/Base` |
| `neutral` | Closed ticket, Locked mission, Inactive | `On Surface/Muted` | `Surface Container/High` |

## Measurements

| Part | Height (min) | Padding (H/V) | Radius | Dot Size | Icon Size | Gap |
|---|---|---|---|---|---|---|
| `small` (default) | 22 | 8 / 3 | 100 (stadium) | 6 | 12 | 4 |
| `medium` | 28 | 10 / 5 | 100 (stadium) | 8 | 14 | 6 |

## Typography

- **Small:** `Outfit Medium 11/14` (letterSpacing -0.3).
- **Medium:** `Outfit Medium 13/16` (letterSpacing -0.4).
- **Persian:** Resolved via `BundledTypography.resolve` with automatic Vazirmatn fallback.

## Behavior

- **Directional layout:** All padding and item placement use `EdgeInsetsDirectional` and `Row` with RTL support.
- **Dot Indicator:** Renders as a circular container with the foreground color.
- **Text scaling:** Supports content scaling up to 2.0x (D-044) without clipping.
- **Touch Target:** When `onTap` is provided, hit target is wrapped in a 48 dp accessible target area.

## Inspector spec

```json
{
  "component": "AppStatusChip",
  "componentId": "badge.status-chip",
  "status": "provisional",
  "figma": {
    "fileKey": "7BurKbCwclcabEGJ7cLcKz",
    "success": "1:2263",
    "failed": "1:2296",
    "refunded": "1:2273",
    "pending": "1:2308",
    "closed": "1:2951"
  },
  "variants": ["status", "appearance", "size", "hasDot", "hasIcon"]
}
```
