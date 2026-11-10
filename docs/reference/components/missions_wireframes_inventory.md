# گزارش جامع استخراج و کالبدشکافی کامپوننت‌های سکشن Missions & Quests Wireframes

> **مرجع دیزاین فیگما**: فایل `7BurKbCwclcabEGJ7cLcKz` · سکشن `1:7470` (`Missions & Quests · Wireframes (20 Oct 2026)`)  
> **لینک مستقیم سکشن در فیگما**: [Figma Section 1:7470 (Missions & Quests · Wireframes)](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7470)  
> **نوع تحلیل**: کاملاً Read-Only، مستند، سیستماتیک و مبتنی بر شواهد مستقیم درختی فیگما  
> **جامعه آماری**: ۶۲ فریم اصلی موبایل، باتم‌شیت و دیالوگ (M01 الی M62) + ۱ بلوک جامع یادداشت‌های دیزاینر (`1:10685`) + ۶۲ باکس مشخصات و کپشن جریان کار دیزاینر (Designer Captions) + ۹ برچسب ردیف ساختاری (Row Labels)

---

## ۱. هدف و خلاصه اجرایی (Executive Summary)

سکشن **Missions & Quests** بزرگ‌ترین، پیچیده‌ترین و متنوع‌ترین بخش تعاملی پلتفرم P2E در وایرفریم‌های فیگما محسوب می‌شود. این سکشن در ۹ ردیف افقی مجزا سازماندهی شده و چرخه کامل ماموریت‌های روزانه و هفتگی پلتفرم، کوئست‌های زنجیره‌ای چندمرحله‌ای، ماموریت‌های اختصاصی بازی‌ها، تسک‌های نصب و اجرای اپلیکیشن‌های شرکا، فرایند کامل تست و کنترل کیفیت بازی‌ها (QA Testing) به همراه ارسال گزارش باگ و سیستم حل اختلاف (Disputes)، پرسشنامه‌ها و نظرسنجی‌های اسپانسرها (Surveys)، و تاریخچه دریافت پاداش‌ها را در قالب ۶۲ فریم موبایل پوشش می‌دهد.

هدف بنیادین این گزارش فنی و معماری:
1. **تفکیک دقیق محتوای واقعی مودال‌ها از پس‌زمینه‌های منجمد (Frozen Backdrop Separation)**: در ۲۷ فریم باتم‌شیت و ۱۱ فریم دیالوگ، دیزاینر کل صفحه مبدا را به صورت کپی در پشت لایه Scrim قرار داده است. عدم تفکیک این پس‌زمینه‌ها باعث بیش از ۸۱۶ تکرار کاذب اینستنس‌ها می‌شد. در این گزارش، آمار به دو صورت «خام با پس‌زمینه» و «خالص/ایزوله‌شده» ارائه شده است.
2. **استخراج کامل کلیه کامپوننت‌ها، الگوها، واریانت‌ها و وضعیت‌ها (States & Variants)**.
3. **طبقه‌بندی ساختاری در دو لایه معماری**:
   - **لایه اول (Core Design System Primitives)**: مؤلفه‌های انتزاعی و قابل استفاده مجدد در تمام بخش‌های پلتفرم در پکیج `packages/design_system/lib/src/components/`.
   - **لایه دوم (Feature-Shared / Domain Widgets)**: ویجت‌های تخصصی ماموریت‌ها، کوئست‌ها، پرسشنامه و QA در `lib/shared/widgets/` یا `lib/features/missions/presentation/widgets/`.

### یافته‌های آماری کلیدی:
- **تعداد کل فریم‌های مستقل**: ۶۲ فریم (M01 الی M62).
- **تفکیک ماهیت فریم‌ها**:
  - صفحات تمام‌صفحه (Full Screens): **۲۴ فریم**.
  - باتم‌شیت‌های مودال (Modal Bottom Sheets): **۲۷ فریم**.
  - دیالوگ‌های مودال (Modal Dialogs): **۱۱ فریم**.
- **تعداد نمونه‌های کامپوننت رسمی (Instances)**:
  - تعداد کل با احتساب پس‌زمینه‌های منجمد (Raw Instances): **۱,۶۷۵ اینستنس**.
  - تعداد خالص رابط کاربری فعال (Clean Isolated Instances): **۸۵۹ اینستنس** (حذف ۸۱۶ اینستنس تکراری پس‌زمینه).
- **تعداد کل فریم‌ها و کانتینرهای الگو (Frames)**:
  - تعداد کل خام (Raw Frames): **۴,۶۰۷ فریم**.
  - تعداد خالص فعال (Clean Frames): **۲,۲۲۷ فریم**.
- **پوشش فعلی در دیزاین سیستم ریپازیتوری**:
  - در حال حاضر تنها `AppButton`، ساختار هدرهای `AppBars`، نوار ناوبری `AppNavigationBar`، ساختار پایه `AppSheet`، آیکون‌های SVG و ویجت `PlayerAvatar` در کدبیس موجودند.
- **بزرگ‌ترین خلاءهای دیزاین سیستم و نیازمندی‌های اولویت‌دار**:
  1. **کارت ماموریت (`MissionCard` / `AppMissionCard`)**: ۴۳ بار تکرار در ۷ صفحه اصلی با ۵ وضعیت معنادار (Not Started، In Progress، Ready to Claim، Claimed، Expired).
  2. **نوار پیشرفت خطی (`AppProgressBar` / `AppProgressTrack`)**: ۴۵ بار تکرار در ۱۷ صفحه مختلف با پشتیبانی از مارکر، لیبل مقدار، و رنگ‌های اختصاصی وضعیت.
  3. **چیپ‌های فیلتر و گروه‌های انتخابی (`AppFilterChips` / `AppChipGroup`)**: ۳۸ بار تکرار در ۱۲ صفحه.
  4. **کارت کوئست چندمرحله‌ای (`QuestCard` / `AppQuestCard`)**: ۴ تکرار در لیست‌ها به همراه صفحه اختصاصی قهرمان کوئست (`QuestHero`) و سطرهای مراحل (`QuestStepRow`).
  5. **تایم‌لاین عمودی مراحل (`AppTimeline` / `AppStatusTimeline`)**: ۷ تکرار در ۷ صفحه فرآیندی (تاییدیه نصب اپ، بررسی گزارش باگ QA، بررسی پرسشنامه و تاریخچه).
  6. **کاشی دسته‌بندی شبکه ماموریت‌ها (`CategoryTile` / `CategoryGrid`)**: ۱۰ بار تکرار در M01 و M02 (ویترین اصلی ماموریت‌ها با ۵ دسته‌بندی).
  7. **جعبه دوتایی جوایز (`RewardTiles`)**: نمایش اختصاصی Points (طلایی) و Tokens (بنفش/طلایی) با استایل کارت هم‌ارز در ۴ صفحه کلیدی.
  8. **کاشی انتخابی رادیویی/چک‌باکس (`AppSelectionTile` / `AppRadioCard`)**: ۷ بار تکرار در پرسشنامه و انتخاب بازی.
  9. **کارت تست و تضمین کیفیت (`QaTestCard`)**: ۶ تکرار در لیست فرصت‌های QA به همراه ظرفیت و شرایط آزمون.
  10. **رشته پیام توسعه‌دهنده و تستر (`DeveloperThreadView`)**: ۸ تکرار در صفحات رفع اشکال باگ‌ها.

---

## ۲. یادداشت‌ها و فرضیات کلیدی دیزاینر (Designer Canvas Notes & Architecture Insights)

در موقعیت x=2168, y=18430 سکشن، یک فریم مستندسازی بسیار غنی تحت نام **"Notes · defaults & open questions"** با شناسه `1:10685` قرار دارد که تصمیمات محصول، فرضیات معماری و سوالات باز تیم را تدوین کرده است:

### ۲.۱. متن دقیق و ساختاریافته یادداشت‌های دیزاینر (Verbatim Transcription)

#### ۱. ساختار ناوبری و معماری صفحه (Structure)
- **تب Missions (فریم M01)**: شامل شبکه دسته‌بندی‌ها (Games، Apps، QA، Surveys، Platform: با نمایش تعداد باز، پاداش‌های قابل دریافت Points و Tokens، و نشانگر Ready to claim) و بلافاصله پس از آن بخش "For you". هیچ تب مجزایی برای تفکیک Missions و Quests وجود ندارد و هیچ چیپ دسته‌بندی در هدر اصلی قرار نگرفته است.
- **کوئست‌ها (Quests)**: در میان ماموریت‌های عادی لیست می‌شوند و با تگ مشکی/مشخص **Quest** در بخش "For you" و در صفحه دسته مربوطه متمایز می‌گردند.
- **صفحات دسته‌بندی (Category Screens)**: با ضربه روی کاشی هر دسته در گرید باز می‌شوند و در بالای صفحه یک کاروسل بنر کمپین (Campaign Banner Carousel) دارند که در صورت نبود کمپین فعال پنهان می‌شود.
- **۹ ردیف سکشن**:
  1. **ردیف ۱**: For you + شیت‌های مشترک جزئیات و پاداش (M01 تا M10).
  2. **ردیف ۲**: کوئست‌ها (Quests) و مراحل آن (M11 تا M14).
  3. **ردیف ۳**: ماموریت‌های بازی‌ها (Games) و فیلترها (M15 تا M18).
  4. **ردیف ۴**: اپلیکیشن‌های شرکا (Apps) و دانلود/تایید (M19 تا M27).
  5. **ردیف ۵**: پیوستن به تست‌های QA و لیست فرصت‌ها (M28 تا M36).
  6. **ردیف ۶**: گزارش باگ و سیستم حل اختلاف تستر/سازنده (M37 تا M45).
  7. **ردیف ۷**: نظرسنجی‌ها و پرسشنامه‌های درآمدی (M46 تا M55).
  8. **ردیف ۸**: ماموریت‌های پلتفرمی اختصاصی P2E (فریم‌های M56 تا M58).
  9. **ردیف ۹**: تاریخچه جامع جوایز و تراکنش‌ها (M59 تا M62).

#### ۲. پیش‌فرض‌های تعیین‌شده (Defaults Chosen)
- **زمان بازنشانی (Reset Timers)**: بازنشانی روزانه راس ساعت **00:00 به وقت تهران** · بازنشانی هفتگی دوشنبه‌ها راس ساعت **00:00 به وقت تهران** (کاملاً هماهنگ با هفته لیدربورد).
- **پرداخت پاداش‌ها**: هر ماموریت و هر مرحله کوئست می‌تواند Points، Tokens یا هر دو را پرداخت کند.
  - ماموریت‌های بازی‌ها: توکن اختصاصی همان بازی را می‌دهند (بنفش / `Purple/400`).
  - ماموریت‌های پلتفرمی: توکن پلتفرم را می‌دهند (طلایی / `Amber/400`).
- **نحوه مطالبه پاداش**: دکمه‌های Claim دستی و Claim all. پاداش‌های مطالبه‌نشده با فرا رسیدن زمان بازنشانی منقضی می‌شوند (MVP rule مصوب ۱۱ اکتبر).
- **کوئست‌ها (Quests)**: شامل ۳ تا ۵ مرحله ترتیبی با تاریخ پایان مشخص؛ همواره دارای پاداش نهایی (Final Reward) هستند؛ پاداش مراحل میانی اختیاری است (هیچ/برخی/همه مراحل بر اساس تنظیمات ادمین)؛ با ثبت اولین رویداد مرحله ۱ خودکار فعال می‌شوند؛ مرحله بعدی با اتمام مرحله قبلی باز می‌شود.
- **محاسبه پیشرفت**: صرفاً از طریق رویدادهای ارسالی SDK بازی‌های P2E ثبت می‌شود.
- **پشتیبانی**: ارجاع به صفحه P12 (New Ticket) با فیلد `Section = Missions`.

#### ۳. ماشین حالات (State Machine)
- **حالات ماموریت (Mission States)**:
  - `Not started` → `In progress` → `Ready to claim` → `Claimed` → `Expired`
- **حالات کوئست (Quest States)**:
  - `Starting soon` → `New` → `In progress` → `All steps done (claim)` → `Completed` → `Ended (not finished)`
- **حالات مرحله کوئست (Step States)**:
  - `Locked` → `Current` → `Done (claim)` → `Claimed` → `Done (no reward)` → `Expired` → `Not finished`

#### ۴. قوانین دسته‌بندی‌های ماموریت (Decided 31 Oct)
- **دسته‌بندی‌های پنج‌گانه**: Games · Apps · QA · Surveys · Platform. کوئست‌ها هرگز دسته‌بندی‌ها را با هم ترکیب نمی‌کنند.
- **شرایط عضویت (Eligibility)**: کاربر هرگز نسخه قفل‌شده ماموریتی که واجد شرایط آن نیست را نمی‌بیند (پنهان‌سازی کامل بدون نسخه Disabled).
- **محدودیت‌ها (Limits & Budgets)**: عمدتاً برای تست‌های QA و پرسشنامه‌ها با ظرفیت محدود (Spots) یا بودجه سقف Points اعمال می‌شود.
- **قوانین درآمدی تست بازی‌ها (QA Rules)**:
  - پاداش تضمینی پایه (Minimum reward) پس از تایید حداقل یک گزارش باگ معتبر تعلق می‌گیرد.
  - مبلغ مشخص تضمینی به ازای هر باگ تاییدشده.
  - سازنده بازی می‌تواند پاداش اضافه سفارشی (Custom Bonus) برای باگ‌های حیاتی (Critical) تعیین کند که از کیف پول امتیازات توسعه‌دهنده کسر می‌شود.
- **اپلیکیشن‌ها (Apps)**: هر اقدام (نصب، باز کردن، ثبت نام، رسیدن به لول مشخص) یک ماموریت مجزاست که توسط SDK شریک تایید می‌شود. مهلت تایید هر مرحله ۴۸ ساعت است و در صورت عدم ارسال رویداد، وضعیت به `Not confirmed` تغییر می‌کند.
- **حل اختلاف باگ‌ها (Disputes Rule)**:
  - بازیکن می‌تواند گزارش باگ ردشده (Rejected) را ظرف مدت ۷ روز یک‌بار اعتراض کند.
  - سقف حداکثر ۳ تیکت حل اختلاف باز برای هر تست مجاز است.
  - در صورت تایید اختلاف توسط P2E، پاداش تضمینی از محل ودیعه توسعه‌دهنده پرداخت می‌شود. اعتراضات تاییدشده مکرر باعث تعلیق تست‌های توسعه‌دهنده خواهد شد.

