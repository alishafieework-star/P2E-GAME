# گزارش جامع استخراج و تحلیل کامپوننت‌های سکشن Leaderboard Wireframes

> **مرجع دیزاین فیگما**: فایل `7BurKbCwclcabEGJ7cLcKz` · سکشن `1:4335` (`Leaderboard · Wireframes (18 Oct 2026)`)  
> **لینک مستقیم سکشن در فیگما**: [Figma Section 1:4335 (Leaderboard · Wireframes)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4335)  
> **نوع تحلیل**: کاملاً Read-Only، مستند، سیستماتیک و مبتنی بر شواهد مستقیم درختی فیگما  
> **جامعه آماری**: ۲۲ فریم اصلی موبایل و باتم‌شیت (L01 الی L22) + ۱ بلوک جامع یادداشت‌های دیزاینر (`1:6428`) + ۲۲ باکس مشخصات و کپشن جریان کار دیزاینر (Designer Captions)

---

## ۱. هدف و خلاصه اجرایی (Executive Summary)

این گزارش به عنوان مرجع رسمی و مستقل مهندسی، کلیه ۲۲ فریم موجود در سکشن لیدربورد فیگما (شامل لیدربورد کلی پلتفرم در حالت زنده، در حال محاسبه و اهدای جایزه، لیدربوردهای اختصاصی بازی‌ها و کاپ‌های هفتگی، حالات ادمین نظیر تعلیق، لغو و غیرفعال‌سازی، باتم‌شیت‌های قوانین، پروفایل بازیکن، گزارش تخلف، راهنمای دریافت توکن، تاریخچه نتایج گذشته و منوی دسترسی سریع ناوبری) را به صورت کامل و ریشه‌ای کالبدشکافی می‌کند.

هدف اصلی این تحقیق، **شناسایی الگوها و کامپوننت‌های پرتکرار UI و تفکیک دقیق آن‌ها به دو لایه معماری** است:
1. **لایه اول (Core Design System Primitives)**: مؤلفه‌های بنیادین، انتزاعی و فاقد وابستگی به دامین (Domain-Agnostic) که باید در پکیج `packages/design_system/lib/src/components/` مستقر شوند.
2. **لایه دوم (Feature-Shared / Leaderboard Domain Widgets)**: ویجت‌های تخصصی دامین بازی و جدول امتیازات که در `lib/shared/widgets/` یا `lib/features/leaderboard/presentation/widgets/` پیاده‌سازی می‌شوند.

### یافته‌های آماری کلیدی:
1. **تعداد کل فریم‌های مستقل**: ۲۲ فریم (L01 الی L22).
2. **تعداد کل نمونه‌های رسمی کامپوننت (Instances)**: ۳۶۵ اینستنس رسمی.
3. **تعداد کل الگوها و کانتینرهای ساختاری (Patterns)**: ۸۰۰ الگو.
4. **میزان پوشش فعلی دیزاین سیستم در سورس‌کد پروژه**:
   - تنها `AppButton`، ساختار `AppBars`، نوار ناوبری پایه `AppNavigationBar`، آیکون‌های وکتور SVG و ویجت خام `PlayerAvatar` در ریپازیتوری وجود دارند.
5. **بزرگ‌ترین خلاءهای دیزاین سیستم (مؤلفه‌هایی با تکرار بسیار بالا که وجود ندارند)**:
   - **سکوی سه رتبه برتر (`AppPodium`)**: در ۱۵ فریم تکرار شده است (بزرگ‌ترین هویت بصری لیدربورد).
   - **سطر رتبه بازیکن (`LeaderboardRankRow`)**: ۵۳ تکرار در ۱۵ فریم.
   - **کارت چسبان رتبه من (`AppStickyRankBar` / `Your Rank`)**: در ۱۱ فریم به عنوان فوتر شناور وضعیت و پیشرفت تا رتبه بعدی حضور دارد.
   - **تب‌های قطعه‌بندی‌شده (`AppSegmentedTabs`)**: در ۱۱ فریم (ترکیب با ۱۱ بار تکرار در بخش Shop Wireframes، مجموعاً ۲۲ فریم در کل پروژه!).
   - **چیپ‌های فیلتر محتوا (`AppFilterChip` / `AppFilterBar`)**: در ۱۱ فریم برای فیلتر بازه‌های زمانی یا وضعیت کاپ‌ها.
   - **بنرهای اطلاع‌رسانی و هشدار (`AppBanner` / `AppCallout`)**: در ۱۱ فریم با ۶ واریانت معنادار (اعلام نتایج، در حال محاسبه، بدون جایزه، تعلیق، لغو، و بازبینی تخلف).
   - **کارت زمان‌سنج و روزشمار دوره (`AppCountdownCard` / `Period Card`)**: در ۸ فریم به همراه نشانگر وضعیت زنده (`Live Badge`).
   - **شبکه جوایز سطوح (`AppRewardTiers`)**: در ۱۰ فریم به صورت نمایش ۳ ستونه جوایز.
   - **کارت‌ها و کاورهای برد بازی‌ها (`GameBoardTileCard`)**: ۱۲ نمونه در تب اختصاصی بازی‌ها.
   - **الگوی قهرمان وضعیت / خطا / موفقیت (`AppStateHero`)**: در ۶ فریم مستقل.
   - **دروازه ناوبری منو (`AppNavigationDrawer` / منوی L22)**: دراور ۳۰۰ پوینتی کشویی با کارت پروفایل و لیست آیتم‌ها.

---

## ۲. یادداشت‌ها و فرضیات کلیدی دیزاینر (Designer Canvas Notes & Architecture Insights)

در کانواس فیگما، یک فریم بسیار باارزش و جامع تحت عنوان **"Notes · states & open questions"** با شناسه `1:6428` قرار داده شده که قوانین کسب‌وکار، معماری ناوبری، تفاوت توکن‌ها و ابهامات باز را تشریح می‌کند:

### ۲.۱. متن کامل یادداشت‌های دیزاینر (Verbatim Transcription of Node `1:6428`)

- **ناوبری و شیوه ورود (Navigation - تاریخ ۲۷ اکتبر)**:
  - *«لیدربورد از طریق منوی کشویی (فریم L22) باز می‌شود که خود منو با ضربه روی آواتار کاربر باز می‌گردد؛ هیچ آیکون همبرگری مستقل در نوار بالا وجود ندارد. تب اجتماعی (Social) جایگاه لیدربورد در نوار ناوبری پایین را گرفته است.»*
  - *«صفحات لیدربورد کلی (Overall) و لیدربورد بازی‌ها (Games) تاپ‌بار اصلی برنامه (شامل آواتار، موجودی Points و موجودی Coins) را حفظ می‌کنند تا منو همیشه با یک تپ در دسترس باشد. صفحات جزئیات (نتایج، برد یک بازی، وضعیت‌های ادمین) از دکمه بازگشت (Back Arrow) استفاده می‌کنند. در زمان حضور در لیدربورد، هیچ تبی در نوار ناوبری پایین در حالت انتخاب (Selected) قرار ندارد.»*
  - *«بردهای اختصاصی بازی‌ها هدر مجزای بازی ندارند، زیرا مستقیماً از صفحه همان بازی باز می‌شوند که خود بازی را نمایش می‌دهد.»*

- **سیستم توکن‌ها و تمایز آن با امتیازات (Tokens - تاریخ ۱۹ اکتبر)**:
  - *«لیدربورد کلی (Overall board) = بر اساس میزان توکن‌های کسب‌شده پلتفرم (Platform Token) محاسبه می‌شود.»*
  - *«لیدربورد بازی‌ها (Game board) = بر اساس توکن اختصاصی همان بازی (مثلاً Block Blast Token) رتبه‌بندی می‌شود.»*
  - *«منابع کسب توکن: بسته‌های سکه فروشگاه (فقط توکن پلتفرم می‌دهند)، ماموریت‌ها (Missions & Quests) و جوایز دوره‌ای.»*
  - *«جوایز لیدربوردها کماکان بر حسب امتیاز (Points) پرداخت می‌شوند (نه توکن).»*
  - *«رنگ‌بندی توکن‌ها: توکن پلتفرم = طلایی (`Amber/400`) · توکن‌های بازی‌ها = بنفش (`Purple/400`).»*

- **وضعیت‌های لیدربورد به دستور ادمین (Board States set by Admin)**:
  - **فعال (Active)**: حالت نرمال و استاندارد، طبق برنامه زمان‌بندی پیش می‌رود.
  - **غیرفعال / خاموش (Turned off / deactivated)**: از تمام لیست‌ها مخفی است؛ پیوندهای قدیمی فریم `L12` را باز می‌کنند.
  - **معلق / متوقف (Paused)**: در لیست‌ها نمایش داده می‌شود، اما امتیازات جدید محاسبه نشده و تایمر منجمد می‌شود (`L10`).
  - **لغو شده (Cancelled)**: برای همیشه متوقف شده و هیچ جایزه‌ای تعلق نمی‌گیرد (`L13`).

- **وضعیت‌های زمان‌بندی بردهای فعال (Schedule States)**:
  - چرخه حیات: **شروع‌نشده (Not started) → زنده (Live) → در حال محاسبه (Calculating) → پایان‌یافته (Finished)**.
  - لیدربورد کلی: `L01` (زنده) → `L02` (در حال محاسبه) → `L03` (مطالبه جایزه).
  - لیدربورد بازی‌ها: `L09` (شروع‌نشده) → `L08` (زنده) → مشابه `L02` (محاسبه) → `L11` (مطالبه و پایان).
  - دوره‌های لیدربورد کلی: این هفته (`L01`) · این ماه (`L20`) · تمام دوران (`L05`).
  - تب بازی‌ها با فیلتر "برای شما" (For you) باز می‌شود که ترکیبی از بازی‌های بازی‌شده و پیشنهادی است (`L07`).

- **حالات وضعیت کاربر و بازیکن (Player States)**:
  - وضعیت بازیکن: رتبه‌بندی‌نشده (`L06`) · رتبه‌بندی‌شده · در محدوده دریافت جایزه · تحت بازبینی تخلف (`L17`) · حذف‌شده از برد.
  - وضعیت جایزه: قابل مطالبه (`L03` و `L11`) · مطالبه‌شده (`L04`) · منقضی‌شده (`L18`).

- **مقادیر فرضی برای تکمیل چیدمان (Made up to fill layout)**:
  - نام بازیکنان و تمامی امتیازات به صورت فرضی درج شده‌اند.
  - جوایز کاپ‌های بازی: رتبه ۱ تا ۱۰ (+۱,۵۰۰ امتیاز)، رتبه ۱ تا ۵۰ (+۵۰۰ امتیاز)، رتبه ۱ تا ۲۰۰ (+۱۰۰ امتیاز).
  - مهلت مطالبه جوایز (Claim Window): ۷ روز تقویمی است. توقف موقت برد (Pause) موعد پایان را به همان میزان به جلو می‌برد.

### ۲.۲. سوالات و ابهامات باز ثبت‌شده توسط دیزاینر (Waiting on Answers)

دیزاینر رسماً ۷ سوال کلیدی را برای تیم محصول و مهندسی مطرح کرده که نیازمند تصمیم‌گیری رسمی (ثبت در `decisions.md`) است:
1. **وضعیت‌های Calculating، Paused و Cancelled**: آیا تمام این سه وضعیت واقعاً باید پیاده‌سازی و پشتیبانی شوند؟
2. **شیوه اعطای جایزه**: آیا مطالبه دستی توسط دکمه "Claim" الزامی است یا جوایز باید مستقیماً و خودکار به کیف پول اضافه شوند؟
3. **بازه‌های زمانی لیدربورد کلی**: آیا فقط هفتگی و تمام دوران کافی است، یا دوره‌های روزانه و ماهانه نیز باید فعال باشند؟
4. **ورود به لیدربورد بازی‌ها**: آیا ورود به کاپ‌ها کاملاً خودکار و با انجام بازی است، یا نیازمند پرداخت ورودی (Entry Fee) و ثبت‌نام در رویدادها است؟
5. **مصرف توکن‌ها**: آیا توکن‌ها صرفاً شاخص امتیاز و رتبه‌بندی هستند، یا کاربر می‌تواند آن‌ها را مانند ارز در فروشگاه خرج کند؟
6. **همپوشانی توکن‌ها**: آیا کسب توکن بازی‌ها باعث افزایش توکن پلتفرم در لیدربورد کلی نیز می‌شود؟
7. **نمایش موجودی توکن**: آیا باید موجودی توکن در نوار بالای اپلیکیشن (کنار Points و Coins) نمایش داده شود؟

