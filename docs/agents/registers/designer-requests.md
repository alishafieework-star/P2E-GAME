# Designer requests

What we need from the designer. Priority: `high` (blocks current stage) | `medium` | `low`.
Status: `open` | `sent` | `delivered` | `dropped`.

| Id | Date | Request | Why | Priority | Status |
|---|---|---|---|---|---|
| R-001 | 2026-10-19 | Light versions of the 12 Authentication / Login frames, plus Light `Base Password Field` and `OTP Field` sets (E-008). | Default theme follows the OS; Light users see undesigned screens. | high | open |
| R-002 | 2026-10-19 | First-launch language picker screen (and settings row). | D-004. | medium | open |
| R-003 | 2026-10-19 | Persian typography (font + scale) and Persian screens. | Persian release; D-006. | medium | open |
| R-004 | 2026-10-19 | Designs for components that have none: Switch, Checkbox, Tabs, Chip, Card, Sheet, Dialog, Toast (list grows with screens). | Built provisional today (D-013). | medium | open |
| R-005 | 2026-10-19 | Read access to the master Figma file (we read a "(Copy)") and a named version per delivery. | Snapshots must track the real file (D-016). | high | open |
| R-006 | 2026-10-19 | Tablet layouts (Medium / Expanded). | D-003. | low | open |
| R-007 | 2026-10-19 | Resolve errata E-001 … E-010. | Clean names and consistent styles. | medium | open |
| R-008 | 2026-10-19 | Motion specs: durations and curves for transitions, presses, sheets, toasts. | Motion tokens are provisional. | low | open |
| R-009 | 2026-10-19 | Loading, empty, error and offline states for the EN screens. | Required by every screen; Figma shows success only. | medium | open |
| R-010 | 2026-10-20 | Add App Bar Back Light twin and official avatar text style; confirm focus/press/disabled behavior (E-015). | Five source variants implemented; Back Light unavailable, avatar metrics preserved source-unlinked, interaction defaults explicitly engineering D-030. | medium | open |
| R-011 | 2026-10-21 | Link Navigator destination/badge typography to official Text Styles and supply interaction/motion specification. | Low: measured Outfit600 12/15 and Outfit700 10/10 ship source-unlinked; D-031 engineering feedback is explicitly distinguished from empty source reactions. E-005; no missing source bar/item variant. | low | open |

| R-012 | 2026-10-21 | Supply sourced Button loading/busy/progress appearance across sizes, families and brightness. | Read-only Button page16433:9027 has18 sets/90 variants and no loading axis. D-045 behavior is final; centered token-sized indicator uses provisional engineering artwork. | medium | open |

| R-013 | 2026-10-23 | Confirm Sky/500 accent Filled Button as an official variant, including Light and interaction states. | Auth Entry uses instance overrides18618:12153/12674; D-056. | medium | open |
| R-014 | 2026-10-23 | Replace the provisional svgrepo Google logo with an official approved asset. | Auth Entry node18613:11518; no branding approval inferred. | medium | open |
| R-015 | 2026-10-24 | Official Success and Error appearance and motion for OTP cells, including green/red borders. | D-069 status tone is an owner-requested engineering appearance. Figma Success is a white verified icon on a neutral cell; Error colors only the digit. | medium | open |

R-016–R-099 are reserved for the parallel Auth track (D-100). Home starts at R-100.

| R-100 | 2026-10-24 | Confirm Home errata E-100–E-106 and supply semantic roles for Sky/500, Green/500, Green/600 and Yellow/400. Promote the detached Home patterns (hero, section header, shelf, page indicator, reward, rating, quest progress, countdown) to components. | These patterns are frames, not component sets. Code will build them provisional (D-013, D-102). | medium | open |
| R-101 | 2026-10-24 | Motion for the Home hero parallax, paged carousel and countdown completion. Section loading, empty and error remain R-009. | Figma defines no motion for these. D-102 uses engineering defaults until a source exists. | low | open |
| R-102 | 2026-10-25 | Promote Game Details patterns (primary data, media tile, about, ratings, comments, studio card) to components. Supply bookmark and Read More states, a media viewer, and registry glyphs for AI, Android and iOS. | These are frames, not component sets (E-112, E-114, E-117). Code is provisional (D-121). | medium | open |
| R-103 | 2026-10-25 | Loading, empty, error, offline and not-found for Game Details, plus the in-app download flow. | Figma shows success only. D-121 uses a provisional page error, saved-copy notice and external install. Section states remain R-009. | medium | open |
| R-104 | 2026-10-26 | Official designs for the logo, Splash, the three Onboarding slides, Username, Avatar, Notifications, All Set, Welcome Back, the in-app Legal reader, the Help sheet and the Home tour. | Figma has none of these. The HTML prototype is the provisional source (D-135–D-142). | high | open |
| R-105 | 2026-10-26 | Licensed or final artwork for the Onboarding game cards, podium and laurel. | The HTML sample images are placeholders and need a license or a replacement before release (D-138). | medium | open |
| R-106 | 2026-10-26 | An official avatar set and its themes, replacing the twelve generated HTML characters. | Avatar art is provisional (D-140). | medium | open |
| R-107 | 2026-10-26 | Registry icons for the notification bell, the tour arrow and any other glyph the HTML draws that is not already in the icon registry. | Missing glyphs stay bundled SVG assets and are not given invented registry ids. | low | open |