### ۲.۲. سوالات و ابهامات باز ثبت‌شده توسط دیزاینر (Open Questions)
چهار سوال کلیدی هنوز در انتظار تایید نهایی تیم مدیریت محصول هستند:
1. **پاداش ماموریت‌ها**: آیا همه ماموریت‌ها باید ترکیب Points + Tokens بدهند یا ماموریت‌هایی با پاداش صرفاً Token نیز مجاز است؟
2. **پاداش‌های مطالبه‌نشده**: آیا پاداش‌های باز در زمان Reset حتماً منقضی شوند یا قابلیت واریز خودکار (Auto-Claim) داشته باشند؟
3. **شروع کوئست‌ها**: آیا شروع کوئست‌ها صددرصد خودکار باشد یا نیاز به زدن دکمه "Start" توسط کاربر وجود دارد؟
4. **تعداد ماموریت‌های فعال**: سقف استاندارد ماموریت‌ها برای هر کاربر چه تعداد است؟ (طرح فعلی ۵ ماموریت روزانه و ۳ ماموریت هفتگی را نمایش می‌دهد).

### ۲.۳. تناقضات، نواقص و باگ‌های فیگما (Figma Errata)
1. **تکثیر شدید پس‌زمینه‌های منجمد (Massive Backdrop Duplication)**: در تمام شیت‌ها و دیالوگ‌ها (۳۸ فریم از ۶۲ فریم!)، دیزاینر کل درخت لایه‌های صفحه والد را در کانتینر `Body/Content` تکرار کرده و یک مستطیل `Scrim` روی آن قرار داده است. در زمان پیاده‌سازی فلاتر، این فریم‌ها تنها باید شامل ویجت درونی `BottomSheet` یا `AppDialog` باشند.
2. **خطای شماره‌گذاری در عنوان کپشن‌ها (Caption Title Inconsistencies)**: دیزاینر در زمان ویرایش وایرفریم‌ها، شماره فریم‌ها را در بوم جابجا کرده اما متن عنوان داخل برخی فریم‌های کپشن را به‌روزرسانی نکرده است:
   - کپشن فریم `M17`: در متن کپشن نوشته شده `M04 · Game missions filters · bottom sheet`.
   - کپشن فریم `M21`: در متن کپشن نوشته شده `M20 · App detail · downloadable · installed`.
   - کپشن فریم `M23`: در متن کپشن نوشته شده `M21 · App detail · not installed / downloading`.
   - کپشن فریم `M41`: در متن کپشن نوشته شده `M40 · Bug report detail + developer thread`.
   - کپشن فریم `M42`: در متن کپشن نوشته شده `M41 · Bug report detail · rejected, can dispute`.
   - کپشن فریم `M45`: در متن کپشن نوشته شده `M43 · Bug report detail · disputed, P2E reviewing`.
   - کپشن فریم `M58`: در متن کپشن نوشته شده `M39 · Platform mission detail · Invite 3 friends`.
   - *ارجاع مهندسی*: نام و شماره فریم روی کانواس فیگما (مانند M17، M21، M41) ملاک قطعی است.
3. **ناهماهنگی در نامگذاری کارت‌ها**: کارت‌های اپلیکیشن با نام `Card / Partner App` نامگذاری شده‌اند در حالی که کارت‌های دیگر `Mission Card / ...` هستند. هر دو از نظر ساختار کالبدی معادل واریانت‌های مختلف یک کامپوننت پایه هستند.

---

## ۳. استخراج فریم به فریم المان‌ها (Frame-by-Frame Inventory)

در این بخش، کلیه ۶۲ فریم سکشن به تفکیک ردیف‌های ۹‌گانه رسمی کالبدشکافی شده‌اند:

### ردیف ۱: تب ماموریت‌ها و بخش اختصاصی کاربر (Row 1 · Missions tab · For you)

#### M01 — M01 · Missions tab · For you · category grid (Expand)
- **Node ID**: [`1:11022`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11022&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11022&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 2513 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 55 اینستنس رسمی · 162 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11024)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11026)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11032)
  - `[Instance]` **Fill / Stadia Controller** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11039)
  - `[Instance]` **Outline / Chevron Right** (تعداد: 5) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11041)
  - `[Instance]` **Icon / Token** (تعداد: 11) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11046)
  - `[Instance]` **Fill / Check** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11049)
  - `[Instance]` **Fill / Download** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11054)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Category Grid** — [شناسه 1:11033](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11033)
  - `[Pattern]` **Grid** — [شناسه 1:11035](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11035)
  - `[Pattern]` **Category Tile / Games** — [شناسه 1:11036](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11036)
  - `[Pattern]` **Category Tile / Apps** — [شناسه 1:11051](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11051)
  - `[Pattern]` **Category Tile / QA** — [شناسه 1:11066](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11066)
  - `[Pattern]` **Category Tile / Surveys** — [شناسه 1:11078](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11078)
  - `[Pattern]` **Category Tile / Platform** — [شناسه 1:11090](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11090)
  - `[Pattern]` **Banner / 2 rewards ready to claim** — [شناسه 1:11103](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11103)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15619):
  > M01 · Missions tab · For you · category  
  > Opened by  
  > Missions in the navigator bar · Go to Mi  
  > Buttons on this screen  
  > Category tile  
  > →  M15 Games · M18 Apps · M23 QA · M30 S  
  > Claim all (banner)  
  > →  M07  
  > Claim on a card  
  > →  M06 (error: M08)  
  > Quest card  
  > →  M11 (or M12 when all steps done)  
  > Pending app card  
  > →  M21  
  > QA Join / Survey Start  
  > →  M25 / M32  
  > Filters  
  > →  M03  
  > History  
  > →  M40  
  > State rule  
  > No Missions/Quests tabs and no category

#### M02 — M02 · Missions tab · For you · all done (Expand)
- **Node ID**: [`1:7471`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7471&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7471&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1635 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 39 اینستنس رسمی · 86 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7473)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7475)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7481)
  - `[Instance]` **Fill / Stadia Controller** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7488)
  - `[Instance]` **Outline / Chevron Right** (تعداد: 5) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7490)
  - `[Instance]` **Icon / Token** (تعداد: 10) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7495)
  - `[Instance]` **Fill / Check** (تعداد: 8) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7498)
  - `[Instance]` **Fill / Download** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7503)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Category Grid** — [شناسه 1:7482](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7482)
  - `[Pattern]` **Grid** — [شناسه 1:7484](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7484)
  - `[Pattern]` **Category Tile / Games** — [شناسه 1:7485](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7485)
  - `[Pattern]` **Category Tile / Apps** — [شناسه 1:7500](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7500)
  - `[Pattern]` **Category Tile / QA** — [شناسه 1:7515](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7515)
  - `[Pattern]` **Category Tile / Surveys** — [شناسه 1:7527](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7527)
  - `[Pattern]` **Category Tile / Platform** — [شناسه 1:7539](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7539)
  - `[Pattern]` **Empty State / All done** — [شناسه 1:7557](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7557)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15650):
  > M02 · Missions tab · For you · all done  
  > Opened by  
  > M01 when nothing is left to do or claim  
  > Buttons on this screen  
  > Category tile  
  > →  That category&#39;s screen  
  > Claimed card  
  > →  M04 read only  
  > History  
  > →  M40  
  > State rule  
  > The grid stays so players can still reac

#### M03 — M03 · Missions filters · all categories · sheet
- **Node ID**: [`1:13240`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13240&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13240&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:13567`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13567)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 24 اینستنس رسمی · 40 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13571)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13575)
  - `[Instance]` **Fill / Check** (تعداد: 20) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13580)
  - `[Instance]` **Button / Reset** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13663)
  - `[Instance]` **Button / Show 14 missions** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13664)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:13569](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13569)
  - `[Pattern]` **Chips** — [شناسه 1:13578](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13578)
  - `[Pattern]` **Chips** — [شناسه 1:13596](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13596)
  - `[Pattern]` **Chips** — [شناسه 1:13608](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13608)
  - `[Pattern]` **Group / Reward** — [شناسه 1:13621](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13621)
  - `[Pattern]` **Chips** — [شناسه 1:13623](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13623)
  - `[Pattern]` **Chips** — [شناسه 1:13635](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13635)
  - `[Pattern]` **Chips** — [شناسه 1:13652](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13652)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15666):
  > M03 · For you filters  
  > Opened by  
  > Filters on M01  
  > Buttons on this screen  
  > Chips  
  > →  Toggle; at least one per group  
  > Show N missions  
  > →  Apply, back to M01 with a count on th  
  > Reset  
  > →  All categories, all types, Full off,  
  > State rule  
  > Missions the player can&#39;t join are never

#### M04 — M04 · Mission detail · in progress · bottom sheet
- **Node ID**: [`1:8179`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8179&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8179&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:8506`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8506)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 9 اینستنس رسمی · 16 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Stadia Controller** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8510)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8514)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8522)
  - `[Instance]` **Icon / Token** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8531)
  - `[Instance]` **Fill / Check** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8537)
  - `[Instance]` **Button / Play Block Blast** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8545)
  - `[Instance]` **Outline / Help** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8547)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:8508](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8508)
  - `[Pattern]` **Progress** — [شناسه 1:8515](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8515)
  - `[Pattern]` **Track** — [شناسه 1:8519](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8519)
  - `[Pattern]` **Reward Tiles** — [شناسه 1:8525](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8525)
  - `[Pattern]` **Tile / Points** — [شناسه 1:8526](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8526)
  - `[Pattern]` **Tile / Tokens** — [شناسه 1:8529](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8529)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15682):
  > M04 · Mission detail · in progress  
  > Opened by  
  > A mission card (in progress or not start  
  > Buttons on this screen  
  > Play / Go  
  > →  Game page or the screen the mission n  
  > Report a problem  
  > →  P12 New ticket · Section: Missions  
  > X / swipe down / scrim  
  > →  close  
  > State rule  
  > Not started shows 0 progress with the sa

#### M05 — M05 · Mission detail · ready to claim · bottom sheet
- **Node ID**: [`1:8549`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8549&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8549&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:8876`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8876)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 6 اینستنس رسمی · 12 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Stadia Controller** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8880)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8884)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8888)
  - `[Instance]` **Icon / Token** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8900)
  - `[Instance]` **Button / Claim reward** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8903)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8905)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:8878](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8878)
  - `[Pattern]` **Progress** — [شناسه 1:8885](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8885)
  - `[Pattern]` **Track** — [شناسه 1:8891](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8891)
  - `[Pattern]` **Reward Tiles** — [شناسه 1:8894](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8894)
  - `[Pattern]` **Tile / Points** — [شناسه 1:8895](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8895)
  - `[Pattern]` **Tile / Tokens** — [شناسه 1:8898](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8898)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15698):
  > M05 · Mission detail · ready to claim  
  > Opened by  
  > A ready card on M01 or any category scre  
  > Buttons on this screen  
  > Claim reward  
  > →  M06 (error: M08)  
  > X / swipe down / scrim  
  > →  close  
  > State rule  
  > If the period ends before Claim, the mis

#### M06 — M06 · Reward claimed · dialog
- **Node ID**: [`1:8907`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8907&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8907&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: دیالوگ مودال (Modal Dialog)
- **کانتینر فعال مودال**: `Dialog` (شناسه [`1:9234`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9234)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 5 اینستنس رسمی · 10 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9236)
  - `[Instance]` **Icon / Token** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9245)
  - `[Instance]` **Button / Done** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9258)
  - `[Instance]` **Button / See Block Blast board** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9259)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Reward Tiles** — [شناسه 1:9239](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9239)
  - `[Pattern]` **Tile / Points** — [شناسه 1:9240](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9240)
  - `[Pattern]` **Tile / Tokens** — [شناسه 1:9243](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9243)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15711):
  > M06 · Reward claimed · dialog  
  > Opened by  
  > Claim on any card · Claim reward on M05  
  > Buttons on this screen  
  > Done  
  > →  back; the card turns Claimed  
  > See board  
  > →  L08 for game Tokens · L01 for platfor  
  > State rule  
  > Points land in the Wallet and Tokens cou

#### M07 — M07 · Claim all · summary dialog
- **Node ID**: [`1:9260`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9260&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9260&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: دیالوگ مودال (Modal Dialog)
- **کانتینر فعال مودال**: `Dialog` (شناسه [`1:9587`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9587)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 11 اینستنس رسمی · 15 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9589)
  - `[Instance]` **Fill / Check** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9593)
  - `[Instance]` **Icon / Token** (تعداد: 5) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9598)
  - `[Instance]` **Button / Done** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9626)
  - `[Instance]` **Button / See leaderboard** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9627)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Reward** — [شناسه 1:9595](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9595)
  - `[Pattern]` **Reward** — [شناسه 1:9603](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9603)
  - `[Pattern]` **Reward** — [شناسه 1:9611](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9611)
  - `[Pattern]` **Reward** — [شناسه 1:9618](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9618)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15724):
  > M07 · Claim all · summary dialog  
  > Opened by  
  > Claim all on the M01 banner (2 or more r  
  > Buttons on this screen  
  > Done  
  > →  M01, or M02 if nothing is left  
  > See leaderboard  
  > →  L01  
  > State rule  
  > Claims every ready reward across categor

#### M08 — M08 · Claim failed · dialog
- **Node ID**: [`1:9628`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9628&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9628&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: دیالوگ مودال (Modal Dialog)
- **کانتینر فعال مودال**: `Dialog` (شناسه [`1:9955`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9955)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 3 اینستنس رسمی · 2 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Warning** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9957)
  - `[Instance]` **Button / Try again** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9962)
  - `[Instance]` **Button / Contact support** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9963)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Error code** — [شناسه 1:9960](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9960)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9964):
  > M08 · Claim failed · dialog  
  > Opened by  
  > A claim error on M01, M06, M08, M11 or M  
  > Buttons on this screen  
  > Try again  
  > →  claims again → M07 / M08 on success  
  > Contact support  
  > →  P12 New ticket · Section: Missions (e  
  > Scrim  
  > →  close; reward stays ready  
  > State rule  
  > A failed claim never takes the reward aw

#### M09 — M09 · Missions tab · couldn’t load
- **Node ID**: [`1:10640`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10640&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10640&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 7 اینستنس رسمی · 31 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10642)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10644)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10650)
  - `[Instance]` **Fill / Warning** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10653)
  - `[Instance]` **Button / Try again** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10656)
  - `[Instance]` **Outline / Help** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10658)
  - `[Instance]` **Navigator Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10682)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Error State** — [شناسه 1:10651](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10651)
  - `[Pattern]` **Track** — [شناسه 1:10666](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10666)
  - `[Pattern]` **Track** — [شناسه 1:10673](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10673)
  - `[Pattern]` **Track** — [شناسه 1:10680](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10680)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15737):
  > M09 · Missions tab · couldn&#39;t load  
  > Opened by  
  > Missions tab or a category screen when t  
  > Buttons on this screen  
  > Try again  
  > →  reloads → M01 or that category  
  > Contact support  
  > →  P12 New ticket · Section: Missions  
  > State rule  
  > While loading, skeleton cards show witho

#### M10 — M10 · How missions & quests work · bottom sheet
- **Node ID**: [`1:10272`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10272&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10272&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:10599`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10599)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 8 اینستنس رسمی · 19 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Help** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10603)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10607)
  - `[Instance]` **Fill / Calendar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10611)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10617)
  - `[Instance]` **Fill / Workspace Premium 1** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10623)
  - `[Instance]` **Icon / Token** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10629)
  - `[Instance]` **Fill / Verified** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10635)
  - `[Instance]` **Button / Got it** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10639)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:10601](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10601)
  - `[Pattern]` **Rule / Rewards** — [شناسه 1:10627](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10627)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15750):
  > M10 · How missions & quests work · sheet  
  > Opened by  
  > How missions work on M01 · Quest rules o  
  > Buttons on this screen  
  > Got it / X / swipe down  
  > →  close

