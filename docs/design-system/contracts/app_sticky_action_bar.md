# AppStickyActionBar contract

- **Status:** provisional (D-032, D-033, D-034, D-044).
- **Figma:** Wireframes file `7BurKbCwclcabEGJ7cLcKz`, node `1:3740` (Sticky CTA in Shop), `1:2001` (Success navigation bar), `1:2544` (Ticket action bar), `1:7706` (Missions CTA).
- **Dart:** `packages/design_system/lib/src/components/navigation/app_sticky_action_bar.dart`

## API

| Parameter | Type | Values / default | Description |
|---|---|---|---|
| `elementId` | `String` | required | identity v1.1 syntax |
| `runtimeLocator` | `UiRuntimeLocator?` | optional context override | route identity |
| `primaryAction` | `Widget` | required | primary CTA button (e.g. `AppButton`) |
| `secondaryAction` | `Widget?` | optional | secondary / cancel button |
| `summaryTitle` | `String?` | optional | start-side summary caption (e.g. "Total Amount") |
| `summarySubtitle` | `String?` | optional | start-side emphasized value (e.g. "54,000 Toman") |
| `summaryWidget` | `Widget?` | optional | custom start-side slot |
| `padding` | `EdgeInsetsDirectional` | default `16 / 12 / 16 / 12` | bar content insets |
| `hasTopBorder` | `bool` | default `true` | top border divider line |
| `useSafeArea` | `bool` | default `true` | pads bottom for device home indicator |

Brightness is not a parameter. The action bar resolves its theme colors from `SkinTheme.of(context)` and `Theme.of(context).brightness`.

## Roles

| Part | Dark | Light |
|---|---|---|
| Surface Background | `Surface Container/High` | `Surface Container/Lowest` |
| Top Border | `Outline/Variant` | `Outline/Variant` |
| Summary Title | `On Surface/Muted` | `On Surface/Muted` |
| Summary Subtitle | `On Surface/Emphasis` | `On Surface/Emphasis` |

## Measurements

| Part | Min Height | Padding | Gap |
|---|---|---|---|
| Single button bar | 72 (with safe area ~96) | Start 16, End 16, Top 12, Bottom 12 | — |
| Dual button bar | 72 | Start 16, End 16, Top 12, Bottom 12 | 12 between buttons |
| Summary + CTA bar | 76 | Start 16, End 16, Top 12, Bottom 12 | 16 between summary and CTA |

## Typography

- Summary Title: `English/Baseline/Label-Small` — Outfit Medium 12/16 (letterSpacing -0.3).
- Summary Subtitle: `English/Baseline/Title-Small` — Outfit SemiBold 16/20 (letterSpacing -0.4).
- Persian: Resolved via `BundledTypography.resolve` with automatic Vazirmatn fallback.

## Behavior

- **SafeArea:** Wraps bottom in `SafeArea(top: false, left: false, right: false, bottom: true)` to ensure buttons are never obscured by iOS Home Bar or Android gesture pill.
- **Directional layout:** All padding, borders, and rows use Directional APIs. In RTL, summary is on the start (right), primary CTA on the end (left).
- **Text scaling:** Supports content scaling up to 2.0x (D-044) without clipping.

## Inspector spec

```json
{
  "component": "AppStickyActionBar",
  "componentId": "navigation.sticky-action-bar",
  "status": "provisional",
  "figma": {
    "fileKey": "7BurKbCwclcabEGJ7cLcKz",
    "stickyCta": "1:3740"
  },
  "variants": ["layout", "hasSecondary", "hasSummary", "hasTopBorder"]
}
```
