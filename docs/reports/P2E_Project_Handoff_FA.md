# گزارش انتقال پروژه MyGame P2E به چت و سیستم جدید

> این سند برای آشناکردن دستیار یا ایجنت جدید با پروژه، اولویت‌های مالک، تصمیم‌های جاری و نقطه ادامه کار نوشته شده است. این سند گزارش انتقال است، نه دستور برای شروع خودکار توسعه یا بازنویسی پروژه.
>
> مبنای وضعیت: مکالمات قبلی، گزارش‌های ایجنت برنامه‌نویس و آخرین اعلام مالک مبنی بر پیاده‌شدن اصلاحات تکمیلی. گزارش تفصیلی و شواهد آخرین مرحله در این چت بازبینی نشده‌اند. هرجا «گزارش شده» آمده، آن را با «مستقلاً بررسی و تأیید شده» یکسان ندانید.

## ۱. پروژه چیست و الان کجا هستیم؟

- نام پروژه: **MyGame P2E / P2E**، مرتبط با همراه اول / MCI.
- فناوری اصلی: Flutter و Dart.
- هدف محصول: اپلیکیشن Android و iOS. توسعه و اعتبارسنجی انجام‌شده عمدتاً روی Windows بوده است.
- فرانت‌اند توسط مالک و ایجنت برنامه‌نویس توسعه داده می‌شود؛ بک‌اند واقعی را شخص دیگری توسعه می‌دهد.
- فعلاً نباید قرارداد شبکه یا جزئیات بک‌اند واقعی را حدس زد.
- پروژه از مرحله ساخت Design System عبور کرده، Foundation اپلیکیشن و ابزارهای توسعه ساخته شده‌اند و اولین صفحه واقعی محصول، **Auth Entry**، پیاده‌سازی شده است.
- صفحه Auth Entry چهار حالت یک صفحه است؛ ساخته‌شدن آن به معنی کامل‌شدن Login/Register یا کل جریان احراز هویت نیست.
- مقصدهای OTP، ورود با رمز و ساخت رمز در آخرین وضعیت مستند، placeholder بوده‌اند. وجود کامپوننت OTP در Design System به معنی ساخته‌شدن صفحه OTP محصول نیست.
- آخرین اصلاحات تکمیلی، بنا بر اعلام مالک، پیاده شده‌اند؛ گزارش و شواهدشان باید از سیستم جدید خوانده شوند.
- مرحله بعدی برنامه‌ریزی‌شده: پس از بستن بازبینی Auth Entry و تغییرات golden، توسعه صفحه OTP.

## ۲. شیوه همکاری و انتظارات مالک

### نقش دستیار و ایجنت برنامه‌نویس

در روند قبلی:

1. دستیار نقش معمار، بررسی‌کننده و کنترل‌کننده کیفیت را داشته است.
2. مسئله و Figma بررسی می‌شده‌اند.
3. یک پرامپت اجرایی دقیق **به انگلیسی** برای ایجنت برنامه‌نویس نوشته می‌شده است.
4. ایجنت تغییرات را روی سیستم مالک انجام می‌داده و گزارش **به فارسی** ارائه می‌کرده است.
5. دستیار گزارش، شواهد، تصاویر و تصمیم‌ها را بررسی می‌کرده و اصلاحات بعدی را مشخص می‌کرده است.

اگر دستیار جدید مستقیماً به repository دسترسی دارد، می‌تواند وضعیت واقعی را بخواند؛ اما نباید وانمود کند به فایل‌های محلی دسترسی دارد وقتی چنین دسترسی‌ای ندارد.

### ترجیحات ارتباطی

- گفتگو و گزارش برای مالک: **فارسی، روشن، مستقیم و بدون تعارف اضافی**.
- پرامپت اجرایی ایجنت، کد، نام‌گذاری، کامنت‌ها و مستندات فنی repository: انگلیسی، مطابق قواعد موجود پروژه.
- نتیجه را اول بگویید؛ سپس دلیل، ریسک و اقدام لازم را توضیح دهید.
- بین خطای واقعی، محدودیت ابزار، اختلاف قابل‌قبول رندر و ترجیح طراحی تفاوت بگذارید.
- مالک تصمیم‌های باز را به دستیار واگذار کرده و گفته است: **«خودت تصمیم بگیر؛ اگر موافق نبودم اصلاحش می‌کنم.»** بنابراین بابت هر انتخاب کوچک متوقف نشوید؛ تصمیم مستدل بگیرید و ثبت کنید. این اختیار، مجوز حدس‌زدن قرارداد بک‌اند، تغییر Figma، نقض معماری یا تغییر بی‌سروصدای قواعد قطعی نیست.
- در هر تسک محدوده کار، موارد خارج از محدوده، معیار پذیرش و شواهد تحویل مشخص باشند.
- گزارش صرفاً با «همه تست‌ها پاس شد» پذیرفته نیست؛ باید معلوم باشد چه چیزی، در چه محیطی و با چه محدودیت‌هایی تست شده است.

### محدودیت تغییرات

- در روند قبلی پروژه Git در دسترس نبود و هیچ commit نباید انجام می‌شد.
- انتقال به سیستم جدید، اجازه خودکار برای Git init، commit، push یا تغییر ساختار کنترل نسخه نیست.
- وضعیت جدید را بررسی کنید، ولی تا دستور صریح مالک **commit نکنید**.
- فایل‌های غیرمرتبط و تغییرات قبلی مالک را حفظ کنید؛ در نبود Git از manifest/hash یا روش مشابه استفاده شده است.
- SDK یا dependency را برای راحت‌ترشدن یک تسک خودسرانه ارتقا ندهید. ناسازگاری واقعی را با شواهد گزارش کنید.

## ۳. مهم‌ترین حساسیت‌های مالک؛ قواعد غیرقابل‌چشم‌پوشی

