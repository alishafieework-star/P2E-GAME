# گزارش جامع استخراج و تحلیل کامپوننت‌های سکشن Shop Wireframes

> **مرجع دیزاین فیگما**: فایل `7BurKbCwclcabEGJ7cLcKz` · سکشن `1:1629` (`Shop · Wireframes (17 Oct 2026)`)  
> **لینک مستقیم سکشن**: [Figma Section 1:1629](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1629)  
> **نوع تحلیل**: کاملاً Read-Only و مبتنی بر شواهد مستقیم درختی فیگما  
> **جامعه آماری**: ۲۴ فریم اصلی موبایل و باتم‌شیت (P01 الی P24)

---

## ۱. هدف و خلاصه اجرایی (Executive Summary)
در این تحقیق، تمام ۲۴ فریم سکشن فروشگاه (شامل تب خرید سکه، تب جوایز و بسته‌های اینترنت، پرداخت، باتم‌شیت‌ها، پیام‌های موفقیت و خطا، تاریخچه خریدها و مرکز تیکت‌های پشتیبانی) به صورت حلقه‌ای و کامل کاوش شدند.
هدف اصلی، **شناسایی المان‌های پرتکراری است که در حال حاضر در دیزاین سیستم پیاده‌سازی نشده‌اند** تا بتوان آن‌ها را به درستی در لایه اول (Core Design System) یا لایه دوم (Shared Widgets / Feature Domain) استانداردسازی کرد.

### یافته‌های کلیدی:
1. **تعداد کل فریم‌های فعال**: ۲۴ فریم کامل.
2. **تعداد نمونه‌های کامپوننت رسمی (Instances)**: ۳۳۸ اینستنس.
3. **المان‌های استانداردسازی‌شده فعلی در سورس‌کد**: تنها `AppButton`، `AppBars` (App Bar Container)، `AppNavigationBar` (Navigator Bar Container) و آیکون‌های SVG.
4. **بزرگ‌ترین خلاءهای دیزاین سیستم (عدم وجود در Core DS)**:
   - **Row / Key-Value Data Row** (بیش از ۵۰ تکرار در ۱۴ فریم)
   - **Sticky CTA Bar** (۱۴ تکرار در ۱۴ فریم)
   - **Selection Option Tile / Radio Card** (۱۶ تکرار در ۶ فریم)
   - **Status Badge / Status Chip** (۱۸ تکرار در ۸ فریم)
   - **Segmented Tabs / Filter Tabs** (۱۱ تکرار در ۱۱ فریم)
   - **Bottom Sheet Frame / Sheet Header** (۱۰ تکرار در ۱۰ فریم)
   - **Info Note / Callout Box** (۸ تکرار در ۸ فریم)
   - **Feedback / Result State Hero** (۵ صفحه کامل)

---

## ۲. استخراج فریم به فریم المان‌ها (Frame-by-Frame Inventory)

### P01 — P01 · Shop · Coins tab (Expand)
- **Node ID**: `1:1633`
- **لینک مستقیم فیگما**: [P01 · Shop · Coins tab (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1633)
- **ابعاد**: 402 × 961 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:1637`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1637)
  - `[Pattern]` **Page Title** (`1:1639`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1639)
  - `[Pattern]` **Segmented Tabs** (`1:1644`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1644)
  - `[Pattern]` **Section Header** (`1:1651`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1651)
  - `[Pattern]` **Coin Packs Grid** (`1:1656`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1656)
  - `[Pattern]` **Coin Pack Tile / 100** (`1:1658`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1658)
  - `[Instance]` **Icon=Token** (`1:1666`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1666)
  - `[Instance]` **Button / 50K T** (`1:1668`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1668)
  - `[Pattern]` **Coin Pack Tile / 220** (`1:1669`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1669)
  - `[Instance]` **Icon=Token** (`1:1678`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1678)
  - `[Instance]` **Button / 100K T** (`1:1680`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1680)
  - `[Pattern]` **Coin Pack Tile / 600** (`1:1681`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1681)
  - `[Instance]` **Icon=Token** (`1:1692`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1692)
  - `[Instance]` **Button / 250K T** (`1:1694`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1694)
  - `[Pattern]` **Coin Pack Tile / 1,300** (`1:1696`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1696)
  - `[Instance]` **Icon=Token** (`1:1707`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1707)
  - `[Instance]` **Button / 500K T** (`1:1709`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1709)
  - `[Pattern]` **Coin Pack Tile / 2,800** (`1:1710`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1710)
  - `[Instance]` **Icon=Token** (`1:1723`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1723)
  - `[Instance]` **Button / 1M T** (`1:1725`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1725)
  - `[Pattern]` **Coin Pack Tile / 6,000** (`1:1726`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1726)
  - `[Instance]` **Icon=Token** (`1:1739`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1739)
  - `[Instance]` **Button / 2M T** (`1:1741`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1741)
  - `[Pattern]` **Info Note** (`1:1743`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1743)
  - `[Instance]` **Navigator Bar Container** (`1:1747`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1747)

### P02 — P02 · Shop · Rewards tab (Expand)
- **Node ID**: `1:1753`
- **لینک مستقیم فیگما**: [P02 · Shop · Rewards tab (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1753)
- **ابعاد**: 402 × 1225 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:1757`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1757)
  - `[Pattern]` **Page Title** (`1:1759`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1759)
  - `[Pattern]` **Segmented Tabs** (`1:1764`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1764)
  - `[Pattern]` **Balance** (`1:1774`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1774)
  - `[Instance]` **Button / Earn more** (`1:1777`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1777)
  - `[Pattern]` **Section Header** (`1:1778`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1778)
  - `[Pattern]` **Reward Card / 1 GB Internet** (`1:1793`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1793)
  - `[Instance]` **Button / Redeem** (`1:1803`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1803)
  - `[Pattern]` **Reward Card / 3 GB Internet** (`1:1804`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1804)
  - `[Instance]` **Button / Redeem** (`1:1814`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1814)
  - `[Pattern]` **Reward Card / Combo pack** (`1:1815`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1815)
  - `[Instance]` **Button / Redeem** (`1:1825`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1825)
  - `[Pattern]` **Reward Card / 10 GB Internet** (`1:1826`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1826)
  - `[Instance]` **Fill** (`1:1840`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1840)
  - `[Pattern]` **Section Header** (`1:1843`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1843)
  - `[Pattern]` **Prize Cards** (`1:1848`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1848)
  - `[Pattern]` **Prize Card / iPhone 18 (coming soon)** (`1:1849`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1849)
  - `[Instance]` **Button / Coming soon (disabled)** (`1:1859`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1859)
  - `[Pattern]` **Prize Card / PlayStation 5 (coming soon)** (`1:1860`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1860)
  - `[Instance]` **Button / Coming soon (disabled)** (`1:1870`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1870)
  - `[Instance]` **Navigator Bar Container** (`1:1872`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1872)