### ردیف ۲: کوئست‌ها و مراحل زنجیره‌ای (Row 2 · Quests & Step Progress)

#### M11 — M11 · Quest detail · in progress (Expand)
- **Node ID**: [`1:9980`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9980&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9980&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1103 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 16 اینستنس رسمی · 50 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9982)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9984)
  - `[Instance]` **Fill / Workspace Premium 1** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9989)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9995)
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10009)
  - `[Instance]` **Icon / Token** (تعداد: 4) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10015)
  - `[Instance]` **Fill / Check** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10021)
  - `[Instance]` **Button / Claim** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10037)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Quest Hero** — [شناسه 1:9986](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-9986)
  - `[Pattern]` **Steps** — [شناسه 1:10001](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10001)
  - `[Pattern]` **Step 1** — [شناسه 1:10002](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10002)
  - `[Pattern]` **Step 2** — [شناسه 1:10003](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10003)
  - `[Pattern]` **Step 3** — [شناسه 1:10004](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10004)
  - `[Pattern]` **Step 4** — [شناسه 1:10005](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10005)
  - `[Pattern]` **Step 5** — [شناسه 1:10006](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10006)
  - `[Pattern]` **Final Reward** — [شناسه 1:10007](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10007)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15758):
  > M11 · Quest detail · in progress  
  > Opened by  
  > A quest card on M01 or any category scre  
  > Buttons on this screen  
  > Back  
  > →  the list it was opened from  
  > Claim (rewarded step)  
  > →  M06 · error M08  
  > Current step row  
  > →  M04 (shows step progress)  
  > Play  
  > →  the game or screen the step needs  
  > Quest rules  
  > →  M10  
  > Report a problem  
  > →  P12 New ticket · Section: Missions  
  > State rule  
  > Quests are listed among missions with a

#### M12 — M12 · Quest detail · all steps done, claim final reward (Expand)
- **Node ID**: [`1:10081`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10081&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10081&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1059 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 13 اینستنس رسمی · 36 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10083)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10085)
  - `[Instance]` **Fill / Workspace Premium 1** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10090)
  - `[Instance]` **Fill / Timer** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10096)
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10109)
  - `[Instance]` **Icon / Token** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10114)
  - `[Instance]` **Button / Claim quest reward** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10116)
  - `[Instance]` **Fill / Check** (تعداد: 4) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10124)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Quest Hero** — [شناسه 1:10087](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10087)
  - `[Pattern]` **Steps** — [شناسه 1:10102](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10102)
  - `[Pattern]` **Step 1** — [شناسه 1:10103](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10103)
  - `[Pattern]` **Step 2** — [شناسه 1:10104](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10104)
  - `[Pattern]` **Step 3** — [شناسه 1:10105](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10105)
  - `[Pattern]` **Step 4** — [شناسه 1:10106](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10106)
  - `[Pattern]` **Final Reward (ready)** — [شناسه 1:10107](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10107)
  - `[Pattern]` **Reward** — [شناسه 1:10111](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10111)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15783):
  > M12 · Quest detail · all steps done  
  > Opened by  
  > A quest card with every step done · Clai  
  > Buttons on this screen  
  > Claim quest reward  
  > →  M13 (error: M08)  
  > Back  
  > →  the list it was opened from  
  > State rule  
  > Shows when every step is done and every

#### M13 — M13 · Quest complete · reward claimed
- **Node ID**: [`1:10154`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10154&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10154&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 8 اینستنس رسمی · 15 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10156)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10158)
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10161)
  - `[Instance]` **Icon / Token** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10170)
  - `[Instance]` **Button / Find a new quest** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10183)
  - `[Instance]` **Button / See Snake Rush board** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10184)
  - `[Instance]` **Navigator Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10186)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Reward Tiles** — [شناسه 1:10164](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10164)
  - `[Pattern]` **Tile / Points** — [شناسه 1:10165](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10165)
  - `[Pattern]` **Tile / Tokens** — [شناسه 1:10168](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10168)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15796):
  > M13 · Quest complete · reward claimed  
  > Opened by  
  > Claim quest reward on M12 · Claim on a r  
  > Buttons on this screen  
  > Find a new quest  
  > →  M01 (For you)  
  > See board  
  > →  L08 game board · L01 platform board  
  > State rule  
  > The quest moves to History (M40) as Comp

#### M14 — M14 · Quest detail · ended, not finished (Expand)
- **Node ID**: [`1:10189`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10189&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10189&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1045 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 13 اینستنس رسمی · 41 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10191)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10193)
  - `[Instance]` **Fill / Workspace Premium 1** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10198)
  - `[Instance]` **Fill / Calendar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10204)
  - `[Instance]` **Fill / Warning** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10214)
  - `[Instance]` **Fill / Check** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10222)
  - `[Instance]` **Icon / Token** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10236)
  - `[Instance]` **Fill / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10240)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Quest Hero** — [شناسه 1:10195](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10195)
  - `[Pattern]` **Steps** — [شناسه 1:10207](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10207)
  - `[Pattern]` **Step 1** — [شناسه 1:10208](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10208)
  - `[Pattern]` **Step 2** — [شناسه 1:10209](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10209)
  - `[Pattern]` **Step 3** — [شناسه 1:10210](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10210)
  - `[Pattern]` **Step 4** — [شناسه 1:10211](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10211)
  - `[Pattern]` **Step 5** — [شناسه 1:10212](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10212)
  - `[Pattern]` **Banner / This quest has ended** — [شناسه 1:10213](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10213)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15809):
  > M14 · Quest detail · ended, not finished  
  > Opened by  
  > An ended quest row in M40 · a quest open  
  > Buttons on this screen  
  > Find a new quest  
  > →  M01  
  > Back  
  > →  the list or M40  
  > State rule  
  > Read only. Claimed step rewards stay; do

### ردیف ۳: ماموریت‌های بازی‌ها و فیلترها (Row 3 · Games Category & Missions)

#### M15 — M15 · Games category · For you (Expand)
- **Node ID**: [`1:7664`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7664&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7664&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1769 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 42 اینستنس رسمی · 108 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7666)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7668)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7674)
  - `[Instance]` **Fill / Star** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7679)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7684)
  - `[Instance]` **Fill / Stadia Controller** (تعداد: 12) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7688)
  - `[Instance]` **Button / View** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7689)
  - `[Instance]` **Outline / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7701)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Campaign Banner** — [شناسه 1:7675](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7675)
  - `[Pattern]` **Carousel dots** — [شناسه 1:7690](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7690)
  - `[Pattern]` **Game Filter Chips** — [شناسه 1:7695](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7695)
  - `[Pattern]` **Quest Card / Games / Block Blast Master** — [شناسه 1:7706](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7706)
  - `[Pattern]` **Tag / Step 3 of 5** — [شناسه 1:7721](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7721)
  - `[Pattern]` **Reward** — [شناسه 1:7726](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7726)
  - `[Pattern]` **Track** — [شناسه 1:7731](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7731)
  - `[Pattern]` **Mission Card / Score 500 in Block Blast (progress)** — [شناسه 1:7742](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7742)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15822):
  > M15 · Games category · For you  
  > Opened by  
  > Games tile on M01 / M02 · Show missions  
  > Buttons on this screen  
  > Campaign · View  
  > →  H05 Campaign detail  
  > See all games  
  > →  M16  
  > Filters  
  > →  M17  
  > Mission card  
  > →  M04 / M05  
  > Claim  
  > →  M06 (error: M08)  
  > Quest card  
  > →  M11  
  > Play / Try  
  > →  that game&#39;s page  
  > State rule  
  > Campaign banner carousel on top: one sli

#### M16 — M16 · Games category · All games (Expand)
- **Node ID**: [`1:10724`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10724&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10724&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1175 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 27 اینستنس رسمی · 69 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10726)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10728)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 10) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10734)
  - `[Instance]` **Fill / Star** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10739)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10744)
  - `[Instance]` **Fill / Stadia Controller** (تعداد: 10) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10748)
  - `[Instance]` **Button / View** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10749)
  - `[Instance]` **Outline / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10761)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Campaign Banner** — [شناسه 1:10735](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10735)
  - `[Pattern]` **Carousel dots** — [شناسه 1:10750](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10750)
  - `[Pattern]` **Game Filter Chips** — [شناسه 1:10755](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10755)
  - `[Pattern]` **Game Tile** — [شناسه 1:10765](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10765)
  - `[Pattern]` **Game Tile** — [شناسه 1:10775](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10775)
  - `[Pattern]` **Game Tile** — [شناسه 1:10788](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10788)
  - `[Pattern]` **Game Tile** — [شناسه 1:10796](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10796)
  - `[Pattern]` **Game Tile** — [شناسه 1:10806](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10806)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15850):
  > M16 · Games category · All games  
  > Opened by  
  > See all games on M15 · Show: All games o  
  > Buttons on this screen  
  > Campaign · View  
  > →  H05 Campaign detail  
  > Game row  
  > →  M15 filtered to that game  
  > Filters  
  > →  M17  
  > State rule  
  > Every game with at least one mission thi

#### M17 — M17 · Game missions filters · bottom sheet
- **Node ID**: [`1:7890`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7890&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-7890&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:8117`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8117)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 6 اینستنس رسمی · 32 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8121)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8125)
  - `[Instance]` **Outline / Stadia Controller** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8140)
  - `[Instance]` **Fill / Arrow Drop Down** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8142)
  - `[Instance]` **Button / Reset** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8177)
  - `[Instance]` **Button / Show 6 missions** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8178)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:8119](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8119)
  - `[Pattern]` **Chips** — [شناسه 1:8128](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8128)
  - `[Pattern]` **Chips** — [شناسه 1:8145](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8145)
  - `[Pattern]` **Chips** — [شناسه 1:8154](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8154)
  - `[Pattern]` **Option / Ready to claim first (selected)** — [شناسه 1:8166](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8166)
  - `[Pattern]` **Option / Ending soonest** — [شناسه 1:8170](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8170)
  - `[Pattern]` **Option / Biggest reward** — [شناسه 1:8173](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-8173)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-10699):
  > M04 · Game missions filters · bottom she  
  > Opened by  
  > Filters on M03 / M18 (a count badge on t  
  > Buttons on this screen  
  > Show: For you / All games  
  > →  M03 / M18  
  > Show: Your games or Suggested  
  > →  M03 with only that section  
  > Game select  
  > →  game picker list (your games first)  
  > Show N missions  
  > →  applies, back to M03 / M18  
  > Reset  
  > →  back to defaults  
  > X / swipe down / scrim  
  > →  close without applying  
  > State rule  
  > Defaults: For you · any game · all types

#### M18 — M18 · Game picker · sheet
- **Node ID**: [`1:16381`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16381&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16381&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:16608`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16608)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 10 اینستنس رسمی · 22 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Stadia Controller** (تعداد: 7) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16612)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16616)
  - `[Instance]` **Outline / Image Search** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16618)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16627)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:16610](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16610)
  - `[Pattern]` **Game Option / Any game** — [شناسه 1:16621](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16621)
  - `[Pattern]` **Game Option / Block Blast** — [شناسه 1:16628](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16628)
  - `[Pattern]` **Game Option / Bubble Pop** — [شناسه 1:16634](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16634)
  - `[Pattern]` **Game Option / Snake Rush** — [شناسه 1:16640](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16640)
  - `[Pattern]` **Game Option / Tower Stack** — [شناسه 1:16647](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16647)
  - `[Pattern]` **Game Option / Jelly Jump** — [شناسه 1:16653](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16653)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17984):
  > M18 · Game picker · sheet  
  > Opened by  
  > Game on the Games filters (M17)  
  > Buttons on this screen  
  > Any game / a game row  
  > →  selects it, back to M17  
  > Search  
  > →  filters the list as you type  
  > X / swipe down  
  > →  back to M17 without changing  
  > State rule  
  > Your games first (played in the last 30

### ردیف ۴: اپلیکیشن‌های شرکا و فرآیند تایید (Row 4 · Apps Category & Partner Tasks)

#### M19 — M19 · Apps category · list (Expand)
- **Node ID**: [`1:13042`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13042&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13042&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1617 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 28 اینستنس رسمی · 98 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13044)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13046)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13052)
  - `[Instance]` **Fill / Star** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13057)
  - `[Instance]` **Fill / Timer** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13062)
  - `[Instance]` **Fill / Download** (تعداد: 8) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13066)
  - `[Instance]` **Button / View** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13067)
  - `[Instance]` **Outline / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13080)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Campaign Banner** — [شناسه 1:13053](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13053)
  - `[Pattern]` **Carousel dots** — [شناسه 1:13068](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13068)
  - `[Pattern]` **Banner / Try partner apps, earn per step** — [شناسه 1:13071](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13071)
  - `[Pattern]` **Card / Partner App (claim)** — [شناسه 1:13084](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13084)
  - `[Pattern]` **Reward** — [شناسه 1:13098](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13098)
  - `[Pattern]` **Track** — [شناسه 1:13100](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13100)
  - `[Pattern]` **Card / Partner App (progress)** — [شناسه 1:13104](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13104)
  - `[Pattern]` **Reward** — [شناسه 1:13121](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13121)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16261):
  > M19 · Apps category · list  
  > Opened by  
  > Apps tile on M01, Home, or a campaign pa  
  > Buttons on this screen  
  > Campaign · View  
  > →  H05 Campaign detail  
  > Claim  
  > →  M06  
  > Download (new app)  
  > →  M21 (download starts in P2E)  
  > Open (web app)  
  > →  web app opens inside P2E  
  > Open (your app) / card  
  > →  M20 or M22  
  > Retry  
  > →  M24  
  > Filters  
  > →  M19  
  > State rule  
  > Apps work like games: downloadable apps