1. **وفاداری واقعی به Figma، نه شبیه‌سازی چشمی.** فونت، وزن، tracking، line-height، فاصله، رنگ، اندازه و حالت‌ها اهمیت دارند.
2. **معماری تمیز و SOLID.** صفحه نباید مجموعه‌ای از widgetهای ظاهراً درست ولی غیرقابل‌نگهداری باشد.
3. **Features فقط composition انجام می‌دهند؛ styling در Design System است.**
4. **بک‌اند جعلی باید قابل‌جایگزینی باشد.** اتصال بک‌اند واقعی نباید باعث بازنویسی UI و domain شود.
5. **Inspector واقعاً جداشدنی باشد.** حتی حذف فایل‌های ابزار نباید اجرای محصول را خراب کند.
6. **پاسخ‌گویی به اندازه صفحه، کیبورد، RTL، مقیاس متن، theme و skin از ابتدا جدی است.**
7. **ابزارهای توسعه، داده حساس و fake backend نباید به نسخه production نشت کنند.**
8. **سبزشدن تست، جای بازبینی بصری را نمی‌گیرد.**
9. **برای سبزکردن تست، assertion را ضعیف یا golden اشتباه را تأیید نکنید.**
10. **تصمیم موقت باید موقت و قابل‌ردیابی بماند.** نبود طراحی نباید به منبع جعلی Figma تبدیل شود.
11. **اصلاح ریشه‌ای بر offset و hack مخصوص یک screenshot اولویت دارد.**
12. **گزارش صادقانه مهم است.** «پیاده شد»، «تست شد»، «گزارش شد» و «بازبینی و پذیرفته شد» چهار وضعیت متفاوت‌اند.

## ۴. منابع حقیقت و اسنادی که باید اول خوانده شوند

### ترتیب تصمیم‌گیری

- **Figma:** مرجع ظاهر.
- **Architecture v1.3 + Addendum v1.4:** مرجع ساختار، لایه‌ها، state، routing و قواعد کلی.
- **Decision register جدیدتر:** در حوزه مربوط بر تصمیم‌های قدیمی مقدم است.
- **کد و تست فعلی repository:** مرجع وضعیت واقعی پیاده‌سازی؛ با اسناد تطبیق داده شود.

این گزارش جایگزین اسناد repository نیست. بعضی متن‌های قدیمی عمداً با تصمیم جدید supersede شده‌اند؛ نباید صرفاً چون در AGENTS قدیمی یا Addendum آمده‌اند دوباره اجرا شوند.

### فایل‌های کلیدی

- `AGENTS.md`
- `docs/agents/rules/`
- `docs/agents/registers/decisions.md`
- `docs/agents/registers/errata.md`
- `docs/agents/registers/designer-requests.md`
- `docs/agents/registers/overrides.md`
- `docs/agents/registers/platform-exceptions.md`
- `docs/agents/figma-map.md`
- `docs/reference/README.md`
- Architecture v1.3 و Addendum v1.4؛ مسیر سند در مراحل قبلی بین بخش reference و architecture ارجاع داده شده است. مسیر واقعی را از index و فایل‌های موجود پیدا کنید؛ سند موازی نسازید.
- `docs/reference/identity/P2E_UI_Identity_and_Inspection_Contract_v1.1.md`
- `docs/reference/identity/p2e-ui-inspector-snapshot.schema.json`
- `docs/design-system/contracts/`

### شناسه‌های ثبت‌ها

- `D-###`: تصمیم پروژه.
- `E-###`: ایراد/ابهام در Figma.
- `R-###`: درخواست از طراح.
- `O-###`: override صریح.
- `PE-###`: استثنای رفتار پلتفرم.

شماره‌های سه‌رقمی ثبت پروژه مثل `D-044` را با Decision Log معماری مثل `D-01` تا `D-25` یکی نگیرید. آخرین شماره تصمیم را از register بخوانید؛ خودکار فرض نکنید هنوز D-060 آخرین مورد است.

### قواعد و فایل‌های generated ایجنت‌ها

- منابع canonical: `AGENTS.md`، `docs/agents/rules/` و skillهای اصلی `.agents/skills/p2e-*`.
- کپی‌های Cursor، Claude و ابزارهای دیگر generated هستند؛ آن‌ها را دستی اصلاح نکنید.
- فرمان sync موجود: `dart run tool/agents/sync_agent_files.dart` و برای کنترل `--check`.
- skillهای پروژه، در صورت وجود، قبل از کار مرتبط خوانده شوند: `p2e-figma-audit`، `p2e-figma-snapshot`، `p2e-component-contract`، `p2e-build-ds-component`، `p2e-build-screen` و `p2e-design-registers`.

## ۵. محیط، ساختار و ملاحظات انتقال سیستم

### مسیر و نسخه‌ها

مسیر قبلی پروژه:

`D:\My_Script\Hamrah-Aval\P2E`

این مسیر، مسیر سیستم جدید را تضمین نمی‌کند. مسیر Flutter در سیستم قبلی نیز نباید به سیستم جدید hard-code شود.

آخرین نسخه‌های ثبت‌شده در گزارش Foundation:

| ابزار/پکیج | نسخه ثبت‌شده |
|---|---|
| Flutter | 3.47.7 |
| Dart bundled | 3.13.5 |
| flutter_riverpod / riverpod | 3.4.3 |
| riverpod_generator | 4.0.9 |
| riverpod_annotation | 4.0.7 |
| riverpod_lint | 3.1.9 |
| analysis_server_plugin | 0.3.18 |
| build_runner | 2.15.1 |
| go_router | 18.1.1 |
| intl | 0.20.3 |

این جدول سابقه است؛ روی سیستم جدید `.fvmrc`، `pubspec.yaml`، lockfile و خروجی واقعی ابزارها بررسی شوند. Flutter قبلی با نسخه فوق گزارش شده، اما checkout آن روی یک channel رسمی نام‌دار نبوده است؛ صرف نام نسخه را تضمین یکسان‌بودن binary/commit ندانید.

- Riverpod runtime نسخه 3 و generator/annotation نسخه 4، انتخاب بررسی‌شده پروژه است؛ صرف تفاوت majorها را ناسازگاری تلقی نکنید.
- lint با `analysis_server_plugin` کار می‌کند؛ `custom_lint` و بسته‌های وابسته‌اش حذف شده‌اند.
- در build_runner 2.15.1، گزینه `--delete-conflicting-outputs` حذف شده است؛ به پرامپت، فرمان یا مستندات جدید اضافه نشود.
- فایل‌های generated از منبع خود تولید شوند؛ خروجی generator دستی patch نشود.

### نقشه ساختاری فعلی، به‌صورت خلاصه

