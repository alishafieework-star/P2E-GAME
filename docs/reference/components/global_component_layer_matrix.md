# ماتریس جامع معماری و لایه‌بندی کامپوننت‌های وایرفریم (Global Component Layer Matrix)

> **دامنه ارزیابی**: ۱۰۸ فریم فعال موبایل، باتم‌شیت و دیالوگ در ۳ سکشن اصلی وایرفریم فیگما (`Shop` با ۲۴ فریم · `Leaderboard` با ۲۲ فریم · `Missions & Quests` با ۶۲ فریم)  
> **مراجع اولیه**:
> 1. [`docs/reference/components/shop_wireframes_inventory.md`](file:///d:/projects/My-Game/docs/reference/components/shop_wireframes_inventory.md)
> 2. [`docs/reference/components/leaderboard_wireframes_inventory.md`](file:///d:/projects/My-Game/docs/reference/components/leaderboard_wireframes_inventory.md)
> 3. [`docs/reference/components/missions_wireframes_inventory.md`](file:///d:/projects/My-Game/docs/reference/components/missions_wireframes_inventory.md)
> 
> **هدف سند**: تفکیک قطعی و مهندسی مؤلفه‌های رابط کاربری به **لایه اول (Core Design System)**، **لایه دوم (Shared Product Widgets)** و **لایه سوم (Feature-Private Widgets)** بر اساس فراوانی تکرار، عدم وابستگی به دامین (Domain-Agnostic)، و انطباق با قوانین سند `AGENTS.md` و معماری v1.4.

---

## ۱. خلاصه اجرایی و اصول تصمیم‌گیری معماری (Architectural Principles)

طبق معماری استاندارد پروژه P2E و قانون تفکیک لایه‌ها (`AGENTS.md` §15.1 و Addendum v1.4 §A6)، تفکیک ویجت‌ها بر اساس ۳ معیار بنیادین انجام می‌گیرد:

1. **معیار استقلال از دامین (Domain-Agnosticism)**:
   - اگر ویجت هیچ وابستگی مفهومی به بیزنس بازی، کاربر، توکن، سفارش یا قوانین گیمینگ نداشته باشد و صرفاً از روی توکن‌ها و تایپوگرافی عمومی رندر شود، **لایه اول (Core Design System)** است و باید در `packages/design_system/lib/src/components/` پیاده‌سازی شود.
2. **معیار اشتراک محصولی (Cross-Feature Domain Sharing)**:
   - اگر ویجت حامل معنا و مدل داده‌ای محصول است (مثلاً سکه، پاداش، رتبه، کارت بازی، یا پروفایل کاربر) اما در **بیش از یک فیچر** استفاده می‌شود، **لایه دوم (Shared Product Widgets)** است و باید در `lib/shared/widgets/` پیاده‌سازی گردد. این ویجت‌ها به دلیل وابستگی به مدل‌های دامین نباید پکیج مستقل دیزاین سیستم را آلوده کنند.
3. **معیار تک‌مالکه (Single-Owner Isolation)**:
   - اگر ویجت صرفاً در یک فیچر و برای یک گردش‌کار اختصاصی کاربرد دارد (مثلاً فرم ارسال باگ، فرم نظرسنجی، یا کاورهای لیدربورد)، **لایه سوم (Feature-Private Widgets)** است و در `lib/features/<feature>/src/presentation/widgets/` محصور می‌ماند (تصمیم D-067).

---

## ۲. ماتریس مقایسه‌ای فراوانی در ۳ سکشن (Cross-Section Frequency Matrix)

در جدول زیر، تمامی الگوهای پرتکرار کشف‌شده در ۳ سکشن تجمیع شده و تعداد تکرار آن‌ها در هر بخش مقایسه گردیده است:

| نام الگو / کامپوننت | تکرار در Shop (۲۴ فریم) | تکرار در Leaderboard (۲۲ فریم) | تکرار در Missions (۶۲ فریم) | **مجموع تکرار خالص** | **لایه تصویب‌شده** | مسیر مقصد در کدبیس |
|---|:---:|:---:|:---:|:---:|:---:|---|
| **`AppFilterChips` / `AppFilterBar`** | ۳۶ چیپ (۷ سطر) | ۷ سطر | ۱۸۵ چیپ (۱۲ سطر) | **+۲۲۰ چیپ در ۲۶ سطر** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/chips/` |
| **`AppStatusChip` / `AppStatusBadge`** | ۱۸ مورد | ۴۲ مورد | ۵۰+ مورد | **+۱۱۰ مورد در ۵۰+ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/badges/` |
| **`AppKeyValueRow` / `AppDataRow`** | ۶۶ مورد | ۴ مورد | ۱۱ مورد | **۸۱ مورد در ۱۷ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/collections/` |
| **`AppProgressBar` / `AppProgressTrack`** | ۷ مورد | در Your Rank | ۴۰ مورد | **۴۸ مورد در ۲۴ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/progress/` |
| **`AppSelectionTile` / `AppRadioCard`** | ۱۶ مورد | ۴ مورد | ۳۱ مورد | **۵۱ مورد در ۱۵ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/selection/` |
| **`AppBanner` / `AppCallout`** | ۱۲ مورد | ۶ مورد | ۱۶ مورد | **۳۴ مورد در ۲۸ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/banners/` |
| **`AppStickyActionBar`** | ۱۴ مورد | ۲ مورد | ۹ مورد | **۲۵ مورد در ۲۵ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/navigation/` |
| **`AppSegmentedTabs`** | ۹ مورد | ۶ مورد | — | **۱۵ مورد در ۱۵ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/tabs/` |
| **`AppTimeline` (عمودی)** | ۱ مورد | — | ۷ مورد | **۸ مورد در ۸ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/timeline/` |
| **`AppStateHero` / `AppEmptyState`** | ۵ مورد | ۲ مورد | ۴ مورد | **۱۱ مورد در ۱۱ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/feedback/` |
| **`AppPodium` (سکوی سه‌گانه)** | — | ۱۱ مورد | در Onboarding (D-143) | **۱۲ مورد در ۱۲ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/gamification/` |
| **`AppCountdownCard`** | — | ۴ مورد | در ماموریت‌ها | **۵ مورد در ۵ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/cards/` |
| **`AppSkeletonCard`** | — | — | ۳ مورد | **۳ مورد در ۱ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/loading/` |
| **`AppNpsScale` (۰ تا ۱۰)** | — | — | ۱ مورد | **۱ مورد در ۱ فریم** | **لایه ۱ (Core DS)** | `packages/design_system/lib/src/components/rating/` |
| **`AppMissionCard`** | — | — | ۳۲ مورد | **۳۲ مورد** | **لایه ۲ (Shared Product)** | `lib/shared/widgets/mission_card.dart` |
| **`AppQuestStepRow` & `QuestHero`** | — | — | ۵۶ سطر | **۵۶ مورد** | **لایه ۲ (Shared Product)** | `lib/shared/widgets/quest_step_row.dart` |
| **`LeaderboardRankRow`** | — | ۲۶ سطر | — | **۲۶ سطر فعال** | **لایه ۲ (Shared Product)** | `lib/shared/widgets/leaderboard_rank_row.dart` |
| **`LeaderboardStickyRankBar`** | — | ۷ مورد | — | **۷ مورد** | **لایه ۲ (Shared Product)** | `lib/shared/widgets/leaderboard_sticky_rank_bar.dart` |
| **`CoinPackCard` / `CoinPackTile`** | ۲۶ مورد | در Drawer | — | **۲۶ مورد** | **لایه ۲ (Shared Product)** | `lib/shared/widgets/coin_pack_card.dart` |
| **`RewardPackageCard` (دیتا همراه اول)** | ۱۲ مورد | — | — | **۱۲ مورد** | **لایه ۲ (Shared Product)** | `lib/shared/widgets/reward_package_card.dart` |
| **`RelatedOrderCard` (کارت پیگیری سفارش)** | ۵ مورد | — | — | **۵ مورد** | **لایه ۲ (Shared Product)** | `lib/shared/widgets/related_order_card.dart` |
| **`ChatMessageBubble` (چت تیکت و باگ)** | ۷ مورد | — | ۸ مورد | **۱۵ مورد** | **لایه ۲ (Shared Product)** | `lib/shared/widgets/chat_message_bubble.dart` |
| **`MissionRewardTiles` (دوقلوی پاداش)** | — | — | ۴ مورد | **۴ مورد** | **لایه ۲ (Shared Product)** | `lib/shared/widgets/mission_reward_tiles.dart` |
| **`QaDisputeCard` (کارت داوری و اعتراض)** | — | — | ۳ مورد | **۳ مورد** | **لایه ۲ (Shared Product)** | `lib/shared/widgets/qa_dispute_card.dart` |

---

## ۳. کاتالوگ تصویب‌شده لایه اول: هسته دیزاین سیستم (Layer 1 — Core Design System)

این کامپوننت‌ها باید به عنوان ویجت‌های خالص و دارای `ElementIdentity` در پکیج `packages/design_system` پیاده‌سازی شوند. هیچ‌کدام از این ویجت‌ها حق استفاده از مدل‌های تجاری پلتفرم (مانند مدل Player، Order یا Mission) را ندارند:

### ۱. `AppFilterChips` و `AppFilterBar`
- **کاربرد سراسری**: فیلترهای شاپ (P02, P10, P14)، فیلترهای لیدربورد (L01, L05, L07)، فیلترهای ماموریت‌ها (M40, M46, M56, M59).
- **پارامترها و Variantها**:
  - `selected`: `bool` (هایلایت تاکیدی با کانتینر پررنگ در برابر کانتینر خنثی).
  - `leadingIcon`: `AppIconId?` (آیکون اختیاری در سمت Start).
  - `hasCheckmark`: `bool` (نمایش تیک در حالت انتخاب‌شده).
  - `label`: `String`.
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/chips/app_filter_chip.dart`

### ۲. `AppKeyValueRow` / `AppDataRow`
- **کاربرد سراسری**: ردیف‌های داده فاکتور شاپ (۶۶ بار)، قوانین امتیاز لیدربورد (L01, L20)، رسید تاریخچه پاداش‌ها (M59).
- **پارامترها و Variantها**:
  - `variant`: enum `AppDataRowVariant { regular, total, status, link }`.
  - `label`: `String` (سمت Start).
  - `value`: `String` (سمت End).
  - `status`: `Widget?` (اسلات بج وضعیت برای واریانت status).
  - `hasTopDivider`: `bool` (برای سطرهای جمع کل فاکتور).
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/collections/app_key_value_row.dart`

### ۳. `AppProgressBar` / `AppProgressTrack`
- **کاربرد سراسری**: پیشرفت ماموریت‌ها (۴۰ بار)، سقف مصرف همراه اول DCB در شاپ (P03)، نوار پیشرفت رتبه لیدربورد (L01).
- **پارامترها و Variantها**:
  - `value`: `double` (بین 0.0 تا 1.0).
  - `height`: enum `AppProgressHeight { sm /* 6pt */, md /* 8pt */, lg /* 12pt */ }`.
  - `color`: enum `AppProgressColor { primary, emerald, amber, purple }`.
  - `trackColor`: `Color?`.
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/progress/app_progress_bar.dart`

### ۴. `AppStatusChip` / `AppStatusBadge`
- **کاربرد سراسری**: بج‌های سمانتیک وضعیت در شاپ (Success, Refunded, Failed, Open, Closed)، لیدربورد (Live, Finished, Paused, Cancelled, Calculating) و ماموریت‌ها (Ready, Claimed, Expired, Locked, Confirmed).
- **پارامترها و Variantها**:
  - `status`: enum `AppStatusType { success, error, warning, pending, neutral, info, live }`.
  - `label`: `String`.
  - `hasDot`: `bool` (نمایش نقطه چشمک‌زن یا ثابت برای وضعیت‌های Live).
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/badges/app_status_chip.dart`

### ۵. `AppSelectionTile` / `AppOptionCard`
- **کاربرد سراسری**: انتخاب درگاه‌های بانکی و همراه اول در شاپ (P03)، نظرسنجی‌ها و آزمون‌ها (M50, M51)، گزارش تخلف لیدربورد (L16).
- **پارامترها و Variantها**:
  - `selected`: `bool`.
  - `title`: `String`.
  - `subtitle`: `String?`.
  - `leadingIcon`: `Widget?`.
  - `trailingControl`: enum `SelectionControlType { radio, checkbox, none }`.
  - `bottomSlot`: `Widget?` (اسلات باز برای قرارگیری نوار پیشرفت یا پیام اخطار).
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/selection/app_selection_tile.dart`

### ۶. `AppBanner` / `AppCallout`
- **کاربرد سراسری**: پیام‌های راهنمای شاپ (Info Note و Warning)، بنرهای لیدربورد (L02, L10, L13, L17)، اخطارهای تعلیق و کمپین در ماموریت‌ها (M14, M32, M36).
- **پارامترها و Variantها**:
  - `type`: enum `AppBannerType { info, warning, error, announcement, campaign }`.
  - `title`: `String?`.
  - `message`: `String`.
  - `icon`: `AppIconId?`.
  - `action`: `Widget?` (دکمه یا لینک متنی اختیاری در انتها).
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/banners/app_banner.dart`

### ۷. `AppStickyActionBar`
- **کاربرد سراسری**: نوارهای شناور دکمه در ۱۴ فریم شاپ، شیت‌های لیدربورد، و فرم‌های ثبت باگ و نظرسنجی ماموریت‌ها.
- **پارامترها و Variantها**:
  - `layout`: enum `StickyActionLayout { single, dualHorizontal, dualVertical, withHeader }`.
  - `headerSlot`: `Widget?` (اسلات بالایی برای نمایش باقیمانده امتیاز یا پیام کمکی).
  - `primaryAction`: `Widget`.
  - `secondaryAction`: `Widget?`.
  - رعایت خودکار `SafeArea(bottom: true)`.
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/navigation/app_sticky_action_bar.dart`

### ۸. `AppSegmentedTabs`
- **کاربرد سراسری**: تب Coins/Rewards در ۹ فریم شاپ و تب Overall/Games در ۶ فریم لیدربورد (مجموعاً ۱۵ فریم).
- **پارامترها و Variantها**:
  - `tabs`: `List<AppSegmentTabItem>`.
  - `selectedIndex`: `int`.
  - `onChanged`: `ValueChanged<int>`.
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/tabs/app_segmented_tabs.dart`

### ۹. `AppTimeline` (عمودی)
- **کاربرد سراسری**: مراحل فرآیندی تایید تسک شرکا (M26)، تایم‌لاین بررسی باگ QA (M41, M43) و پیگیری سفارش شاپ.
- **پارامترها و Variantها**:
  - `steps`: `List<AppTimelineStep>`.
  - `currentStepIndex`: `int`.
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/timeline/app_timeline.dart`

### ۱۰. `AppPodium` (سکوی سه‌گانه رتبه‌بندی)
- **کاربرد سراسری**: ۱۱ فریم لیدربورد و اسلاید سکوی آنبوردینگ (D-143).
- **طراحی انتزاعی**: سکوی ۳ پدستال با اسلات ویجت باز برای رتبه‌های ۱، ۲ و ۳ (کاملاً مستقل از کلاس بازیکن).
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/gamification/app_podium.dart`

### ۱۱. `AppStateHero` / `AppEmptyState`
- **کاربرد سراسری**: صفحات موفقیت و خطای شاپ (P04, P05)، وضعیت بورد خاموش یا تایید جایزه لیدربورد (L04, L12)، صفحات خالی و ردصلاحیت ماموریت‌ها (M02, M29, M53).
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/feedback/app_state_hero.dart`

### ۱۲. `AppCountdownCard`
- **کاربرد سراسری**: کارت روزشمار زمان باقیمانده دوره لیدربورد (L01, L20) و ایونت‌های زمان‌دار شاپ و ماموریت‌ها.
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/cards/app_countdown_card.dart`

### ۱۳. `AppSkeletonCard`
- **کاربرد سراسری**: وایرفریم انیمیشن شیمر لودینگ کارت‌ها (M09).
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/loading/app_skeleton_card.dart`

### ۱۴. `AppNpsScale` (مقیاس ۰ تا ۱۰)
- **کاربرد سراسری**: پرسشنامه‌های ارزیابی رضایت و نظرسنجی اسپانسرها (M52).
- **مسیر پیشنهادی**: `packages/design_system/lib/src/components/rating/app_nps_scale.dart`

---

## ۴. کاتالوگ تصویب‌شده لایه دوم: ویجت‌های مشترک محصولی (Layer 2 — Shared Product Widgets)

این ویجت‌ها به مدل‌های دامین، تعاریف بازی، ارزها و لاجیک محصول P2E متصل هستند و در مسیر `lib/shared/widgets/` قرار می‌گیرند تا چندین فیچر بتوانند از آن‌ها استفاده کنند بدون اینکه وارد پکیج مستقل دیزاین سیستم شوند:

### ۱. `AppMissionCard`
- **حوزه اشتراک**: فیچر `missions`، صفحه `home` (سکشن For You)، و تب ماموریت‌ها در صفحه جزئیات بازی (`game_details`).
- **مدل دامین**: متصل به `MissionEntity` با ۵ استیت رسمی: `notStarted`، `inProgress`، `readyToClaim`، `claimed`، `expired`.
- **مسیر**: `lib/shared/widgets/mission_card.dart`

### ۲. `AppQuestStepRow` و `AppQuestHero`
- **حوزه اشتراک**: فیچر `missions`، هیرو کوئست و صفحه آنبوردینگ (`onboarding_quests`).
- **مدل دامین**: گام‌های کوئست با ۷ وضعیت، محاسبه پاداش مرحله‌ای و سقف نهایی.
- **مسیر**: `lib/shared/widgets/quest_step_row.dart`

### ۳. `LeaderboardRankRow`
- **حوزه اشتراک**: فیچر `leaderboard`، صفحه `game_details` (مینی‌لیدربورد مسابقه بازی) و صفحه `home`.
- **مدل دامین**: نمایش رتبه، ویجت `PlayerAvatar`، نام کاربری، نشان توکن و میزان امتیاز.
- **مسیر**: `lib/shared/widgets/leaderboard_rank_row.dart`

### ۴. `LeaderboardStickyRankBar`
- **حوزه اشتراک**: نوار شناور نمایش رتبه کاربر جاری در لیدربورد و ویجت چسبان صفحه مسابقات بازی.
- **مدل دامین**: استیت رتبه من (`Your Rank`)، فاصله تا ۱۰ نفر برتر، یا استیت کاربر رتبه‌بندی‌نشده.
- **مسیر**: `lib/shared/widgets/leaderboard_sticky_rank_bar.dart`

### ۵. `CoinPackCard` / `CoinPackTile`
- **حوزه اشتراک**: صفحه `shop` (تب خرید سکه) و باتم‌شیت‌های پرداخت درون‌برنامه‌ای (`CheckoutHost`) در حین بازی.
- **مدل دامین**: پکیج‌های سکه با قیمت تومانی، نشان رشد سکه و پاداش توکن پلتفرم.
- **مسیر**: `lib/shared/widgets/coin_pack_card.dart`

### ۶. `RewardPackageCard`
- **حوزه اشتراک**: صفحه `shop` (تب جوایز اینترنت همراه اول) و بخش ردیم امتیازات در پروفایل کاربر.
- **مدل دامین**: بسته‌های دیتای همراه اول با حجم، دوره انقضا و قیمت امتیازی.
- **مسیر**: `lib/shared/widgets/reward_package_card.dart`

### ۷. `RelatedOrderCard`
- **حوزه اشتراک**: تاریخچه سفارشات شاپ (`shop/history`) و مرکز تیکت‌های پشتیبانی (`support/ticket`).
- **مدل دامین**: شناسه سفارش، تاریخ خرید، وضعیت تحویل بسته و لینک الصاق به تیکت.
- **مسیر**: `lib/shared/widgets/related_order_card.dart`

### ۸. `ChatMessageBubble` و `ThreadView`
- **حوزه اشتراک**: تیکت‌های پشتیبانی فروشگاه (P15, P17) و گفتگوی باگ‌های QA با سازندگان (M41).
- **مدل دامین**: پیام کاربر، پیام پشتیبان/توسعه‌دهنده، ضمیمه فایل لاگ و متادیتای دستگاه.
- **مسیر**: `lib/shared/widgets/chat_message_bubble.dart`

### ۹. `MissionRewardTiles`
- **حوزه اشتراک**: مدال دریافت پاداش در ماموریت‌ها، اهدای جایزه لیدربورد و پاداش‌های ثبت‌نام.
- **مدل دامین**: کارت‌های دوقلوی امتیاز طلایی (`Points`) و توکن (`Tokens`).
- **مسیر**: `lib/shared/widgets/mission_reward_tiles.dart`

### ۱۰. `QaDisputeCard`
- **حوزه اشتراک**: بخش گزارش باگ‌ها در `missions/qa` و مرکز داوری و رسیدگی به شکایات پلتفرم.
- **مدل دامین**: استیت‌های ۳ گانه اعتراض با مهلت ۷ روزه و استعلام سقف تیکت‌های فعال.
- **مسیر**: `lib/shared/widgets/qa_dispute_card.dart`

### ۱۱. `ReferralProgressCard`
- **حوزه اشتراک**: فیچر ماموریت‌های پلتفرم (M58)، صفحه پروفایل کاربر و بخش هاب اجتماعی (`social`).
- **مدل دامین**: کد معرف، لیست وضعیت دوستان معرفی‌شده و دکمه اشتراک‌گذاری سیستم‌عامل.
- **مسیر**: `lib/shared/widgets/referral_progress_card.dart`

---

## ۵. کاتالوگ لایه سوم: ویجت‌های اختصاصی هر فیچر (Layer 3 — Feature-Private Widgets)

این مؤلفه‌ها تک‌مالکه (Single-Owner) بوده و خروج آن‌ها از پوشه فیچر ممنوع است:

1. **فیچر `shop` (`lib/features/shop/presentation/widgets/`)**:
   - `DiscountCodeInput`: فیلد اختصاصی اعمال کد تخفیف با دکمه توکار Apply.
   - `PrizeCard`: کارت‌های جوایز فیزیکی قرعه‌کشی (آیفون و پلی‌استیشن).
   - `ShopPointsHeaderCard`: هدر بزرگ بالانس موجودی تب پاداش‌ها.
2. **فیچر `leaderboard` (`lib/features/leaderboard/presentation/widgets/`)**:
   - `LeaderboardRewardTiers`: جدول ۳ ستونه سطوح رتبه‌بندی و سهمیه جوایز.
   - `GameBoardTileCard`: کاور و متادیتای اختصاصی مسابقات بازی‌ها در تب Games.
   - باتم‌شیت‌های تخصصی: `LeaderboardRulesSheet`, `PlayerSummarySheet`, `ReportRankProblemSheet`, `EarnTokensSheet`.
3. **فیچر `missions` (`lib/features/missions/presentation/widgets/`)**:
   - `MissionCategoryTile`: شبکه کاشی‌های ۵ دسته در ورودی ماموریت‌ها.
   - `QaTestCard`: کارت شرایط شرکت در تست بازی با سقف باگ و ودیعه.
   - `QaBugReportRow`: سطر مدیریت باگ‌های ارسالی کاربر.
   - `PartnerAppCard`: تسک‌های نصبی اپلیکیشن‌های شرکا با ترک لاجیک SDK.
   - `SurveyEngineView`: صفحات موتور پرسشنامه چندمرحله‌ای اسپانسرها.

---

## ۶. نقشه راه و اولویت‌بندی پیاده‌سازی مهندسی (Implementation Roadmap)

پیاده‌سازی باید بر اساس پیش‌نیازها و بالاترین ضریب بازگشت سرمایه توسعه (ROI) در ۳ فاز سازماندهی شود:

```
┌────────────────────────────────────────────────────────────────────────┐
│ فاز ۱: مؤلفه‌های بنیادین پرمصرف لایه اول (Core DS Primitives)            │
│ 1. AppFilterChips / AppFilterBar (استفاده در بیش از ۲۲۰ موقعیت)        │
│ 2. AppProgressBar / AppProgressTrack (استفاده در ۴۸ فریم)              │
│ 3. AppKeyValueRow / AppDataRow (استفاده در ۸۱ موقعیت فاکتور و آمار)   │
│ 4. AppStatusChip / AppStatusBadge (پوشش بیش از ۱۱۰ نشان وضعیت)         │
│ 5. AppStickyActionBar (پوشش نوارهای ثابت پایین در ۲۵ صفحه)            │
│ 6. AppSegmentedTabs (پوشش تب‌های اصلی شاپ و لیدربورد)                  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ فاز ۲: کامپوننت‌های تکمیلی لایه اول و ویجت‌های دوقلوی لایه دوم          │
│ • لایه اول: AppBanner, AppSelectionTile, AppTimeline, AppPodium,       │
│             AppStateHero, AppCountdownCard, AppSkeletonCard            │
│ • لایه دوم: AppMissionCard, AppQuestStepRow, LeaderboardRankRow,       │
│             LeaderboardStickyRankBar, CoinPackCard, RewardPackageCard  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ فاز ۳: ماژول‌های پیشرفته دامین و اتصال صفحات فیچرها (Feature Assembly)   │
│ • لایه دوم تکمیلی: ChatMessageBubble, QaDisputeCard, ReferralCard      │
│ • صفحات کامل: Shop Assembly, Leaderboard Assembly, Missions Engine     │
└────────────────────────────────────────────────────────────────────────┘
```

---
*سند حاضر ماتریس رسمی معماری و مرجع نهایی هدایت توسعه ویجت‌های فلاتر برای تیم توسعه‌دهنده محسوب می‌شود.*
