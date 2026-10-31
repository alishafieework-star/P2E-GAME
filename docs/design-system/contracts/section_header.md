# AppSectionHeader contract

- **Status:** provisional. Detached frame, not a component set (D-013, R-100).
- **Figma:** Dark `18457:13111` (also `18533:4266`); Light `18457:14912`. Evidence `evidence/collections.json`.
- **Dart:** `packages/design_system/lib/src/components/collections/app_section_header.dart`

## API
| Parameter | Type | Values / default | Figma source |
|---|---|---|---|
| elementId | `String` | required | identity |
| title | `String` | one-tone title; empty when `subject` is set | Home section title |
| lead | `String?` | muted prefix of a two-tone title | "About", "More Like", "More by" |
| subject | `String?` | emphasized subject; replaces `title` | game or studio name |
| showMark | `bool` | default false; draws ® after `subject` | Game Details studio title |
| actionLabel | `String?` | null hides the action | Text Label |
| onAction | `VoidCallback?` | null disables the action | none |
| actionChevron | `bool` | default true. Game Details actions pass false (E-114) | Home chevron |

Brightness is not a parameter. The Home action owns its trailing chevron, so `AppButton` is unchanged. A two-tone title uses `sectionLead` for the prefix and `sectionTitle` for the subject.

## Measurements
| Part | min height | padding | gap | radius | icon |
|---|---|---|---|---|---|
| row | 36 | 0 | 10 | 0 | — |
| title | 24 | start 12, end 12 | — | — | — |
| action | 36 | 8 | 4 | 10 | chevron Fill 20 |

## Roles
| Part | Dark | Light |
|---|---|---|
| title | On Surface/Emphasis | On Surface/Base |
| action and chevron | Action/Accent (source `Sky/500`, E-103) | Action/Accent |

## Typography
Title `English/Baseline/Title-Small`; action `English/Baseline/Button-Small`. Persian pending R-003.

## Behavior
The action is a native button with D-021 press scale. A null callback keeps source paint and disabled semantics. The chevron mirrors in RTL through the icon registry. The title grows at text scale 2.0; there is no chrome cap.

## Inspector spec
```json
{"component": "AppSectionHeader", "componentId": "collection.section-header", "status": "provisional", "figma": {"dark": "18457:13111", "light": "18457:14912"}, "variants": ["title", "titleAndAction"]}
```