### P03 — P03 · Coin pack checkout · bottom sheet
- **Node ID**: `1:1875`
- **لینک مستقیم فیگما**: [P03 · Coin pack checkout · bottom sheet](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1875)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:1879`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1879)
  - `[Pattern]` **Page Title** (`1:1881`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1881)
  - `[Pattern]` **Segmented Tabs** (`1:1886`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1886)
  - `[Pattern]` **Section Header** (`1:1893`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1893)
  - `[Pattern]` **Coin Packs Grid** (`1:1896`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1896)
  - `[Pattern]` **Coin Pack Card / 100** (`1:1898`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1898)
  - `[Instance]` **Button / 50,000 T** (`1:1906`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1906)
  - `[Pattern]` **Coin Pack Card / 220** (`1:1907`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1907)
  - `[Instance]` **Button / 100,000 T** (`1:1917`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1917)
  - `[Pattern]` **Coin Pack Card / 600** (`1:1919`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1919)
  - `[Instance]` **Button / 250,000 T** (`1:1929`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1929)
  - `[Pattern]` **Coin Pack Card / 1,300** (`1:1930`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1930)
  - `[Instance]` **Button / 500,000 T** (`1:1940`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1940)
  - `[Pattern]` **Info Note** (`1:1941`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1941)
  - `[Instance]` **Navigator Bar Container** (`1:1945`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1945)
  - `[Pattern]` **Bottom Sheet** (`1:1949`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1949)
  - `[Pattern]` **Order Summary** (`1:1958`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1958)
  - `[Pattern]` **Row / Pack** (`1:1959`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1959)
  - `[Pattern]` **Row / Bonus** (`1:1962`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1962)
  - `[Pattern]` **Row / Tokens** (`1:1965`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1965)
  - `[Pattern]` **Row / Total** (`1:1969`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1969)
  - `[Pattern]` **Discount Code** (`1:1972`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1972)
  - `[Instance]` **Button / Apply** (`1:1978`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1978)
  - `[Pattern]` **Payment Methods** (`1:1979`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1979)
  - `[Pattern]` **Option / Bank card (IPG) (selected)** (`1:1981`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1981)
  - `[Pattern]` **Option / Mobile bill (DCB)** (`1:1987`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1987)
  - `[Pattern]` **DCB Limit** (`1:1992`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1992)
  - `[Instance]` **Button / Pay 100,000 T** (`1:1999`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1999)

### P04 — P04 · Coin purchase · success
- **Node ID**: `1:2001`
- **لینک مستقیم فیگما**: [P04 · Coin purchase · success](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2001)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2005`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2005)
  - `[Pattern]` **Row / Pack** (`1:2013`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2013)
  - `[Pattern]` **Row / Tokens** (`1:2016`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2016)
  - `[Pattern]` **Row / Paid** (`1:2019`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2019)
  - `[Pattern]` **Row / Method** (`1:2022`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2022)
  - `[Pattern]` **Row / Reference** (`1:2025`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2025)
  - `[Pattern]` **Row / Date** (`1:2028`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2028)
  - `[Pattern]` **Row / New balance** (`1:2032`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2032)
  - `[Pattern]` **Sticky CTA** (`1:2036`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2036)
  - `[Instance]` **Button / Back to Shop** (`1:2037`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2037)
  - `[Instance]` **Button / Play a game** (`1:2038`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2038)

### P05 — P05 · Coin purchase · failed
- **Node ID**: `1:2041`
- **لینک مستقیم فیگما**: [P05 · Coin purchase · failed](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2041)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2045`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2045)
  - `[Pattern]` **Row / Pack** (`1:2053`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2053)
  - `[Pattern]` **Row / Amount** (`1:2056`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2056)
  - `[Pattern]` **Row / Method** (`1:2059`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2059)
  - `[Pattern]` **Row / Reference** (`1:2062`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2062)
  - `[Pattern]` **Info Note** (`1:2065`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2065)
  - `[Pattern]` **Sticky CTA** (`1:2069`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2069)
  - `[Instance]` **Button / Try again** (`1:2070`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2070)
  - `[Instance]` **Button / Pay another way** (`1:2071`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2071)

### P06 — P06 · Reward detail · MCI package
- **Node ID**: `1:2074`
- **لینک مستقیم فیگما**: [P06 · Reward detail · MCI package](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2074)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2078`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2078)
  - `[Pattern]` **Row / Data** (`1:2089`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2089)
  - `[Pattern]` **Row / Valid for** (`1:2092`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2092)
  - `[Pattern]` **Row / Operator** (`1:2095`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2095)
  - `[Pattern]` **Row / Sent to** (`1:2098`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2098)
  - `[Pattern]` **Sticky CTA** (`1:2113`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2113)
  - `[Pattern]` **Row / Balance after redeeming** (`1:2114`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2114)
  - `[Instance]` **Button / Redeem for 5,000 pts** (`1:2117`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2117)

### P07 — P07 · Confirm redeem · bottom sheet
- **Node ID**: `1:2120`
- **لینک مستقیم فیگما**: [P07 · Confirm redeem · bottom sheet](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2120)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2124`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2124)
  - `[Pattern]` **Row / Data** (`1:2135`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2135)
  - `[Pattern]` **Row / Valid for** (`1:2138`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2138)
  - `[Pattern]` **Row / Operator** (`1:2141`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2141)
  - `[Pattern]` **Row / Sent to** (`1:2144`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2144)
  - `[Pattern]` **Sticky CTA** (`1:2159`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2159)
  - `[Pattern]` **Row / Balance after redeeming** (`1:2160`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2160)
  - `[Instance]` **Button / Redeem for 5,000 pts** (`1:2163`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2163)
  - `[Pattern]` **Bottom Sheet** (`1:2167`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2167)
  - `[Pattern]` **Row / Package** (`1:2177`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2177)
  - `[Pattern]` **Row / Sent to** (`1:2180`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2180)
  - `[Pattern]` **Row / Cost** (`1:2183`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2183)
  - `[Pattern]` **Row / Balance after** (`1:2187`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2187)
  - `[Instance]` **Button / Confirm and redeem** (`1:2193`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2193)
  - `[Instance]` **Button / Cancel** (`1:2194`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2194)

### P08 — P08 · Redeem · success
- **Node ID**: `1:2195`
- **لینک مستقیم فیگما**: [P08 · Redeem · success](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2195)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2199`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2199)
  - `[Pattern]` **Row / Package** (`1:2207`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2207)
  - `[Pattern]` **Row / Cost** (`1:2210`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2210)
  - `[Pattern]` **Row / Line** (`1:2213`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2213)
  - `[Pattern]` **Row / Reference** (`1:2216`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2216)
  - `[Pattern]` **Row / Date** (`1:2219`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2219)
  - `[Pattern]` **Row / New balance** (`1:2223`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2223)
  - `[Pattern]` **Sticky CTA** (`1:2227`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2227)
  - `[Instance]` **Button / Back to Shop** (`1:2228`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2228)
  - `[Instance]` **Button / View shop history** (`1:2229`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2229)

