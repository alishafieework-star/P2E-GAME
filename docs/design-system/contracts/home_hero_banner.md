# HomeHeroBanner contract

- **Status:** contract, not built. Detached Hero Section Banner (D-013, R-100, R-101).
- **Figma:** Dark `18457:13090` (also `18533:4246`), Light `18457:14891`; 402×343, placed 119 above the hero card. Evidence `evidence/collections.json`.
- **Dart:** `lib/features/games/src/presentation/widgets/home_hero_banner.dart`, games public API (D-101). The featured `GameInfoRow` is a sibling supplied by the section.

## API
`background` (`ImageProvider`, required) and `foreground` (`ImageProvider?`).

## Measurements and paints
| Part | Dark | Light |
|---|---|---|
| background frame | 402×343 | 402×421; image 494×421 |
| foreground object | 246×248 | 206×119 |
| vignette | inner shadows `#0a0a0a`, blur 50 and 120 | inner shadows `#ffffff` blur 40 and `#03a7e2` blur 90 |

Vignette colors are raw (E-108). They will be generated as source paints with a skin-role fallback.

## Behavior
Decorative. It extends under the real status bar and the Home App Bar and draws no fake status bar. Parallax is named but not specified: the first build is static, also under reduced motion (D-102, R-101).
