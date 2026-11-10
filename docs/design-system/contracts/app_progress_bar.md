# AppProgressBar contract

- **Status:** provisional (D-032, D-033, D-034, D-044).
- **Figma:** Wireframes file `7BurKbCwclcabEGJ7cLcKz`, nodes across Missions (`1:7706` Quest Progress), Shop (`1:1981` Credit Limit Bar), and Leaderboard (`1:4335` Tier Progress).
- **Dart:** `packages/design_system/lib/src/components/progress/app_progress_bar.dart`

## API

| Parameter | Type | Values / default | Description |
|---|---|---|---|
| `elementId` | `String` | required | identity v1.1 syntax |
| `runtimeLocator` | `UiRuntimeLocator?` | optional context override | route identity |
| `value` | `double?` | `0.0` to `1.0` (null = indeterminate) | progress percentage |
| `height` | `AppProgressHeight` | `sm` (6), `md` (8, default), `lg` (12) | track height |
| `tone` | `AppProgressTone` | `primary` (default), `emerald`, `amber`, `teal`, `purple` | semantic fill color |
| `label` | `String?` | optional | leading label displayed above track |
| `trailingLabel` | `String?` | optional | trailing label displayed above track (e.g. "3/5" or "75%") |
| `minLabel` | `String?` | optional | start label displayed below track |
| `maxLabel` | `String?` | optional | end label displayed below track |
| `animated` | `bool` | default `true` | animate progress value transitions |

Brightness is not a parameter. The progress bar resolves its theme colors from `SkinTheme.of(context)` and `Theme.of(context).brightness`.

## Tone Mapping

| Tone | Dark Fill Role | Light Fill Role | Common Use Case |
|---|---|---|---|
| `primary` | `Primary/Pink` | `Primary/Pink` | Standard gamification / generic tasks |
| `emerald` | `Primary/Emerald` | `Primary/Emerald` | Completed, claimed, and active progress |
| `amber` | `On Surface/Emphasis` / Amber | `On Surface/Emphasis` / Amber | Expiring soon, near credit limit |
| `teal` | `Primary/Teal` | `Primary/Teal` | Secondary missions, explorer tasks |
| `purple` | `Primary/Purple` | `Primary/Purple` | League & tournament point progression |

Track background role: `Surface Container/Highest` (Dark) / `Surface Container/High` (Light).

## Measurements

| Variant | Height | Track Radius | Content Hug |
|---|---|---|---|
| `sm` | 6 | 3 (capsule) | compact card, table row |
| `md` (default) | 8 | 4 (capsule) | quest cards, task rows |
| `lg` | 12 | 6 (capsule) | hero sections, DCB credit bar |

## Typography

- Header labels (`label`, `trailingLabel`): `Outfit Medium 12/16` (letterSpacing -0.3).
- Footer labels (`minLabel`, `maxLabel`): `Outfit Regular 11/14` (letterSpacing -0.2), color `On Surface/Muted`.
- Persian: Resolved via `BundledTypography.resolve` with automatic Vazirmatn fallback.

## Behavior

- **Directional layout:** Bar fills from `AlignmentDirectional.centerStart` to `centerEnd`. In RTL (Persian), fills smoothly from right to left without physical left/right branching.
- **Animation:** Value changes animate with duration 300ms using `Curves.easeOutCubic`.
- **Indeterminate:** When `value == null`, displays a smooth looping indeterminate indicator.
- **Text scaling:** Supports content scaling up to 2.0x (D-044) without clipping.

## Inspector spec

```json
{
  "component": "AppProgressBar",
  "componentId": "progress.bar",
  "status": "provisional",
  "figma": {
    "fileKey": "7BurKbCwclcabEGJ7cLcKz",
    "track": "1:7706"
  },
  "variants": ["height", "tone", "hasHeader", "hasFooter", "isIndeterminate"]
}
```