### P09 — P09 · Not enough Points · bottom sheet
- **Node ID**: `1:2327`
- **لینک مستقیم فیگما**: [P09 · Not enough Points · bottom sheet](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2327)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2331`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2331)
  - `[Pattern]` **Page Title** (`1:2333`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2333)
  - `[Pattern]` **Segmented Tabs** (`1:2338`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2338)
  - `[Pattern]` **Balance** (`1:2348`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2348)
  - `[Instance]` **Button / Earn more** (`1:2351`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2351)
  - `[Pattern]` **Section Header** (`1:2352`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2352)
  - `[Pattern]` **Reward Card / 1 GB Internet** (`1:2367`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2367)
  - `[Instance]` **Button / Redeem** (`1:2377`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2377)
  - `[Pattern]` **Reward Card / 3 GB Internet** (`1:2378`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2378)
  - `[Instance]` **Button / Redeem** (`1:2388`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2388)
  - `[Pattern]` **Reward Card / Combo pack** (`1:2389`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2389)
  - `[Instance]` **Button / Redeem** (`1:2399`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2399)
  - `[Pattern]` **Reward Card / 10 GB Internet** (`1:2400`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2400)
  - `[Instance]` **Fill** (`1:2414`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2414)
  - `[Instance]` **Navigator Bar Container** (`1:2417`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2417)
  - `[Pattern]` **Bottom Sheet** (`1:2421`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2421)
  - `[Instance]` **Button / Go to Missions** (`1:2459`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2459)

### P10 — P10 · Shop history
- **Node ID**: `1:2235`
- **لینک مستقیم فیگما**: [P10 · Shop history](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2235)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2239`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2239)
  - `[Pattern]` **Page Title** (`1:2241`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2241)
  - `[Pattern]` **History Item / 3 GB Internet** (`1:2255`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2255)
  - `[Pattern]` **Status / Success** (`1:2263`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2263)
  - `[Pattern]` **History Item / 3 GB Internet (refunded)** (`1:2265`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2265)
  - `[Pattern]` **Status / Refunded** (`1:2273`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2273)
  - `[Pattern]` **History Item / 220 Coins** (`1:2275`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2275)
  - `[Instance]` **Icon / Token** (`1:2282`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2282)
  - `[Pattern]` **Status / Success** (`1:2286`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2286)
  - `[Pattern]` **History Item / 220 Coins** (`1:2288`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2288)
  - `[Pattern]` **Status / Failed** (`1:2296`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2296)
  - `[Pattern]` **History Item / 1 GB Internet** (`1:2300`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2300)
  - `[Pattern]` **Status / Pending** (`1:2308`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2308)
  - `[Pattern]` **History Item / 600 Coins** (`1:2310`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2310)
  - `[Instance]` **Icon / Token** (`1:2317`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2317)
  - `[Pattern]` **Status / Success** (`1:2321`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2321)
  - `[Instance]` **Navigator Bar Container** (`1:2324`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2324)

### P11 — P11 · Redeem · failed, Points returned
- **Node ID**: `1:2460`
- **لینک مستقیم فیگما**: [P11 · Redeem · failed, Points returned](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2460)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2464`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2464)
  - `[Pattern]` **Row / Package** (`1:2472`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2472)
  - `[Pattern]` **Row / Line** (`1:2475`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2475)
  - `[Pattern]` **Row / Reference** (`1:2478`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2478)
  - `[Pattern]` **Row / Points returned** (`1:2482`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2482)
  - `[Pattern]` **Row / Your balance** (`1:2485`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2485)
  - `[Pattern]` **Info Note** (`1:2488`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2488)
  - `[Pattern]` **Sticky CTA** (`1:2492`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2492)
  - `[Instance]` **Button / Try again** (`1:2493`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2493)
  - `[Instance]` **Button / Contact support** (`1:2494`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2494)

### P12 — P12 · Support ticket · new
- **Node ID**: `1:2497`
- **لینک مستقیم فیگما**: [P12 · Support ticket · new](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2497)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2501`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2501)
  - `[Pattern]` **Field / Section** (`1:2506`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2506)
  - `[Pattern]` **Status / Refunded** (`1:2523`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2523)
  - `[Pattern]` **Field / Topic** (`1:2525`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2525)
  - `[Pattern]` **Field / Describe the problem** (`1:2530`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2530)
  - `[Pattern]` **Field / Contact number** (`1:2534`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2534)
  - `[Pattern]` **Sticky CTA** (`1:2540`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2540)
  - `[Instance]` **Button / Send ticket** (`1:2541`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2541)

### P13 — P13 · Support ticket · sent
- **Node ID**: `1:2544`
- **لینک مستقیم فیگما**: [P13 · Support ticket · sent](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2544)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2548`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2548)
  - `[Pattern]` **Row / Ticket** (`1:2556`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2556)
  - `[Pattern]` **Row / Section** (`1:2559`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2559)
  - `[Pattern]` **Row / Topic** (`1:2564`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2564)
  - `[Pattern]` **Row / Order** (`1:2567`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2567)
  - `[Pattern]` **Row / Status** (`1:2571`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2571)
  - `[Pattern]` **Sticky CTA** (`1:2575`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2575)
  - `[Instance]` **Button / Back to Shop** (`1:2576`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2576)
  - `[Instance]` **Button / View my ticket** (`1:2577`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2577)

### P14 — P14 · Ticket center · filtered by Shop
- **Node ID**: `1:2682`
- **لینک مستقیم فیگما**: [P14 · Ticket center · filtered by Shop](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2682)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2686`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2686)
  - `[Pattern]` **Ticket Card / #T-20418 · Shop** (`1:2719`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2719)
  - `[Pattern]` **Status / Answered** (`1:2727`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2727)
  - `[Pattern]` **Ticket Card / #T-20377 · Shop** (`1:2734`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2734)
  - `[Pattern]` **Status / Open** (`1:2741`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2741)
  - `[Pattern]` **Ticket Card / #T-20102 · Shop** (`1:2748`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2748)
  - `[Pattern]` **Status / Closed** (`1:2755`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2755)
  - `[Pattern]` **Sticky CTA** (`1:2763`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2763)
  - `[Instance]` **Button / New ticket** (`1:2764`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2764)

### P15 — P15 · Ticket detail · conversation
- **Node ID**: `1:2767`
- **لینک مستقیم فیگما**: [P15 · Ticket detail · conversation](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2767)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2771`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2771)
  - `[Pattern]` **Status / Answered** (`1:2780`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2780)
  - `[Pattern]` **Message / You** (`1:2791`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2791)
  - `[Pattern]` **Message / Support** (`1:2796`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2796)
  - `[Pattern]` **Sticky CTA** (`1:2803`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2803)
  - `[Instance]` **Button / My problem is solved** (`1:2810`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2810)

### P16 — P16 · Choose ticket topic · bottom sheet
- **Node ID**: `1:2813`
- **لینک مستقیم فیگما**: [P16 · Choose ticket topic · bottom sheet](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2813)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2817`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2817)
  - `[Pattern]` **Status / Refunded** (`1:2830`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2830)
  - `[Pattern]` **Field / Topic** (`1:2832`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2832)
  - `[Pattern]` **Field / Describe the problem** (`1:2837`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2837)
  - `[Pattern]` **Field / Contact number** (`1:2841`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2841)
  - `[Pattern]` **Sticky CTA** (`1:2847`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2847)
  - `[Instance]` **Button / Send ticket** (`1:2848`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2848)
  - `[Pattern]` **Bottom Sheet** (`1:2852`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2852)
  - `[Pattern]` **Option / Package not activated (selected)** (`1:2858`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2858)
  - `[Pattern]` **Option / Coins not added after payment** (`1:2862`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2862)
  - `[Pattern]` **Option / Charged twice** (`1:2865`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2865)
  - `[Pattern]` **Option / Package sent to the wrong line** (`1:2868`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2868)
  - `[Pattern]` **Option / Points balance looks wrong** (`1:2871`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2871)
  - `[Pattern]` **Option / Other** (`1:2874`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2874)
  - `[Instance]` **Button / Done** (`1:2877`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2877)

