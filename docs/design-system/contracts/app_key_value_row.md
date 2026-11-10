# AppKeyValueRow contract

- **Status:** provisional (D-032, D-033, D-034, D-044).
- **Figma:** Wireframes file `7BurKbCwclcabEGJ7cLcKz`, nodes across Shop Checkout & Receipts (`1:1981`, `1:2001`, `1:2195`, `1:2263`), Leaderboard Scoring Rules (`1:4335`, `1:5111`), and Missions Receipts (`1:7706`).
- **Dart:** `packages/design_system/lib/src/components/collections/app_key_value_row.dart`

## API

| Parameter | Type | Values / default | Description |
|---|---|---|---|
| `elementId` | `String` | required | identity v1.1 syntax |
| `runtimeLocator` | `UiRuntimeLocator?` | optional context override | route identity |
| `label` | `String` | required | start-side descriptor (e.g. "Order ID", "VAT 10%") |
| `value` | `String?` | optional | end-side text value (e.g. "50,000 Toman") |
| `valueWidget` | `Widget?` | optional | custom end-side slot (e.g. `AppStatusChip`, badge) |
| `variant` | `AppKeyValueVariant` | `regular` (default), `total`, `subtle` | typographic and visual emphasis |
| `leadingIcon` | `AppIcon?` | optional | icon next to label at start |
| `trailingIcon` | `AppIcon?` | optional | icon next to value at end (e.g. chevron or copy) |
| `hasTopDivider` | `bool` | default `false` | draws divider line above row |
| `hasBottomDivider` | `bool` | default `false` | draws divider line below row |
| `padding` | `EdgeInsetsDirectional` | default vertical 8, horizontal 0 | row insets |
| `onTap` | `VoidCallback?` | optional | interactive callback for copyable / clickable rows |

Brightness is not a parameter. The row resolves its theme colors from `SkinTheme.of(context)` and `Theme.of(context).brightness`.

## Variant Matrix

| Variant | Label Role | Value Role | Label Typography | Value Typography |
|---|---|---|---|---|
| `regular` (default) | `On Surface/Base` | `On Surface/Emphasis` | `Outfit Regular 14/18` | `Outfit Medium 14/18` |
| `total` | `On Surface/Emphasis` | `On Surface/Emphasis` / `Action/Accent` | `Outfit SemiBold 16/20` | `Outfit SemiBold 16/20` |
| `subtle` | `On Surface/Muted` | `On Surface/Muted` | `Outfit Regular 12/16` | `Outfit Regular 12/16` |

Divider role: `Outline/Variant`.

## Measurements

| Part | Height (min) | Inset | Gap |
|---|---|---|---|
| `regular` | 36 | V 8 | 8 between label and value |
| `total` | 44 | V 10 | 8 between label and value |
| `subtle` | 28 | V 4 | 6 between label and value |

## Typography

- Persian: Resolved via `BundledTypography.resolve` with automatic Vazirmatn fallback.
- Supports content scaling up to 2.0x (D-044) with flexible wrap.

## Behavior

- **Directional layout:** Label aligns to `AlignmentDirectional.centerStart`, value/slot to `AlignmentDirectional.centerEnd`.
- **RTL:** Fully mirrored in Persian (label on right, value on left).
- **Touch target:** When `onTap` is supplied, row is interactive with `PressAction` or clickable ripple and 48 dp hit target.

## Inspector spec

```json
{
  "component": "AppKeyValueRow",
  "componentId": "collection.key-value-row",
  "status": "provisional",
  "figma": {
    "fileKey": "7BurKbCwclcabEGJ7cLcKz",
    "regular": "1:1981",
    "total": "1:2001"
  },
  "variants": ["variant", "hasTopDivider", "hasBottomDivider", "hasLeadingIcon", "hasTrailingIcon", "isClickable"]
}
```