#### M20 — M20 · Apps filters · sheet
- **Node ID**: [`1:14481`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14481&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14481&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:14669`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14669)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 14 اینستنس رسمی · 30 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14673)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14677)
  - `[Instance]` **Fill / Check** (تعداد: 10) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14682)
  - `[Instance]` **Button / Reset** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14736)
  - `[Instance]` **Button / Show 5 apps** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14737)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:14671](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14671)
  - `[Pattern]` **Chips** — [شناسه 1:14680](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14680)
  - `[Pattern]` **Chips** — [شناسه 1:14694](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14694)
  - `[Pattern]` **Group / Step type** — [شناسه 1:14701](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14701)
  - `[Pattern]` **Chips** — [شناسه 1:14703](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14703)
  - `[Pattern]` **Group / Reward** — [شناسه 1:14716](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14716)
  - `[Pattern]` **Chips** — [شناسه 1:14718](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14718)
  - `[Pattern]` **Chips** — [شناسه 1:14727](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14727)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16289):
  > M20 · Apps filters · sheet  
  > Opened by  
  > Filters on M19  
  > Buttons on this screen  
  > Show N apps  
  > →  apply, back to M18  
  > Reset  
  > →  New + Your apps + Ready to claim, bot  
  > State rule  
  > App type = Downloadable (installed from

#### M21 — M21 · App detail · downloadable · installed (Expand)
- **Node ID**: [`1:12158`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12158&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12158&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 947 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 20 اینستنس رسمی · 40 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12160)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12162)
  - `[Instance]` **Fill / Download** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12167)
  - `[Instance]` **Fill / Star** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12179)
  - `[Instance]` **Button / Open** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12182)
  - `[Instance]` **Fill / Verified** (تعداد: 4) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12184)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12189)
  - `[Instance]` **Button / Claim** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12195)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:12164](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12164)
  - `[Pattern]` **Reward** — [شناسه 1:12193](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12193)
  - `[Pattern]` **Reward** — [شناسه 1:12202](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12202)
  - `[Pattern]` **Reward** — [شناسه 1:12216](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12216)
  - `[Pattern]` **Reward** — [شناسه 1:12228](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12228)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16302):
  > M20 · App detail · downloadable · instal  
  > Opened by  
  > An installed app card on M18 or M01, a c  
  > Buttons on this screen  
  > Open  
  > →  launches the installed app  
  > Claim  
  > →  M06  
  > Pending step  
  > →  M23  
  > Open app (step)  
  > →  deep link into the app  
  > Update (new version)  
  > →  deep link into the app  
  > State rule  
  > Main button follows the game page: Downl

#### M22 — M22 · App detail · update available (Expand)
- **Node ID**: [`1:16659`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16659&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16659&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1013 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 21 اینستنس رسمی · 41 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16661)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16663)
  - `[Instance]` **Fill / Download** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16668)
  - `[Instance]` **Fill / Star** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16680)
  - `[Instance]` **Fill / Warning** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16683)
  - `[Instance]` **Button / Update · 12 MB** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16686)
  - `[Instance]` **Fill / Cloud Download** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16688)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16693)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:16665](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16665)
  - `[Pattern]` **Reward** — [شناسه 1:16697](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16697)
  - `[Pattern]` **Reward** — [شناسه 1:16706](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16706)
  - `[Pattern]` **Reward** — [شناسه 1:16720](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16720)
  - `[Pattern]` **Reward** — [شناسه 1:16732](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16732)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18000):
  > M22 · App detail · update available  
  > Opened by  
  > An installed app that has a newer versio  
  > Buttons on this screen  
  > Update · 12 MB  
  > →  updates inside P2E, then back to M21  
  > Claim  
  > →  M06  
  > State rule  
  > Open-app steps are paused while the inst

#### M23 — M23 · App detail · downloadable · not installed / downloading (Expand)
- **Node ID**: [`1:16087`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16087&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16087&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1023 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 16 اینستنس رسمی · 41 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16089)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16091)
  - `[Instance]` **Fill / Download** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16096)
  - `[Instance]` **Fill / Star** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16108)
  - `[Instance]` **Button / Downloading · 62%  ·  Cancel** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16113)
  - `[Instance]` **Fill / Downloading** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16115)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16122)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16130)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:16093](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16093)
  - `[Pattern]` **Reward** — [شناسه 1:16126](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16126)
  - `[Pattern]` **Reward** — [شناسه 1:16134](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16134)
  - `[Pattern]` **Reward** — [شناسه 1:16145](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16145)
  - `[Pattern]` **Reward** — [شناسه 1:16156](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16156)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16324):
  > M21 · App detail · not installed / downl  
  > Opened by  
  > Download on M18, or a new app card on M0  
  > Buttons on this screen  
  > Download · 38 MB  
  > →  starts the download inside P2E  
  > Cancel  
  > →  stops the download, button back to Do  
  > Steps after Install  
  > →  locked until installed  
  > Download fails  
  > →  locked until installed  
  > State rule  
  > Install completes when the package is in

#### M24 — M24 · App detail · download failed (Expand)
- **Node ID**: [`1:16750`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16750&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16750&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1037 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 16 اینستنس رسمی · 41 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16752)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16754)
  - `[Instance]` **Fill / Download** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16759)
  - `[Instance]` **Fill / Star** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16771)
  - `[Instance]` **Button / Try again** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16776)
  - `[Instance]` **Fill / Warning** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16778)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16785)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16793)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:16756](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16756)
  - `[Pattern]` **Reward** — [شناسه 1:16789](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16789)
  - `[Pattern]` **Reward** — [شناسه 1:16797](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16797)
  - `[Pattern]` **Reward** — [شناسه 1:16808](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16808)
  - `[Pattern]` **Reward** — [شناسه 1:16819](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16819)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18013):
  > M24 · App detail · download failed  
  > Opened by  
  > A download on M23 that stops (no connect  
  > Buttons on this screen  
  > Try again  
  > →  resumes from where it stopped → M23  
  > State rule  
  > Shows the % reached and the space needed

#### M25 — M25 · App detail · web app (Expand)
- **Node ID**: [`1:16173`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16173&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16173&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 933 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 20 اینستنس رسمی · 40 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16175)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16177)
  - `[Instance]` **Fill / Download** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16182)
  - `[Instance]` **Fill / Star** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16194)
  - `[Instance]` **Button / Open web app** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16197)
  - `[Instance]` **Fill / Verified** (تعداد: 4) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16199)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16204)
  - `[Instance]` **Button / Claim** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16210)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:16179](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16179)
  - `[Pattern]` **Reward** — [شناسه 1:16208](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16208)
  - `[Pattern]` **Reward** — [شناسه 1:16217](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16217)
  - `[Pattern]` **Reward** — [شناسه 1:16231](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16231)
  - `[Pattern]` **Reward** — [شناسه 1:16243](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16243)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16343):
  > M25 · App detail · web app  
  > Opened by  
  > A web app card on M19 or M01, a campaign  
  > Buttons on this screen  
  > Open web app  
  > →  opens inside P2E, signed in with P2E  
  > Claim  
  > →  M06  
  > Pending step  
  > →  M23  
  > State rule  
  > No download. The first step is &#39;Open the

#### M26 — M26 · Waiting for confirmation · sheet
- **Node ID**: [`1:12246`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12246&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12246&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:12335`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12335)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 9 اینستنس رسمی · 17 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Timer** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12339)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12343)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12347)
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12359)
  - `[Instance]` **Fill / Help** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12366)
  - `[Instance]` **Button / Open Partner App** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12371)
  - `[Instance]` **Button / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12372)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:12337](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12337)
  - `[Pattern]` **Timeline** — [شناسه 1:12344](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12344)
  - `[Pattern]` **Step / You opened Partner App** — [شناسه 1:12345](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12345)
  - `[Pattern]` **Step / Partner App sends the confirmation** — [شناسه 1:12351](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12351)
  - `[Pattern]` **Step / Reward ready to claim** — [شناسه 1:12357](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12357)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12373):
  > M26 · Waiting sheet  
  > Opened by  
  > Pending step or Pending tag on M32 / M19  
  > Buttons on this screen  
  > Open Partner App  
  > →  Deep link  
  > Close  
  > →  M32  
  > State rule  
  > Timer starts at the user&#39;s action. Count

#### M27 — M27 · Not confirmed · dialog
- **Node ID**: [`1:12386`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12386&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12386&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: دیالوگ مودال (Modal Dialog)
- **کانتینر فعال مودال**: `Dialog` (شناسه [`1:12475`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12475)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 4 اینستنس رسمی · 1 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Warning** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12477)
  - `[Instance]` **Button / Try again** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12480)
  - `[Instance]` **Button / Contact support** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12481)
  - `[Instance]` **Button / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12482)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12483):
  > M27 · Not confirmed  
  > Opened by  
  > 48 h passed with no SDK confirmation (pu  
  > Buttons on this screen  
  > Try again  
  > →  Restarts the 48 h window, once  
  > Contact support  
  > →  P12 New ticket (Section: Missions · A  
  > Close  
  > →  M32 (step shows Not confirmed)  
  > State rule  
  > Try again is allowed once per step. Afte

### ردیف ۵: فرصت‌های تست و ارزیابی کیفی بازی‌ها (Row 5 · QA Testing Opportunities & Join)

#### M28 — M28 · QA category · list (Expand)
- **Node ID**: [`1:11348`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11348&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11348&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1251 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 22 اینستنس رسمی · 77 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11350)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11352)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11358)
  - `[Instance]` **Fill / Star** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11363)
  - `[Instance]` **Fill / Timer** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11368)
  - `[Instance]` **Fill / Release Alert** (تعداد: 6) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11372)
  - `[Instance]` **Button / View** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11373)
  - `[Instance]` **Outline / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11384)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Campaign Banner** — [شناسه 1:11359](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11359)
  - `[Pattern]` **Carousel dots** — [شناسه 1:11374](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11374)
  - `[Pattern]` **Banner / How QA testing works** — [شناسه 1:11376](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11376)
  - `[Pattern]` **Mission Card / QA / Test Jelly Jump beta (progress)** — [شناسه 1:11388](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11388)
  - `[Pattern]` **Reward** — [شناسه 1:11408](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11408)
  - `[Pattern]` **Track** — [شناسه 1:11410](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11410)
  - `[Pattern]` **Mission Card / QA / Rocket Rush · new level pack (new)** — [شناسه 1:11417](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11417)
  - `[Pattern]` **Reward** — [شناسه 1:11437](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11437)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15866):
  > M28 · QA category · list  
  > Opened by  
  > QA tile on M01, or a QA card on Home / a  
  > Buttons on this screen  
  > Campaign · View  
  > →  H05 Campaign detail  
  > Active test · Open  
  > →  M26  
  > Open test · View  
  > →  M25  
  > Full test  
  > →  M25 (waitlist)  
  > Filters  
  > →  M24  
  > No open tests  
  > →  M24  
  > Active test card · Paused by P2E  
  > →  M24  
  > State rule  
  > Cards show spots left (orange under 10)

#### M29 — M29 · QA category · no open tests (Expand)
- **Node ID**: [`1:17055`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17055&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17055&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 651 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 7 اینستنس رسمی · 9 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17057)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17059)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17065)
  - `[Instance]` **Fill / Release Alert** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17068)
  - `[Instance]` **Button / Notify me about new tests** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17071)
  - `[Instance]` **Button / See your past tests** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17072)
  - `[Instance]` **Navigator Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17074)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Empty State** — [شناسه 1:17066](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17066)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18023):
  > M29 · QA category · no open tests  
  > Opened by  
  > QA tile on M01 when no test is open for  
  > Buttons on this screen  
  > Notify me about new tests  
  > →  turns on push for new tests that matc  
  > See your past tests  
  > →  M54 filtered to QA  
  > State rule  
  > Same empty-state pattern for every categ