### P17 — P17 · Close ticket · bottom sheet
- **Node ID**: `1:2878`
- **لینک مستقیم فیگما**: [P17 · Close ticket · bottom sheet](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2878)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2882`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2882)
  - `[Pattern]` **Status / Answered** (`1:2887`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2887)
  - `[Pattern]` **Message / You** (`1:2898`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2898)
  - `[Pattern]` **Message / Support** (`1:2903`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2903)
  - `[Pattern]` **Sticky CTA** (`1:2910`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2910)
  - `[Instance]` **Button / My problem is solved** (`1:2917`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2917)
  - `[Pattern]` **Bottom Sheet** (`1:2921`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2921)
  - `[Instance]` **Button / Close ticket** (`1:2936`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2936)
  - `[Instance]` **Button / Not yet** (`1:2937`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2937)

### P18 — P18 · Ticket detail · closed
- **Node ID**: `1:2938`
- **لینک مستقیم فیگما**: [P18 · Ticket detail · closed](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2938)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:2942`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2942)
  - `[Pattern]` **Status / Closed** (`1:2951`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2951)
  - `[Pattern]` **Message / You** (`1:2962`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2962)
  - `[Pattern]` **Message / Support** (`1:2967`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2967)
  - `[Pattern]` **Sticky CTA** (`1:2978`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2978)
  - `[Instance]` **Button / Open a new ticket** (`1:2982`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2982)

### P19 — P19 · Coin checkout · discount applied
- **Node ID**: `1:3050`
- **لینک مستقیم فیگما**: [P19 · Coin checkout · discount applied](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3050)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:3054`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3054)
  - `[Pattern]` **Page Title** (`1:3056`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3056)
  - `[Pattern]` **Segmented Tabs** (`1:3061`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3061)
  - `[Pattern]` **Section Header** (`1:3068`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3068)
  - `[Pattern]` **Coin Packs Grid** (`1:3071`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3071)
  - `[Pattern]` **Coin Pack Card / 100** (`1:3073`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3073)
  - `[Instance]` **Button / 50,000 T** (`1:3081`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3081)
  - `[Pattern]` **Coin Pack Card / 220** (`1:3082`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3082)
  - `[Instance]` **Button / 100,000 T** (`1:3092`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3092)
  - `[Pattern]` **Coin Pack Card / 600** (`1:3094`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3094)
  - `[Instance]` **Button / 250,000 T** (`1:3104`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3104)
  - `[Pattern]` **Coin Pack Card / 1,300** (`1:3105`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3105)
  - `[Instance]` **Button / 500,000 T** (`1:3115`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3115)
  - `[Pattern]` **Info Note** (`1:3116`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3116)
  - `[Instance]` **Navigator Bar Container** (`1:3120`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3120)
  - `[Pattern]` **Bottom Sheet** (`1:3124`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3124)
  - `[Pattern]` **Order Summary** (`1:3133`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3133)
  - `[Pattern]` **Row / Pack** (`1:3134`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3134)
  - `[Pattern]` **Row / Bonus** (`1:3137`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3137)
  - `[Pattern]` **Row / Tokens** (`1:3140`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3140)
  - `[Pattern]` **Row / Discount** (`1:3143`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3143)
  - `[Pattern]` **Row / Total** (`1:3147`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3147)
  - `[Pattern]` **Discount Code** (`1:3151`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3151)
  - `[Instance]` **Button / Remove** (`1:3157`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3157)
  - `[Pattern]` **Payment Methods** (`1:3161`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3161)
  - `[Pattern]` **Option / Bank card (IPG) (selected)** (`1:3163`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3163)
  - `[Pattern]` **Option / Mobile bill (DCB)** (`1:3169`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3169)
  - `[Pattern]` **DCB Limit** (`1:3174`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3174)
  - `[Instance]` **Button / Pay 80,000 T** (`1:3181`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3181)

### P20 — P20 · Coin checkout · invalid code
- **Node ID**: `1:3183`
- **لینک مستقیم فیگما**: [P20 · Coin checkout · invalid code](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3183)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:3187`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3187)
  - `[Pattern]` **Page Title** (`1:3189`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3189)
  - `[Pattern]` **Segmented Tabs** (`1:3194`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3194)
  - `[Pattern]` **Section Header** (`1:3201`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3201)
  - `[Pattern]` **Coin Packs Grid** (`1:3204`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3204)
  - `[Pattern]` **Coin Pack Card / 100** (`1:3206`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3206)
  - `[Instance]` **Button / 50,000 T** (`1:3214`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3214)
  - `[Pattern]` **Coin Pack Card / 220** (`1:3215`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3215)
  - `[Instance]` **Button / 100,000 T** (`1:3225`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3225)
  - `[Pattern]` **Coin Pack Card / 600** (`1:3227`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3227)
  - `[Instance]` **Button / 250,000 T** (`1:3237`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3237)
  - `[Pattern]` **Coin Pack Card / 1,300** (`1:3238`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3238)
  - `[Instance]` **Button / 500,000 T** (`1:3248`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3248)
  - `[Pattern]` **Info Note** (`1:3249`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3249)
  - `[Instance]` **Navigator Bar Container** (`1:3253`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3253)
  - `[Pattern]` **Bottom Sheet** (`1:3257`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3257)
  - `[Pattern]` **Order Summary** (`1:3266`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3266)
  - `[Pattern]` **Row / Pack** (`1:3267`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3267)
  - `[Pattern]` **Row / Bonus** (`1:3270`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3270)
  - `[Pattern]` **Row / Tokens** (`1:3273`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3273)
  - `[Pattern]` **Row / Total** (`1:3277`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3277)
  - `[Pattern]` **Discount Code** (`1:3280`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3280)
  - `[Instance]` **Button / Apply** (`1:3286`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3286)
  - `[Pattern]` **Payment Methods** (`1:3290`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3290)
  - `[Pattern]` **Option / Bank card (IPG) (selected)** (`1:3292`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3292)
  - `[Pattern]` **Option / Mobile bill (DCB)** (`1:3298`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3298)
  - `[Pattern]` **DCB Limit** (`1:3303`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3303)
  - `[Instance]` **Button / Pay 100,000 T** (`1:3310`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3310)