### ۲.۳. تناقضات و باگ‌های فیگما (Figma Errata)

1. **ناوبری منو (L22 vs Notes)**:
   - در کپشن فریم `L22` دیزاینر نوشته است: *«Menu icon (☰) at the top right of every screen»*.
   - اما در یادداشت‌های `1:6431` (تاریخ ۲۷ اکتبر) تصریح کرده است: *«لیدربورد با تپ روی آواتار باز می‌شود و هیچ آیکون همبرگری وجود ندارد؛ Social جای لیدربورد در Bottom Nav را گرفته است.»*
   - **تصمیم مهندسی**: یادداشت جدیدتر (۲۷ اکتبر) ملاک است؛ ورود از طریق تپ روی آواتار صورت می‌گیرد.
2. **رنگ آیکون توکن در فریم‌ها**:
   - در یادداشت‌ها آمده است که توکن بازی‌ها بنفش است، اما در فریم‌های وایرفریم L08 و L10 و L11 همچنان از کامپوننت مشترک با رنگ زرد/خاکستری وایرفریم استفاده شده است. در مرحله High-Fidelity باید توکن‌های پلتفرم زرد (`Amber/400`) و توکن‌های بازی بنفش (`Purple/400`) رنگ‌آمیزی شوند.

---

## ۳. استخراج فریم به فریم المان‌ها (Frame-by-Frame Inventory)

### L01 — L01 · Leaderboard · Overall · this week (live) (Expand)
- **Node ID**: `1:4339`
- **لینک مستقیم فیگما**: [L01 · Leaderboard · Overall · this week (live) (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4339)
- **ابعاد**: 402 × 1297 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L01 · Overall · this week (live)  
  > **Opened by**:  
  > • Leaderboard in the nav bar (opens here)  
  > **Buttons on this screen**:  
  > • Avatar  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L18  
  > • This month chip  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L18  
  > • Past results  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L18  
  > • Games tab  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L07  
  > • Claim (results banner)  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L03  
  > • All time chip  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L05  
  > • Rules  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L14  
  > • Any player row or podium  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L15  
  > • Earn Tokens  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L18  
  > **State rule**:  
  > • Live from Mon 00:00 to Sun 23:59. Mon–Tu  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:4341`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4341)
  - `[Instance]` **App Bar Container** (`1:4343`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4343)
  - `[Pattern]` **Page Title** (`1:4345`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4345)
  - `[Pattern]` **Text Button / Past results** (`1:4347`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4347)
  - `[Pattern]` **Segmented Tabs** (`1:4350`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4350)
  - `[Pattern]` **Tab / Overall (selected)** (`1:4351`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4351)
  - `[Pattern]` **Tab / Games** (`1:4354`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4354)
  - `[Pattern]` **Banner / Week 41 results are out** (`1:4357`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4357)
  - `[Instance]` **Fill / Trophy** (`1:4358`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4358)
  - `[Instance]` **Button / Claim** (`1:4362`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4362)
  - `[Pattern]` **Filter Chips** (`1:4363`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4363)
  - `[Pattern]` **Chip / This week** (`1:4364`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4364)
  - `[Pattern]` **Chip / This month** (`1:4366`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4366)
  - `[Pattern]` **Chip / All time** (`1:4368`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4368)
  - `[Pattern]` **Period Card** (`1:4370`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4370)
  - `[Pattern]` **Badge / Live** (`1:4376`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4376)
  - `[Pattern]` **Reward Tiers** (`1:4379`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4379)
  - `[Pattern]` **Tier / Top 10** (`1:4380`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4380)
  - `[Pattern]` **Tier / Top 100** (`1:4383`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4383)
  - `[Pattern]` **Tier / Top 500** (`1:4386`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4386)
  - `[Pattern]` **Score rule** (`1:4389`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4389)
  - `[Pattern]` **Podium · Top 3** (`1:4398`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4398)
  - `[Pattern]` **Place 2 / Reza M.** (`1:4399`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4399)
  - `[Pattern]` **Place 1 / Sara K.** (`1:4408`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4408)
  - `[Pattern]` **Place 3 / Mina T.** (`1:4418`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4418)
  - `[Pattern]` **Rank Row / #4 Omid R.** (`1:4427`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4427)
  - `[Pattern]` **Rank** (`1:4428`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4428)
  - `[Pattern]` **Score** (`1:4434`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4434)
  - `[Pattern]` **Rank Row / #5 Neda H.** (`1:4438`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4438)
  - `[Pattern]` **Rank** (`1:4439`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4439)
  - `[Pattern]` **Score** (`1:4445`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4445)
  - `[Pattern]` **Rank Row / #6 Kian P.** (`1:4449`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4449)
  - `[Pattern]` **Rank** (`1:4450`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4450)
  - `[Pattern]` **Score** (`1:4456`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4456)
  - `[Pattern]` **Rank Row / #7 Hamid J.** (`1:4460`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4460)
  - `[Pattern]` **Rank** (`1:4461`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4461)
  - `[Pattern]` **Score** (`1:4467`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4467)
  - `[Pattern]` **Your Rank** (`1:4472`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4472)
  - `[Pattern]` **Row** (`1:4473`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4473)
  - `[Pattern]` **Labels** (`1:4485`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4485)
  - `[Pattern]` **Track** (`1:4488`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4488)
  - `[Instance]` **Navigator Bar Container** (`1:4491`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4491)

### L02 — L02 · Overall · week results, calculating (Expand)
- **Node ID**: `1:4494`
- **لینک مستقیم فیگما**: [L02 · Overall · week results, calculating (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4494)
- **ابعاد**: 402 × 977 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L02 · Week results · calculating  
  > **Opened by**:  
  > • The &quot;results on Tue&quot; banner on L01 (Mon–  
  > **Buttons on this screen**:  
  > • Any player row or podium  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L15  
  > • Back arrow  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  previous screen  
  > **State rule**:  
  > • Provisional ranks while the top 20 are c  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:4496`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4496)
  - `[Instance]` **App Bar Container** (`1:4498`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4498)
  - `[Pattern]` **Page Title** (`1:4500`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4500)
  - `[Pattern]` **Banner / Checking the final scores** (`1:4502`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4502)
  - `[Instance]` **Fill / Timer** (`1:4503`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4503)
  - `[Pattern]` **Period Card** (`1:4507`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4507)
  - `[Pattern]` **Badge / Calculating** (`1:4513`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4513)
  - `[Pattern]` **Podium · Top 3** (`1:4515`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4515)
  - `[Pattern]` **Place 2 / Reza M.** (`1:4516`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4516)
  - `[Pattern]` **Place 1 / Sara K.** (`1:4525`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4525)
  - `[Pattern]` **Place 3 / Mina T.** (`1:4535`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4535)
  - `[Pattern]` **Rank Row / #4 Omid R.** (`1:4544`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4544)
  - `[Pattern]` **Rank** (`1:4545`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4545)
  - `[Pattern]` **Score** (`1:4551`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4551)
  - `[Pattern]` **Rank Row / #5 Neda H.** (`1:4555`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4555)
  - `[Pattern]` **Rank** (`1:4556`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4556)
  - `[Pattern]` **Score** (`1:4562`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4562)
  - `[Pattern]` **Your Rank** (`1:4567`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4567)
  - `[Pattern]` **Row** (`1:4568`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4568)
  - `[Pattern]` **Labels** (`1:4580`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4580)
  - `[Instance]` **Navigator Bar Container** (`1:4584`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4584)

### L03 — L03 · Overall · week results, claim reward (Expand)
- **Node ID**: `1:4587`
- **لینک مستقیم فیگما**: [L03 · Overall · week results, claim reward (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4587)
- **ابعاد**: 402 × 1021 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L03 · Week results · claim reward  
  > **Opened by**:  
  > • Claim on the L01 results banner · Overal  
  > **Buttons on this screen**:  
  > • Claim 1,000 Points  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L04  
  > • Full ranking  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  that week’s full list (read-only)  
  > • Back arrow  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  previous screen  
  > **State rule**:  
  > • After claiming, the button turns into &quot;C  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:4589`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4589)
  - `[Instance]` **App Bar Container** (`1:4591`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4591)
  - `[Pattern]` **Page Title** (`1:4593`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4593)
  - `[Pattern]` **Result Card** (`1:4596`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4596)
  - `[Pattern]` **Reward** (`1:4602`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4602)
  - `[Instance]` **Button / Claim 1,000 Points** (`1:4605`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4605)
  - `[Pattern]` **Section Header** (`1:4607`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4607)
  - `[Pattern]` **Row** (`1:4608`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4608)
  - `[Pattern]` **Podium · Top 3** (`1:4613`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4613)
  - `[Pattern]` **Place 2 / Omid R.** (`1:4614`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4614)
  - `[Pattern]` **Place 1 / Sara K.** (`1:4623`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4623)
  - `[Pattern]` **Place 3 / Reza M.** (`1:4633`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4633)
  - `[Pattern]` **Rank Row / #87 You** (`1:4642`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4642)
  - `[Pattern]` **Rank** (`1:4643`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4643)
  - `[Pattern]` **Score** (`1:4649`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4649)
  - `[Instance]` **Navigator Bar Container** (`1:4656`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4656)

### L04 — L04 · Reward claimed · success
- **Node ID**: `1:4659`
- **لینک مستقیم فیگما**: [L04 · Reward claimed · success](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4659)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L04 · Reward claimed · success  
  > **Opened by**:  
  > • Claim on L03 or L11  
  > **Buttons on this screen**:  
  > • Spend Points in Shop  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  P02 (Shop · Rewards)  
  > • Back to Leaderboard  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L01  
  > **State rule**:  
  > • If adding Points fails, show an error wi  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:4661`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4661)
  - `[Instance]` **App Bar Container** (`1:4663`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4663)
  - `[Pattern]` **Success Icon** (`1:4665`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4665)
  - `[Instance]` **Fill / Check** (`1:4666`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4666)
  - `[Pattern]` **Balance Card** (`1:4669`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4669)
  - `[Pattern]` **Spacer** (`1:4672`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4672)
  - `[Instance]` **Button / Spend Points in Shop** (`1:4673`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4673)
  - `[Instance]` **Button / Back to Leaderboard** (`1:4674`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4674)
  - `[Instance]` **Navigator Bar Container** (`1:4676`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4676)