```text
<project-root>/
  lib/
    app/                         # bootstrap، config، composition، startup، router
    core/                        # errors، diagnostics و زیرساخت پایه
    shared/                      # session، formatting، platform ports، widgets محصولی
    features/
      auth/                      # domain، data، presentation؛ ساختار دقیق را از کد بخوانید
        .../data/fake/            # fakeهای feature؛ نه backend production
  packages/
    design_system/               # package: p2e_design_system
  apps/
    design_system_viewer/         # مصرف‌کننده دوم DS و کاتالوگ توسعه
  dev_tools/
    inspector/
      ...
      hosts/
        product_host/
        viewer_host/
  docs/
  tool/
  config/
```

- این نقشه برای فهم معماری است، نه فهرست دقیق همه فایل‌ها.
- مسیر قدیمی `lib/ui` در برخی اسناد تاریخی آمده است؛ Design System اکنون در package مستقل است. آن را دوباره به `lib/ui` برنگردانید.
- مستقل‌شدن DS مجوز چندپکیجی‌کردن بی‌دلیل همه featureها نیست؛ محصول همچنان root package است.
- Viewer با Inspector یک چیز نیست؛ Viewer یک مصرف‌کننده مستقل DS است، Inspector ابزار مشاهده و بررسی روی hostهای جداست.

## ۶. اصول معماری محصول

### لایه‌ها و SOLID

- `app` مسئول composition و wiring است.
- `domain` شامل value object، entity و abstractionهای موردنیاز است؛ باید pure Dart بماند.
- استثنای صریح D-055: domain می‌تواند فقط فایل تأییدشده `lib/core/errors/app_failure.dart` را از core/errors وارد کند. این مجوز import عمومی core یا Flutter نیست.
- `data` مسئول data source، DTO، mapper و implementation قراردادهاست.
- `presentation` از abstractionهای domain استفاده می‌کند؛ UI نباید transport، endpoint یا DTO را بشناسد.
- Controller نباید `BuildContext` یا widget نگه دارد.
- `TextEditingController` و `FocusNode` متعلق به lifecycle widget هستند.
- dependency injection با Riverpod/composition انجام می‌شود؛ service locator یا singleton سراسری خودسرانه اضافه نشود.
- interfaceها کوچک و متناسب با مسئولیت باشند؛ یک repository عظیم برای همه عملیات نسازید.
- fake و remote باید قرارداد رفتاری یکسان داشته باشند؛ تست قرارداد مشترک برای repositoryها مهم است.
- `tool/check_architecture.dart` و تست‌های منفی مرزها وجود دارند؛ checker کمک‌کننده و lexical است، نه اثبات کامل معماری.

### Foundation پیاده‌شده

- bootstrap با hookهای خنثی `rootWrapper` و `providerOverrides`، از جمله مسیر composition مورد استفاده hostها.
- startup controller و router واکنشی.
- session حافظه‌ای با وضعیت‌های signedOut / signedIn / expired.
- زیرساخت localization و تبدیل/نمایش ارقام.
- `AppFailure` و `Result` در فایل تأییدشده core/errors.
- logger با redaction و محافظت اطلاعات حساس.
- config محیط‌ها؛ از افزودن endpoint یا secret حدسی خودداری شود.
- session حافظه‌ای را با احراز هویت واقعی، secure storage یا persistence آماده اشتباه نگیرید.
- محل خنثی startup برای splash آینده باز گذاشته شده؛ صفحه لوگو طراحی/ساخته نشده است.

## ۷. قواعد Design System و تطابق با Figma

### دسترسی Figma

**Figma کاملاً read-only است.** تغییر فایل، component، asset، variant، mapping یا هر write دیگر بدون دستور جدید صریح ممنوع است.

فایل اصلی:

`7PGTHT5CQzbTsWZQnPIQce`