### P21 — P21 · Coin checkout · mobile bill limit too low
- **Node ID**: `1:3340`
- **لینک مستقیم فیگما**: [P21 · Coin checkout · mobile bill limit too low](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3340)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:3344`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3344)
  - `[Pattern]` **Page Title** (`1:3346`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3346)
  - `[Pattern]` **Segmented Tabs** (`1:3351`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3351)
  - `[Pattern]` **Section Header** (`1:3358`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3358)
  - `[Pattern]` **Coin Packs Grid** (`1:3361`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3361)
  - `[Pattern]` **Coin Pack Card / 100** (`1:3363`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3363)
  - `[Instance]` **Button / 50,000 T** (`1:3371`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3371)
  - `[Pattern]` **Coin Pack Card / 220** (`1:3372`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3372)
  - `[Instance]` **Button / 100,000 T** (`1:3382`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3382)
  - `[Pattern]` **Coin Pack Card / 600** (`1:3384`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3384)
  - `[Instance]` **Button / 250,000 T** (`1:3394`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3394)
  - `[Pattern]` **Coin Pack Card / 1,300** (`1:3395`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3395)
  - `[Instance]` **Button / 500,000 T** (`1:3405`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3405)
  - `[Pattern]` **Info Note** (`1:3406`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3406)
  - `[Instance]` **Navigator Bar Container** (`1:3410`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3410)
  - `[Pattern]` **Bottom Sheet** (`1:3414`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3414)
  - `[Pattern]` **Order Summary** (`1:3423`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3423)
  - `[Pattern]` **Row / Pack** (`1:3424`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3424)
  - `[Pattern]` **Row / Bonus** (`1:3427`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3427)
  - `[Pattern]` **Row / Tokens** (`1:3430`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3430)
  - `[Pattern]` **Row / Total** (`1:3434`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3434)
  - `[Pattern]` **Discount Code** (`1:3437`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3437)
  - `[Instance]` **Button / Apply** (`1:3443`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3443)
  - `[Pattern]` **Payment Methods** (`1:3444`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3444)
  - `[Pattern]` **Option / Bank card (IPG) (selected)** (`1:3446`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3446)
  - `[Pattern]` **Option / Mobile bill (DCB) (unavailable)** (`1:3452`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3452)
  - `[Pattern]` **DCB Limit** (`1:3457`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3457)
  - `[Instance]` **Button / Pay 1,000,000 T** (`1:3466`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3466)

### P22 — P22 · Coin checkout · mobile bill limit used up
- **Node ID**: `1:3468`
- **لینک مستقیم فیگما**: [P22 · Coin checkout · mobile bill limit used up](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3468)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:3472`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3472)
  - `[Pattern]` **Page Title** (`1:3474`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3474)
  - `[Pattern]` **Segmented Tabs** (`1:3479`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3479)
  - `[Pattern]` **Section Header** (`1:3486`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3486)
  - `[Pattern]` **Coin Packs Grid** (`1:3489`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3489)
  - `[Pattern]` **Coin Pack Card / 100** (`1:3491`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3491)
  - `[Instance]` **Button / 50,000 T** (`1:3499`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3499)
  - `[Pattern]` **Coin Pack Card / 220** (`1:3500`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3500)
  - `[Instance]` **Button / 100,000 T** (`1:3510`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3510)
  - `[Pattern]` **Coin Pack Card / 600** (`1:3512`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3512)
  - `[Instance]` **Button / 250,000 T** (`1:3522`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3522)
  - `[Pattern]` **Coin Pack Card / 1,300** (`1:3523`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3523)
  - `[Instance]` **Button / 500,000 T** (`1:3533`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3533)
  - `[Pattern]` **Info Note** (`1:3534`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3534)
  - `[Instance]` **Navigator Bar Container** (`1:3538`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3538)
  - `[Pattern]` **Bottom Sheet** (`1:3542`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3542)
  - `[Pattern]` **Order Summary** (`1:3551`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3551)
  - `[Pattern]` **Row / Pack** (`1:3552`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3552)
  - `[Pattern]` **Row / Bonus** (`1:3555`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3555)
  - `[Pattern]` **Row / Tokens** (`1:3558`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3558)
  - `[Pattern]` **Row / Total** (`1:3562`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3562)
  - `[Pattern]` **Discount Code** (`1:3565`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3565)
  - `[Instance]` **Button / Apply** (`1:3571`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3571)
  - `[Pattern]` **Payment Methods** (`1:3572`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3572)
  - `[Pattern]` **Option / Bank card (IPG) (selected)** (`1:3574`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3574)
  - `[Pattern]` **Option / Mobile bill (DCB) (unavailable)** (`1:3580`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3580)
  - `[Pattern]` **DCB Limit** (`1:3585`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3585)
  - `[Instance]` **Button / Pay 100,000 T** (`1:3593`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3593)