### L05 — L05 · Overall · all time (Expand)
- **Node ID**: `1:4679`
- **لینک مستقیم فیگما**: [L05 · Overall · all time (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4679)
- **ابعاد**: 402 × 1011 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L05 · Overall · all time  
  > **Opened by**:  
  > • All time chip on L01 or L06  
  > **Buttons on this screen**:  
  > • This month chip  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L01  
  > • This week chip  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L01  
  > • Games tab  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L07  
  > • Past results  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L18  
  > • Any player row or podium  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L15  
  > **State rule**:  
  > • No countdown, no rewards, never resets.  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:4681`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4681)
  - `[Instance]` **App Bar Container** (`1:4683`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4683)
  - `[Pattern]` **Page Title** (`1:4685`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4685)
  - `[Pattern]` **Text Button / Past results** (`1:4687`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4687)
  - `[Pattern]` **Segmented Tabs** (`1:4690`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4690)
  - `[Pattern]` **Tab / Overall (selected)** (`1:4691`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4691)
  - `[Pattern]` **Tab / Games** (`1:4694`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4694)
  - `[Pattern]` **Filter Chips** (`1:4697`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4697)
  - `[Pattern]` **Chip / This week** (`1:4698`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4698)
  - `[Pattern]` **Chip / This month** (`1:4700`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4700)
  - `[Pattern]` **Chip / All time** (`1:4702`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4702)
  - `[Pattern]` **Banner / All-time ranking has no rewards** (`1:4704`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4704)
  - `[Instance]` **Outline / Help** (`1:4705`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4705)
  - `[Pattern]` **Podium · Top 3** (`1:4709`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4709)
  - `[Pattern]` **Place 2 / Reza M.** (`1:4710`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4710)
  - `[Pattern]` **Place 1 / Sara K.** (`1:4719`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4719)
  - `[Pattern]` **Place 3 / Omid R.** (`1:4729`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4729)
  - `[Pattern]` **Rank Row / #4 Mina T.** (`1:4738`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4738)
  - `[Pattern]` **Rank** (`1:4739`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4739)
  - `[Pattern]` **Score** (`1:4745`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4745)
  - `[Pattern]` **Rank Row / #5 Neda H.** (`1:4749`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4749)
  - `[Pattern]` **Rank** (`1:4750`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4750)
  - `[Pattern]` **Score** (`1:4756`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4756)
  - `[Pattern]` **Rank Row / #6 Kian P.** (`1:4760`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4760)
  - `[Pattern]` **Rank** (`1:4761`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4761)
  - `[Pattern]` **Score** (`1:4767`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4767)
  - `[Pattern]` **Your Rank** (`1:4772`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4772)
  - `[Pattern]` **Row** (`1:4773`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4773)
  - `[Instance]` **Navigator Bar Container** (`1:4786`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4786)

### L06 — L06 · Overall · you are not ranked yet (Expand)
- **Node ID**: `1:4789`
- **لینک مستقیم فیگما**: [L06 · Overall · you are not ranked yet (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4789)
- **ابعاد**: 402 × 1141 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L06 · Overall · you’re not ranked yet  
  > **Opened by**:  
  > • L01 when you have 0 Points this week  
  > **Buttons on this screen**:  
  > • This month chip  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  Missions tab  
  > • Go to Missions  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  Missions tab  
  > • Games tab  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L07  
  > • All time chip  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L05  
  > • Any player row or podium  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L15  
  > • How to earn Tokens  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  Missions tab  
  > **State rule**:  
  > • As soon as you earn Points, this card be  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:4791`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4791)
  - `[Instance]` **App Bar Container** (`1:4793`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4793)
  - `[Pattern]` **Page Title** (`1:4795`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4795)
  - `[Pattern]` **Text Button / Past results** (`1:4797`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4797)
  - `[Pattern]` **Segmented Tabs** (`1:4800`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4800)
  - `[Pattern]` **Tab / Overall (selected)** (`1:4801`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4801)
  - `[Pattern]` **Tab / Games** (`1:4804`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4804)
  - `[Pattern]` **Filter Chips** (`1:4807`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4807)
  - `[Pattern]` **Chip / This week** (`1:4808`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4808)
  - `[Pattern]` **Chip / This month** (`1:4810`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4810)
  - `[Pattern]` **Chip / All time** (`1:4812`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4812)
  - `[Pattern]` **Period Card** (`1:4814`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4814)
  - `[Pattern]` **Badge / Live** (`1:4820`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4820)
  - `[Pattern]` **Reward Tiers** (`1:4823`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4823)
  - `[Pattern]` **Tier / Top 10** (`1:4824`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4824)
  - `[Pattern]` **Tier / Top 100** (`1:4827`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4827)
  - `[Pattern]` **Tier / Top 500** (`1:4830`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4830)
  - `[Pattern]` **Podium · Top 3** (`1:4833`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4833)
  - `[Pattern]` **Place 2 / Kian P.** (`1:4834`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4834)
  - `[Pattern]` **Place 1 / Neda H.** (`1:4843`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4843)
  - `[Pattern]` **Place 3 / Sara K.** (`1:4853`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4853)
  - `[Pattern]` **Rank Row / #4 Omid R.** (`1:4862`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4862)
  - `[Pattern]` **Rank** (`1:4863`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4863)
  - `[Pattern]` **Score** (`1:4869`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4869)
  - `[Pattern]` **Rank Row / #5 Hamid J.** (`1:4873`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4873)
  - `[Pattern]` **Rank** (`1:4874`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4874)
  - `[Pattern]` **Score** (`1:4880`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4880)
  - `[Pattern]` **Your Rank · not ranked** (`1:4884`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4884)
  - `[Instance]` **Button / Go to Missions** (`1:4889`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4889)
  - `[Pattern]` **Text Button / How to earn Tokens** (`1:4890`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4890)
  - `[Instance]` **Navigator Bar Container** (`1:4894`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4894)

