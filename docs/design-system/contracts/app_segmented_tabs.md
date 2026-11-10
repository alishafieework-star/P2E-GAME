# AppSegmentedTabs contract

- **Status:** provisional (D-032, D-033, D-034, D-044).
- **Figma:** Wireframes file `7BurKbCwclcabEGJ7cLcKz`, nodes `1:1644` (Segmented Tabs in Shop P01), `1:1645` (Coins tab), `1:4345` (Leaderboard Tabs L01).
- **Dart:** `packages/design_system/lib/src/components/tabs/app_segmented_tabs.dart`

## API

| Parameter | Type | Values / default | Description |
|---|---|---|---|
| `elementId` | `String` | required | identity v1.1 syntax |
| `runtimeLocator` | `UiRuntimeLocator?` | optional context override | route identity |
| `tabs` | `List<AppSegmentedTabItem>` | required (2 to 4 items) | tab definitions |
| `selectedIndex` | `int` | default `0` | active tab index |
| `onChanged` | `ValueChanged<int>?` | optional | tab selection callback |
| `height` | `double` | default `44.0` | container height |
| `padding` | `EdgeInsetsDirectional` | default `all(4.0)` | container internal padding |

### `AppSegmentedTabItem` Model
- `label`: `String` (required)
- `icon`: `AppIcon?` (optional leading icon)
- `badge`: `String?` (optional trailing count/badge)

Brightness is not a parameter. The segmented tabs resolve theme colors from `SkinTheme.of(context)` and `Theme.of(context).brightness`.

## Roles

| Part | Dark | Light |
|---|---|---|
| Outer Track Container | `Surface Container/Lowest` | `Surface Container/High` |
| Outer Border | `Outline/Variant` (at 0.5 opacity) | `Outline/Variant` |
| Active Tab Pill | `Surface Container/High` | `Surface/Base` (White) |
| Active Foreground | `On Surface/Emphasis` | `On Surface/Emphasis` |
| Inactive Foreground | `On Surface/Muted` | `On Surface/Muted` |

## Measurements

| Part | Height | Radius | Inset |
|---|---|---|---|
| Outer Container | 44 (or 48) | 100 (stadium) | internal padding 4 |
| Active Tab Pill | 36 (or 40) | 100 (stadium) | — |

## Typography

- Active Tab: `English/Baseline/Label-Small` — Outfit SemiBold 14/18 (letterSpacing -0.4).
- Inactive Tab: `English/Variant/Label-Small` — Outfit Medium 14/18 (letterSpacing -0.4).
- Persian: Resolved via `BundledTypography.resolve` with automatic Vazirmatn fallback.

## Behavior

- **Directional layout:** All tabs are arranged in a `Row` with `Expanded`. In RTL (Persian), index 0 starts on the right, maintaining directional order naturally.
- **Animation:** Selection indicator transitions smoothly with an `AnimatedContainer` (duration 250ms, `Curves.easeInOutCubic`).
- **Touch target:** Each tab has at least 44 dp height, fulfilling accessibility guidelines.
- **Text scaling:** Supports content scaling up to 2.0x (D-044) without clipping.

## Inspector spec

```json
{
  "component": "AppSegmentedTabs",
  "componentId": "tabs.segmented",
  "status": "provisional",
  "figma": {
    "fileKey": "7BurKbCwclcabEGJ7cLcKz",
    "segmentedTabs": "1:1644"
  },
  "variants": ["tabCount", "hasIcons", "hasBadges"]
}
```
