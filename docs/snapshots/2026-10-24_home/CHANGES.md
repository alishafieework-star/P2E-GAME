# Home source snapshot — 2026-10-24

خلاصه برای مالک: یک snapshot فقط‌خواندنی و محدود از چهار frame صفحه Home و صفحه `- Games` گرفته شد. نسخه نام‌گذاری‌شده طراح در دسترس نیست و ادعای تأیید طراحی نشده است. snapshotهای قبلی دست نخورده‌اند و اشاره‌گر سراسری `LATEST` ساخته نشده است.

یافته مهم: عنوان بخش چهارم در Light نوشته «Recommended for You» است، در حالی که نام همان frame «Competition Games» است و Dark همان عنوان را «Competition Games» دارد. این متن Light کپی نمی‌شود (E-101).

شدت: متوسط. بقیه اختلاف‌ها در `docs/agents/registers/errata.md` با شناسه E-100 به بعد ثبت شده‌اند. هیچ token، کامپوننت یا صفحه محصولی در این snapshot ساخته نشده است.

## English detail

Scoped development snapshot of the EN Home frames and the Games page component sets. Figma access was read-only (`get_metadata`, `get_screenshot`, and read-only `use_figma` queries). No node was created or edited.

| Frame | Node | Size | Screenshot |
|---|---|---|---|
| Home Page - Dark | `18437:9175` | 402×874 | `screens/18437-9175.png` |
| Home Page - Dark (Expand) | `18457:13084` | 402×1809 | `screens/18457-13084.png` |
| Home Page - Light | `18422:11645` | 402×874 | `screens/18422-11645.png` |
| Home Page - Light (Expand) | `18457:14885` | 402×1809 | `screens/18457-14885.png` |

Each Expand frame contains 44 component instances. Fourteen of those are nested inside the existing App Bar and Navigator. The Home-owned instances are App Bar, three Small Tonal buttons, eight Game Compact Cards, one Games Expand Card, and Navigator, plus icons that belong to the detached patterns.

Section order is the same in Dark and Light: App Bar, Hero, Recommended for You, Multiplayer Games, Competition Games, Mission and Quest, Navigator. Keyboard layers are hidden.

Component sets on `- Games`: Game Compact Card (`18457:14096`, four variants) and Games Expand Card (`18457:14486`, two variants) are in Home scope. Event and Offer Card and Comment are inventoried and are out of Home scope.

Embedded game rasters are visible in the screenshots. They were not extracted as separate production assets. SHA-256 covers the files in this folder. Previous snapshots are unchanged.