### L07 — L07 · Games tab · For you (default) (Expand)
- **Node ID**: `1:4900`
- **لینک مستقیم فیگما**: [L07 · Games tab · For you (default) (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4900)
- **ابعاد**: 402 × 1089 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L07 · Games tab · For you (default)  
  > **Opened by**:  
  > • Games tab on L01, L05, L06 or L20 (alway  
  > **Buttons on this screen**:  
  > • Overall tab  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L01  
  > • For you chip  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  this list (default)  
  > • All, Live, Starts soon, Finished chips  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L21 (filtered)  
  > • Your games: live card  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L08  
  > • Your games: claim card  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L11  
  > • Your games: paused card  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L10  
  > • Suggested: Play  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  opens the game  
  > • Suggested: Remind me  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  turns on a reminder (L09 rules)  
  > • Suggested card (tap elsewhere)  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  that board (L08 or L09)  
  > • Past results  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L18  
  > **State rule**:  
  > • Your games = boards where you have that  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:4902`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4902)
  - `[Instance]` **App Bar Container** (`1:4904`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4904)
  - `[Pattern]` **Page Title** (`1:4906`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4906)
  - `[Pattern]` **Text Button / Past results** (`1:4908`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4908)
  - `[Pattern]` **Segmented Tabs** (`1:4911`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4911)
  - `[Pattern]` **Tab / Overall** (`1:4912`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4912)
  - `[Pattern]` **Tab / Games (selected)** (`1:4915`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4915)
  - `[Pattern]` **Filter Chips** (`1:4918`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4918)
  - `[Pattern]` **Chip / For you** (`1:4919`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4919)
  - `[Pattern]` **Chip / All** (`1:4921`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4921)
  - `[Pattern]` **Chip / Live** (`1:4923`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4923)
  - `[Pattern]` **Chip / Starts soon** (`1:4925`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4925)
  - `[Pattern]` **Chip / Finished** (`1:4927`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4927)
  - `[Pattern]` **Section Header** (`1:4929`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4929)
  - `[Pattern]` **Game Board Card / Block Blast** (`1:4932`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4932)
  - `[Pattern]` **Game Tile** (`1:4933`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4933)
  - `[Pattern]` **Game Board Card / Bubble Pop** (`1:4946`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4946)
  - `[Pattern]` **Game Tile** (`1:4947`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4947)
  - `[Pattern]` **Game Board Card / Snake Rush** (`1:4959`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4959)
  - `[Pattern]` **Game Tile** (`1:4960`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4960)
  - `[Pattern]` **Section Header** (`1:4972`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4972)
  - `[Pattern]` **Game Board Card / Tower Stack** (`1:4975`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4975)
  - `[Pattern]` **Game Tile** (`1:4976`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4976)
  - `[Instance]` **Button / Play** (`1:4984`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4984)
  - `[Pattern]` **Game Board Card / Knife Hit Cup** (`1:4985`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4985)
  - `[Pattern]` **Game Tile** (`1:4986`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4986)
  - `[Instance]` **Button / Remind me** (`1:4993`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4993)
  - `[Pattern]` **Game Board Card / Jelly Jump** (`1:4994`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4994)
  - `[Pattern]` **Game Tile** (`1:4995`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-4995)
  - `[Instance]` **Button / Play** (`1:5003`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5003)
  - `[Instance]` **Navigator Bar Container** (`1:5005`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5005)

### L08 — L08 · Game board · live (Expand)
- **Node ID**: `1:5008`
- **لینک مستقیم فیگما**: [L08 · Game board · live (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5008)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L08 · Game board · live  
  > **Opened by**:  
  > • Live card on L07 · leaderboard card on t  
  > **Buttons on this screen**:  
  > • Play Block Blast  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  opens the game  
  > • Rules  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L14 (game version)  
  > • Any player row or podium  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L15  
  > • Back arrow  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  previous screen  
  > **State rule**:  
  > • Score = best single game in the cup, che  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:5010`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5010)
  - `[Instance]` **App Bar Container** (`1:5012`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5012)
  - `[Pattern]` **Cup Bar** (`1:5014`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5014)
  - `[Pattern]` **Badge / Live** (`1:5016`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5016)
  - `[Pattern]` **Reward Tiers** (`1:5019`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5019)
  - `[Pattern]` **Tier / Top 10** (`1:5020`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5020)
  - `[Pattern]` **Tier / Top 50** (`1:5023`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5023)
  - `[Pattern]` **Tier / Top 200** (`1:5026`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5026)
  - `[Pattern]` **Score rule** (`1:5029`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5029)
  - `[Pattern]` **Text Button / Rules** (`1:5031`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5031)
  - `[Pattern]` **Podium · Top 3** (`1:5034`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5034)
  - `[Pattern]` **Place 2 / Sara K.** (`1:5035`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5035)
  - `[Pattern]` **Place 1 / Kian P.** (`1:5044`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5044)
  - `[Pattern]` **Place 3 / Omid R.** (`1:5054`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5054)
  - `[Pattern]` **Rank Row / #4 Neda H.** (`1:5063`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5063)
  - `[Pattern]` **Rank** (`1:5064`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5064)
  - `[Pattern]` **Score** (`1:5070`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5070)
  - `[Pattern]` **Rank Row / #5 Reza M.** (`1:5074`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5074)
  - `[Pattern]` **Rank** (`1:5075`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5075)
  - `[Pattern]` **Score** (`1:5081`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5081)
  - `[Pattern]` **Your Rank** (`1:5086`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5086)
  - `[Pattern]` **Row** (`1:5087`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5087)
  - `[Pattern]` **Labels** (`1:5099`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5099)
  - `[Pattern]` **Track** (`1:5102`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5102)
  - `[Instance]` **Button / Play Block Blast** (`1:5104`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5104)
  - `[Instance]` **Navigator Bar Container** (`1:5106`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5106)

### L09 — L09 · Game board · not started yet (Expand)
- **Node ID**: `1:5109`
- **لینک مستقیم فیگما**: [L09 · Game board · not started yet (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5109)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L09 · Game board · not started yet  
  > **Opened by**:  
  > • Starts soon card on L07 · game page  
  > **Buttons on this screen**:  
  > • Remind me when it starts  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  turns on a reminder (button says &quot;Rem  
  > • Practice now (not counted)  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  opens the game  
  > • Rules  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L14 (game version)  
  > **State rule**:  
  > • At start time it becomes Live (L08).  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:5111`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5111)
  - `[Instance]` **App Bar Container** (`1:5113`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5113)
  - `[Pattern]` **Cup Bar** (`1:5115`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5115)
  - `[Pattern]` **Badge / Tokents in 1d 03h** (`1:5117`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5117)
  - `[Pattern]` **Reward Tiers** (`1:5119`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5119)
  - `[Pattern]` **Tier / Top 10** (`1:5120`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5120)
  - `[Pattern]` **Tier / Top 50** (`1:5123`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5123)
  - `[Pattern]` **Tier / Top 200** (`1:5126`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5126)
  - `[Pattern]` **Score rule** (`1:5129`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5129)
  - `[Pattern]` **Text Button / Rules** (`1:5131`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5131)
  - `[Pattern]` **Empty Board** (`1:5134`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5134)
  - `[Instance]` **Button / Remind me when it starts** (`1:5139`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5139)
  - `[Instance]` **Button / Practice now (not counted)** (`1:5140`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5140)
  - `[Instance]` **Navigator Bar Container** (`1:5142`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5142)

### L10 — L10 · Game board · paused (Expand)
- **Node ID**: `1:5145`
- **لینک مستقیم فیگما**: [L10 · Game board · paused (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5145)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L10 · Game board · paused  
  > **Opened by**:  
  > • Paused card on L07 · game page  
  > **Buttons on this screen**:  
  > • Play (not counted)  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  opens the game  
  > • Back arrow  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  previous screen  
  > **State rule**:  
  > • An admin pauses and resumes it. Time lef  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:5147`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5147)
  - `[Instance]` **App Bar Container** (`1:5149`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5149)
  - `[Pattern]` **Cup Bar** (`1:5151`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5151)
  - `[Pattern]` **Badge / Paused** (`1:5153`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5153)
  - `[Pattern]` **Banner / This leaderboard is paused** (`1:5155`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5155)
  - `[Instance]` **Fill / Pause Circle** (`1:5156`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5156)
  - `[Pattern]` **Reward Tiers** (`1:5160`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5160)
  - `[Pattern]` **Tier / Top 10** (`1:5161`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5161)
  - `[Pattern]` **Tier / Top 50** (`1:5164`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5164)
  - `[Pattern]` **Tier / Top 200** (`1:5167`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5167)
  - `[Pattern]` **Podium · Top 3** (`1:5170`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5170)
  - `[Pattern]` **Place 2 / Hamid J.** (`1:5171`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5171)
  - `[Pattern]` **Place 1 / Mina T.** (`1:5180`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5180)
  - `[Pattern]` **Place 3 / Neda H.** (`1:5190`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5190)
  - `[Pattern]` **Rank Row / #4 Reza M.** (`1:5199`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5199)
  - `[Pattern]` **Rank** (`1:5200`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5200)
  - `[Pattern]` **Score** (`1:5206`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5206)
  - `[Pattern]` **Rank Row / #5 Kian P.** (`1:5210`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5210)
  - `[Pattern]` **Rank** (`1:5211`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5211)
  - `[Pattern]` **Score** (`1:5217`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5217)
  - `[Pattern]` **Your Rank** (`1:5222`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5222)
  - `[Pattern]` **Row** (`1:5223`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5223)
  - `[Instance]` **Button / Play (not counted)** (`1:5235`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5235)
  - `[Instance]` **Navigator Bar Container** (`1:5237`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5237)

### L11 — L11 · Game board · finished, results published (Expand)
- **Node ID**: `1:5240`
- **لینک مستقیم فیگما**: [L11 · Game board · finished, results published (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5240)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L11 · Game board · finished  
  > **Opened by**:  
  > • Claim or Finished card on L07 · Past res  
  > **Buttons on this screen**:  
  > • Claim 1,500 Points  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L04  
  > • Remind me (next cup)  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  turns on a reminder  
  > • Any player row or podium  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L15  
  > **State rule**:  
  > • Outside the reward tiers the result card  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:5242`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5242)
  - `[Instance]` **App Bar Container** (`1:5244`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5244)
  - `[Pattern]` **Cup Bar** (`1:5246`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5246)
  - `[Pattern]` **Badge / Finished** (`1:5248`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5248)
  - `[Pattern]` **Result Card** (`1:5250`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5250)
  - `[Pattern]` **Row** (`1:5251`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5251)
  - `[Instance]` **Button / Claim 1,500 Points** (`1:5258`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5258)
  - `[Pattern]` **Section Header** (`1:5260`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5260)
  - `[Pattern]` **Row** (`1:5261`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5261)
  - `[Pattern]` **Podium · Top 3** (`1:5263`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5263)
  - `[Pattern]` **Place 2 / Mina T.** (`1:5264`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5264)
  - `[Pattern]` **Place 1 / Omid R.** (`1:5273`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5273)
  - `[Pattern]` **Place 3 / Sara K.** (`1:5283`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5283)
  - `[Pattern]` **Rank Row / #4 Kian P.** (`1:5292`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5292)
  - `[Pattern]` **Rank** (`1:5293`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5293)
  - `[Pattern]` **Score** (`1:5299`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5299)
  - `[Pattern]` **Rank Row / #5 You** (`1:5303`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5303)
  - `[Pattern]` **Rank** (`1:5304`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5304)
  - `[Pattern]` **Score** (`1:5310`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5310)
  - `[Pattern]` **Next Cup** (`1:5314`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5314)
  - `[Instance]` **Button / Remind me** (`1:5320`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5320)
  - `[Instance]` **Navigator Bar Container** (`1:5322`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5322)

### L12 — L12 · Game board · turned off (deactivated)
- **Node ID**: `1:5325`
- **لینک مستقیم فیگما**: [L12 · Game board · turned off (deactivated)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5325)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L12 · Game board · turned off  
  > **Opened by**:  
  > • An old link after an admin turned the bo  
  > **Buttons on this screen**:  
  > • Play Color Match  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  opens the game  
  > • See live leaderboards  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L07  
  > **State rule**:  
  > • Turned off (deactivated) = hidden everyw  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:5327`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5327)
  - `[Instance]` **App Bar Container** (`1:5329`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5329)
  - `[Instance]` **Fill / Visibility Off** (`1:5332`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5332)
  - `[Pattern]` **Badge / Turned off** (`1:5335`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5335)
  - `[Pattern]` **Spacer** (`1:5337`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5337)
  - `[Instance]` **Button / Play Color Match** (`1:5338`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5338)
  - `[Instance]` **Button / See live leaderboards** (`1:5339`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5339)
  - `[Instance]` **Navigator Bar Container** (`1:5341`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5341)

### L13 — L13 · Game board · cancelled (Expand)
- **Node ID**: `1:5344`
- **لینک مستقیم فیگما**: [L13 · Game board · cancelled (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5344)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L13 · Game board · cancelled  
  > **Opened by**:  
  > • Past results (L18) · cancellation notifi  
  > **Buttons on this screen**:  
  > • See live leaderboards  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L07  
  > • Contact support  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  P12 (new ticket)  
  > **State rule**:  
  > • Cancelled = stopped for good, no rewards  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:5346`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5346)
  - `[Instance]` **App Bar Container** (`1:5348`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5348)
  - `[Pattern]` **Cup Bar** (`1:5350`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5350)
  - `[Pattern]` **Badge / Cancelled** (`1:5352`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5352)
  - `[Pattern]` **Banner / This cup was cancelled** (`1:5354`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5354)
  - `[Instance]` **Fill / Warning** (`1:5355`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5355)
  - `[Pattern]` **Section Header** (`1:5359`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5359)
  - `[Pattern]` **Row** (`1:5360`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5360)
  - `[Pattern]` **Podium · Top 3** (`1:5362`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5362)
  - `[Pattern]` **Place 2 / Reza M.** (`1:5363`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5363)
  - `[Pattern]` **Place 1 / Neda H.** (`1:5372`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5372)
  - `[Pattern]` **Place 3 / Hamid J.** (`1:5382`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5382)
  - `[Pattern]` **Rank Row / #4 Sara K.** (`1:5391`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5391)
  - `[Pattern]` **Rank** (`1:5392`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5392)
  - `[Pattern]` **Score** (`1:5398`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5398)
  - `[Pattern]` **Rank Row / #31 You** (`1:5402`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5402)
  - `[Pattern]` **Rank** (`1:5403`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5403)
  - `[Pattern]` **Score** (`1:5409`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5409)
  - `[Instance]` **Button / See live leaderboards** (`1:5415`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5415)
  - `[Pattern]` **Support Row** (`1:5416`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5416)
  - `[Pattern]` **Text Button / Questions? Contact support** (`1:5417`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5417)
  - `[Instance]` **Navigator Bar Container** (`1:5421`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5421)

### L14 — L14 · Rules &amp; rewards · bottom sheet
- **Node ID**: `1:5427`
- **لینک مستقیم فیگما**: [L14 · Rules &amp; rewards · bottom sheet](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5427)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L14 · Rules &amp; rewards · bottom sheet  
  > **Opened by**:  
  > • Rules on L01 or L08 (a game shows its ow  
  > **Buttons on this screen**:  
  > • Got it / X / swipe down  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  close  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:5429`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5429)
  - `[Instance]` **App Bar Container** (`1:5431`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5431)
  - `[Pattern]` **Page Title** (`1:5433`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5433)
  - `[Pattern]` **Text Button / Past results** (`1:5435`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5435)
  - `[Pattern]` **Segmented Tabs** (`1:5438`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5438)
  - `[Pattern]` **Tab / Overall (selected)** (`1:5439`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5439)
  - `[Pattern]` **Tab / Games** (`1:5442`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5442)
  - `[Pattern]` **Banner / Week 41 results are out** (`1:5445`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5445)
  - `[Instance]` **Fill / Trophy** (`1:5446`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5446)
  - `[Instance]` **Button / Claim** (`1:5450`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5450)
  - `[Pattern]` **Filter Chips** (`1:5451`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5451)
  - `[Pattern]` **Chip / This week** (`1:5452`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5452)
  - `[Pattern]` **Chip / All time** (`1:5454`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5454)
  - `[Pattern]` **Period Card** (`1:5456`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5456)
  - `[Pattern]` **Badge / Live** (`1:5462`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5462)
  - `[Pattern]` **Reward Tiers** (`1:5465`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5465)
  - `[Pattern]` **Tier / Top 10** (`1:5466`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5466)
  - `[Pattern]` **Tier / Top 100** (`1:5469`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5469)
  - `[Pattern]` **Tier / Top 500** (`1:5472`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5472)
  - `[Pattern]` **Score rule** (`1:5475`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5475)
  - `[Pattern]` **Text Button / Rules** (`1:5477`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5477)
  - `[Pattern]` **Podium · Top 3** (`1:5480`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5480)
  - `[Pattern]` **Place 2 / Reza M.** (`1:5481`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5481)
  - `[Pattern]` **Place 1 / Sara K.** (`1:5490`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5490)
  - `[Pattern]` **Place 3 / Mina T.** (`1:5500`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5500)
  - `[Pattern]` **Rank Row / #4 Omid R.** (`1:5509`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5509)
  - `[Pattern]` **Rank** (`1:5510`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5510)
  - `[Pattern]` **Score** (`1:5516`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5516)
  - `[Pattern]` **Rank Row / #5 Neda H.** (`1:5520`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5520)
  - `[Pattern]` **Rank** (`1:5521`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5521)
  - `[Pattern]` **Score** (`1:5527`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5527)
  - `[Pattern]` **Rank Row / #6 Kian P.** (`1:5531`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5531)
  - `[Pattern]` **Rank** (`1:5532`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5532)
  - `[Pattern]` **Score** (`1:5538`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5538)
  - `[Pattern]` **Rank Row / #7 Hamid J.** (`1:5542`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5542)
  - `[Pattern]` **Rank** (`1:5543`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5543)
  - `[Pattern]` **Score** (`1:5549`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5549)
  - `[Pattern]` **Your Rank** (`1:5554`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5554)
  - `[Pattern]` **Row** (`1:5555`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5555)
  - `[Pattern]` **Labels** (`1:5567`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5567)
  - `[Pattern]` **Track** (`1:5570`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5570)
  - `[Instance]` **Navigator Bar Container** (`1:5573`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5573)
  - `[Pattern]` **Bottom Sheet** (`1:5577`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5577)
  - `[Pattern]` **Sheet Header** (`1:5579`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5579)
  - `[Instance]` **Outline / Help** (`1:5581`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5581)
  - `[Pattern]` **Title** (`1:5582`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5582)
  - `[Instance]` **Outline / Close** (`1:5585`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5585)
  - `[Pattern]` **Rules** (`1:5586`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5586)
  - `[Pattern]` **Rule / Your score** (`1:5587`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5587)
  - `[Pattern]` **Rule / Ties** (`1:5593`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5593)
  - `[Pattern]` **Rule / Rewards** (`1:5599`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5599)
  - `[Pattern]` **Rule / Results** (`1:5605`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5605)
  - `[Pattern]` **Rule / Fair play** (`1:5611`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5611)
  - `[Instance]` **Button / Got it** (`1:5617`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5617)

### L15 — L15 · Player summary · bottom sheet
- **Node ID**: `1:5618`
- **لینک مستقیم فیگما**: [L15 · Player summary · bottom sheet](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5618)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L15 · Player summary · bottom sheet  
  > **Opened by**:  
  > • Any player row or podium place on a boar  
  > **Buttons on this screen**:  
  > • Close / X  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  close  
  > • Report a problem with this rank  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L16  
  > **State rule**:  
  > • Your own row doesn’t open this sheet.  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:5620`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5620)
  - `[Instance]` **App Bar Container** (`1:5622`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5622)
  - `[Pattern]` **Page Title** (`1:5624`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5624)
  - `[Pattern]` **Text Button / Past results** (`1:5626`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5626)
  - `[Pattern]` **Segmented Tabs** (`1:5629`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5629)
  - `[Pattern]` **Tab / Overall (selected)** (`1:5630`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5630)
  - `[Pattern]` **Tab / Games** (`1:5633`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5633)
  - `[Pattern]` **Banner / Week 41 results are out** (`1:5636`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5636)
  - `[Instance]` **Fill / Trophy** (`1:5637`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5637)
  - `[Instance]` **Button / Claim** (`1:5641`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5641)
  - `[Pattern]` **Filter Chips** (`1:5642`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5642)
  - `[Pattern]` **Chip / This week** (`1:5643`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5643)
  - `[Pattern]` **Chip / All time** (`1:5645`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5645)
  - `[Pattern]` **Period Card** (`1:5647`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5647)
  - `[Pattern]` **Badge / Live** (`1:5653`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5653)
  - `[Pattern]` **Reward Tiers** (`1:5656`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5656)
  - `[Pattern]` **Tier / Top 10** (`1:5657`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5657)
  - `[Pattern]` **Tier / Top 100** (`1:5660`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5660)
  - `[Pattern]` **Tier / Top 500** (`1:5663`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5663)
  - `[Pattern]` **Score rule** (`1:5666`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5666)
  - `[Pattern]` **Text Button / Rules** (`1:5668`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5668)
  - `[Pattern]` **Podium · Top 3** (`1:5671`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5671)
  - `[Pattern]` **Place 2 / Reza M.** (`1:5672`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5672)
  - `[Pattern]` **Place 1 / Sara K.** (`1:5681`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5681)
  - `[Pattern]` **Place 3 / Mina T.** (`1:5691`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5691)
  - `[Pattern]` **Rank Row / #4 Omid R.** (`1:5700`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5700)
  - `[Pattern]` **Rank** (`1:5701`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5701)
  - `[Pattern]` **Score** (`1:5707`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5707)
  - `[Pattern]` **Rank Row / #5 Neda H.** (`1:5711`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5711)
  - `[Pattern]` **Rank** (`1:5712`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5712)
  - `[Pattern]` **Score** (`1:5718`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5718)
  - `[Pattern]` **Rank Row / #6 Kian P.** (`1:5722`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5722)
  - `[Pattern]` **Rank** (`1:5723`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5723)
  - `[Pattern]` **Score** (`1:5729`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5729)
  - `[Pattern]` **Rank Row / #7 Hamid J.** (`1:5733`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5733)
  - `[Pattern]` **Rank** (`1:5734`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5734)
  - `[Pattern]` **Score** (`1:5740`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5740)
  - `[Pattern]` **Your Rank** (`1:5745`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5745)
  - `[Pattern]` **Row** (`1:5746`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5746)
  - `[Pattern]` **Labels** (`1:5758`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5758)
  - `[Pattern]` **Track** (`1:5761`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5761)
  - `[Instance]` **Navigator Bar Container** (`1:5764`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5764)
  - `[Pattern]` **Bottom Sheet** (`1:5768`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5768)
  - `[Pattern]` **Close Row** (`1:5770`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5770)
  - `[Instance]` **Outline / Close** (`1:5771`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5771)
  - `[Pattern]` **Stats** (`1:5776`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5776)
  - `[Pattern]` **Stat / This week** (`1:5777`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5777)
  - `[Pattern]` **Stat / Points this week** (`1:5780`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5780)
  - `[Pattern]` **Stat / Weeks in Top 10** (`1:5783`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5783)
  - `[Pattern]` **Most played** (`1:5786`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5786)
  - `[Instance]` **Fill / Stadia Controller** (`1:5787`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5787)
  - `[Instance]` **Button / Close** (`1:5789`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5789)
  - `[Pattern]` **Report Row** (`1:5790`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5790)
  - `[Pattern]` **Text Button / Report a problem with this rank** (`1:5791`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5791)
  - `[Instance]` **Fill / Release Alert** (`1:5792`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5792)

### L16 — L16 · Report a rank problem · bottom sheet
- **Node ID**: `1:5794`
- **لینک مستقیم فیگما**: [L16 · Report a rank problem · bottom sheet](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5794)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L16 · Report a rank problem · bottom she  
  > **Opened by**:  
  > • Report a problem on L15  
  > **Buttons on this screen**:  
  > • Reason options  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  pick one (required)  
  > • Send report  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  closes, &quot;Report sent&quot; toast, ticket i  
  > • X  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  close  
  > **State rule**:  
  > • Send report stays disabled until a reaso  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:5796`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5796)
  - `[Instance]` **App Bar Container** (`1:5798`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5798)
  - `[Pattern]` **Page Title** (`1:5800`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5800)
  - `[Pattern]` **Text Button / Past results** (`1:5802`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5802)
  - `[Pattern]` **Segmented Tabs** (`1:5805`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5805)
  - `[Pattern]` **Tab / Overall (selected)** (`1:5806`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5806)
  - `[Pattern]` **Tab / Games** (`1:5809`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5809)
  - `[Pattern]` **Banner / Week 41 results are out** (`1:5812`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5812)
  - `[Instance]` **Fill / Trophy** (`1:5813`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5813)
  - `[Instance]` **Button / Claim** (`1:5817`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5817)
  - `[Pattern]` **Filter Chips** (`1:5818`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5818)
  - `[Pattern]` **Chip / This week** (`1:5819`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5819)
  - `[Pattern]` **Chip / All time** (`1:5821`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5821)
  - `[Pattern]` **Period Card** (`1:5823`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5823)
  - `[Pattern]` **Badge / Live** (`1:5829`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5829)
  - `[Pattern]` **Reward Tiers** (`1:5832`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5832)
  - `[Pattern]` **Tier / Top 10** (`1:5833`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5833)
  - `[Pattern]` **Tier / Top 100** (`1:5836`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5836)
  - `[Pattern]` **Tier / Top 500** (`1:5839`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5839)
  - `[Pattern]` **Score rule** (`1:5842`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5842)
  - `[Pattern]` **Text Button / Rules** (`1:5844`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5844)
  - `[Pattern]` **Podium · Top 3** (`1:5847`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5847)
  - `[Pattern]` **Place 2 / Reza M.** (`1:5848`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5848)
  - `[Pattern]` **Place 1 / Sara K.** (`1:5857`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5857)
  - `[Pattern]` **Place 3 / Mina T.** (`1:5867`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5867)
  - `[Pattern]` **Rank Row / #4 Omid R.** (`1:5876`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5876)
  - `[Pattern]` **Rank** (`1:5877`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5877)
  - `[Pattern]` **Score** (`1:5883`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5883)
  - `[Pattern]` **Rank Row / #5 Neda H.** (`1:5887`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5887)
  - `[Pattern]` **Rank** (`1:5888`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5888)
  - `[Pattern]` **Score** (`1:5894`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5894)
  - `[Pattern]` **Rank Row / #6 Kian P.** (`1:5898`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5898)
  - `[Pattern]` **Rank** (`1:5899`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5899)
  - `[Pattern]` **Score** (`1:5905`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5905)
  - `[Pattern]` **Rank Row / #7 Hamid J.** (`1:5909`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5909)
  - `[Pattern]` **Rank** (`1:5910`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5910)
  - `[Pattern]` **Score** (`1:5916`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5916)
  - `[Pattern]` **Your Rank** (`1:5921`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5921)
  - `[Pattern]` **Row** (`1:5922`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5922)
  - `[Pattern]` **Labels** (`1:5934`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5934)
  - `[Pattern]` **Track** (`1:5937`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5937)
  - `[Instance]` **Navigator Bar Container** (`1:5940`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5940)
  - `[Pattern]` **Bottom Sheet** (`1:5944`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5944)
  - `[Pattern]` **Sheet Header** (`1:5946`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5946)
  - `[Instance]` **Fill / Release Alert** (`1:5948`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5948)
  - `[Pattern]` **Title** (`1:5949`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5949)
  - `[Instance]` **Outline / Close** (`1:5952`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5952)
  - `[Pattern]` **Reasons** (`1:5953`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5953)
  - `[Pattern]` **Reason / This score looks impossible or like cheating** (`1:5954`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5954)
  - `[Pattern]` **Radio** (`1:5955`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5955)
  - `[Pattern]` **Reason / My score is missing or too low** (`1:5958`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5958)
  - `[Pattern]` **Radio** (`1:5959`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5959)
  - `[Pattern]` **Reason / My rank is wrong** (`1:5961`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5961)
  - `[Pattern]` **Radio** (`1:5962`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5962)
  - `[Pattern]` **Reason / Something else** (`1:5964`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5964)
  - `[Pattern]` **Radio** (`1:5965`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5965)
  - `[Pattern]` **Text Field** (`1:5967`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5967)
  - `[Instance]` **Button / Send report** (`1:5970`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5970)

### L17 — L17 · Game board · your score under review (Expand)
- **Node ID**: `1:5971`
- **لینک مستقیم فیگما**: [L17 · Game board · your score under review (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5971)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L17 · Game board · your score under revi  
  > **Opened by**:  
  > • L08 when your best score is flagged · no  
  > **Buttons on this screen**:  
  > • Play Block Blast  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  opens the game  
  > • Contact support  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  P12 (new ticket)  
  > **State rule**:  
  > • Cleared: your rank comes back. Cheating  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:5973`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5973)
  - `[Instance]` **App Bar Container** (`1:5975`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5975)
  - `[Pattern]` **Cup Bar** (`1:5977`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5977)
  - `[Pattern]` **Badge / Live** (`1:5979`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5979)
  - `[Pattern]` **Banner / Your score is under review** (`1:5982`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5982)
  - `[Instance]` **Fill / Release Alert** (`1:5983`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5983)
  - `[Pattern]` **Podium · Top 3** (`1:5987`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5987)
  - `[Pattern]` **Place 2 / Sara K.** (`1:5988`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5988)
  - `[Pattern]` **Place 1 / Kian P.** (`1:5997`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-5997)
  - `[Pattern]` **Place 3 / Omid R.** (`1:6007`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6007)
  - `[Pattern]` **Rank Row / #4 Neda H.** (`1:6016`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6016)
  - `[Pattern]` **Rank** (`1:6017`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6017)
  - `[Pattern]` **Score** (`1:6023`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6023)
  - `[Pattern]` **Rank Row / #5 Reza M.** (`1:6027`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6027)
  - `[Pattern]` **Rank** (`1:6028`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6028)
  - `[Pattern]` **Score** (`1:6034`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6034)
  - `[Pattern]` **Your Rank** (`1:6039`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6039)
  - `[Pattern]` **Row** (`1:6040`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6040)
  - `[Instance]` **Button / Play Block Blast** (`1:6054`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6054)
  - `[Pattern]` **Support Row** (`1:6055`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6055)
  - `[Pattern]` **Text Button / Contact support** (`1:6056`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6056)
  - `[Instance]` **Navigator Bar Container** (`1:6060`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6060)

### L18 — L18 · Past results (Expand)
- **Node ID**: `1:6063`
- **لینک مستقیم فیگما**: [L18 · Past results (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6063)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L18 · Past results  
  > **Opened by**:  
  > • Past results on L01, L05, L06 or L07  
  > **Buttons on this screen**:  
  > • Chips (All, Overall, Games)  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  filter this list  
  > • Claim row  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L03 or L11  
  > • Cancelled row  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L13  
  > • Other rows  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  that board’s final results (read-only  
  > **State rule**:  
  > • Expired = not claimed within 7 days.  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:6065`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6065)
  - `[Instance]` **App Bar Container** (`1:6067`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6067)
  - `[Pattern]` **Page Title** (`1:6069`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6069)
  - `[Pattern]` **Filter Chips** (`1:6071`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6071)
  - `[Pattern]` **Chip / All** (`1:6072`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6072)
  - `[Pattern]` **Chip / Overall** (`1:6074`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6074)
  - `[Pattern]` **Chip / Games** (`1:6076`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6076)
  - `[Pattern]` **Group / Waiting** (`1:6079`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6079)
  - `[Pattern]` **History Item / Overall · Week 41** (`1:6080`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6080)
  - `[Pattern]` **History Item / Bubble Pop cup** (`1:6090`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6090)
  - `[Pattern]` **Group / Earlier** (`1:6101`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6101)
  - `[Pattern]` **History Item / Jewel Rush cup** (`1:6102`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6102)
  - `[Pattern]` **History Item / Overall · Week 40** (`1:6112`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6112)
  - `[Pattern]` **History Item / Block Blast cup** (`1:6122`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6122)
  - `[Pattern]` **History Item / Overall · Week 39** (`1:6132`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6132)
  - `[Instance]` **Navigator Bar Container** (`1:6143`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6143)

### L19 — L19 · How to earn Tokens · bottom sheet
- **Node ID**: `1:6444`
- **لینک مستقیم فیگما**: [L19 · How to earn Tokens · bottom sheet](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6444)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L19 · How to earn Tokens · bottom sheet  
  > **Opened by**:  
  > • Earn Tokens on L01 · How to earn Tokens on  
  > **Buttons on this screen**:  
  > • Buy a Coin pack  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  P01 (Shop · Coins)  
  > • Missions &amp; quests  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  Missions tab  
  > • Streak, Lucky Wheel &amp; campaigns  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  Home  
  > • Play the game  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  Games tab  
  > • Game missions &amp; events  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  Games tab  
  > • Go to Missions  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  Missions tab  
  > • X / swipe down  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  close  
  > **State rule**:  
  > • Coin packs give only the platform Token.  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:6446`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6446)
  - `[Instance]` **App Bar Container** (`1:6448`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6448)
  - `[Pattern]` **Page Title** (`1:6450`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6450)
  - `[Pattern]` **Text Button / Past results** (`1:6452`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6452)
  - `[Pattern]` **Segmented Tabs** (`1:6455`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6455)
  - `[Pattern]` **Tab / Overall (selected)** (`1:6456`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6456)
  - `[Pattern]` **Tab / Games** (`1:6459`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6459)
  - `[Pattern]` **Banner / Week 41 results are out** (`1:6462`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6462)
  - `[Instance]` **Fill / Trophy** (`1:6463`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6463)
  - `[Instance]` **Button / Claim** (`1:6467`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6467)
  - `[Pattern]` **Filter Chips** (`1:6468`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6468)
  - `[Pattern]` **Chip / This week** (`1:6469`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6469)
  - `[Pattern]` **Chip / All time** (`1:6471`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6471)
  - `[Pattern]` **Period Card** (`1:6473`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6473)
  - `[Pattern]` **Badge / Live** (`1:6479`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6479)
  - `[Pattern]` **Reward Tiers** (`1:6482`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6482)
  - `[Pattern]` **Tier / Top 10** (`1:6483`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6483)
  - `[Pattern]` **Tier / Top 100** (`1:6486`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6486)
  - `[Pattern]` **Tier / Top 500** (`1:6489`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6489)
  - `[Pattern]` **Score rule** (`1:6492`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6492)
  - `[Pattern]` **Podium · Top 3** (`1:6501`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6501)
  - `[Pattern]` **Place 2 / Reza M.** (`1:6502`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6502)
  - `[Pattern]` **Place 1 / Sara K.** (`1:6511`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6511)
  - `[Pattern]` **Place 3 / Mina T.** (`1:6521`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6521)
  - `[Pattern]` **Rank Row / #4 Omid R.** (`1:6530`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6530)
  - `[Pattern]` **Rank** (`1:6531`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6531)
  - `[Pattern]` **Score** (`1:6537`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6537)
  - `[Pattern]` **Rank Row / #5 Neda H.** (`1:6541`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6541)
  - `[Pattern]` **Rank** (`1:6542`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6542)
  - `[Pattern]` **Score** (`1:6548`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6548)
  - `[Pattern]` **Rank Row / #6 Kian P.** (`1:6552`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6552)
  - `[Pattern]` **Rank** (`1:6553`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6553)
  - `[Pattern]` **Score** (`1:6559`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6559)
  - `[Pattern]` **Rank Row / #7 Hamid J.** (`1:6563`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6563)
  - `[Pattern]` **Rank** (`1:6564`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6564)
  - `[Pattern]` **Score** (`1:6570`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6570)
  - `[Pattern]` **Your Rank** (`1:6575`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6575)
  - `[Pattern]` **Row** (`1:6576`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6576)
  - `[Pattern]` **Labels** (`1:6588`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6588)
  - `[Pattern]` **Track** (`1:6591`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6591)
  - `[Instance]` **Navigator Bar Container** (`1:6594`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6594)
  - `[Pattern]` **Bottom Sheet** (`1:6598`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6598)
  - `[Pattern]` **Sheet Header** (`1:6600`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6600)
  - `[Instance]` **Icon / Token** (`1:6602`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6602)
  - `[Pattern]` **Title** (`1:6603`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6603)
  - `[Instance]` **Outline / Close** (`1:6606`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6606)
  - `[Pattern]` **Section / Token** (`1:6607`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6607)
  - `[Pattern]` **Row** (`1:6608`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6608)
  - `[Instance]` **Icon / Token** (`1:6609`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6609)
  - `[Pattern]` **Ways / Token** (`1:6612`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6612)
  - `[Pattern]` **Way / Buy a Coin pack** (`1:6613`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6613)
  - `[Instance]` **Fill / Chevron Right** (`1:6619`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6619)
  - `[Pattern]` **Way / Missions &amp; quests** (`1:6620`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6620)
  - `[Instance]` **Fill / Chevron Right** (`1:6626`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6626)
  - `[Pattern]` **Way / Streak, Lucky Wheel &amp; campaigns** (`1:6627`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6627)
  - `[Instance]` **Fill / Chevron Right** (`1:6633`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6633)
  - `[Pattern]` **Section / Game Tokens** (`1:6634`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6634)
  - `[Pattern]` **Row** (`1:6635`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6635)
  - `[Instance]` **Icon / Token** (`1:6636`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6636)
  - `[Pattern]` **Ways / Game Tokens** (`1:6639`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6639)
  - `[Pattern]` **Way / Play the game** (`1:6640`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6640)
  - `[Instance]` **Fill / Chevron Right** (`1:6646`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6646)
  - `[Pattern]` **Way / Game missions &amp; events** (`1:6647`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6647)
  - `[Instance]` **Fill / Chevron Right** (`1:6653`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6653)
  - `[Instance]` **Button / Go to Missions** (`1:6654`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6654)

### L20 — L20 · Overall · this month (live) (Expand)
- **Node ID**: `1:6685`
- **لینک مستقیم فیگما**: [L20 · Overall · this month (live) (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6685)
- **ابعاد**: 402 × 1223 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L20 · Overall · this month (live)  
  > **Opened by**:  
  > • This month chip on L01, L05 or L06  
  > **Buttons on this screen**:  
  > • This week chip  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L01  
  > • All time chip  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L05  
  > • Games tab  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L07  
  > • Earn Tokens  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L19  
  > • Rules  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L14 (monthly version)  
  > • Any player row or podium  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L15  
  > • Past results  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L18  
  > **State rule**:  
  > • Runs 1st 00:00 to last day 23:59. Ends l  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:6687`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6687)
  - `[Instance]` **App Bar Container** (`1:6689`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6689)
  - `[Pattern]` **Page Title** (`1:6691`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6691)
  - `[Pattern]` **Text Button / Past results** (`1:6693`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6693)
  - `[Pattern]` **Segmented Tabs** (`1:6696`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6696)
  - `[Pattern]` **Tab / Overall (selected)** (`1:6697`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6697)
  - `[Pattern]` **Tab / Games** (`1:6700`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6700)
  - `[Pattern]` **Filter Chips** (`1:6703`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6703)
  - `[Pattern]` **Chip / This week** (`1:6704`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6704)
  - `[Pattern]` **Chip / This month** (`1:6706`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6706)
  - `[Pattern]` **Chip / All time** (`1:6708`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6708)
  - `[Pattern]` **Period Card** (`1:6710`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6710)
  - `[Pattern]` **Badge / Live** (`1:6716`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6716)
  - `[Pattern]` **Reward Tiers** (`1:6719`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6719)
  - `[Pattern]` **Tier / Top 10** (`1:6720`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6720)
  - `[Pattern]` **Tier / Top 100** (`1:6723`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6723)
  - `[Pattern]` **Tier / Top 500** (`1:6726`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6726)
  - `[Pattern]` **Score rule** (`1:6729`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6729)
  - `[Pattern]` **Podium · Top 3** (`1:6738`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6738)
  - `[Pattern]` **Place 2 / Reza M.** (`1:6739`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6739)
  - `[Pattern]` **Place 1 / Sara K.** (`1:6748`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6748)
  - `[Pattern]` **Place 3 / Mina T.** (`1:6758`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6758)
  - `[Pattern]` **Rank Row / #4 Omid R.** (`1:6767`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6767)
  - `[Pattern]` **Rank** (`1:6768`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6768)
  - `[Pattern]` **Score** (`1:6774`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6774)
  - `[Pattern]` **Rank Row / #5 Neda H.** (`1:6778`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6778)
  - `[Pattern]` **Rank** (`1:6779`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6779)
  - `[Pattern]` **Score** (`1:6785`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6785)
  - `[Pattern]` **Rank Row / #6 Kian P.** (`1:6789`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6789)
  - `[Pattern]` **Rank** (`1:6790`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6790)
  - `[Pattern]` **Score** (`1:6796`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6796)
  - `[Pattern]` **Rank Row / #7 Hamid J.** (`1:6800`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6800)
  - `[Pattern]` **Rank** (`1:6801`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6801)
  - `[Pattern]` **Score** (`1:6807`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6807)
  - `[Pattern]` **Your Rank** (`1:6812`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6812)
  - `[Pattern]` **Row** (`1:6813`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6813)
  - `[Pattern]` **Labels** (`1:6825`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6825)
  - `[Pattern]` **Track** (`1:6828`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6828)
  - `[Instance]` **Navigator Bar Container** (`1:6831`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6831)