#### M30 — M30 · QA filters · sheet
- **Node ID**: [`1:13973`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13973&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13973&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:14120`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14120)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 10 اینستنس رسمی · 30 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14124)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14128)
  - `[Instance]` **Fill / Check** (تعداد: 6) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14133)
  - `[Instance]` **Button / Reset** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14183)
  - `[Instance]` **Button / Show 3 tests** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14184)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:14122](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14122)
  - `[Pattern]` **Chips** — [شناسه 1:14131](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14131)
  - `[Pattern]` **Chips** — [شناسه 1:14144](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14144)
  - `[Pattern]` **Chips** — [شناسه 1:14154](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14154)
  - `[Pattern]` **Group / Reward** — [شناسه 1:14161](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14161)
  - `[Pattern]` **Chips** — [شناسه 1:14163](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14163)
  - `[Pattern]` **Chips** — [شناسه 1:14172](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14172)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14196):
  > M30 · QA filters  
  > Opened by  
  > Filters on M28 QA list.  
  > Buttons on this screen  
  > Show N tests  
  > →  Apply, back to M21  
  > Reset  
  > →  Open + Joined, my device&#39;s platform,  
  > State rule  
  > Platform defaults to the user&#39;s current

#### M31 — M31 · QA test detail · before joining (Expand)
- **Node ID**: [`1:11494`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11494&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11494&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1077 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 12 اینستنس رسمی · 36 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11496)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11498)
  - `[Instance]` **Fill / Release Alert** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11503)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11515)
  - `[Instance]` **Fill / Target Check** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11543)
  - `[Instance]` **Fill / Warning** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11555)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11576)
  - `[Instance]` **Button / Join test · 12 spots left** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11578)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:11500](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11500)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15894):
  > M31 · QA test detail · before joining  
  > Opened by  
  > An open test on M23 or M01, or a QA miss  
  > Buttons on this screen  
  > Join test  
  > →  M26 (spot reserved)  
  > Back  
  > →  M23  
  > Full: Join waitlist  
  > →  notify when a spot frees up  
  > State rule  
  > Join is disabled until the checkbox is t

#### M32 — M32 · QA test detail · full, on waitlist (Expand)
- **Node ID**: [`1:16836`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16836&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16836&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1143 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 13 اینستنس رسمی · 37 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16838)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16840)
  - `[Instance]` **Fill / Release Alert** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16845)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16857)
  - `[Instance]` **Fill / Notifications** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16860)
  - `[Instance]` **Fill / Target Check** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16888)
  - `[Instance]` **Fill / Warning** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16900)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16921)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:16842](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16842)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18036):
  > M32 · QA test detail · full, on waitlist  
  > Opened by  
  > Join waitlist on M31 when spots are 0  
  > Buttons on this screen  
  > Leave waitlist  
  > →  removes you; button back to Join wait  
  > State rule  
  > When a spot frees up the first person on

#### M33 — M33 · QA test · joined, in progress (Expand)
- **Node ID**: [`1:11579`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11579&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11579&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 881 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 11 اینستنس رسمی · 28 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11581)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11583)
  - `[Instance]` **Fill / Release Alert** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11588)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11597)
  - `[Instance]` **Button / Claim 150 pts** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11618)
  - `[Instance]` **Button / Open build** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11620)
  - `[Instance]` **Button / Report a bug** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11621)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11627)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:11585](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11585)
  - `[Pattern]` **Track** — [شناسه 1:11604](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11604)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11644):
  > M33 · QA joined  
  > Opened by  
  > M22 Join test, or the active test card o  
  > Buttons on this screen  
  > Claim 80 pts  
  > →  M09 reward dialog  
  > Open build  
  > →  Store / TestFlight / APK link  
  > Report a bug  
  > →  M24  
  > See all  
  > →  M26  
  > Leave test  
  > →  Confirm dialog, frees the spot  
  > Before first valid report  
  > →  Confirm dialog, frees the spot  
  > Test paused by P2E  
  > →  Confirm dialog, frees the spot  
  > State rule  
  > Claim appears only when something is rea

#### M34 — M34 · QA test · joined, no valid report yet (Expand)
- **Node ID**: [`1:16997`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16997&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16997&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 765 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 10 اینستنس رسمی · 26 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16999)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17001)
  - `[Instance]` **Fill / Release Alert** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17006)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17015)
  - `[Instance]` **Button / Open build** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17034)
  - `[Instance]` **Button / Report a bug** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17035)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17041)
  - `[Instance]` **Fill / Target Check** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17049)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:17003](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17003)
  - `[Pattern]` **Track** — [شناسه 1:17022](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17022)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18046):
  > M34 · QA test · joined, no valid report  
  > Opened by  
  > M33 right after joining, until the first  
  > Buttons on this screen  
  > Report a bug  
  > →  M36  
  > Open build  
  > →  build download / web build  
  > Leave test  
  > →  M35  
  > State rule  
  > Minimum reward shows &#39;Locked until first

#### M35 — M35 · Leave test · dialog
- **Node ID**: [`1:16924`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16924&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16924&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: دیالوگ مودال (Modal Dialog)
- **کانتینر فعال مودال**: `Dialog` (شناسه [`1:16990`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16990)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 3 اینستنس رسمی · 1 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Warning** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16992)
  - `[Instance]` **Button / Leave test** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16995)
  - `[Instance]` **Button / Stay** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16996)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18062):
  > M35 · Leave test · dialog  
  > Opened by  
  > Leave test on M33 / M34  
  > Buttons on this screen  
  > Leave test  
  > →  frees the spot, back to M28  
  > Stay  
  > →  close  
  > State rule  
  > Claimed Points stay. Reports still under

#### M36 — M36 · QA test · paused by P2E (Expand)
- **Node ID**: [`1:18648`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18648&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18648&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 945 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 11 اینستنس رسمی · 30 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18650)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18652)
  - `[Instance]` **Fill / Release Alert** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18657)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18666)
  - `[Instance]` **Fill / Pause Circle** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18670)
  - `[Instance]` **Button / Claim 150 pts** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18692)
  - `[Instance]` **Button / Open build** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18694)
  - `[Instance]` **Button / Report a bug** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18695)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:18654](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18654)
  - `[Pattern]` **Track** — [شناسه 1:18678](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18678)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18730):
  > M36 · QA test · paused by P2E  
  > Opened by  
  > Active test card on M28 or M33 after P2E  
  > Buttons on this screen  
  > Open build / Report a bug (disabled)  
  > →  test is paused  
  > Back  
  > →  M28  
  > State rule  
  > P2E pauses a developer&#39;s tests when it u

### ردیف ۶: گزارش باگ، بازخورد و حل اختلاف (Row 6 · QA Bug Reports, Threads & Disputes)

#### M37 — M37 · Report a bug · form (Expand)
- **Node ID**: [`1:11672`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11672&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11672&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1173 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 9 اینستنس رسمی · 33 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11674)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11676)
  - `[Instance]` **Fill / Release Alert** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11682)
  - `[Instance]` **Fill / Chevron Down** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11694)
  - `[Instance]` **Outline / Image** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11724)
  - `[Instance]` **Outline / Video Camera Back** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11726)
  - `[Instance]` **Outline / Attach File Add** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11728)
  - `[Instance]` **Button / Send report** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11741)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Banner / Test Jelly Jump beta** — [شناسه 1:11680](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11680)
  - `[Pattern]` **Input** — [شناسه 1:11688](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11688)
  - `[Pattern]` **Input** — [شناسه 1:11692](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11692)
  - `[Pattern]` **Filter Chips** — [شناسه 1:11697](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11697)
  - `[Pattern]` **Field / Steps to reproduce** — [شناسه 1:11708](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11708)
  - `[Pattern]` **Input** — [شناسه 1:11710](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11710)
  - `[Pattern]` **Input** — [شناسه 1:11714](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11714)
  - `[Pattern]` **Input** — [شناسه 1:11718](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11718)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11743):
  > M37 · Report a bug  
  > Opened by  
  > M23 Report a bug, or the in-build SDK sh  
  > Buttons on this screen  
  > Send report  
  > →  M25  
  > See known issues  
  > →  Known issues list for this test  
  > Add attachment  
  > →  Gallery / screen recording  
  > State rule  
  > Send is enabled when title, where, sever

#### M38 — M38 · QA known issues (Expand)
- **Node ID**: [`1:17077`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17077&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17077&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 849 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 10 اینستنس رسمی · 21 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17079)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17081)
  - `[Instance]` **Fill / Release Alert** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17086)
  - `[Instance]` **Outline / Image Search** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17089)
  - `[Instance]` **Fill / Check** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17095)
  - `[Instance]` **Fill / Verified** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17109)
  - `[Instance]` **Fill / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17123)
  - `[Instance]` **Button / Report a new bug** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17127)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Banner** — [شناسه 1:17085](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17085)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18075):
  > M38 · QA known issues  
  > Opened by  
  > See known issues on M36, or the test det  
  > Buttons on this screen  
  > Report a new bug  
  > →  M36  
  > Issue row  
  > →  issue detail (read only)  
  > State rule  
  > Developer keeps this list. Reporting a l

#### M39 — M39 · Report sent · dialog
- **Node ID**: [`1:11759`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11759&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11759&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: دیالوگ مودال (Modal Dialog)
- **کانتینر فعال مودال**: `Dialog` (شناسه [`1:11831`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11831)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 3 اینستنس رسمی · 4 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11833)
  - `[Instance]` **Button / Report another bug** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11843)
  - `[Instance]` **Button / Back to test** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11844)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11845):
  > M39 · Report sent  
  > Opened by  
  > M37 Send report.  
  > Buttons on this screen  
  > Report another bug  
  > →  M24 (empty form)  
  > Back to test  
  > →  M23 (report shows Under review)  
  > State rule  
  > First report of a test shows the minimum

#### M40 — M40 · My bug reports (Expand)
- **Node ID**: [`1:11858`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11858&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11858&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 799 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 14 اینستنس رسمی · 34 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11860)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11862)
  - `[Instance]` **Fill / Check** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11882)
  - `[Instance]` **Button / Claim 100** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11884)
  - `[Instance]` **Outline / Chevron Right** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11893)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11899)
  - `[Instance]` **Fill / Warning** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11907)
  - `[Instance]` **Button / Reply** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11909)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Filter Chips** — [شناسه 1:11866](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11866)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11927):
  > M40 · My bug reports  
  > Opened by  
  > M23 See all, or a notification when a re  
  > Buttons on this screen  
  > Claim  
  > →  M09 reward dialog (+30)  
  > Reply  
  > →  Report thread with developer  
  > Report row  
  > →  Report detail with status timeline  
  > Needs a ticket  
  > →  P12 New ticket (Section: Missions · Q  
  > Dispute (Not a bug / Duplicate / Won&#39;t fix rows)  
  > →  P12 New ticket (Section: Missions · Q  
  > State rule  
  > Statuses: Under review → Confirmed / Dup

#### M41 — M41 · Bug report detail + developer thread (Expand)
- **Node ID**: [`1:17128`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17128&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17128&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 843 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 9 اینستنس رسمی · 28 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17130)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17132)
  - `[Instance]` **Fill / Warning** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17139)
  - `[Instance]` **Fill / Check** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17155)
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17173)
  - `[Instance]` **Outline / Attach File** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17186)
  - `[Instance]` **Button / Send** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17189)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Timeline** — [شناسه 1:17152](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17152)
  - `[Pattern]` **Step / Sent** — [شناسه 1:17153](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17153)
  - `[Pattern]` **Step / Under review** — [شناسه 1:17159](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17159)
  - `[Pattern]` **Step / Needs more info** — [شناسه 1:17165](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17165)
  - `[Pattern]` **Step / Confirmed or closed** — [شناسه 1:17171](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17171)
  - `[Pattern]` **Thread** — [شناسه 1:17177](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17177)
  - `[Pattern]` **Input** — [شناسه 1:17187](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17187)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18088):
  > M40 · Bug report detail + developer thre  
  > Opened by  
  > A report row or Reply on M39 · a push wh  
  > Buttons on this screen  
  > Send  
  > →  adds your reply; status back to Under  
  > Attach  
  > →  gallery / screen recording  
  > Claim (when confirmed)  
  > →  M06  
  > Closed as Not a bug  
  > →  M06  
  > State rule  
  > Thread is between the player and the tes

#### M42 — M42 · Bug report detail · rejected, can dispute (Expand)
- **Node ID**: [`1:18320`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18320&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18320&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 967 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 10 اینستنس رسمی · 29 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18322)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18324)
  - `[Instance]` **Fill / Warning** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18331)
  - `[Instance]` **Fill / Check** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18347)
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18365)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18383)
  - `[Instance]` **Button / Dispute via support ticket** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18385)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Timeline** — [شناسه 1:18344](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18344)
  - `[Pattern]` **Step / Sent** — [شناسه 1:18345](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18345)
  - `[Pattern]` **Step / Under review** — [شناسه 1:18351](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18351)
  - `[Pattern]` **Step / Needs more info** — [شناسه 1:18357](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18357)
  - `[Pattern]` **Step / Confirmed or closed** — [شناسه 1:18363](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18363)
  - `[Pattern]` **Thread** — [شناسه 1:18369](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18369)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18507):
  > M41 · Bug report detail · rejected, can  
  > Opened by  
  > Dispute on M39 · a report row closed as  
  > Buttons on this screen  
  > Dispute via support ticket  
  > →  M42 (prefilled)  
  > Limit reached · window closed · already disputed  
  > →  M42 (prefilled)  
  > State rule  
  > Shown for 7 days after the developer rej

#### M43 — M43 · Bug report detail · rejected, dispute not available
- **Node ID**: [`1:18579`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18579&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18579&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1077 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 10 اینستنس رسمی · 30 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18581)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18583)
  - `[Instance]` **Fill / Warning** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18590)
  - `[Instance]` **Fill / Check** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18606)
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18624)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18642)
  - `[Instance]` **Button / Dispute (disabled)** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18644)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Timeline** — [شناسه 1:18603](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18603)
  - `[Pattern]` **Step / Sent** — [شناسه 1:18604](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18604)
  - `[Pattern]` **Step / Under review** — [شناسه 1:18610](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18610)
  - `[Pattern]` **Step / Needs more info** — [شناسه 1:18616](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18616)
  - `[Pattern]` **Step / Confirmed or closed** — [شناسه 1:18622](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18622)
  - `[Pattern]` **Thread** — [شناسه 1:18628](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18628)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18717):
  > M43 · Bug report detail · rejected, disp  
  > Opened by  
  > Dispute on M40 / M42 when a limit blocks  
  > Buttons on this screen  
  > Dispute (disabled)  
  > →  no action, reason shown on the card  
  > Back  
  > →  M40  
  > State rule  
  > Disabled when: the player already has 3

#### M44 — M44 · Dispute ticket · new (prefilled)
- **Node ID**: [`1:18386`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18386&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18386&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 10 اینستنس رسمی · 25 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18388)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18390)
  - `[Instance]` **Fill / Store** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18399)
  - `[Instance]` **Fill / Chevron Down** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18402)
  - `[Instance]` **Fill / Crown** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18408)
  - `[Instance]` **Outline / Attach File** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18426)
  - `[Instance]` **Button / Send ticket** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18441)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Input** — [شناسه 1:18397](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18397)
  - `[Pattern]` **Order Card** — [شناسه 1:18406](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18406)
  - `[Pattern]` **Input** — [شناسه 1:18416](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18416)
  - `[Pattern]` **Input** — [شناسه 1:18421](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18421)
  - `[Pattern]` **Input** — [شناسه 1:18436](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18436)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18520):
  > M44 · Dispute ticket · new (prefilled)  
  > Opened by  
  > Dispute via support ticket on M42  
  > Buttons on this screen  
  > Send  
  > →  creates the ticket, report shows Disp  
  > Topic  
  > →  P16 topic picker (preset: Developer r  
  > Back  
  > →  M41 without sending  
  > State rule  
  > Same screen as Shop&#39;s P12 New ticket, wi

#### M45 — M45 · Bug report detail · disputed, P2E reviewing (Expand)
- **Node ID**: [`1:18444`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18444&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18444&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 943 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 9 اینستنس رسمی · 28 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18446)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18448)
  - `[Instance]` **Fill / Warning** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18455)
  - `[Instance]` **Fill / Check** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18471)
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18489)
  - `[Instance]` **Button / Open ticket #5120** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18506)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Timeline** — [شناسه 1:18468](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18468)
  - `[Pattern]` **Step / Sent** — [شناسه 1:18469](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18469)
  - `[Pattern]` **Step / Under review** — [شناسه 1:18475](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18475)
  - `[Pattern]` **Step / Needs more info** — [شناسه 1:18481](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18481)
  - `[Pattern]` **Step / Confirmed or closed** — [شناسه 1:18487](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18487)
  - `[Pattern]` **Thread** — [شناسه 1:18493](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18493)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18536):
  > M43 · Bug report detail · disputed, P2E  
  > Opened by  
  > After sending the dispute ticket · push  
  > Buttons on this screen  
  > Open ticket #5120  
  > →  P15 ticket conversation  
  > State rule  
  > P2E upholds → report becomes Confirmed a

### ردیف ۷: نظرسنجی‌ها و پرسشنامه‌های تعاملی (Row 7 · Surveys & Questionnaires Flow)

#### M46 — M46 · Surveys category · list (Expand)
- **Node ID**: [`1:12855`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12855&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12855&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1575 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 28 اینستنس رسمی · 91 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12857)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12859)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12865)
  - `[Instance]` **Fill / Star** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12870)
  - `[Instance]` **Fill / Timer** (تعداد: 5) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12875)
  - `[Instance]` **Fill / Edit Square** (تعداد: 8) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12879)
  - `[Instance]` **Button / View** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12880)
  - `[Instance]` **Outline / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12893)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Campaign Banner** — [شناسه 1:12866](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12866)
  - `[Pattern]` **Carousel dots** — [شناسه 1:12881](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12881)
  - `[Pattern]` **Banner / Share your opinion, earn Points** — [شناسه 1:12884](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12884)
  - `[Pattern]` **Card / Gaming habits survey (progress)** — [شناسه 1:12897](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12897)
  - `[Pattern]` **Reward** — [شناسه 1:12911](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12911)
  - `[Pattern]` **Track** — [شناسه 1:12916](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12916)
  - `[Pattern]` **Card / Shop experience survey (pending)** — [شناسه 1:12920](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12920)
  - `[Pattern]` **Reward** — [شناسه 1:12936](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12936)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15910):
  > M46 · Surveys category · list  
  > Opened by  
  > Surveys tile on M01, or a Surveys card o  
  > Buttons on this screen  
  > Campaign · View  
  > →  H05 Campaign detail  
  > Continue  
  > →  last unanswered question (M33 / M34)  
  > Start  
  > →  M32  
  > Pending card  
  > →  detail sheet with review status  
  > Filters  
  > →  M31  
  > State rule  
  > Order: In progress, Waiting for review,

#### M47 — M47 · Surveys filters · sheet
- **Node ID**: [`1:14209`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14209&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14209&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:14386`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14386)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 14 اینستنس رسمی · 31 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14390)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14394)
  - `[Instance]` **Fill / Check** (تعداد: 10) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14399)
  - `[Instance]` **Button / Reset** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14455)
  - `[Instance]` **Button / Show 5 surveys** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14456)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:14388](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14388)
  - `[Pattern]` **Chips** — [شناسه 1:14397](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14397)
  - `[Pattern]` **Chips** — [شناسه 1:14409](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14409)
  - `[Pattern]` **Chips** — [شناسه 1:14421](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14421)
  - `[Pattern]` **Group / Reward** — [شناسه 1:14433](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14433)
  - `[Pattern]` **Chips** — [شناسه 1:14435](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14435)
  - `[Pattern]` **Chips** — [شناسه 1:14444](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14444)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14468):
  > M47 · Surveys filters  
  > Opened by  
  > Filters on M46 Surveys list.  
  > Buttons on this screen  
  > Show N surveys  
  > →  Apply, back to M36  
  > Reset  
  > →  All sources and lengths, Full off, En  
  > State rule  
  > Surveys the user was screened out of or

