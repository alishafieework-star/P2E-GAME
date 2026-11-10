# AppFilterChip contract

- **Status:** provisional (D-032, D-033, D-034, D-044).
- **Figma:** Wireframes file `7BurKbCwclcabEGJ7cLcKz`, node `1:4363` (Filter Chips row), `1:4364` (Chip / This week - selected), `1:4366` (Chip / This month - unselected).
- **Dart:** `packages/design_system/lib/src/components/chips/app_filter_chip.dart`

## API

| Parameter | Type | Values / default | Figma source |
|---|---|---|---|
| `elementId` | `String` | required | identity v1.1 syntax |
| `runtimeLocator` | `UiRuntimeLocator?` | optional context override | route identity |
| `label` | `String` | required | chip text |
| `selected` | `bool` | default `false` | selected / unselected |
| `onSelected` | `ValueChanged<bool>?` | null disables interaction | interactive tap callback |
| `leadingIcon` | `AppIcon?` | optional leading icon | icon slot |
| `count` | `int?` | optional counter badge | e.g. "All (12)" |
| `enabled` | `bool` | default `true` | enabled / disabled appearance |
| `size` | `AppFilterChipSize` | `small`, `medium` (default `medium`) | height & padding scale |

Brightness is not a parameter. The chip resolves its colors from `SkinTheme.of(context)` and `Theme.of(context).brightness`.

## Measurements

| Part | Height | Padding (H/V) | Radius | Border | Gap (internal) | Touch target |
|---|---|---|---|---|---|---|
| `medium` (default) | 34 | 14 / 7 | 100 (stadium) | unselected 1.0, selected 0.0 | 6 | min 48 |
| `small` | 28 | 10 / 4 | 100 (stadium) | unselected 1.0, selected 0.0 | 4 | min 48 |
| `AppFilterBar` (row) | 48 | start 16, end 16 | 0 | 0 | 8 (between chips) | — |

## Roles

| State | Part | Dark | Light |
|---|---|---|---|
| **Selected** | Background | `On Surface/Emphasis` (`white`) | `On Surface/Emphasis` (`black`) |
| | Border | None (0) | None (0) |
| | Foreground (Text & Icon) | `Alpha/Black` (`#000000`) | `Alpha/White` (`#FFFFFF`) |
| **Unselected** | Background | `Surface Container/Base` (`#171717`) | `Surface Container/Base` (`#FFFFFF` / `#F5F5F5`) |
| | Border | `Outline/Variant` (`#262626`) | `Outline/Variant` (`#E5E5E5`) |
| | Foreground (Text & Icon) | `On Surface/Base` (`#A1A1A1`) | `On Surface/Base` (`#525252`) |
| **Disabled** | Surface | Opacity 0.38 | Opacity 0.38 |
| | Foreground | `On Surface/Disabled` | `On Surface/Disabled` |

## Typography

- **Selected:** `English/Baseline/Label-Small` — Outfit SemiBold (600), size 14, line-height 18, letter-spacing -0.56.
- **Unselected:** `English/Variant/Label-Small` — Outfit Medium (500), size 14, line-height 18, letter-spacing -0.56.
- **Small size:** Font size 12, line-height 16, letter-spacing -0.4.
- **Persian:** Resolved via `BundledTypography.resolve` with automatic Vazirmatn fallback.

## Behavior

- **Touch target:** Wrapped in `ConstrainedBox` with minimum height and width of 48 dp to meet WCAG 2.5.5 accessibility requirements while preserving visual hug geometry.
- **Press motion:** Uses `PressAction` with `ButtonMotion.pressedScale` (0.97) for smooth tactile response without layout reflow.
- **Directional layout:** All insets and alignments use `EdgeInsetsDirectional` and `AlignmentDirectional`. Icons and counts respect RTL mirroring.
- **Text scaling:** Supports content text scaling up to 2.0x (D-044) without clipping.

## Inspector spec

```json
{
  "component": "AppFilterChip",
  "componentId": "chip.filter-chip",
  "status": "provisional",
  "figma": {
    "fileKey": "7BurKbCwclcabEGJ7cLcKz",
    "selected": "1:4364",
    "unselected": "1:4366"
  },
  "variants": ["size", "selected", "enabled", "hasIcon", "hasCount"]
}
```