### L21 — L21 · Games tab · All filter (Expand)
- **Node ID**: `1:6834`
- **لینک مستقیم فیگما**: [L21 · Games tab · All filter (Expand)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6834)
- **ابعاد**: 402 × 1067 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L21 · Games tab · All filter  
  > **Opened by**:  
  > • All, Live, Starts soon or Finished chip  
  > **Buttons on this screen**:  
  > • For you chip  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L07  
  > • Live card (Block Blast)  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L08  
  > • Paused card (Snake Rush)  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L10  
  > • Starts soon card  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L09  
  > • Calculating card (Fruit Slice)  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  game version of L02  
  > • Claim card (Bubble Pop)  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L11  
  > • Finished card, no reward  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L11 without reward  
  > **State rule**:  
  > • Every board, grouped by state. Turned-of  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:6836`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6836)
  - `[Instance]` **App Bar Container** (`1:6838`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6838)
  - `[Pattern]` **Page Title** (`1:6840`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6840)
  - `[Pattern]` **Text Button / Past results** (`1:6842`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6842)
  - `[Pattern]` **Segmented Tabs** (`1:6845`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6845)
  - `[Pattern]` **Tab / Overall** (`1:6846`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6846)
  - `[Pattern]` **Tab / Games (selected)** (`1:6849`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6849)
  - `[Pattern]` **Filter Chips** (`1:6852`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6852)
  - `[Pattern]` **Chip / For you** (`1:6853`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6853)
  - `[Pattern]` **Chip / All** (`1:6855`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6855)
  - `[Pattern]` **Chip / Live** (`1:6857`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6857)
  - `[Pattern]` **Chip / Starts soon** (`1:6859`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6859)
  - `[Pattern]` **Chip / Finished** (`1:6861`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6861)
  - `[Pattern]` **Section Header** (`1:6863`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6863)
  - `[Pattern]` **Row** (`1:6864`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6864)
  - `[Pattern]` **Game Board Card / Block Blast** (`1:6866`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6866)
  - `[Pattern]` **Game Tile** (`1:6867`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6867)
  - `[Pattern]` **Game Board Card / Snake Rush** (`1:6878`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6878)
  - `[Pattern]` **Game Tile** (`1:6879`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6879)
  - `[Pattern]` **Section Header** (`1:6889`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6889)
  - `[Pattern]` **Row** (`1:6890`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6890)
  - `[Pattern]` **Game Board Card / Knife Hit Cup** (`1:6892`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6892)
  - `[Pattern]` **Game Tile** (`1:6893`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6893)
  - `[Pattern]` **Section Header** (`1:6902`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6902)
  - `[Pattern]` **Row** (`1:6903`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6903)
  - `[Pattern]` **Game Board Card / Fruit Slice** (`1:6905`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6905)
  - `[Pattern]` **Game Tile** (`1:6906`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6906)
  - `[Pattern]` **Game Board Card / Bubble Pop** (`1:6916`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6916)
  - `[Pattern]` **Game Tile** (`1:6917`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6917)
  - `[Pattern]` **Game Board Card / Tower Stack** (`1:6927`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6927)
  - `[Pattern]` **Game Tile** (`1:6928`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6928)
  - `[Instance]` **Navigator Bar Container** (`1:6938`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-6938)

### L22 — L22 · Menu (from avatar) · Leaderboard entry
- **Node ID**: `1:7034`
- **لینک مستقیم فیگما**: [L22 · Menu (from avatar) · Leaderboard entry](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7034)
- **ابعاد**: 402 × 874 pt
- **کپشن و قوانین رفتار صفحه (Designer Caption & Flow Rules)**:
  > **عنوان**: L22 · Menu (hamburger) · Leaderboard ent  
  > **Opened by**:  
  > • Menu icon (☰) at the top right of every  
  > **Buttons on this screen**:  
  > • Leaderboard  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  L01 (Overall · this week)  
  > • Your profile  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  Profile (S01)  
  > • Wallet  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  Wallet (W01)  
  > • Ticket center  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  P23  
  > • Notifications / Language &amp; theme / Help  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  their screens  
  > • X, scrim or swipe left  
  > &nbsp;&nbsp;&nbsp;&nbsp;→  close  
  > **State rule**:  
  > • Leaderboard left the bottom nav on 27 Oc  
- **المان‌ها و کامپوننت‌های استخراج‌شده**:
  - `[Instance]` **iPhone - Status Bar** (`1:7036`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7036)
  - `[Instance]` **App Bar Container** (`1:7038`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7038)
  - `[Pattern]` **Page Title** (`1:7040`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7040)
  - `[Pattern]` **Text Button** (`1:7042`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7042)
  - `[Pattern]` **Segmented Tabs** (`1:7045`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7045)
  - `[Pattern]` **Tab / Coins (selected)** (`1:7046`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7046)
  - `[Pattern]` **Tab / Rewards** (`1:7049`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7049)
  - `[Pattern]` **Section Header** (`1:7052`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7052)
  - `[Pattern]` **Title Row** (`1:7053`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7053)
  - `[Pattern]` **Coin Packs Grid** (`1:7057`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7057)
  - `[Pattern]` **Row 1** (`1:7058`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7058)
  - `[Pattern]` **Row 2** (`1:7096`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7096)
  - `[Pattern]` **Info Note** (`1:7144`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7144)
  - `[Instance]` **Outline / Help** (`1:7145`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7145)
  - `[Instance]` **Navigator Bar Container** (`1:7148`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7148)
  - `[Pattern]` **Menu Drawer** (`1:7152`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7152)
  - `[Pattern]` **Drawer Header** (`1:7153`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7153)
  - `[Instance]` **Outline / Close** (`1:7155`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7155)
  - `[Pattern]` **Profile** (`1:7156`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7156)
  - `[Instance]` **Fill / Chevron Right** (`1:7162`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7162)
  - `[Pattern]` **Menu Items** (`1:7163`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7163)
  - `[Pattern]` **Menu Item / Leaderboard** (`1:7164`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7164)
  - `[Instance]` **Fill / Chevron Right** (`1:7170`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7170)
  - `[Pattern]` **Menu Item / Wallet** (`1:7171`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7171)
  - `[Instance]` **Fill / Chevron Right** (`1:7177`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7177)
  - `[Pattern]` **Menu Item / Ticket center** (`1:7178`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7178)
  - `[Instance]` **Fill / Chevron Right** (`1:7184`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7184)
  - `[Pattern]` **Menu Item / Notifications** (`1:7185`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7185)
  - `[Instance]` **Fill / Chevron Right** (`1:7190`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7190)
  - `[Pattern]` **Menu Item / Language &amp; theme** (`1:7191`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7191)
  - `[Instance]` **Fill / Chevron Right** (`1:7196`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7196)
  - `[Pattern]` **Menu Item / Help &amp; FAQ** (`1:7197`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7197)
  - `[Instance]` **Fill / Chevron Right** (`1:7202`) — [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7202)

---

## ۴. جدول رتبه‌بندی فراوانی و تکرار المان‌ها (Frequency Ranking Table)

جدول زیر تمام الگوها و کامپوننت‌های شناسایی‌شده در ۲۲ فریم لیدربورد را بر اساس تکرار مرتب کرده و پوشش فعلی کد و لایه پیشنهادی را مشخص می‌کند:

| نام المان / کامپوننت | تعداد کل تکرار | تعداد فریم‌ها | فریم‌های مشاهده‌شده | وضعیت فعلی در سورس‌کد | لایه معماری پیشنهادی |
|---|:---:|:---:|---|:---:|:---:|
| **سطر رتبه بازیکن (`LeaderboardRankRow`)** | ۵۳ | ۱۵ | L01, L02, L03, L05, L06, L08, L10, L11, L13, L14, L15, L16, L17, L19, L20 | ⚠️ آواتار هست، سطر امتیاز و رتبه اختصاصی نیست | **Layer 2 (Leaderboard Feature)** |
| **سکوی سه رتبه برتر (`AppPodium`)** | ۱۵ | ۱۵ | L01, L02, L03, L05, L06, L08, L10, L11, L13, L14, L15, L16, L17, L19, L20 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **کارت چسبان رتبه من (`AppStickyRankBar`)** | ۱۱ | ۱۱ | L01, L02, L05, L08, L10, L14, L15, L16, L17, L19, L20 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **تب‌های قطعه‌بندی‌شده (`AppSegmentedTabs`)** | ۱۱ | ۱۱ | L01, L05, L06, L07, L14, L15, L16, L19, L20, L21, L22 | ❌ وجود ندارد (در Shop هم ۱۱ بار تکرار شده بود) | **Layer 1 (Core DS)** |
| **چیپ‌های فیلتر محتوا (`AppFilterChip` / Bar)** | ۱۱ | ۱۱ | L01, L05, L06, L07, L14, L15, L16, L18, L19, L20, L21 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **بنرهای اطلاع‌رسانی و هشدار (`AppBanner`)** | ۱۱ | ۱۰ | L01, L02, L05, L10, L13, L14, L15, L16, L17, L19 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **شبکه جوایز سطوح (`AppRewardTiers`)** | ۱۰ | ۱۰ | L01, L06, L08, L09, L10, L14, L15, L16, L19, L20 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **کارت زمان‌سنج و روزشمار (`AppCountdownCard`)** | ۸ | ۸ | L01, L02, L06, L14, L15, L16, L19, L20 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **سطر راهنمای امتیاز (`Score Rule Row`)** | ۸ | ۸ | L01, L08, L09, L14, L15, L16, L19, L20 | ❌ وجود ندارد | **Layer 2 (Leaderboard Feature)** |
| **کارت‌های برد بازی (`GameBoardTileCard`)** | ۱۲ | ۲ | L07, L21 | ❌ فقط کاور بازی خام وجود دارد | **Layer 2 (Games Feature)** |
| **نوار کاپ بازی (`Cup Bar` Header)** | ۶ | ۶ | L08, L09, L10, L11, L13, L17 | ❌ وجود ندارد | **Layer 2 (Leaderboard Feature)** |
| **کارت قهرمان وضعیت / خطا / جشن (`AppStateHero`)** | ۶ | ۶ | L04, L06, L09, L12, L13, L17 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **نشانگر زنده با نقطه فعال (`Badge / Live`)** | ۱۳ | ۱۱ | L01, L06, L07, L08, L14, L15, L16, L17, L19, L20, L21 | ⚠️ AppBadge ساده هست، Live Dot ندارد | **Layer 1 (Core DS)** |
| **باتم‌شیت استاندارد (`Bottom Sheet Layout`)** | ۴ | ۴ | L14, L15, L16, L19 | ⚠️ فقط AppSheet خام بدون هدر و ساختار فرم | **Layer 1 (Core DS)** |
| **آیتم تاریخچه نتایج گذشته (`LeaderboardHistoryItem`)** | ۶ | ۱ | L18 | ❌ وجود ندارد | **Layer 2 (Leaderboard Feature)** |
| **گزینه انتخابی رادیویی (`AppRadioTile`)** | ۴ | ۱ | L16 | ⚠️ فقط AppRadio خام (در Shop هم ۱۶ بار بود) | **Layer 1 (Core DS)** |
| **کارت‌های ۳گانه آمار کاربر (`AppStatGroup`)** | ۱ | ۱ | L15 | ❌ وجود ندارد | **Layer 1 (Core DS)** |
| **دراور کشویی منو (`AppNavigationDrawer`)** | ۱ | ۱ | L22 | ❌ وجود ندارد | **Layer 1 (Core DS)** |

---

## ۵. تفکیک معماری و طبقه‌بندی لایه‌ها (Layer 1 vs Layer 2)

### ۵.۱. لایه اول: کامپوننت‌های بنیادین دیزاین سیستم (Layer 1 — Core Design System)

این کامپوننت‌ها هیچ وابستگی معنایی به جدول رده‌بندی، بازی خاص یا متون تجاری ندارند و قابلیت استفاده مجدد در تمام بخش‌های محصول (پروفایل، فروشگاه، گردونه شانس، ماموریت‌ها و تنظیمات) را دارا هستند. محل استقرار این فایل‌ها در پکیج `packages/design_system/lib/src/components/` خواهد بود:

1. **`AppPodium` (کامپوننت سکوی سه‌گانه رتبه‌های ۱ تا ۳)**:
   - **تعداد تکرار**: ۱۵ فریم کامل!
   - **آناتومی**:
     - سکوی رتبه ۲ (سمت چپ در LTR / راست در RTL): ارتفاع ۱۱۹ الی ۱۶۶ پوینت، آواتار ۵۲ پوینتی، نام، امتیاز، پدستال با عدد '2'.
     - سکوی رتبه ۱ (مرکز): ارتفاع ۱۶۲ الی ۲۳۲ پوینت، آیکون تاج طلایی (`Fill / Crown`)، آواتار ۵۲ پوینتی، نام، امتیاز، پدستال مرتفع با عدد '1'.
     - سکوی رتبه ۳ (سمت راست در LTR / چپ در RTL): ارتفاع ۱۱۰ الی ۱۵۰ پوینت، آواتار، نام، امتیاز، پدستال با عدد '3'.
   - **واریانت‌ها**:
     - `overall`: سایز استاندارد لیدربورد کلی پلتفرم.
     - `compact` / `gameCup`: نسخه فشرده با پدستال کوتاه‌تر برای کاپ‌های بازی‌ها.
   - **پارامترها**: `AppPodiumEntry first`, `AppPodiumEntry second`, `AppPodiumEntry third`, `ValueChanged<AppPodiumEntry>? onPlayerTap`.

2. **`AppStickyRankBar` (نوار چسبان نمایش وضعیت و رتبه کاربر)**:
   - **تعداد تکرار**: ۱۱ فریم.
   - **آناتومی**:
     - محفظه استیکی در پایین صفحه (بالای Bottom Nav یا Bottom Sheet).
     - نمایش نشان رتبه کاربر (`#87 You`)، آواتار، نام، و میزان توکن کسب‌شده.
     - نوار پیشرفت متریال (`Track`) به همراه برچسب‌های متنی محاسبه فاصله تا سطح بعدی (مثلاً `+590 pts to Top 50`).
   - **حالات**:
     - `ranked`: حالت عادی با نوار پیشرفت تا تایر بعدی.
     - `calculating`: نمایش وضعیت موقت رتبه در زمان محاسبه نتایج نهایی.
     - `underReview`: هشدار عدم محاسبه امتیاز به دلیل بازبینی ادمین.
     - `unranked`: حالت خالی با دکمه انتقال به ماموریت‌ها.