### P23 — P23 · Ticket center · all sections
- **Node ID**: `1:3646`
- **لینک مستقیم فیگما**: [P23 · Ticket center · all sections](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3646)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:3650`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3650)
  - `[Pattern]` **Ticket Card / #T-20418 · Shop** (`1:3682`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3682)
  - `[Pattern]` **Status / Answered** (`1:3690`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3690)
  - `[Pattern]` **Ticket Card / #T-20455 · Games** (`1:3697`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3697)
  - `[Pattern]` **Status / Open** (`1:3704`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3704)
  - `[Pattern]` **Ticket Card / #T-20431 · Missions** (`1:3711`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3711)
  - `[Pattern]` **Status / Answered** (`1:3718`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3718)
  - `[Pattern]` **Ticket Card / #T-20377 · Shop** (`1:3725`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3725)
  - `[Pattern]` **Status / Open** (`1:3732`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3732)
  - `[Pattern]` **Sticky CTA** (`1:3740`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3740)
  - `[Instance]` **Button / New ticket** (`1:3741`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3741)

### P24 — P24 · Confirm redeem · bottom sheet on P02
- **Node ID**: `1:3844`
- **لینک مستقیم فیگما**: [P24 · Confirm redeem · bottom sheet on P02](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3844)
- **ابعاد**: 402 × 874 pt
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **App Bar Container** (`1:3848`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3848)
  - `[Pattern]` **Page Title** (`1:3850`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3850)
  - `[Pattern]` **Segmented Tabs** (`1:3855`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3855)
  - `[Pattern]` **Balance** (`1:3865`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3865)
  - `[Instance]` **Button / Earn more** (`1:3868`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3868)
  - `[Pattern]` **Section Header** (`1:3869`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3869)
  - `[Pattern]` **Reward Card / 1 GB Internet** (`1:3884`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3884)
  - `[Instance]` **Button / Redeem** (`1:3894`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3894)
  - `[Pattern]` **Reward Card / 3 GB Internet** (`1:3895`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3895)
  - `[Instance]` **Button / Redeem** (`1:3905`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3905)
  - `[Pattern]` **Reward Card / Combo pack** (`1:3906`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3906)
  - `[Instance]` **Button / Redeem** (`1:3916`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3916)
  - `[Pattern]` **Reward Card / 10 GB Internet** (`1:3917`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3917)
  - `[Instance]` **Fill** (`1:3931`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3931)
  - `[Pattern]` **Section Header** (`1:3934`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3934)
  - `[Pattern]` **Prize Cards** (`1:3939`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3939)
  - `[Pattern]` **Prize Card / iPhone 18 (coming soon)** (`1:3940`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3940)
  - `[Instance]` **Button / Coming soon (disabled)** (`1:3950`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3950)
  - `[Pattern]` **Prize Card / PlayStation 5 (coming soon)** (`1:3951`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3951)
  - `[Instance]` **Button / Coming soon (disabled)** (`1:3961`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3961)
  - `[Instance]` **Navigator Bar Container** (`1:3963`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3963)
  - `[Pattern]` **Bottom Sheet** (`1:3967`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3967)
  - `[Pattern]` **Row / Package** (`1:3977`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3977)
  - `[Pattern]` **Row / Sent to** (`1:3980`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3980)
  - `[Pattern]` **Row / Cost** (`1:3983`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3983)
  - `[Pattern]` **Row / Balance after** (`1:3987`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3987)
  - `[Instance]` **Button / Confirm and redeem** (`1:3993`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3993)
  - `[Instance]` **Button / Cancel** (`1:3994`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3994)

---

## ۳. جدول فراوانی و تکرار المان‌ها (Frequency Ranking Table)
جدول زیر تمام الگوها و کامپوننت‌های شناسایی‌شده را بر اساس میزان تکرار مرتب کرده و وضعیت فعلی آن‌ها را در سورس‌کد پروژه نشان می‌دهد:

| نام المان / کامپوننت | تعداد تکرار کل | تعداد فریم‌ها | فریم‌های مشاهده‌شده | وضعیت فعلی در کد | پیشنهاد لایه‌بندی |
|---|:---:|:---:|---|:---:|:---:|
| **Key-Value Data Row** (`Row / *`) | ۵۲ | ۱۴ | P03, P04, P05, P06, P07, P08, P11, P13, P19, P20, P21, P22, P24 | ❌ وجود ندارد (فقط GameInfoRow اختصاصی) | **Layer 1 (Core DS)** |
| **Coin Pack Cards / Tiles** | ۲۶ | ۶ | P01, P03, P19, P20, P21, P22 | ❌ وجود ندارد | **Layer 2 (Shop Feature)** |
| **Status Badge / Status Chip** (`Status / *`) | ۱۸ | ۸ | P10, P12, P14, P15, P16, P17, P18, P23 | ⚠️ فقط AppBadge عمومی (بدون سمانتیک رنگی) | **Layer 1 (Core DS)** |
| **Selection Option Tile / Radio Card** | ۱۶ | ۶ | P03, P16, P19, P20, P21, P22 | ❌ فقط AppRadio خام | **Layer 1 (Core DS)** |
| **Sticky CTA Action Bar** | ۱۴ | ۱۴ | P04, P05, P06, P07, P08, P11, P12, P13, P14, P15, P16, P17, P18, P23 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **Reward Package Card** (MCI internet) | ۱۲ | ۳ | P02, P09, P24 | ❌ وجود ندارد | **Layer 2 (Shop Feature)** |
| **Segmented Tabs / Filter Tabs** | ۱۱ | ۱۱ | P01, P02, P03, P09, P14, P19, P20, P21, P22, P23, P24 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **Section Header (Title + Subtitle + Count)** | ۱۱ | ۹ | P01, P02, P03, P09, P19, P20, P21, P22, P24 | ⚠️ AppSectionHeader هست (بدون پشتیبانی Subtitle) | **Layer 1 (Core DS)** |
| **Bottom Sheet Frame / Layout** | ۱۰ | ۱۰ | P03, P07, P09, P16, P17, P19, P20, P21, P22, P24 | ⚠️ فقط شیت خام D-140 بدون هدر استاندارد | **Layer 1 (Core DS)** |
| **Page Title Header** | ۱۰ | ۱۰ | P01, P02, P03, P09, P10, P19, P20, P21, P22, P24 | ⚠️ در فریم‌ها ترکیب متن و TextButton | **Layer 1 (Core DS)** |
| **Info Note / Alert Callout** | ۸ | ۸ | P01, P03, P05, P11, P19, P20, P21, P22 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **Ticket Card / Summary Card** | ۷ | ۲ | P14, P23 | ❌ وجود ندارد | **Layer 2 (Support Feature)** |
| **Chat Message Bubble** (User/Support) | ۶ | ۳ | P15, P17, P18 | ❌ وجود ندارد | **Layer 2 (Support Feature)** |
| **History Item** (Order/Redeem history) | ۶ | ۱ | P10 | ❌ وجود ندارد | **Layer 2 (Shop Feature)** |
| **Feedback / Result State Hero** | ۵ | ۵ | P04, P05, P08, P11, P13 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **Discount Code Input Row** | ۵ | ۵ | P03, P19, P20, P21, P22 | ⚠️ AppTextField هست (ترکیب با Apply دکمه ندارد) | **Layer 1 / Layer 2** |
| **DCB Limit Progress Bar** | ۵ | ۵ | P03, P19, P20, P21, P22 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **Prize Card** (Coming soon physical) | ۴ | ۲ | P02, P24 | ❌ وجود ندارد | **Layer 2 (Shop Feature)** |
| **Points Balance Header Card** | ۳ | ۳ | P02, P09, P24 | ❌ وجود ندارد (فقط RewardPill کامپکت) | **Layer 2 (Shop Feature)** |

---

## ۴. تفکیک معماری و طبقه‌بندی لایه‌ها (Layer 1 vs Layer 2)

### ۴.۱. لایه اول: کامپوننت‌های بنیادین دیزاین سیستم (Layer 1 — Core Design System)
این المان‌ها ماهیت عمومی (Domain-Agnostic) دارند، در کل اپلیکیشن (صفحات بازی، ماموریت‌ها، پروفایل، تنظیمات، کیف پول و فروشگاه) قابل استفاده مجدد هستند و باید در پکیج `packages/design_system/lib/src/components/` قرار گیرند:

1. **`AppKeyValueRow` / `AppDataRow`**:
   - **تعداد کل تکرار**: ۵۲ مرتبه در ۱۴ فریم!
   - **آناتومی**: ردیف افقی شامل Label در سمت Start (با استایل Muted)، و Value در سمت End (با استایل Emphasized).
   - **واریانت‌ها**:
     - `regular`: سطر استاندارد مشخصات.
     - `total`: سطر مجموع نهایی با خط جداکننده بالا (Top Divider) و فونت بولد/بزرگ‌تر.
     - `withStatus`: همراه با چیپ وضعیت یا آیکون در بخش Value.
   - **نمونه نود فیگما**: [Row / Total](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1969) · [Row / Pack](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1959)

2. **`AppCallout` / `AppInfoNote`**:
   - **تعداد کل تکرار**: ۸ فریم.
   - **آناتومی**: کادر با پس‌زمینه کانتینر ملایم، آیکون ۲۴/۱۸ پیکسلی در سمت Start، و متن توضیحی چندخطی در سمت End.
   - **واریانت‌ها**:
     - `neutral`: با آیکون Help (برای اطلاع‌رسانی قوانین مانند عدم امکان انتقال سکه‌ها).
     - `warning`: با آیکون Warning و رنگ زرد/نارنجی (برای استرداد بانکی ۷۲ ساعته یا پیام خطا).
   - **نمونه نود فیگما**: [Info Note P01](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1743) · [Info Note P05](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2065)

3. **`AppStickyActionBar`**:
   - **تعداد کل تکرار**: ۱۴ فریم!
   - **آناتومی**: کانتینر چسبیده به پایین صفحه با Safe Area، شامل یک یا دو دکمه اکشن، با امکان قرارگیری یک ردیف متادیتا یا بالانس در بالای دکمه‌ها.
   - **واریانت‌ها**: Single Button, Dual Buttons (Primary + Tonal/Cancel), Button + Helper Row.
   - **نمونه نود فیگما**: [Sticky CTA P04](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2036) · [Sticky CTA P06](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2113)

4. **`AppRadioOptionTile` / `AppSelectionCard`**:
   - **تعداد کل تکرار**: ۱۶ مرتبه در ۶ فریم.
   - **آناتومی**: کارت قابل انتخاب با رادیوباتن (`AppRadio`)، عنوان، زیرعنوان توضیحی اختیاری، و وضعیت غیرفعال با متن هشدار.
   - **واریانت‌ها**: Selected (حاشیه هایلایت و پر بودن رادیو)، Unselected، Disabled/Unavailable (با نوار پیشرفت یا هشدار عبور از سقف اعتبار).
   - **نمونه نود فیگما**: [Option Bank card](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1981) · [Option Mobile bill unavailable](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3452) · [Option Topic](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2858)

5. **`AppStatusChip` / `AppSemanticBadge`**:
   - **تعداد کل تکرار**: ۱۸ مرتبه در ۸ فریم.
   - **آناتومی**: چیپ کوچک ۱۸ پیکسلی با رنگ‌های معنایی مشخص.
   - **استیت‌ها**: `Success` (سبز - پرداخت موفق، تیکت پاسخ داده شده)، `Failed` (قرمز - پرداخت ناموفق)، `Refunded` (نارنجی - مرجوعی وجه/امتیاز)، `Pending` (زرد/آبی - در حال فعال‌سازی بسته)، `Open` (آبی - تیکت در جریان)، `Closed` (خاکستری - تیکت بسته شده).
   - **نمونه نود فیگما**: [Status Success](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2263) · [Status Refunded](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2273) · [Status Answered](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2727)

6. **`AppSegmentedControl` / `AppFilterTabs`**:
   - **تعداد کل تکرار**: ۱۱ فریم.
   - **آناتومی**: نوار سوئیچ تب‌ها با کپسول متحرک/هایلایت‌شده، پشتیبانی از آیکون + عنوان.
   - **واریانت‌ها**: دو تب کانتینردار (مانند Coins / Rewards در P01) و تب‌های فیلتر اسکرولی (مانند All / Shop / Games در مرکز تیکت P14/P23).
   - **نمونه نود فیگما**: [Segmented Tabs P01](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1644) · [Filter Tabs P14](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2692)

7. **`AppResultStateView` / `AppFeedbackHero`**:
   - **تعداد کل تکرار**: ۵ فریم کامل.
   - **آناتومی**: آیکون بزرگ دایره‌ای وضعیت (تیک سبز، ضربدر قرمز، پاکت نامه سبز)، تیتر پیام نتیجه، متن تشریحی، کارت رسید مشخصات، و دکمه‌های ناوبری.
   - **واریانت‌ها**: `success`, `failure`, `warning`, `info`.
   - **نمونه نود فیگما**: [P04 Coin Purchase Success](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2001) · [P05 Coin Purchase Failed](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2041) · [P08 Redeem Success](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2195) · [P13 Ticket Sent](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2544)

8. **`AppLinearProgressBar` / `AppQuotaBar`**:
   - **تعداد کل تکرار**: ۵ فریم.
   - **آناتومی**: نوار پیشرفت خطی با برچسب مقدار و سقف (مثلاً `100,000 / 500,000 Toman`) و نمایش وضعیت پر شدن یا اخطار سقف مجاز.
   - **نمونه نود فیگما**: [DCB Limit Bar](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1992)

9. **`AppSheetHeader`**:
   - **تعداد کل تکرار**: ۱۰ فریم باتم‌شیت.
   - **آناتومی**: هدر استاندارد باتم‌شیت شامل تیتر وسط‌چین یا استارت‌چین و دکمه بستن (`Outline / Close`) در سمت End.
   - **نمونه نود فیگما**: [Sheet Header](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1951)

---

### ۴.۲. لایه دوم: کامپوننت‌های اشتراکی فیچر و دامنه (Layer 2 — Shared & Feature Domain)
این کامپوننت‌ها منطق، محتوا یا تصویرسازی اختصاصی بیزینس فروشگاه و پشتیبانی را در بر دارند و بر اساس معماری پروژه باید در `lib/features/shop/presentation/widgets/` یا `lib/shared/widgets/` قرار گیرند:

1. **`CoinPackTile`** (کارت گرید بسته سکه):
   - **تعداد تکرار**: ۶ بسته در P01.
   - **آناتومی**: نشان نشان تخفیف/محبوبیت در بالا، آیکون رشد سکه‌ها (`Coin Art`)، رقم بسته (۱۰۰، ۲۲۰، ۶۰۰، ۱۳۰۰، ۲۸۰۰، ۶۰۰۰)، برچسب بونوس، بج توکن‌های رایگان هدیه (`+10 Tokens`)، و دکمه خرید ریالی در پایین.
   - **لینک فیگما**: [Coin Pack Tile / 100](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1658) · [Coin Pack Tile / 6000](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1726)

2. **`CoinPackCheckoutCard`** (کارت افقی انتخاب بسته در چک‌اوت):
   - **تعداد تکرار**: ۲۰ مرتبه در فریم‌های P03, P19, P20, P21, P22.
   - **آناتومی**: طراحی افقی فشرده برای اسکرول سریع در شیت تسویه‌حساب.
   - **لینک فیگما**: [Coin Pack Card / 100](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1898)

3. **`RewardPackageCard`** (کارت بسته اینترنت MCI):
   - **تعداد تکرار**: ۱۲ مرتبه در فریم‌های P02, P09, P24.
   - **آناتومی**: تایل حجم بسته با فونت متمایز ("1 GB", "3 GB", "Combo"), تیتر و مدت اعتبار، قیمت امتیازی همراه با آیکون تاج (`2,000 pts`)، و دکمه اکشن "Redeem".
   - **لینک فیگما**: [Reward Card / 1 GB](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1793) · [Reward Card / Combo](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1815)

4. **`PrizeCard`** (کارت جوایز فیزیکی در راه است):
   - **تعداد تکرار**: ۴ مرتبه در فریم‌های P02, P24.
   - **آناتومی**: تصویر بزرگ محصول (آیفون ۱۸، پلی‌استیشن ۵)، برچسب "Coming soon"، توضیحات، و دکمه غیرفعال CTA.
   - **لینک فیگما**: [Prize Card iPhone 18](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1849)

5. **`ShopHistoryItem`** (سطر تاریخچه تراکنش و ردیم):
   - **تعداد تکرار**: ۶ آیتم در P10.
   - **آناتومی**: آیکون بسته/سکه در سمت چپ، تیتر و ساعت تراکنش در وسط، مبلغ کسر/اضافه شده (`-5,000 pts` / `+220 Coins`) و چیپ وضعیت تراکنش (`Success`, `Refunded`, `Failed`, `Pending`) در سمت راست.
   - **لینک فیگما**: [History Item / 3 GB](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2255) · [History Item / 220 Coins](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2275)

6. **`TicketSummaryCard`** (کارت خلاصه تیکت پشتیبانی):
   - **تعداد تکرار**: ۷ مرتبه در P14, P23.
   - **آناتومی**: دات خوانده‌نشده (Unread indicator)، شماره تیکت (`#T-20418`)، برچسب بخش (`Shop`, `Games`, `Missions`)، چیپ وضعیت (`Answered`, `Open`, `Closed`)، موضوع تیکت، شماره سفارش، و پیش‌نمایش آخرین پیام همراه با زمان.
   - **لینک فیگما**: [Ticket Card #T-20418](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2719)

7. **`SupportChatMessageBubble`** (حباب پیام گفتگوی تیکت):
   - **تعداد تکرار**: ۶ مرتبه در P15, P17, P18.
   - **آناتومی**: حباب تراز راست کاربر (`Message / You`) با ساعت و استیت Sent، در برابر حباب تراز چپ پشتیبان (`Message / Support`) با نام و آواتار کارشناس.
   - **لینک فیگما**: [Message You](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2791) · [Message Support](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-2796)

8. **`PointsBalanceHeaderCard`** (کارت موجودی امتیاز کاربر):
   - **تعداد تکرار**: ۳ مرتبه در P02, P09, P24.
   - **آناتومی**: نمایش برجسته امتیاز فعلی کاربر (`5,325 pts`) همراه با آیکون تاج و دکمه CTA سریع `Earn more` جهت هدایت به ماموریت‌ها.
   - **لینک فیگما**: [Balance Header](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1774)

9. **`DiscountCodeField`** (فیلد کد تخفیف):
   - **تعداد تکرار**: ۵ مرتبه در تسویه‌حساب سکه.
   - **آناتومی**: اینپوت اختصاصی با دکمه چسبیده یا درون‌فیلد `Apply`، همراه با مدیریت استیت‌های خطا ("Code expired or invalid") و استیت موفقیت تخفیف.
   - **لینک فیگما**: [Discount Code P03](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-1972) · [Invalid Code State P20](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-3278)

---

## ۵. بررسی ظرافت‌ها و تفاوت‌های جزئی در کامپوننت‌های مشابه (Comparative Analysis)
در طراحی وایرفریم‌ها، مواردی وجود دارند که در نگاه اول شبیه به نظر می‌رسند اما تفاوت‌های جزئی دارند که باید در قرارداد کامپوننت (Component Contract) دیده شوند:

1. **تفاوت `Coin Pack Tile` (صفحه اصلی) در مقابل `Coin Pack Card` (صفحه چک‌اوت)**:
   - در P01، کاشی‌ها عمودی و بلند (`116 × 212 pt`) هستند، دارای استک رشد چندلایه‌ای سکه‌ها (`Coin Art`) و نشان مجزای توکن‌های هدیه (`Token Bonus`) می‌باشند.
   - در P03 و P19 الی P22، کارت‌ها فشرده‌تر و افقی (`178.5 × 176 pt`) هستند، استک چند سکه ندارند و تنها یک آیکون ۳۶ پیکسلی سکه دارند و نشان توکن از آن‌ها حذف شده است.

2. **تفاوت `Reward Card` (بسته‌های اینترنت) در مقابل `Prize Card` (جوایز فیزیکی)**:
   - `Reward Card` برای ردیم فوری بسته‌های دیجیتال همراه اول است؛ ابعاد فشرده سطری (`370 × 78 pt`) دارد، تایل حجم با فونت عددی دارد و دکمه آن اکتیو و تعاملی است.
   - `Prize Card` برای قرعه‌کشی‌های آینده (آیفون و کنسول) است؛ دارای تصویر گرافیکی بزرگ، تگ برجسته "Coming soon" و دکمه سراسری غیرفعال (Disabled) می‌باشد.

3. **تفاوت `Reward Card` در لیست با `Reward Detail Hero` در P06**:
   - در صفحه جزئیات P06، کارت بسته اینترنت تبدیل به یک هدر گسترده قهرمان (`370 × 140 pt`) شده که حجم، لوگوی همراه اول و اطلاعات تکمیلی به صورت درشت‌تر نمایش داده می‌شوند و سطرهای مشخصات در زیر آن قرار می‌گیرند.

4. **تفاوت استیت‌های `Option / *` در چک‌اوت و انتخاب موضوع تیکت**:
   - در انتخاب درگاه پرداخت، آپشن‌ها می‌توانند حالت `Unavailable` داشته باشند (به دلیل پر شدن سقف مصرف صورتحساب همراه اول DCB) که در این حالت پیام هشدار اخطار و نوار سقف اعتبار درون آپشن رندر می‌شود.
   - در انتخاب موضوع تیکت (P16)، آپشن‌ها ساده، تک‌خطی و بدون محتوای تودرتو هستند.

5. **تنوع وایرفریم برای `Status Chip`**:
   - در تراکنش‌ها: ۴ وضعیت سمانتیک (`Success`، `Refunded`، `Failed`، `Pending / Activating`).
   - در تیکت‌ها: ۳ وضعیت چرخه عمر تیکت (`Answered`، `Open`، `Closed`).
   - تمام این چیپ‌ها از فرمت واحد کپسول ۱۸ پیکسلی با فونت ۱۲ استفاده می‌کنند و می‌توانند به صورت یک اینام منسجم `StatusTone` پیاده‌سازی شوند.

---

## ۶. تطبیق با کدهای فعلی ریپازیتوری (Gap Analysis)

| کامپوننت وایرفریم | وضعیت در `packages/design_system` | وضعیت در `lib/shared/widgets` | اقدام لازم |
|---|---|---|---|
| **App Button** | ✅ `AppButton` با تمام واریانت‌ها پیاده شده | — | کامل است. |
| **App Bar / Status Bar** | ✅ `AppBarContent`, `AppBarLayout` پیاده شده | — | کامل است. |
| **Navigation Bar** | ✅ `AppNavigationBar` پیاده شده | — | کامل است. |
| **App Badge** | ⚠️ `AppBadge` پیاده شده | — | نیاز به توسعه واریانت‌های معنایی (`success`, `warning`, `error`, `info`) یا ساخت `AppStatusChip`. |
| **App Section Header** | ⚠️ `AppSectionHeader` پیاده شده | — | نیاز به پشتیبانی از پاراگراف توضیحی چندخطی (Subtitle) و متادیتای تعداد. |
| **App Sheet** | ⚠️ `AppSheet` پرویژنال D-140 | — | نیاز به هدر استاندارد (`AppSheetHeader`) با دکمه خروج و ساختار محتوا. |
| **Key-Value Data Row** | ❌ ندارد | ⚠️ فقط `GameInfoRow` خاص بازی | **ساخت کامپوننت پایه `AppKeyValueRow` در Core DS**. |
| **Sticky CTA Action Bar** | ❌ ندارد | ❌ ندارد | **ساخت کامپوننت پایه `AppStickyActionBar` در Core DS**. |
| **Radio Option Tile** | ⚠️ فقط `AppRadio` خام | ❌ ندارد | **ساخت `AppRadioTile` در Core DS**. |
| **Info Note / Callout** | ❌ ندارد | ❌ ندارد | **ساخت `AppCallout` در Core DS**. |
| **Segmented Tabs** | ❌ ندارد | ❌ ندارد | **ساخت `AppSegmentedControl` در Core DS**. |
| **Result State / Hero** | ❌ ندارد | ❌ ندارد | **ساخت `AppResultView` در Core DS**. |
| **Coin Pack Tile / Card** | ❌ ندارد | ❌ ندارد | **ساخت در `lib/features/shop/presentation/widgets/`**. |
| **Reward Package Card** | ❌ ندارد | ❌ ندارد | **ساخت در `lib/features/shop/presentation/widgets/`**. |
| **Ticket Summary Card** | ❌ ندارد | ❌ ندارد | **ساخت در فیچر ساپورت/تیکت**. |
| **Chat Message Bubble** | ❌ ندارد | ❌ ندارد | **ساخت در فیچر ساپورت/تیکت**. |

---

## ۷. اولویت‌بندی و نقشه راه پیشنهادی پیاده‌سازی (Recommendations & Roadmap)
برای توسعه ماژولار و اصولی این صفحات و جلوگیری از کد تکراری (Duplicate styling) در فیچرهای بعدی، ترتیب زیر پیشنهاد می‌شود:

1. **مرحله ۱ — پایه‌گذاری المان‌های عمومی پرتکرار در لایه اول (Core DS)**:
   - اولویت ۱: `AppKeyValueRow` (۵۲ بار تکرار)
   - اولویت ۲: `AppStickyActionBar` (۱۴ بار تکرار)
   - اولویت ۳: `AppStatusChip` (۱۸ بار تکرار)
   - اولویت ۴: `AppRadioOptionTile` (۱۶ بار تکرار)
   - اولویت ۵: `AppSegmentedControl` (۱۱ بار تکرار)
   - اولویت ۶: `AppCallout` / `AppInfoNote` (۸ بار تکرار)
   - اولویت ۷: `AppSheetHeader` (۱۰ بار تکرار)
   - اولویت ۸: `AppResultStateView` (۵ بار تکرار)

2. **مرحله ۲ — کامپوننت‌های بیزینسی اختصاصی فروشگاه در لایه دوم (Feature Widgets)**:
   - کامپوننت‌های بسته‌های سکه (`CoinPackTile` و `CoinPackCheckoutCard`)
   - کامپوننت‌های بسته اینترنت و جوایز (`RewardPackageCard` و `PrizeCard`)
   - کامپوننت ردیف تاریخچه خرید (`ShopHistoryItem`)
   - هدر موجودی کاربر (`PointsBalanceHeaderCard`)

3. **مرحله ۳ — کامپوننت‌های ماژول مرکز پشتیبانی و تیکت‌ها (Support Widgets)**:
   - کارت خلاصه تیکت (`TicketSummaryCard`)
   - حباب‌های گفتگوی تیکت (`SupportChatMessageBubble`)
   - فرم ثبت تیکت جدید و فیلد انتخاب موضوع

---
*این گزارش به صورت کاملاً خودکار و مستند از روی درخت لایه‌های فیگما استخراج شده و تمام نودها به پیوند مستقیم دیزاین فیگما متصل شده‌اند.*