#### M48 — M48 · Survey waiting for review · sheet
- **Node ID**: [`1:17190`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17190&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17190&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:17367`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17367)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 6 اینستنس رسمی · 14 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Edit Square** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17371)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17375)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17379)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17385)
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17391)
  - `[Instance]` **Button / Got it** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17397)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:17369](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17369)
  - `[Pattern]` **Timeline** — [شناسه 1:17376](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17376)
  - `[Pattern]` **Step / Answers sent** — [شناسه 1:17377](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17377)
  - `[Pattern]` **Step / Quality check** — [شناسه 1:17383](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17383)
  - `[Pattern]` **Step / Reward ready to claim** — [شناسه 1:17389](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17389)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18107):
  > M48 · Survey waiting for review · sheet  
  > Opened by  
  > A pending survey card on M46  
  > Buttons on this screen  
  > Got it  
  > →  close  
  > State rule  
  > Quality check usually takes under 1 h, u

#### M49 — M49 · Survey intro + consent (Expand)
- **Node ID**: [`1:11949`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11949&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11949&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 729 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 11 اینستنس رسمی · 27 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11951)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11953)
  - `[Instance]` **Fill / Edit Square** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11958)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11967)
  - `[Instance]` **Fill / Visibility** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11984)
  - `[Instance]` **Fill / Warning** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11996)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12003)
  - `[Instance]` **Button / Start survey** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12005)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Hero** — [شناسه 1:11955](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11955)
  - `[Pattern]` **Reward** — [شناسه 1:11972](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-11972)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15932):
  > M49 · Survey intro + consent  
  > Opened by  
  > A survey card on M30 or M01, or a campai  
  > Buttons on this screen  
  > Start survey  
  > →  M33  
  > Back  
  > →  the list it was opened from  
  > State rule  
  > Start is disabled until consent is ticke

#### M50 — M50 · Survey question · single choice
- **Node ID**: [`1:12006`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12006&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12006&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 4 اینستنس رسمی · 21 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12008)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12010)
  - `[Instance]` **Button / Back** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12038)
  - `[Instance]` **Button / Next** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12039)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Survey Progress** — [شناسه 1:12012](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12012)
  - `[Pattern]` **Track** — [شناسه 1:12016](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12016)
  - `[Pattern]` **Option / Every day (selected)** — [شناسه 1:12019](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12019)
  - `[Pattern]` **Option / A few times a week** — [شناسه 1:12024](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12024)
  - `[Pattern]` **Option / A few times a month** — [شناسه 1:12028](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12028)
  - `[Pattern]` **Option / Rarely** — [شناسه 1:12032](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12032)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12040):
  > M50 · Single choice  
  > Opened by  
  > M49 Start survey, or previous question.  
  > Buttons on this screen  
  > Next  
  > →  M29 (next question)  
  > Back  
  > →  Previous question  
  > App bar back  
  > →  Leave dialog: progress saved for 30 m  
  > State rule  
  > Next disabled until an option is picked.

#### M51 — M51 · Leave survey · dialog
- **Node ID**: [`1:17398`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17398&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17398&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: دیالوگ مودال (Modal Dialog)
- **کانتینر فعال مودال**: `Dialog` (شناسه [`1:17433`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17433)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 3 اینستنس رسمی · 1 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17435)
  - `[Instance]` **Button / Keep going** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17438)
  - `[Instance]` **Button / Leave for now** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17439)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18117):
  > M51 · Leave survey · dialog  
  > Opened by  
  > App bar back during a survey (M50 / M52)  
  > Buttons on this screen  
  > Keep going  
  > →  close  
  > Leave for now  
  > →  M41; card shows Continue with time le  
  > State rule  
  > Answers and spot are held for 30 min fro

#### M52 — M52 · Survey question · rating + text
- **Node ID**: [`1:12056`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12056&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12056&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 4 اینستنس رسمی · 23 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12058)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12060)
  - `[Instance]` **Button / Back** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12102)
  - `[Instance]` **Button / Next** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12103)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Survey Progress** — [شناسه 1:12062](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12062)
  - `[Pattern]` **Track** — [شناسه 1:12066](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12066)
  - `[Pattern]` **Input** — [شناسه 1:12097](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12097)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12104):
  > M52 · Rating + text  
  > Opened by  
  > Previous question.  
  > Buttons on this screen  
  > Next  
  > →  Last question → M31  
  > Back  
  > →  Previous question  
  > State rule  
  > Other question types use the same shell:

#### M53 — M53 · Survey · screened out
- **Node ID**: [`1:12117`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12117&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12117&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 5 اینستنس رسمی · 6 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12119)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12121)
  - `[Instance]` **Fill / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12124)
  - `[Instance]` **Button / Claim 10 pts** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12131)
  - `[Instance]` **Button / See other surveys** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12132)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15945):
  > M53 · Survey · screened out  
  > Opened by  
  > A screener answer on M33 that doesn&#39;t ma  
  > Buttons on this screen  
  > Claim 10 pts  
  > →  M06  
  > See other surveys  
  > →  M30  
  > State rule  
  > Consolation is set per survey (can be 0)

#### M54 — M54 · Survey complete · reward
- **Node ID**: [`1:12133`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12133&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12133&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 8 اینستنس رسمی · 10 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12135)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12137)
  - `[Instance]` **Fill / Check** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12140)
  - `[Instance]` **Icon / Token** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12146)
  - `[Instance]` **Fill / Verified** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12151)
  - `[Instance]` **Button / Claim reward** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12156)
  - `[Instance]` **Button / More surveys** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12157)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Reward** — [شناسه 1:12143](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12143)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15958):
  > M54 · Survey complete · reward  
  > Opened by  
  > Next on the last question (M52)  
  > Buttons on this screen  
  > Claim reward  
  > →  M06, then back to M30  
  > More surveys  
  > →  M30  
  > Quality check flags answers  
  > →  M30  
  > State rule  
  > If the quality check flags the answers,

#### M55 — M55 · Survey complete · under review
- **Node ID**: [`1:17440`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17440&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17440&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 7 اینستنس رسمی · 10 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17442)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17444)
  - `[Instance]` **Fill / Timer** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17447)
  - `[Instance]` **Icon / Token** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17453)
  - `[Instance]` **Fill / Verified** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17458)
  - `[Instance]` **Button / Back to surveys** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17463)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Reward** — [شناسه 1:17450](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17450)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18130):
  > M55 · Survey complete · under review  
  > Opened by  
  > Last question Next when the quality chec  
  > Buttons on this screen  
  > Back to surveys  
  > →  M41 (card shows Waiting for review →  
  > State rule  
  > Reward greyed until released (Claim) or

### ردیف ۸: ماموریت‌های پلتفرمی و ارجاع دوستان (Row 8 · Platform Missions & Referrals)

#### M56 — M56 · Platform category · list (Expand)
- **Node ID**: [`1:14749`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14749&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14749&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 2027 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 39 اینستنس رسمی · 127 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14751)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14753)
  - `[Instance]` **Fill / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14759)
  - `[Instance]` **Fill / Star** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14764)
  - `[Instance]` **Fill / Timer** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14769)
  - `[Instance]` **Fill / Trophy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14773)
  - `[Instance]` **Button / View** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14774)
  - `[Instance]` **Outline / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14781)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Campaign Banner** — [شناسه 1:14760](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14760)
  - `[Pattern]` **Carousel dots** — [شناسه 1:14775](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14775)
  - `[Pattern]` **Mission Card / Platform / Log in today (claim)** — [شناسه 1:14785](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14785)
  - `[Pattern]` **Reward** — [شناسه 1:14799](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14799)
  - `[Pattern]` **Track** — [شناسه 1:14804](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14804)
  - `[Pattern]` **Quest Card / Platform / New player journey** — [شناسه 1:14806](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14806)
  - `[Pattern]` **Tag / Step 2 of 4** — [شناسه 1:14821](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14821)
  - `[Pattern]` **Reward** — [شناسه 1:14826](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14826)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15974):
  > M56 · Platform category · list  
  > Opened by  
  > Platform tile on M01, Home, or a campaig  
  > Buttons on this screen  
  > Campaign · View  
  > →  H05 Campaign detail  
  > Claim  
  > →  M06 (error: M08)  
  > Quest card  
  > →  M11 / M12  
  > Spin  
  > →  Lucky Wheel  
  > Invite  
  > →  M39  
  > Shop  
  > →  Shop tab  
  > Go (profile)  
  > →  Profile edit  
  > Filters  
  > →  M38  
  > State rule  
  > P2E&#39;s own missions: daily, weekly, one-t

#### M57 — M57 · Platform filters · sheet
- **Node ID**: [`1:14996`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14996&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-14996&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:15244`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15244)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 19 اینستنس رسمی · 33 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15248)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15252)
  - `[Instance]` **Fill / Check** (تعداد: 15) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15257)
  - `[Instance]` **Button / Reset** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15322)
  - `[Instance]` **Button / Show 8 missions** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15323)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:15246](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15246)
  - `[Pattern]` **Chips** — [شناسه 1:15255](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15255)
  - `[Pattern]` **Chips** — [شناسه 1:15270](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15270)
  - `[Pattern]` **Chips** — [شناسه 1:15288](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15288)
  - `[Pattern]` **Group / Reward** — [شناسه 1:15300](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15300)
  - `[Pattern]` **Chips** — [شناسه 1:15302](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15302)
  - `[Pattern]` **Chips** — [شناسه 1:15313](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15313)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16005):
  > M57 · Platform filters · sheet  
  > Opened by  
  > Filters on M56  
  > Buttons on this screen  
  > Show N missions  
  > →  apply, back to M37  
  > Reset  
  > →  all types and topics, not claimed, Re