3. **`AppSegmentedTabs` (تب‌های قطعه‌بندی‌شده افقی)**:
   - **تعداد تکرار**: ۱۱ فریم در لیدربورد + ۱۱ فریم در فروشگاه (مجموعاً ۲۲ فریم در محصول!).
   - **آناتومی**: کانتینر کپسولی با پدینگ ۴ پوینت، تب فعال با پس‌زمینه سالید و تب‌های غیرفعال با متن Muted، قابلیت دریافت آیکون اختصاصی در کنار برچسب متنی.

4. **`AppFilterChip` / `AppFilterBar` (نوار فیلترهای تک‌انتخابی)**:
   - **تعداد تکرار**: ۱۱ فریم.
   - **آناتومی**: چیپ‌های افقی اسکرول‌پذیر با بوردر کانتینری در حالت غیرفعال و پس‌زمینه هایلایت در حالت انتخاب‌شده. پشتیبانی از شمارنده یا بج در کنار عنوان.

5. **`AppBanner` / `AppCallout` (بنرهای اعلان و پیام وضعیت)**:
   - **تعداد تکرار**: ۱۱ فریم.
   - **آناتومی**: کادر افقی با آیکون راهنما/هشدار در سمت Start، متن عنوان و توضیح، و اکشن اختیاری (مانند دکمه `Claim`).
   - **واریانت‌های سمانتیک**:
     - `announcement`: جشن اهدای جوایز با آیکون کاپ.
     - `info`: پیام‌های خنثی نظیر عدم تعلق جایزه به برد All-Time.
     - `progress`: حالت محاسبه نتایج با آیکون تایمر.
     - `warning`: توقف موقت برد (`Paused`) یا بازبینی امتیاز (`Under Review`).
     - `error`: لغو رسمی رویداد (`Cancelled`).