لینک مرجع صفحه ورود: [Auth Entry در Figma](https://www.figma.com/design/7PGTHT5CQzbTsWZQnPIQce/?node-id=18608-11451)

### شیوه پیاده‌سازی

- tokenها و registryهای generated از snapshot و منبع canonical تولید می‌شوند.
- رنگ، font size، spacing، radius، duration و سایر raw visual valueها در feature و shared widget پراکنده نشوند؛ محل مجاز و generator را از قواعد فعلی بخوانید.
- نیاز جدید ابتدا با token/component مناسب حل شود؛ override فقط با شناسه، دلیل و ثبت رسمی.
- featureها از public API دیزاین‌سیستم استفاده کنند؛ import از implementation خصوصی package یا ساخت مجدد کنترل‌های Material/Cupertino در feature ممنوع است.
- پارامترهای variant با enum و قراردادهای واقعی مدل شوند؛ برای دورزدن DS به feature پارامتر دلخواه `Color`، `TextStyle` یا padding ندهید.
- brightness معمولاً از theme خوانده می‌شود؛ برای هر widget یک پارامتر مستقل Light/Dark نسازید.
- ترکیب نامعتبر variant باید تشخیص داده شود؛ نبود یک variant در Figma با جعل designRef حل نشود.
- هر جزء بدون طراحی، `provisional` و source-unlinked باقی بماند تا تصمیم یا طراحی معتبر برسد.
- خطای تایپی یا تناقض Figma عیناً تکثیر نشود؛ در errata ثبت و تصمیم‌گیری شود.
- آیکن‌ها از assetهای تأییدشده Figma و مسیر عمومی AppIcon مصرف شوند؛ `Icons.*`، `CupertinoIcons.*` یا icon package جایگزین خودسرانه منبع طراحی نشوند.
- snapshot، asset و token generated با هم قابل‌ردیابی بمانند؛ خروجی generator دستی اصلاح نشود.

### خانواده‌های ساخته‌شده

در وضعیت مستند، این خانواده‌ها و زیرساخت‌هایشان وجود دارند:

- Button و Badge.
- AppIcon و assetهای آیکن از منبع تأییدشده.
- TextField، PasswordField، OTPField و Radio.
- App Bar و Navigator / Navigation Bar.
- adaptive primitives از جمله SizeClass و PageScaffold.
- typography، tokens، theme/skin و identity/inspection metadata.
- primitiveهای لازم Auth مانند divider متنی، متن لینک‌دار، hero، toast، social tile و toggle مستقل؛ API دقیق از کد خوانده شود.
- widget محصولی RewardPill در shared، بر پایه DS؛ داده هدیه نباید در widget به‌عنوان عدد تجاری ثابت شود.

### اصلاح بسیار مهم Button: D-059

- همه ۹۰ variant در ۱۸ set بررسی شده‌اند.
- در موارد بررسی‌شده، **ارتفاع fixed/rendered frame فیگما مرجع است، نه جمع‌کردن padding و line-height**.
- ارتفاع بصری اندازه‌ها: Small = 36، Medium = 46، Large = 56 logical px.
- icon buttonها ابعاد ثبت‌شده خودشان را دارند؛ این سه عدد را کورکورانه به همه کنترل‌ها تعمیم ندهید.
- تفسیر قبلی E-011 که padding الزاماً ارتفاع ۵۲ ایجاد می‌کند پس گرفته شده است.
- content در ارتفاع صحیح وسط‌چین می‌شود.
- راهکار گزارش‌شده برای هدف لمس/semantics حداقل ۴۸، بدون بزرگ‌کردن layout، از render proxy استفاده می‌کند.
- ریسک مهم: ancestor می‌تواند hit-test بیرون layout را قطع کند؛ envelope دکمه‌های Small هم ممکن است با هم هم‌پوشانی پیدا کنند. این موضوع در آخرین اصلاحات برای تست و تشخیص به ایجنت سپرده شده است؛ صرف بزرگ‌ترشدن semantics اثبات tappableبودن نیست.

## ۸. فونت، زبان، RTL، ارقام و theme/skin

### فونت: D-048 و D-060

- فونت لاتین: **Outfit**، مطابق Figma.
- فونت فارسی: **Vazirmatn**، موقت تا تعیین typography فارسی توسط طراح.
- فونت‌ها bundled هستند؛ دانلود فونت در runtime مجاز نیست.
- در گذشته fallback فارسی به‌دلیل package prefix اشتباه مشکل داشت؛ این مورد اصلاح شده است.
- ایراد مهم دیگر: فایل Outfit variable قبلی با face/weight نامناسب نگاشت شده بود و ظاهر را سنگین‌تر و باریک‌تر از Figma می‌کرد.
- طبق D-060 فایل‌های static واقعی وزن‌های 400 / 500 / 600 / 700 از release رسمی pinned Outfit 1.100 جایگزین شده‌اند.
- طبق گزارش، تطبیق raster با reference مستقل برای وزن‌ها پاس شده است؛ این اصلاح در روند قبلی پذیرفته شد.
- Vazirmatn 33.003 بدون تغییر و provisional مانده است.
- منبع، نسخه، SHA-256 و مجوز OFL در `packages/design_system/assets/fonts/FONTS.md` ثبت شده‌اند.
- برای بستن اختلاف ظاهری، فونت fallback تصادفی، synthetic weight یا کشیدن افقی متن راه‌حل قابل‌قبول نیست.
- در آخرین درخواست تکمیلی، محل مصرف Outfit 700 یا دلیل bundledبودن آن نیز باید مستند شود.

### وضعیت زبان و ارقام

- `fa` پیش‌فرض موقت فعلی است: D-041.
- `en` نیز در دسترس است. دستور قدیمی «فقط انگلیسی فعال است» دیگر توصیف فعلی پروژه نیست.
- متن‌های کاربر از ARB/l10n بیایند؛ متن قابل‌مشاهده در widget hard-code نشود.
- layout پیش‌فرض directional باشد: start/end و APIهای Directional.
- left/right فیزیکی فقط با دلیل واقعی و مستند.
- محتوای کاربرمحور فارسی، طبق D-049 ارقام فارسی دارد؛ storage و مقدار محاسباتی ASCII می‌مانند. caller مسئول تبدیل نمایشی است، نه تبدیل کورکورانه تمام متن‌های DS.
- captionهای فنی طبق D-050، ASCII می‌مانند.
- استثنای Auth: فیلد شناسه، متن واردشده را همان‌طور که هست نشان می‌دهد؛ ارقام داخل ایمیل فارسی نمی‌شوند. فیلد ایمیل/تلفن LTR است حتی در صفحه فارسی.
- تشخیص و normalization ارقام فارسی/عربی به ASCII در منطق domain/formatting انجام می‌شود؛ نمایش و مقدار canonical را با هم قاطی نکنید.
- فونت و متن فارسی فعلاً نسبت به طرح انگلیسی با انعطاف بیشتری بازبینی می‌شوند، چون طرح رسمی فارسی وجود ندارد؛ این به معنی مجازبودن overflow، ابهام semantics یا متن خراب نیست.

### text scale: تصمیم جاری D-044

- محتوای صفحات تا **2.0** پشتیبانی می‌شود.
- تمام متن App Bar و labelهای Navigator از `chromeTextScaleCap = 1.3` استفاده می‌کنند.
- قاعده قدیمی D-015 برای clamp کل محتوا روی 1.3 supersede شده است.
- رفتار non-linear TextScaler حفظ شود؛ به ضرب دستی یک عدد تقلیل پیدا نکند.
- اندازه مرجع مقایسه Figma برابر 1.0 است؛ بزرگ‌نمایی‌های دیگر معیار سازگاری و دسترس‌پذیری‌اند.

### theme و skin

- Light و Dark هر دو در scope محصول هستند؛ نبود design یک حالت به معنی ساخت منبع جعلی نیست.
- foundation از brightness سیستم پیروی می‌کند؛ وجود زیرساخت را با ساخته‌شدن UI تنظیمات و persistence آن یکی ندانید.
- skin یک محور مستقل از brightness است: D-046، با ۳۵ role در مرحله اولیه و test skin.
- اضافه‌شدن roleهای جدید از جمله accent باید در همین معماری حل شود، نه با شرط‌های پراکنده در feature.
- رنگ برندهای خارجی ممکن است عمداً theme-independent باشد و باید استثنای روشن داشته باشد.

## ۹. responsive، پلتفرم و دسترس‌پذیری

### اندازه و layout

- اندازه‌های Figma بر پایه logical px هستند؛ عرض ۴۰۲ به معنی DPI دستگاه نیست.
- size class بر اساس **عرض**: Compact < 600، Medium از 600 تا 839، Expanded ≥ 840.
- PageScaffold برای عرض‌های بزرگ‌تر content cap فعلی 600 دارد؛ این تصمیم موقت مستند است.
- اندازه 402×874 مرجع تطابق صفحه ورود است، نه یک قاب اجباری برای همه دستگاه‌ها.
- safe area، edge-to-edge، viewInsets کیبورد، اسکرول محتوای لازم و قابل‌دسترسی‌بودن فیلد focused اهمیت دارند.
- برای tablet layout خیالی نسازید؛ زیرساخت adaptive و رفتار درست بسازید، طراحی محصولی مستقل نیازمند منبع است.
- سیاست فعلی گوشی portrait و tablet منعطف‌تر است؛ تنظیمات native واقعی را بررسی کنید.
- Navigator حداقل عرض مرجع 252 = 12 + 5×48 دارد. طبق D-036 زیر این عرض هم با layout تنزل‌یافته باقی می‌ماند، نه اینکه exception جای UI را بگیرد.

### یکپارچگی پلتفرم

- ظاهر، motion و interaction Android و iOS باید تا حد مقرر یکسان باشند.
- platform branching در feature/DS خودسرانه اضافه نشود؛ تفاوت‌ها در boundary تعیین‌شده و با PE ثبت شوند.
- scroll physics و system back از استثناهای ثبت‌شده قبلی‌اند؛ رفتار بومی keyboard/text selection هم باید طبق قواعد موجود حفظ شود.
- reduce motion رعایت شود.

### native فعلی

- Android minSdk = 26 و targetSdk = 36 در آخرین گزارش.
- شناسه provisional: `ir.mci.mygame.p2e`؛ تأیید ناشر پیش از توزیع خارج از تیم توسعه لازم است.
- Android debug APK ساخته شده و release با config تولید برای بررسی exclusion نیز گزارش شده است؛ این به معنی آماده‌بودن signing و انتشار تجاری نیست.
- iOS یک target واقعی است، اما build/runtime آن روی Windows تأیید نشده است. بررسی ساختاری فایل Xcode را با build موفق iOS یکی ندانید؛ macOS/Xcode لازم است.

### دسترس‌پذیری

- target لمس، semantics، focus order و keyboard activation باید واقعاً تست شوند.
- «Remember me» با ظاهر Radio، از نظر semantics یک checkbox/toggle مستقل است، نه عضو گروه radio.
- لینک‌های قوانین، semantics و فعال‌سازی مستقل دارند.
- loading، error و پیام گذرا باید رفتار/اعلان مناسب داشته باشند.
- برای لینک inline قانونی، استثنای WCAG 2.5.8 پذیرفته شده است؛ برای رسیدن صوری به ۴۸، layout متن را خراب نکنید.

## ۱۰. UI Identity و Inspector

### قرارداد identity

- قرارداد هویت نسخه 1.1 پذیرفته شده است؛ D-032 تا D-035 جزئیات adoption، scope، slot و metadata امن را ثبت کرده‌اند.
- component/source identity مشترک می‌تواند میان instanceها مشترک بماند؛ occurrence identity باید کنترل‌ها را تفکیک کند.
- route scope در هر صفحه وجود دارد؛ routeInstanceId در طول rebuild، تغییر theme/locale/state ثابت می‌ماند.
- screenهای mountشده مستقل instance مستقل دارند.
- effective identity از route، route instance، elementId و در صورت نیاز entityKey/slotPath ساخته می‌شود.
- برای لیست‌های دامنه از index، label ترجمه‌شده یا متن نمایشی شناسه نسازید.
- Radio optionها از مقدار پایدار option شناسه می‌گیرند.
- cellهای OTP و visibility action رمز، owner-relative slot دارند؛ برای آن‌ها component جعلی مستقل نسازید.
- designRef فقط وقتی منبع واقعی موجود است؛ source-unlinked را به node خیالی منتسب نکنید.
- metadata با تغییر state/variant/identity باید به‌روز شود، نه فقط با تغییر geometry.
- collision detection و notification regressionها مهم‌اند؛ راه‌حل مخفی‌کردن duplicate با scope اضافی نیست.

### حریم خصوصی snapshot

- Password، OTP، token و اطلاعات حساس نباید در Inspector یا JSON نشت کنند.
- شناسه ایمیل/شماره نیز PII محسوب می‌شود؛ masking طبق schema فعلی.
- D-057، loading و حفاظت شناسه را با schema 1.1.0 وارد کرده است؛ نسخه و قواعد واقعی فعلی از repository خوانده شوند.
- snapshot ابزار مشاهده است، نه مجوز export آزاد داده کاربر یا raw tree حساس.

### جداسازی ابزار

- Inspector در `dev_tools/inspector/` است؛ hostهای محصول و Viewer جدا هستند.
- dependency فقط از ابزار به product/DS/Viewer می‌رود؛ مسیر برعکس ممنوع است.
- محصول از طریق hookهای خنثی bootstrap میزبانی می‌شود؛ product نباید import مخصوص Inspector داشته باشد.
- API مشاهده read-only دیزاین‌سیستم در `inspection.dart`، طبق D-051؛ ورود آن به product lib ممنوع است.
- utilityهای تست از entrypoint مخصوص `testing.dart` جدا شده‌اند.
- حذف/کنارگذاشتن `dev_tools/` باید pub get، analyze، test و build محصول و DS/Viewer را سالم بگذارد؛ این یک شرط معماری واقعی و تست‌شده است.
- marker ابزار نباید در APK تولید باشد؛ نبود دکمه بازکردن Inspector اثبات exclusion نیست.

### قابلیت‌های ساخته‌شده

- انتخاب و مشاهده component و metadata.
- شبیه‌سازی دستگاه با عرض/ارتفاع قابل‌تغییر، preset، rotate، zoom و ruler.
- تنظیمات دستگاه به‌عنوان ورودی OS، از جمله locale دستگاه با boundary خنثی D-052.
- گروه Dev، تب Problems، Sweep و API scriptable برای آزمون‌های آینده.
- نمایش سناریوهای fake از طریق overrideهای توسعه.
- اصلاح RenderAnimatedSize با duration صفر، طبق D-054.
- حداقل پنجره Viewer در حالت مربوط 640×740 گزارش شده است.
- هنگام اختلاف منبع یا شرایط مقایسه، نتیجه باید «قابل‌مقایسه نیست» با دلیل باشد؛ عدد diff گمراه‌کننده تولید نشود.

## ۱۱. Auth Entry؛ دقیقاً چه چیزی ساخته شده؟

### منابع طراحی

صفحه EN در Figma: `16458:11`.

| حالت | node |
|---|---|
| idle | `18608:11451` |
| فیلد فعال / کیبورد | `18618:12447` |
| شماره تلفن | `18618:12126` |
| ایمیل | `18618:12651` |

این چهار frame حالت‌های یک صفحه‌اند. برای مقایسه دقیق: en، dark، text scale 1.0 و قاب 402×874 با inset مرجع ثبت‌شده.[^https://www.figma.com/design/7PGTHT5CQzbTsWZQnPIQce/?node-id=18608-11451]

سبک‌های Outfit ثبت‌شده در بررسی طراحی: Headline-Large SemiBold با 32/40 و letter-spacing برابر ‎−4٪؛ Title-Small Medium با 18/24؛ Label-Medium SemiBold با 16/20؛ Label-Small Medium و Muted/Label-Small Regular با 14/18. مشخصات دقیق هر عنصر از snapshot و style مرتبط خوانده شوند، نه با اعمال یک style مشترک به تمام متن‌ها.

### رفتار و معماری ثبت‌شده

- تشخیص شماره/ایمیل تابع خالص و تست‌پذیر است.
- قالب‌های موبایل ایران از جمله 09…، +98… و 0098… و ارقام فارسی/عربی normalize می‌شوند.
- پیش‌فرض فعلی پذیرش همه موبایل‌های ایران است؛ MCI-onlyشدن تصمیم قطعی ثبت‌شده در این گزارش نیست.
- CTA با نوع ورودی تغییر می‌کند؛ حالت خالی/نامعتبر disabled است.
- مسیر شماره به OTP، ایمیل ثبت‌شده به Password و ایمیل جدید به Create Password می‌رود؛ این مقصدها در آخرین وضعیت مستند placeholder هستند.
- داده جریان ورود در auth-flow state نگه‌داری می‌شود، نه انتقال PII در route/URL.
- برگشت به صفحه باید ورودی و remember flag را حفظ کند.
- double submit، پاسخ stale، تغییر ورودی در درخواست، dispose/cancellation و failure mapping باید محافظت‌شده باشند.
- خطای مرتبط با فیلد از خطای عمومی تفکیک می‌شود؛ پیام‌ها از presentation mapper/l10n می‌آیند.
- autofill و keyboard action بررسی شده‌اند.
- مقدار welcome bonus داده بک‌اند است؛ در failure/نبود داده نمایش داده نمی‌شود.
- social login فعلاً اتصال واقعی نیست؛ fake پاسخ unavailable می‌دهد. لوگوی اجتماعی مساوی پیاده‌سازی OAuth نیست.
- remember flag فعلاً به جریان بعدی منتقل می‌شود؛ به معنی persistence امن session واقعی نیست.
- URL نهایی Terms و Privacy باید از پیکربندی/ناشر بیاید؛ لینک تولید حدس زده نشود.

### حالت کیبورد

- ملاک بازبودن کیبورد `viewInsets.bottom` است، نه فقط focus.
- hero، remember، divider، social و legal در حالت کیبورد مخفی می‌شوند.
- CTA مطابق design با فاصله مرجع بالای کیبورد قرار می‌گیرد؛ محتوای لازم قابلیت اسکرول دارد.
- state اجزای مخفی‌شده حفظ می‌شود.
- hero در حالت idle زیر status bar امتداد دارد؛ خود status bar نباید با widget جعلی بازسازی شود.

### تفاوت‌های طراحی و تصمیم‌های موقت

- طراحی رسمی این صفحه فقط Dark و English بوده است؛ Light و فارسی derived/provisional هستند.
- accent CTA به‌صورت override در Figma وجود داشته، نه variant اصلی DS؛ D-056 و درخواست R-013 آن را به راهکار token-based و قابل‌ردیابی تبدیل کرده‌اند.
- دارایی رسمی Google در R-014 پیگیری شده؛ بسته‌شدن آن را از register بررسی کنید.
- اصلاح املای PlayStation پذیرفته شده است.
- فونت فارسی همچنان موضوع R-003 است.
- بعضی فاصله‌های افقی Figma متفاوت‌اند؛ برای «تمیزکردن» دلخواه همه را یکسان نکنید.

### اصلاحات بصری پذیرفته‌شده در مرحله قبلی

- رفع فونت Outfit: D-060.
- ارتفاع Button: D-059.
- legal text: اندازه 14 و line-height 18، body Regular با `#a1a1a1` و لینک SemiBold با `#00a6f4`؛ در مرجع idle دو خط و ارتفاع 36.
- متن legal قبلاً بزرگ و clipped شده بود؛ این مشکل نباید برگردد.
- لحاظ‌شدن inside stroke یک‌پیکسلی Body.
- ارتفاع social section در مرجع 129.
- field label در frame بیست‌وچهارپیکسلی وسط‌چین.
- ورودی phone برابر 16/24 با tracking صفر و email برابر 18/24.
- caret با extent مرجع 20.
- این عددها مشخصات منبع/مرجعند، نه مجوز پراکندن raw value در feature.

## ۱۲. Fake backend و اتصال آینده به بک‌اند واقعی

- fake درون خود برنامه و در data/fake مربوط به feature است؛ قرار نیست یک سرور جدا لازم باشد تا APK روی گوشی تست شود.
- انتخاب از composition و config، با `BACKEND_MODE` انجام می‌شود.
- fake باید در build production خارج شود؛ config تولید همراه fake باید رد شود.
- remote فعلی stub است و failure typed برای not configured می‌دهد؛ وجود data source interface به معنی اتصال HTTP آماده نیست.
- fake باید DTO/mapping همان معماری را طی کند؛ نباید UI را با یک مسیر مخفی دور بزند.
- marker اختصاصی در build توسعه موجود و در release تولید غایب گزارش شده است.

### سناریوها و قواعد تست ثبت‌شده

- latency عادی: 600ms.
- success، slow، offline، serverError، rateLimited و notConfigured.
- slow در طراحی تسک 3 ثانیه بوده؛ مقدار فعلی از کد خوانده شود.
- شماره با پسوند `0000`: blocked.
- local part ایمیل که با `new` شروع شود: ثبت‌نام‌نشده.
- welcome offer: 3500، فقط داده fake.
- social: unavailable.
- scenario از config/define و override توسعه قابل‌کنترل است.
- لاگ fake فقط داده غیرحساس مثل نام scenario؛ شماره، ایمیل، OTP، password و token نباید log شوند.
- backend واقعی بعداً باید implementationهای data و wiring را جایگزین کند و تست قرارداد مشترک را پاس کند؛ نه اینکه presentation و domain را به شکل API جدید بازنویسی کنیم.

## ۱۳. سیاست تست، golden و پذیرش

### کنترل‌های معمول

متناسب با تغییر و فرمان‌های موجود repository:

- format check.
- analyze با صفر issue.
- تست root، DS، Viewer، Inspector و hostهای مرتبط.
- codegen/l10n و کنترل currentبودن خروجی‌ها.
- token generation check.
- `tool/check_architecture.dart` و تست منفی قواعد جدید.
- agent sync check.
- goldenهای مرتبط.
- Inspector sweep.
- Android build توسعه و در صورت ارتباط build تولید برای exclusion.
- deletion test ابزار.
- build hostهای Windows در صورت ارتباط.

فرمان‌ها را از README و اسکریپت‌های فعلی بردارید. حدس مسیر قدیمی executable یا استفاده از flag منسوخ ممنوع است.

### golden

- D-047: baseline مرجع Windows است.
- goldenها tag `golden` دارند؛ Linux CI آن‌ها را از اجرای ناسازگار با مرجع Windows جدا می‌کند.
- تغییر سیستم‌عامل، Flutter binary، font rasterizer یا ابزار ممکن است نتیجه را عوض کند؛ با `--update-goldens` دسته‌جمعی مشکل را پنهان نکنید.
- baseline فقط پس از بازبینی بصری و توجیه تغییرات پذیرفته شود.
- اجرای دوباره golden بدون update برای اثبات پایداری مهم است.
- test skin برای پیدا‌کردن نشت رنگ و وابستگی اشتباه به product palette استفاده می‌شود.
- ماتریس fa/en، Light/Dark، text scale 1.0/2.0 و عرض‌های نماینده اهمیت دارد؛ chrome cap مستقل رعایت شود.

### تطابق بصری با Figma

- مقایسه geometry به‌تنهایی کافی نیست؛ screenshot، overlay/diff، style و در اختلاف‌های متن، glyph ink لازم‌اند.
- تفاوت text layout box با ink واقعی حروف را اشتباه نگیرید.
- اختلاف را با offset موضعی و مخصوص یک حالت پنهان نکنید.
- caret ممکن است اختلاف raster/pixel snapping قابل‌قبول داشته باشد؛ این استثنا را به همه mismatchها تعمیم ندهید.
- اگر baseline اشتباه بوده، اصلاحش باید با دلیل و بررسی انجام شود، نه اینکه همیشه baseline قدیمی حقیقت فرض شود.

### آخرین اعداد گزارش‌شده پیش از اصلاحات تکمیلی

این اعداد **برای سیستم جدید و آخرین کد دوباره تأیید نشده‌اند**:

- root: 423 تست.
- Design System: 535 تست.
- Viewer: 35 تست.
- Inspector: 15 تست.
- hostها: 4 و 3 تست.
- analyze: صفر issue.
- DS goldens: 76/76، و root goldens: 18/18، دو بار اجرای موفق گزارش شده است.
- sweep: 10,784 frame و صفر مشکل در دامنه گزارش‌شده.
- 91 golden تغییرکرده برای بازبینی: 73 مورد DS و 18 مورد root.

این آمار نشان‌دهنده گزارش آن مرحله است؛ به معنی تأیید نهایی تمام تصاویر یا پوشش همه رفتارهای محصول نیست.

## ۱۴. آخرین کار انجام‌شده و وضعیت دقیق تحویل

### موضوع بازبینی قبلی

پس از اصلاح فونت، Button و legal text، گزارش هنوز 42 مقایسه با اختلاف bounds بیش از 0.5px داشت. ایجنت علت عمده را intrinsic text advance و یک مدل احتمالی trailing-tracking/ceil می‌دانست؛ ۲ مورد هم به caret pixel snapping مربوط بود.

- 43 بررسی size/weight/color پاس شده گزارش شده بود.
- تحلیل 28 از 29 عرض تک‌خطی با مدل `ceil(Flutter advance − tracking)` یک توضیح تشخیصی بود، نه مجوز تبدیل آن به hack layout.
- اصلاح فونت، ارتفاع‌های Button، legal و اصلاحات label/social/caret در روند قبلی پذیرفته شدند.
- تفاوت‌های متن **مشروط به glyph-ink delta حداکثر 1px** پذیرفتنی دانسته شدند.
- اختلاف‌های caret پذیرفته شدند.
- تأیید نهایی مجموعه Auth و همه goldenهای تغییریافته هنوز به مشاهده شواهد وابسته بود.

### درخواست تکمیلی ارسال‌شده به ایجنت

1. مقایسه glyph-ink bounding box برای تمام عناصر با bounds deviation بیش از 0.5px؛ آستانه پذیرش حداکثر 1px.
2. تست hit envelope روی صفحه واقعی Auth، از جمله tap یک پیکسل داخل ناحیه توسعه‌یافته.
3. تست دکمه‌های Small مجاور با gap کمتر از 12؛ انتخاب قابل‌پیش‌بینی نزدیک‌ترین کنترل و بدون double activation.
4. debug assertion یا قانون Problems برای تشخیص envelopeهای clipped و اجرای دوباره sweep.
5. فهرست styleهای مصرف‌کننده Outfit 700 یا مستندسازی علت bundledبودن آن در صورت نبود مصرف.
6. contact sheet به تفکیک component به شکل before | after | diff همراه changed-pixel percentage؛ مشخص‌کردن هر تغییری که با اصلاح فونت/Button توضیح داده نمی‌شود.

**آخرین پیام مالک:** این تغییرات هم پیاده شده‌اند و پروژه به سیستم قوی‌تر منتقل شده است.

بنابراین وضعیت صحیح برای دستیار بعدی:

> پیاده‌سازی اصلاحات تکمیلی توسط مالک اعلام شده است. خروجی تست، تصاویر و گزارش آن مرحله در این چت دیده نشده‌اند. کار را بی‌دلیل دوباره نساز؛ ابتدا خروجی موجود را بخوان و فقط خلأ واقعی را تکمیل کن. پذیرش قطعیِ ندیده صادر نکن.

### محل شواهد موجود در سیستم قبلی

- `docs/reports/auth-conformance/README.md`
- `docs/reports/auth-conformance/conformance.md`
- `docs/reports/auth-conformance/rect-comparison.json`
- `docs/reports/auth-conformance/text-style-comparison.json`
- `docs/reports/auth-conformance/validation.md`
- تصاویر side-by-side، overlay و diff چهار حالت در همان بخش.
- `docs/reports/golden-samples/auth-conformance/README.md`
- `docs/snapshots/2026-10-23_auth-entry`
- گزارش‌ها و خروجی جدید درخواست تکمیلی؛ نام دقیقشان باید از repository پیدا شود.

وجود این مسیرها در خلاصه به معنی دسترسی فعلی دستیار نیست. اگر دسترسی فایل ندارید، از مالک بخواهید فایل لازم را ضمیمه کند؛ ادعا نکنید تصاویر را دیده‌اید.

## ۱۵. کارهای باز و کارهایی که نباید انجام‌شده فرض شوند

### اولویت نزدیک

1. بررسی وضعیت واقعی پروژه پس از انتقال و بازتولید حداقل validation پایه.
2. خواندن شواهد اصلاحات تکمیلی؛ تأیید یا اعلام باقی‌مانده‌های دقیق Auth/goldens.
3. در صورت بسته‌شدن موارد واقعی، شروع صفحه OTP با تسک محدود و معیار پذیرش مشخص.

### منابع مراحل بعدی Figma

- OTP: `18664:13688` و `18653:13337`.
- Email Password: `18618:12990` و `18707:15349`.
- Forgot Password: `18707:16458` و `18707:16986`.
- Create Password: `18707:15598` و `18707:16129`.

قبل از توسعه، frameها و variantهای فعلی دوباره خوانده شوند. این فهرست به‌تنهایی specification کامل رفتار نیست.

### موارد باز یا موقت شناخته‌شده

- قرارداد و اتصال بک‌اند واقعی / OD-2.
- typography رسمی فارسی / R-003.
- طراحی رسمی Light و فارسی Auth و بعضی variantهای DS؛ مانند کمبودهای ثبت‌شده Light در Password/OTP یا Back App Bar. وضعیت جاری را از درخواست‌های طراح بخوانید.
- variant رسمی accent / R-013.
- دارایی رسمی Google / R-014 و امکان واقعی social sign-in.
- URLهای نهایی قوانین و حریم خصوصی.
- تأیید ناشر برای شناسه اپ.
- splash/logo قبل از Auth؛ فعلاً slot خنثی، نه صفحه ساخته‌شده.
- session persistence و secure token storage واقعی.
- build/runtime iOS روی macOS/Xcode.
- تنظیمات انتشار، signing و آمادگی توزیع production.
- UI تنظیمات زبان/theme و رفتار first launch را از کد/تصمیم جدید بخوانید؛ سیاست‌های قدیمی را خودکار پیاده‌شده فرض نکنید.

## ۱۶. نکات مهم برای جلوگیری از تکرار اشتباه‌ها

- یک‌بار جهت icon در Button RTL به اشتباه ایراد گرفته شد؛ پیاده‌سازی آن درست بود. پیش از درخواست اصلاح دوباره، source و رفتار واقعی را بررسی کنید.
- Medium Button باید در مرجع 46 باشد؛ به‌خاطر جمع padding آن را دوباره 52 نکنید.
- legal text برای بزرگ‌کردن hit area نباید به ارتفاعی مثل 96 و حالت clipped برگردد.
- Outfit صحیح فعلی را با فایل variable قدیمی یا fallback شبکه‌ای جایگزین نکنید.
- D-044 را با قاعده قدیمی scale 1.3 برای همه متن‌ها جایگزین نکنید.
- default فارسی فعلی را صرفاً با خواندن سند قدیمی به انگلیسی برنگردانید.
- Inspector را به `lib/dev` یا main محصول برنگردانید؛ مسیر قدیمی در اسناد تاریخی supersede شده است.
- وجود metadata inspection در DS به معنی مجازبودن import ابزار در محصول نیست.
- حذف پوشه ابزار باید واقعاً قابل‌تحمل باشد، نه فقط در build release پنهان شود.
- fake را با یک سرور خارجی اجباری یا شرط‌های UI مخصوص تست جایگزین نکنید.
- goldens جدید را چون تست سبز است، تأیید بصری‌شده معرفی نکنید.
- اعداد آماری گزارش قدیمی را به‌عنوان نتیجه اجرای تازه تکرار نکنید.
- از دسترسی Figma، فایل محلی، build iOS یا CI اجرا‌نشده ادعای غیرواقعی نکنید.
- برای انتقال به سیستم قوی‌تر، از فرصت برای بازنویسی بی‌درخواست معماری استفاده نکنید.

## ۱۷. دستور شروع پیشنهادی برای دستیار یا ایجنت جدید

این بخش را به‌عنوان راهنمای اولین اقدام بخوان:

1. ابتدا این گزارش، `AGENTS.md`، قواعد مرتبط، architecture/addendum و تصمیم‌های جدید register را بخوان.
2. مسیر جدید repository، OS، Flutter/Dart واقعی، pinned version، lockfile و اتصال read-only Figma را مشخص کن؛ بدون تغییر خودسرانه SDK.
3. فهرست آخرین فایل‌های تغییرکرده و گزارش‌های اصلاحات تکمیلی Auth را بخوان؛ چیزی را که پیاده شده بی‌دلیل دوباره انجام نده.
4. روشن بگو کدام نتیجه فقط از گزارش می‌آید و کدام را خودت با کد، تست یا تصویر بررسی کرده‌ای.
5. اولویت فعلی، تأیید انتقال سالم و بستن بازبینی Auth/goldens است؛ نه شروع خودکار چند صفحه جدید.
6. پس از آن برای OTP تسک مستقل تهیه کن: بررسی Figma → مشخص‌کردن رفتار → استفاده از DS → domain/data/presentation و fake مناسب → تست/Inspector/golden → گزارش و بازبینی.
7. به فارسی گزارش بده؛ اگر قرار است کار به ایجنت دیگری واگذار شود، پرامپت اجرایی روشن به انگلیسی بنویس.
8. Figma را تغییر نده، commit نکن، مرز ابزار و محصول را نشکن، و هیچ محدودیت یا تصمیم موقت را پنهان نکن.

**معیار موفقیت این پروژه فقط شبیه‌شدن یک صفحه نیست؛ ترکیب وفاداری طراحی، معماری قابل‌نگهداری، تست‌پذیری، جداسازی واقعی ابزار، حریم خصوصی و امکان اتصال تمیز به بک‌اند واقعی است.**