#### M58 — M58 · Platform mission detail · Invite 3 friends · sheet
- **Node ID**: [`1:15324`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15324&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15324&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:15572`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15572)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 10 اینستنس رسمی · 20 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Person** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15576)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15580)
  - `[Instance]` **Icon / Token** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15587)
  - `[Instance]` **Button / Copy** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15607)
  - `[Instance]` **Fill / Check** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15610)
  - `[Instance]` **Button / Share invite link** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15618)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:15574](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15574)
  - `[Pattern]` **Progress** — [شناسه 1:15581](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15581)
  - `[Pattern]` **Reward** — [شناسه 1:15584](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15584)
  - `[Pattern]` **Track** — [شناسه 1:15589](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-15589)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16016):
  > M39 · Platform mission detail · Invite 3  
  > Opened by  
  > Invite on M37, or the card body of any p  
  > Buttons on this screen  
  > Copy  
  > →  copies the invite code  
  > Share invite link  
  > →  system share sheet  
  > X / swipe down  
  > →  close  
  > State rule  
  > A friend counts after signing up with th

### ردیف ۹: تاریخچه جوایز و گزارشات مالی (Row 9 · Reward History & Analytics)

#### M59 — M59 · History · updated for categories, pending & bonuses (Expand)
- **Node ID**: [`1:12664`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12664&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12664&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 1607 pt
- **نوع فریم**: صفحه کامل (Full Screen)
- **آمار عناصر خالص**: 33 اینستنس رسمی · 78 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **iPhone - Status Bar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12666)
  - `[Instance]` **App Bar Container** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12668)
  - `[Instance]` **Icon / Token** (تعداد: 7) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12676)
  - `[Instance]` **Fill / Timer** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12682)
  - `[Instance]` **Outline / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12702)
  - `[Instance]` **Fill / Download** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12707)
  - `[Instance]` **Fill / Edit Square** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12721)
  - `[Instance]` **Fill / Release Alert** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12735)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Summary · last 30 days** — [شناسه 1:12671](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12671)
  - `[Pattern]` **Filter Chips** — [شناسه 1:12684](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12684)
  - `[Pattern]` **Reward** — [شناسه 1:12714](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12714)
  - `[Pattern]` **Reward** — [شناسه 1:12728](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12728)
  - `[Pattern]` **Reward** — [شناسه 1:12743](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12743)
  - `[Pattern]` **Reward** — [شناسه 1:12754](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12754)
  - `[Pattern]` **Reward** — [شناسه 1:12765](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12765)
  - `[Pattern]` **Reward** — [شناسه 1:12777](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-12777)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-16032):
  > M59 · History  
  > Opened by  
  > History on M01 and every category screen  
  > Buttons on this screen  
  > Category chips  
  > →  filter by Games / Apps / QA / Surveys  
  > Filters  
  > →  M41  
  > Pending banner  
  > →  shows only waiting rows  
  > Row  
  > →  detail sheet: reward breakdown, timel  
  > Ticket link  
  > →  P12 Ticket Center (Section: Missions  
  > State rule  
  > Lists reward events (bug reports live in

#### M60 — M60 · History detail · sheet
- **Node ID**: [`1:17464`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17464&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17464&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:17645`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17645)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 7 اینستنس رسمی · 18 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Release Alert** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17649)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17653)
  - `[Instance]` **Fill / Check** (تعداد: 3) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17668)
  - `[Instance]` **Button / View report** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17685)
  - `[Instance]` **Button / Report a problem** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17686)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:17647](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17647)
  - `[Pattern]` **Timeline** — [شناسه 1:17665](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17665)
  - `[Pattern]` **Step / Reported** — [شناسه 1:17666](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17666)
  - `[Pattern]` **Step / Confirmed** — [شناسه 1:17672](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17672)
  - `[Pattern]` **Step / Claimed** — [شناسه 1:17678](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17678)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18140):
  > M60 · History detail · sheet  
  > Opened by  
  > A row on M59  
  > Buttons on this screen  
  > View report  
  > →  M40 (QA rows)  
  > Report a problem  
  > →  P12 New ticket · Section: Missions  
  > State rule  
  > Shows the reward breakdown (guaranteed /

#### M61 — M61 · History filters · sheet
- **Node ID**: [`1:13676`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13676&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13676&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:13857`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13857)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 23 اینستنس رسمی · 35 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Menu** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13861)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13865)
  - `[Instance]` **Fill / Check** (تعداد: 15) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13870)
  - `[Instance]` **Outline / Stadia Controller** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13922)
  - `[Instance]` **Fill / Arrow Drop Down** (تعداد: 2) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13924)
  - `[Instance]` **Outline / Star** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13928)
  - `[Instance]` **Button / Reset** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13944)
  - `[Instance]` **Button / Show 38 results** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13945)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:13859](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13859)
  - `[Pattern]` **Chips** — [شناسه 1:13868](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13868)
  - `[Pattern]` **Chips** — [شناسه 1:13889](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13889)
  - `[Pattern]` **Group / Reward** — [شناسه 1:13905](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13905)
  - `[Pattern]` **Chips** — [شناسه 1:13907](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13907)
  - `[Pattern]` **Chips** — [شناسه 1:13933](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13933)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-13957):
  > M61 · History filters  
  > Opened by  
  > Filters on M59 History.  
  > Buttons on this screen  
  > Custom  
  > →  Date range picker  
  > Game or app  
  > →  Searchable list of games and apps the  
  > Show N results  
  > →  Apply, totals card recalculates for t  
  > State rule  
  > The 30-day summary on M35 follows the Da

#### M62 — M62 · History date range · sheet
- **Node ID**: [`1:17687`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17687&t=izJmnPAfVXhlv1J2-4)
- **لینک مستقیم فیگما**: [مشاهده در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17687&t=izJmnPAfVXhlv1J2-4)
- **ابعاد**: 402 × 874 pt
- **نوع فریم**: باتم‌شیت مودال (Modal Bottom Sheet)
- **کانتینر فعال مودال**: `Bottom Sheet` (شناسه [`1:17868`](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17868)) · *محتوای پس‌زمینه منجمد پشت لایه Scrim قرار دارد.*
- **آمار عناصر خالص**: 5 اینستنس رسمی · 61 کانتینر الگویی
- **اینستنس‌های شاخص (Instances)**:
  - `[Instance]` **Fill / Calendar** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17872)
  - `[Instance]` **Outline / Close** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17876)
  - `[Instance]` **Outline / Chevron Left** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17887)
  - `[Instance]` **Outline / Chevron Right** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17889)
  - `[Instance]` **Button / Apply · 22 days** (تعداد: 1) — [مشاهده نمونه در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17983)
- **الگوها و ساختارهای کلیدی (Patterns)**:
  - `[Pattern]` **Sheet Header** — [شناسه 1:17870](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-17870)
- **یادداشت و جریان کار دیزاینر (Designer Caption)** — [مشاهده فریم کپشن در فیگما](https://www.figma.com/design/7BurKbCwclcabEGJ7cLcKz/P2E---Wireframe?node-id=1-18153):
  > M62 · History date range · sheet  
  > Opened by  
  > Custom on M61  
  > Buttons on this screen  
  > Quick chips  
  > →  set the range  
  > Apply  
  > →  back to M56 with the range set  
  > State rule  
  > Up to 12 months back. The summary card o

---

## ۴. تفکیک معماری و ماتریس دسته‌بندی کامپوننت‌ها (Component Matrix & Layer Separation)

به منظور جلوگیری از آلودگی دامین و پایبندی به اصول معماری تمیز (Clean Architecture & Atomic Design System)، کلیه کامپوننت‌های استخراج‌شده به دو لایه دقیق تفکیک شده‌اند:

### ۴.۱. لایه اول: مؤلفه‌های بنیادین هسته دیزاین سیستم (Layer 1: Core Design System Primitives)
این مؤلفه‌ها کاملاً **مستقل از دامین (Domain-Agnostic)** هستند، هیچ شناختی از ماموریت، بازی یا توکن ندارند، پارامترهای آن‌ها منطبق بر توکن‌های طراحی است و باید در پکیج `packages/design_system/lib/src/components/` قرار گیرند:

| نام کامپوننت | ماهیت و کاربرد در Core DS | محل استفاده در فریم‌ها | تعداد تکرار | وضعیت موجود در سورس‌کد |
|---|---|---|---|---|
| `AppProgressBar` | نوار پیشرفت خطی با پشتیبانی از ارتفاع متغیر (8pt / 12pt)، گوشه‌های کاملاً گرد، پرشدگی درصدی و لیبل مقدار | کارت‌های ماموریت، کوئست، پیشرفت دانلود اپ، درصد تکمیل پرسشنامه | ۴۵ بار در ۱۷ فریم | **مفقود** (نیاز به ایجاد) |
| `AppFilterChips` / `AppChipGroup` | چیپ‌های انتخاب فیلتر به صورت تک‌انتخابی یا چندانتخابی با حالت‌های Default، Selected و Outline | هدر صفحات دسته‌بندی، شیت‌های فیلتر (M03, M17, M20, M30, M47, M57, M61) | ۳۸ کانتینر در ۱۲ فریم | **مفقود** (نیاز به ایجاد) |
| `AppTimeline` | تایم‌لاین عمودی وضعیت‌های چندمرحله‌ای با آیکون وضعیت (Completed، Pending، Failed) و خطوط متصل‌کننده | پیگیری نصب اپ شرکا (M26)، جریان بررسی باگ QA (M41-M45)، وضعیت پرسشنامه (M48) | ۷ بار در ۷ فریم فرآیندی | **مفقود** (نیاز به ایجاد) |
| `AppBanner` / `AppCallout` | بنرهای هشدار، موفقیت، اطلاعیه و یادآوری با واریانت‌های معنادار و دکمه کنشی اختیاری | بنر پاداش آماده دریافت (M01)، خطای دانلود (M24)، توقف تست توسط سیستم (M36) | ۱۸ بار در ۱۲ فریم | **مفقود** (نیاز به ایجاد) |
| `AppSelectionTile` | کاشی انتخابی تمام‌عرض شامل دکمه رادیویی یا چک‌باکس، عنوان، توضیحات فرعی و استروک انتخاب | سوالات تک‌گزینه‌ای پرسشنامه (M50)، گزینه‌های مرتب‌سازی فیلترها (M17, M61) | ۷ بار در ۲ فریم | **مفقود** (نیاز به ایجاد) |
| `AppRatingBar` | نشانگر و ورودی امتیازبندی تعاملی ۵ ستاره با قابلیت دریافت بازخورد لمسی | فرم نظرسنجی و ارزیابی کیفی (M52) | ۱ بار در فریم M52 | **مفقود** (نیاز به ایجاد) |
| `AppStatSummaryCard` | کارت نمایش آمار و شاخص‌های تجمیعی (Metric Box) با چیدمان ستونی مقادیر و عناوین | بالای صفحه تاریخچه (M59) و دیالوگ تجمیعی Claim All (M07) | ۲ بار در فریم‌های M07 و M59 | **مفقود** (نیاز به ایجاد) |
| `AppEmptyState` | الگوی صفحه خالی شامل آیکون قهرمان در کانتینر دایره‌ای، تیتر، توضیح و اکشن CTA | صفحه اتمام ماموریت‌ها (M02)، خطای لودینگ (M09)، عدم وجود تست باز (M29) | ۳ بار در فریم‌های اصلی | **مفقود** (نیاز به ایجاد) |
| `AppSheetHeader` | هدر استاندارد باتم‌شیت شامل دستگیره Drag Handle، عنوان، زیرعنوان و آیکون بستن (Close Button) | تمام ۲۷ فریم باتم‌شیت سکشن | ۱۶ اینستنس رسمی | در پکیج `AppSheet` نیازمند تقویت و یکپارچه‌سازی |

### ۴.۲. لایه دوم: ویجت‌های تخصصی دامین ماموریت‌ها (Layer 2: Feature-Shared Widgets)
این ویجت‌ها دارای مفاهیم کسب‌وکار (بیزنس لاجیک ماموریت‌ها، امتیازات، توکن‌ها، گردش کار QA و پرسشنامه) هستند و باید در `lib/shared/widgets/` یا `lib/features/missions/presentation/widgets/` مستقر گردند:

| نام ویجت دامین | نقش عملکردی در محصول | فریم‌های اصلی استفاده | وضعیت و وابستگی‌ها |
|---|---|---|---|
| `AppMissionCard` | کارت استاندارد ماموریت با نمایش آیکون دسته/بازی، تیتر، زیرعنوان، نوار پیشرفت، نشانگر پاداش Points/Tokens، و دکمه کنشی متناسب با وضعیت | M01, M02, M15, M19, M28, M46, M56 (۴۳ بار تکرار) | وابسته به `AppProgressBar`، `AppButton` و `AppBadge` |
| `AppQuestCard` | کارت ماموریت زنجیره‌ای (کوئست) با تگ مشکی Quest، شماره مرحله، نوار پیشرفت کلی، پاداش نهایی و دکمه ادامه | M01, M15, M56 (۴ بار در لیست‌ها) | ساختار ارتقایافته `MissionCard` با نشانگر مرحله |
| `AppQuestHero` | هدر قهرمان صفحه جزئیات کوئست شامل کاور، زمان‌سنج پایان، تعداد مراحل باقی‌مانده و پاداش کل | M11, M12, M14 (۳ صفحه جزئیات کوئست) | کامپوننت هدر اختصاصی کوئست |
| `AppQuestStepRow` | سطر مرحله مجزا در صفحه کوئست با حالات Locked، In Progress، Ready to Claim و Claimed | M11, M12, M14 (۵۶ سطر مرحله در ۱۰ فریم) | پشتیبانی از حالات ترتیبی بازگشایی |
| `MissionCategoryTile` | کاشی تعاملی در شبکه ۵ تایی M01 شامل آیکون، نام، آمار باز بودن، و موجودی پاداش‌های قابل دریافت | M01, M02 (۱۰ بار تکرار) | ویترین ورودی دسته‌بندی‌های ماموریت |
| `MissionRewardTiles` | جعبه نمایش دوقلوی پاداش (Points طلایی با آیکون ستاره + Tokens بنفش/طلایی با آیکون اختصاصی) | M04, M05, M06, M07, M13, M54 (۴ فریم کلیدی) | ماژول اشتراکی نمایش پاداش‌ها |
| `QaTestCard` | کارت معرفی پروژه تستی QA با نمایش ظرفیت باقیمانده، پاداش تضمینی پایه و سقف پاداش باگ‌های بحرانی | M28, M31, M32, M33, M34, M36 (۶ فریم) | شامل نشانگر هشدار نارنجی ظرفیت زیر ۱۰ نفر |
| `QaBugReportRow` | سطر پیگیری گزارش باگ ارسالی کاربر با برچسب‌های وضعیت (Under review، Confirmed، Duplicate، Rejected) | M40 (۶ سطر گزارش) | پشتیبانی از اکشن حل اختلاف (Dispute) |
| `BugReportThreadView` | حباب‌های گفتگو میان تستر و توسعه‌دهنده به همراه ضمیمه فایل و تغییر وضعیت گزارش | M41, M42, M43, M45 (۸ فریم) | سیستم تیکتینگ یکپارچه با تیم فنی |
| `PartnerAppCard` | کارت تسک اپلیکیشن شرکا با تفکیک حالت نصبی (Downloadable APK) و وب‌اپلیکیشن (Web App) | M19, M21, M22, M23, M24, M25 (۶ فریم) | پیگیری وضعیت دانلود و تاییدیه رویداد SDK |
| `SurveyEngineView` | موتور اجرای آزمون و پرسشنامه شامل نوار پیشرفت، مدیریت زمان پاسخ‌دهی و گزینه‌های تک‌انتخابی و متنی | M49 الی M55 (۷ فریم آزمون) | سیستم جلوگیری از اتلاف زمان با تایمر ۳۰ دقیقه‌ای |
| `MissionHistoryRow` | سطر نمایش سابقه دریافت پاداش‌ها با تفکیک آیکون دسته، تاریخ شمسی/میلادی و مبالغ واریزشده | M59, M60 (در صفحه تاریخچه) | گزارش‌گیری مالی ماموریت‌ها |

---

## ۵. تحلیل تخصصی الگوهای مشترک، واریانت‌ها و وضعیت‌ها (Patterns & States Deep Dive)

### ۵.۱. ماشین حالات کارت ماموریت (`AppMissionCard`)
کارت ماموریت دارای ۵ وضعیت مجزا در چیدمان و رفتار بصری است:
1. **شروع‌نشده (Not Started / New)**: نوار پیشرفت ۰٪، دکمه اکشن "Start" یا "Play"، پاداش به صورت کامل نمایش داده می‌شود.
2. **در حال انجام (In Progress)**: نوار پیشرفت بر حسب پیشرفت واقعی پر شده است (مثلاً ۲ از ۳ بازی)، متن راهنمای مرحله، دکمه اکشن فعال (Play / Open).
3. **آماده دریافت پاداش (Ready to Claim)**: نوار پیشرفت ۱۰۰٪ پر، کادر با تاکید بصری بالا یا بج سبز "Ready"، دکمه اکشن برجسته Primary "Claim".
4. **دریافت‌شده (Claimed)**: ظاهر نیمه‌شفاف/خاکستری، دکمه غیرفعال با آیکون تیک Check و متن "Claimed"، نوار پیشرفت منجمد.
5. **منقضی‌شده (Expired)**: ماموریت‌هایی که تا پیش از ساعت 00:00 تهران دریافت نشده‌اند و غیرفعال می‌شوند.

### ۵.۲. ساختار واریانت‌های کوئست (`AppQuestCard` vs `AppMissionCard`)
- کوئست‌ها همواره نشانگر گام کنونی دارند (مانند `Step 3 of 5`).
- دارای تاریخ و ساعت انقضای مشخص هستند (مثلاً `Ends in 2d 14h`).
- پاداش نهایی در سمت راست با ابعاد بزرگ‌تر به عنوان انگیزه اصلی تکمیل زنجیره مشخص شده است.

### ۵.۳. سیستم واریانت‌های نوار پیشرفت (`AppProgressBar`)
- **ضخامت نوار**:
  - اندازه فشرده: ارتفاع ۸ پوینت (در کارت‌های ماموریت).
  - اندازه استاندارد: ارتفاع ۱۲ پوینت (در بالای پرسشنامه‌ها و هدر کوئست).
- **پشتیبانی از چند قطعه (Segmented Track)**: در کوئست‌ها و مراحل اپلیکیشن، خط پیشرفت به تعداد مراحل به قطعات برابر تقسیم می‌شود.

### ۵.۴. معماری سیستم ارزیابی و تست بازی‌ها (QA Testing Flow)
سیستم QA دارای یک اکوسیستم کامل با ۴ بازیگر و مرحله است:
1. **ورود و رزرو صندلی (M28 - M32)**: تا زمانی که ظرفیت باقی است کاربر وارد آزمون می‌شود. ظرفیت زیر ۱۰ نفر با رنگ اخطار نارنجی مشخص می‌شود. با اتمام ظرفیت، امکان ورود به لیست انتظار (Waitlist) فراهم است.
2. **فرآیند آزمون (M33 - M36)**: اجرای بیلد تستی، دانلود آپدیت اختصاصی، و ارسال باگ.
3. **گزارش باگ و رفع اشکال (M37 - M41)**: ثبت فرم کامل گزارش، الصاق اسکرین‌شات و ویدیو، و ایجاد ترید گفتگو با توسعه‌دهنده.
4. **سیستم داوری و حل اختلاف (M42 - M45)**: در صورت رد گزارش توسط توسعه‌دهنده، بازیکن ظرف ۷ روز حق ثبت تیکت حل اختلاف نزد تیم P2E را دارد (حداکثر ۳ تیکت همزمان). تایید اختلاف توسط P2E باعث کسر جریمه از سازنده و واریز پاداش تستر می‌شود.

---

## ۶. برنامه اقدام و اولویت‌بندی پیاده‌سازی (Action Plan & Implementation Roadmap)

با توجه به حجم بالای فریم‌ها، توسعه باید در ۴ فاز مهندسی تدوین شود:

### فاز ۱: مؤلفه‌های بنیادین Core DS (هفته اول)
- پیاده‌سازی `AppProgressBar` با پشتیبانی از گوشه‌های گرد و استایل‌های ابعادی.
- پیاده‌سازی `AppFilterChips` و `AppChipGroup` (به عنوان نیازمندی مشترک Shop، Leaderboard و Missions).
- استانداردسازی `AppTimeline` برای سناریوهای گام‌به‌گام چندمرحله‌ای.
- ایجاد `AppBanner` و `AppCallout` با استایل‌های اخطار، اطلاعات و کمپین.
- پیاده‌سازی `AppSelectionTile` برای فرم‌های انتخاب رادیویی و چک‌باکس.

### فاز ۲: ویجت‌های دامین و هسته ماموریت‌ها (هفته دوم)
- پیاده‌سازی `AppMissionCard` به همراه ماشین حالات ۵‌گانه.
- پیاده‌سازی `MissionCategoryTile` و ساختار شبکه ۵ تایی M01.
- پیاده‌سازی جعبه دوقلوی پاداش `MissionRewardTiles`.
- توسعه `AppQuestCard` و صفحه جزئیات `QuestHero` و سطرهای `QuestStepRow`.

### فاز ۳: جریان‌های تخصصی QA و پرسشنامه (هفته سوم)
- پیاده‌سازی کارت‌های تست `QaTestCard` و لیست فرصت‌ها.
- پیاده‌سازی فرم گزارش باگ و ساختار ترید `BugReportThreadView`.
- توسعه شل تعاملی پرسشنامه `SurveyEngineView` و تایمر انقضای پاسخ.
- پیاده‌سازی جریان اپلیکیشن‌های شرکا و ردیابی وضعیت نصب.

### فاز ۴: صفحات تکمیلی، فیلترها و تاریخچه (هفته چهارم)
- ساخت شیت‌های فیلتر پیشرفته با استفاده از چیپ‌های فاز ۱.
- پیاده‌سازی صفحه تاریخچه جامع پاداش‌ها (M59) و شیت جزئیات (M60).
- اتصال سیستم حل اختلاف باگ‌ها به ماژول تیکتینگ پلتفرم.

---

## ۷. جدول تفصیلی تکرار و فراوانی مؤلفه‌ها (Comprehensive Frequency Table)

| عنوان مؤلفه یا الگو | نوع معماری | تعداد کل نمونه‌های خالص | تعداد فریم‌های دربرگیرنده | نمونه فریم‌های شاخص |
|---|---|---|---|---|
| `AppProgressBar` (خطوط و ترک‌های پیشرفت) | Core DS | ۴۵ | ۱۷ | M01, M02, M04, M05, M15, M19, M50, M52, M56 |
| `MissionCard` (کارت‌های ماموریت روزانه/هفتگی) | Feature-Shared | ۴۳ | ۷ | M01, M02, M15, M19, M28, M46, M56 |
| `AppFilterChips` / چیپ‌های فیلتر | Core DS | ۳۸ | ۱۲ | M03, M15, M16, M17, M20, M30, M47, M57, M61 |
| `QuestSteps` (سطرهای مراحل کوئست) | Feature-Shared | ۵۶ | ۱۰ | M11, M12, M14, M26, M41, M42, M43, M45, M48 |
| `AppSheetHeader` (هدر استاندارد شیت‌ها) | Core DS | ۱۶ | ۱۶ | M03, M04, M05, M10, M17, M18, M20, M26, M30, M47, M57 |
| `AppTimeline` (تایم‌لاین عمودی وضعیت‌ها) | Core DS | ۷ | ۷ | M26, M41, M42, M43, M45, M48, M60 |
| `CategoryTile` (کاشی شبکه ۵ تایی) | Feature-Shared | ۱۰ | ۲ | M01, M02 |
| `CampaignBanner` (بنر بالای دسته‌بندی‌ها) | Feature-Shared | ۶ | ۶ | M15, M16, M19, M28, M46, M56 |
| `AppBanner` / بنرهای اعلان و هشدار | Core DS | ۷ | ۷ | M01, M14, M19, M28, M37, M38, M46 |
| `QuestCard` (کارت کوئست در لیست‌ها) | Feature-Shared | ۴ | ۳ | M01, M15, M56 |
| `QuestHero` (هدر صفحه جزئیات کوئست) | Feature-Shared | ۳ | ۳ | M11, M12, M14 |
| `RewardTiles` (جعبه پاداش Points + Tokens) | Feature-Shared | ۴ | ۴ | M04, M05, M06, M13 |
| `Selection Option Tile` (کاشی انتخابی رادیویی) | Core DS | ۷ | ۲ | M17, M50 |
| `QaTestCard` (کارت فرصت آزمون QA) | Feature-Shared | ۶ | ۲ | M01, M28 |
| `QaBugReportRow` (سطر گزارش باگ کاربر) | Feature-Shared | ۶ | ۱ | M40 |
| `DeveloperThreadView` (رشته پیام تستر/سازنده) | Feature-Shared | ۹ | ۸ | M41, M42, M43, M45 |
| `AppEmptyState` (صفحه خالی/اتمام ماموریت) | Core DS | ۳ | ۳ | M02, M09, M29 |

---

## ۸. جمع‌بندی نهایی (Conclusion)

سکشن **Missions & Quests Wireframes** ستون فقرات درگیرسازی (Engagement) و چرخه اقتصادی درون‌برنامه‌ای (Tokenomics) پلتفرم P2E را تشکیل می‌دهد. بررسی کالبدشکافانه کلیه ۶۲ فریم نشان داد که:
1. با جداسازی دقیق پس‌زمینه‌های منجمد مودال‌ها، حجم واقعی اینستنس‌های فعال از ۱,۶۷۵ به **۸۵۹ اینستنس** تقلیل یافت که شفافیت آماری کاملی را در اختیار تیم پیاده‌سازی قرار می‌دهد.
2. الگوهای مشترکی نظیر `AppProgressBar` (با ۴۵ تکرار)، `AppFilterChips` (با ۳۸ تکرار)، `AppTimeline` و `AppSelectionTile` باید فوراً در پکیج هسته `p2e_design_system` استانداردسازی شوند تا از پیاده‌سازی‌های چندباره و ناسازگار در ویژگی‌های Shop، Leaderboard و Missions جلوگیری به عمل آید.
3. مستندات کسب‌وکار و سوالات باز تدوین‌شده در نوت `1:10685` باید در جلسه فنی با مدیر محصول مطرح شده و خروجی آن در رجیستر رسمی `decisions.md` ثبت گردد.