6. **`AppCountdownCard` (کارت روزشمار و بازه زمانی دوره)**:
   - **تعداد تکرار**: ۸ فریم.
   - **آناتومی**: آیکون تایمر در سمت چپ، بازه زمانی (مانند `Week 42 · 13–19 Oct`)، زمان باقی‌مانده به صورت تایپوگرافی برجسته (مثلاً `2d 14h 05m`) و بج زنده `Live Badge`.

7. **`AppRewardTiers` (نمایشگر ستونی جوایز سطوح)**:
   - **تعداد تکرار**: ۱۰ فریم.
   - **آناتومی**: گرید ۳ ستونه افقی، هر سلول شامل نام سطح (مانند `Top 10`, `Top 100`, `Top 500`) و پاداش امتیازی آن (`+3,000 pts`).

8. **`AppStateHero` (الگوی قهرمان وضعیت تمام‌صفحه)**:
   - **تعداد تکرار**: ۶ فریم.
   - **آناتومی**: آیکون بزرگ دایره‌ای (۴۸ الی ۹۶ پوینت)، عنوان درشت، توضیحات دوخطی، کارت نمایش مقدار (مانند موجودی جدید)، و دو دکمه اکشن عمودی در پایین صفحه.

9. **`AppRadioTile` (ردیف انتخابی رادیویی)**:
   - **تعداد تکرار**: ۴ مورد در L16 (و ۱۶ مورد در فریم‌های Shop).
   - **آناتومی**: کادر گزینش دلایل گزارش تخلف شامل دایره رادیویی (`AppRadio`) و عنوان دلیل.

10. **`AppNavigationDrawer` (دراور کشویی منوی جانبی)**:
    - **تعداد تکرار**: فریم L22.
    - **آناتومی**: دراور با عرض ۳۰۰ پوینت، هدر با دکمه بستن، کارت پروفایل کاربر (شامل آواتار و شماره تلفن)، و لیست آیتم‌های منو با آیکون، عنوان و فلش نشانگر.

---

### ۵.۲. لایه دوم: ویجت‌های تخصصی دامین لیدربورد (Layer 2 — Shared / Feature Widgets)

این ویجت‌ها منطق کسب‌وکار، مدل داده‌ای و سمانتیک جدول رده‌بندی بازی‌ها را حمل می‌کنند و در `lib/features/leaderboard/presentation/widgets/` یا `lib/shared/widgets/` مستقر می‌شوند:

1. **`LeaderboardRankRow` (سطر رتبه جدول لیدربورد)**:
   - ۵۳ مرتبه تکرار در ۱۵ فریم.
   - رندرر سطر بازیکن شامل شماره رتبه (با رنگ‌بندی طلایی برای ۴ تا ۱۰)، ویجت `PlayerAvatar`، نام کاربر، نمایش مقدار توکن‌ها با آیکون سکه طلایی یا بنفش، و هایلایت بصری ویژه زمانی که سطر متعلق به کاربر جاری است (`isCurrentUser = true`).

2. **`GameBoardTileCard` (کارت لیدربورد بازی‌ها در تب Games)**:
   - ۱۲ تکرار در فریم‌های L07 و L21.
   - شامل تایل بازی با گوشه‌های گرد (`Game Tile`)، عنوان بازی و دوره مسابقه، وضعیت فعلی و بهترین امتیاز بازیکن، و دکمه‌های اکشن مستقیم (`Play`، `Remind me` یا فلش ورود).

3. **`LeaderboardCupHeader` (`Cup Bar`)**:
   - نوار بالای بردهای اختصاصی بازی‌ها شامل عنوان کاپ هفتگی و نشانگر وضعیت زنده یا پایان‌یافته.

4. **`LeaderboardHistoryItem` (سطر نتایج پیشین)**:
   - ۶ تکرار در L18.
   - نمایش نتیجه قطعی کاربر در دوره‌های قبل، وضعیت مطالبه جایزه (`Claimable`, `Claimed`, `Expired`, `Cancelled`).

5. **باتم‌شیت‌های چهارگانه تخصصی دامین لیدربورد**:
   - **`LeaderboardRulesSheet` (L14)**: باتم‌شیت شرح ۵ قانون طلایی امتیازگیری، برابری امتیازات، اعطای جوایز، نتایج و بازی جوانمردانه.
   - **`PlayerSummarySheet` (L15)**: باتم‌شیت پروفایل عمومی بازیکن با آمار ۳گانه عملکرد در هفته، بازی‌های محبوب و دکمه گزارش تخلف.
   - **`ReportRankProblemSheet` (L16)**: فرم ثبت گزارش تخلف با ۴ گزینه رادیویی، فیلد توضیحات و دکمه ارسال گزارش.
   - **`EarnTokensSheet` (L19)**: راهنمای تعاملی ۲ بخشی جهت آموزش روش‌های کسب توکن پلتفرم و توکن‌های اختصاصی بازی‌ها.

---

## ۶. تحلیل ناسازگاری‌ها، موارد Errata و سوالات نیازمند تصمیم‌گیری

### ۶.۱. موارد ثبت در اراتا (Figma Errata to Register)

| کد اراتا | موقعیت در فیگما | شرح تناقض و ناسازگاری | تصمیم مهندسی پیشنهادی |
|:---:|:---:|---|---|
| **E-021** | فریم `L22` در برابر یادداشت `1:6431` | در فریم L22 دیزاینر به آیکون همبرگر (☰) در هدر اشاره کرده، در حالی که در یادداشت ۲۷ اکتبر تاکید شده ورود از طریق تپ روی آواتار است و Social جای لیدربورد را در نوار پایین گرفته است. | مرجع رسمی، تپ روی آواتار کاربر خواهد بود و آیکون همبرگر مستقل طراحی نمی‌شود. |
| **E-022** | فریم‌های `L08`, `L10`, `L11` | عدم تطابق رنگ توکن بازی‌ها با متن یادداشت دیزاینر؛ در یادداشت توکن بازی بنفش (`Purple/400`) تعریف شده اما در وایرفریم‌ها استایل توکن پلتفرم را دارند. | در پیاده‌سازی High-Fidelity توکن بازی‌ها از تم بنفش تغذیه خواهد کرد. |
| **E-023** | فریم `L09` شناسه `1:5117` | خطای تایپی در فیگما: `Badge / Tokents in 1d 03h` به جای `Tokens in 1d 03h`. | اصلاح تایپوگرافی در کد سیستم. |

### ۶.۲. تصمیمات مورد نیاز از اونر پروژه (Cyber Miller)

1. **مکانیزم اعطای جوایز (Claim vs Auto-Credit)**: آیا سیستم مهلت ۷ روزه دکمه مطالبه دستی (Claim) باید حفظ شود یا پاداش‌ها در پایان هر هفته مستقیماً به موجودی Points کاربر افزوده شوند؟ (پیشنهاد مهندسی: حفظ Claim دستی به دلیل ایجاد حس دستاورد و گیمیفیکیشن مطابق وایرفریم L03 و L04).
2. **وضعیت‌های تعلیق و لغو (Paused / Cancelled)**: آیا در فاز MVP نیاز به پیاده‌سازی لاجیک پیچیده Paused و Cancelled در سرور و کلاینت است، یا صرفاً وضعیت‌های استاندارد Live و Finished کفایت می‌کند؟
3. **دراور منوی کاربری (L22)**: آیا منوی جانبی L22 باید به عنوان یک کامپوننت پایه دیزاین سیستم پیاده‌سازی شود یا به عنوان شیت عمومی اپلیکیشن در لایه `lib/app/` قرار گیرد؟

---

## ۷. نقشه راه پیاده‌سازی کامپوننت‌های لیدربورد (Implementation Roadmap)

جهت اجرای بهینه و بدون دوباره‌کاری، پیشنهاد می‌شود پیاده‌سازی در ۳ فاز مستقل زیر انجام پذیرد:

1. **فاز ۱ — استانداردسازی کامپوننت‌های مشترک لایه اول دیزاین سیستم**:
   - پیاده‌سازی `AppPodium` در `packages/design_system/lib/src/components/collections/app_podium.dart`
   - پیاده‌سازی `AppStickyRankBar`
   - پیاده‌سازی `AppSegmentedTabs` و `AppFilterBar` (مشترک با فروشگاه)
   - پیاده‌سازی `AppBanner` با واریانت‌های سمانتیک ۶ گانه
   - پیاده‌سازی `AppCountdownCard` و `AppRewardTiers`
2. **فاز ۲ — توسعه ویجت‌های تخصصی دامین در لایه Shared / Feature**:
   - پیاده‌سازی `LeaderboardRankRow` با اتصال به `PlayerAvatar`
   - پیاده‌سازی `GameBoardTileCard`
   - پیاده‌سازی باتم‌شیت‌های `LeaderboardRulesSheet` و `PlayerSummarySheet`
   - پیاده‌سازی فرم `ReportRankProblemSheet`
3. **فاز ۳ — اسمبل و پیاده‌سازی صفحات اصلی (Screen Assembly)**:
   - پیاده‌سازی صفحه لیدربورد اصلی هفتگی (`L01`) و بردهای وابسته (`L02`, `L03`, `L04`, `L05`, `L06`)
   - پیاده‌سازی تب لیدربوردهای بازی‌ها (`L07`, `L08`, `L11`, `L21`)
   - پیاده‌سازی تاریخچه نتایج پیشین (`L18`) و دراور کاربری (`L22`)

---
*گزارش استخراج مستقل سکشن Leaderboard Wireframes به پایان رسید.*
