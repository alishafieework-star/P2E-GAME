# پرامپت — تکمیل احراز هویت Flutter (بازیکن) هم‌تراز با Users

تو روی اپ Flutter در `D:\projects\My-Game` کار می‌کنی. بک‌اند را تغییر نده. UI پنل را کپی نکن. Figma و D-139 را برای ظاهر و ترتیب سفر نگه دار؛ فقط اتصال، سشن، و امنیت دستگاه را کامل کن.

مرجع قرارداد اتصال، harness تست است نه محصول:

`C:\Users\PC\source\repos\MCI\PlayToEarn\MainCode\Fronts\front_panelplayer`

سورس سرور فقط برای رفع ابهام قرارداد خوانده شود، نه برای تغییر:

`C:\Users\PC\source\repos\MCI\PlayToEarn\MainCode\users`

قوانین ریپو: `AGENTS.md`، `docs/agents/rules/app-platform.md`، `docs/agents/registers/decisions.md` (D-139، D-150، D-152، D-153). گزارش به مالک فارسی، کوتاه، و با مسیر فایل.

---

## وضعیت فعلی

احراز هویت بازیکن روی Users از گیت‌وی زنده شده است. Flutter در حالت `BACKEND_MODE=remote` همان قرارداد harness را صدا می‌زند. تست واحد کلاینت سبز است. ثبت‌نام زنده با OTP تا `Complete` و سپس `PlayerLogin` و `Me` (`userType == 4`) یک بار تأیید شده است.

کوکی فقط در RAM همان پروسه است. رمز عبور ذخیره نمی‌شود (درست است) ولی سشن بعد از kill اپ می‌میرد. pinning، ذخیرهٔ امن کوکی، و واکنش سراسری ۴۰۱ هنوز نیستند. `android/.../network_security_config.xml` در `base-config` کلیر‌تکست را باز گذاشته؛ کامنت D-150 می‌گوید کلیر‌تکست فقط لوپ‌بک توسعه باشد.

Journey محصول (D-139): سشن UI فقط از **All Set** یا **Welcome Back** به `signedIn` می‌رود. `GET Me` در سرد شدن، اگر `userType == 4` باشد، `signedIn` را برمی‌گرداند. `Complete` ثبت‌نام سشن نمی‌سازد؛ `loginRequired: true` یعنی کاربر باید جدا وارد شود.

---

## پروتکل سرور — تغییر نده

اپ به گیت‌وی عمومی وصل می‌شود، نه به IP داخلی سرویس‌ها.

```text
UI → repository → UsersApiClient → یک HttpClient (cookie jar)
  → HTTPS  {GATEWAY}/api/users/...
  → Users
```

بدنه JSON خام است. رمز را در کلاینت hash یا رمزنگاری نکن؛ سرور با PasswordHasher دات‌نت hash می‌کند. توکن در JSON لاگین نیست.

| کوکی | معنی |
|---|---|
| `AuthToken` | سشن. HttpOnly، Path `/`، SameSite Lax، host-only |
| `AuthRemember` | `1` یا `0` |
| `PlayerPreAuth` | جریان ثبت‌نام/OTP. جایگزین `AuthToken` نیست |

`remember: true` کوکی پایدار (پایه ۱۰ روز، `SessionLifetimeDays`). `remember: false` کوکی نشست. Production سرور `RequireSecureCookies: true` است؛ APK فروشگاهی فقط HTTPS.

هدرهای اجباری مسیر بازیکن: `Accept: application/json`، `X-Player-Auth: 1`، `Origin` برابر `REMOTE_API_ORIGIN` (scheme+host، بدون مسیر). بدون Origin مجاز: `403 ORIGIN_OR_CSRF_REJECTED`.

موفقیت: HTTP 2xx **و** `envelope.status` در 2xx. نتیجه داخل `data`. خطا: `errorCode` + گاهی `Retry-After`. سقف بدنه Player حدود ۱۶ کیلوبایت.

هاست لاگین = هاست بقیهٔ `/api/<service>/`. کوکی host-only با عوض کردن هاست نمی‌آید. Bearer، refresh token، `ClientLogin`، و `/api/authentication` در APK ممنوع است.

### پایپ‌لاین ثبت‌نام و ورود

1. `POST general/auth/ResolvePlayerIdentifier` با `{identifier}`. موبایل روی wire: `9XXXXXXXXX` (بدون `0` و `+98`).
2. اگر `exists == false` و `identifierKind == 1`: `POST general/player-registration/SendCode` با `{mobile, requestId}`. `requestId` یک UUID است و تا موفقیت همان درخواست تکرار می‌شود.
3. `POST general/player-registration/VerifyCode` با `{challengeId, code}`. `code` = `codePrefix + digits`. UI فقط رقم‌ها را می‌گیرد.
4. `CheckUserName` سپس `SaveUserName`. نام: `^[a-z][a-z0-9]{4,19}$`.
5. `POST general/player-registration/Complete` با `{challengeId, password}`. انتظار: `registered == true` و `loginRequired == true`. بعدش PlayerLogin، نه signed-in خاموش.
6. ورود رمز: `POST general/auth/PlayerLogin` با `{method:1, identifier, password, remember}`.
7. ورود OTP برای حساب موجود: فقط اگر `canUseOtp == true`. `SendPlayerLoginCode` با `{identifier, requestId}` سپس PlayerLogin `{method:2, challengeId, code, remember}`.
8. `mustChangePassword == true` یعنی هنوز وارد نشده. `ChangeInitialPassword` با `{changeTicket, newPassword, remember}`. اگر `loginRequired` برگشت، با رمز جدید دوباره PlayerLogin.
9. سرد شدن: `GET general/auth/Me`. فقط `userType == 4` و `id > 0` و `fullName` رشته یعنی بازیکن.
10. خروج: `POST general/auth/Logout` سپس پاک کردن jar و ذخیرهٔ امن.
11. ادامهٔ ثبت‌نام نیمه‌کاره: `GET general/player-registration/Current` فقط با همان کوکی `PlayerPreAuth`.

`identifierKind`: ۱ موبایل، ۲ ایمیل (ثبت‌نام موبایل نیست)، ۳ نام کاربری (برای ثبت‌نام اول موبایل لازم است). ایمیلِ موجود مبهم: `PLAYER_IDENTIFIER_AMBIGUOUS`.

هر پاسخ ممکن است `Set-Cookie` تازه بدهد (چرخش `AuthToken`). jar باید ترتیب هدر را حفظ کند. `Set-Cookie` را با کاما جدا نکن.

---

## چه چیزی باید در Flutter کامل شود

### اتصال (باگ نسبت به harness)

- `canUseOtp`: اگر false، دکمه/مسیر OTP ورود را نفرست؛ `PLAYER_OTP_UNAVAILABLE` نساز.
- `requestId` را برای همان SendCode تا پاسخ موفق نگه دار؛ هر retry UUID تازه نسازد.
- timeout مسیر OTP/لاگین را از ۸ ثانیهٔ عمومی جدا کن (harness ۴۵ ثانیه است). بقیهٔ خواندن‌ها را بی‌جهت کند نکن.
- `codeDigits` را به‌عنوان عدد بپذیر (`int` یا `num` صحیح).
- `errorCode`های شناخته‌شده را به خطای دامنه‌ای نگاشت کن، نه همه را `server`: `PLAYER_BUSY`، `INVALID_REGISTRATION_REQUEST`، `REGISTRATION_CONTACT_REQUIRED`، `PLAYER_REQUEST_TOO_LARGE`، `PLAYER_REQUEST_CONFLICT`، به‌اضافهٔ کدهایی که `faultFor` الان دارد.
- `Retry-After` را به UI قفل وصل کن؛ اسپم OTP/رمز ممنوع.
- `Complete` را فقط وقتی موفق بدان که `registered` و `loginRequired` هر دو true باشند.
- `mustChangePassword` را به‌جای پرتاب `server` به مرحلهٔ تعویض رمز اولیه ببر (endpoint هست: `ChangeInitialPassword`). فراموشی رمز endpoint ندارد؛ همان `notConfigured` بماند.
- GET `Current` را به UI ثبت‌نام وصل کن تا step 1/2/3 بعد از مرگ پروسه، اگر کوکی جریان مانده، ادامه یابد.
- پروفایل را در این کار نساز مگر مدل دامنه با `player/profile/Mine` و `Update` یکی شود. `Update` بدون فلگ‌های `*Specified` از قرارداد خارج است.

### امنیت دستگاه — همین کار

رمز عبور را هیچ‌جا ماندگار نکن: نه secure storage، نه SharedPreferences، نه لاگ، نه آنالیتیکس، نه فیلد Riverpod بعد از submit. فقط در حافظهٔ فرم تا لحظهٔ POST، بعد کنترلر را خالی کن. `obscureText` بماند. autofill سیستم‌عامل مجاز است؛ vault رمز در اپ نساز.

توکن یعنی مقدار کوکی. آن را Bearer یا فیلد JSON نکن. نگهداری پیشرفته برای این پروتکل:

1. یک `HttpClient` برای کل عمر کانتینر (`jsonHttpTransportProvider` همین نقش را دارد).
2. بعد از هر پاسخ، کوکی‌های `AuthToken`، `AuthRemember`، `PlayerPreAuth` را از jar بخوان و در **Android Keystore / iOS Keychain** بنویس (`flutter_secure_storage` با EncryptedSharedPreferences در اندروید). کلیدها غیرقابل استخراج بمانند؛ خودت AES جدا با کلید داخل سورس ننویس.
3. موقع ساخت کلاینت، قبل از `Me`، کوکی‌ها را از Keystore به jar برگردان. هاست ذخیره باید همان هاست گیت‌وی باشد.
4. `Logout`، ۴۰۱ سشن، و تعویض حساب: پاک کردن jar **و** Keystore.
5. اندروید: backup ابری این مقادیر را نبرد (`allowBackup` محدود یا rules که secure storage را حذف کند). لاگ `cookie` / `Authorization` / بدنهٔ auth را در `AppLogger` و `print` ننویس. `PiiRedactor` هست؛ تست باید ثابت کند کافی است.
6. ریلیز: فقط HTTPS. `base-config` کلیر‌تکست را ببند. HTTP فقط برای `127.0.0.1` / `localhost` / `10.0.2.2` در debug/profile، هم‌خوان با D-150.
7. pinning را در این کار نگذار تا hostname و SPKI پروداکشن قطعی نشده؛ pin اشتباه اپ را می‌کشد. در PRD محصول بعدی است نه این تسک.
8. Origin پروداکشن فقط از `--dart-define=REMOTE_API_ORIGIN`. مقدار نمونهٔ لوکال `https://player.dev.p2e.example.com` را در سورس پروداکشن هاردکد نکن.
9. ۴۰۱ روی هر API که از همین jar می‌رود: `SessionStatus.expired` و برگشت به ورود. امروز `expired` تعریف شده و هیچ‌جا ست نمی‌شود.
10. WebView را به کوکی یا رمز وصل نکن.

### خارج از این تسک

wallet، games، missions، shop. کپی صفحهٔ پنل. `ClientLogin`. `SendPlayerMobileVerification` / `VerifyPlayerMobile`. تغییر بک‌اند. pinning. ذخیرهٔ رمز.

---

## فایل‌ها — چیستند و چه کاری مجاز است

### حمل و پیکربندی

| فایل | نقش | کار مجاز |
|---|---|---|
| `lib/app/platform/json_http_transport.dart` | `IoJsonTransport`: GET/POST، jar کوکی RAM، `clearSession` | بارگذاری/ذخیرهٔ کوکی از طریق پورت؛ لاگ بدنه ممنوع |
| `lib/shared/backend/json_transport.dart` | اینترفیس transport | فقط اگر پورت کوکی لازم شد، بدون نشت مقدار کوکی به domain |
| `lib/app/platform/transports.dart` | یک transport زنده (`keepAlive`) | همان کلاینت برای auth و بعداً APIهای گیت‌وی |
| `lib/app/platform/users_api_provider.dart` | `UsersApiClient` روی همان transport | wire کردن ذخیرهٔ امن |
| `lib/app/config/app_config.dart` | `REMOTE_API_BASE`، `REMOTE_API_ORIGIN`، `BACKEND_MODE` | راز داخل کانفیگ نگذار |
| `lib/app/auth_bindings.dart` | سوییچ fake/remote | remote فقط وقتی base پر است |
| `lib/app/startup/remote_session_probe.dart` | `GET Me` در سرد شدن | بعد از restore کوکی از Keystore صدا زده شود |
| `lib/core/diagnostics/app_logger.dart` | `PiiRedactor` | تست نشت؛ مقدار کوکی/رمز را در sink ننویس |
| `android/app/src/main/res/xml/network_security_config.xml` | سیاست کلیر‌تکست | بستن کلیر‌تکست سراسری در ریلیز |

### کلاینت Users

| فایل | نقش |
|---|---|
| `lib/features/auth/src/data/remote/users_api_client.dart` | تنها نقشهٔ endpoint بازیکن. envelope، OTP prefix، Complete، Me، Logout، `faultFor` |
| `lib/features/auth/src/data/remote/stub_sources.dart` | وقتی کلاینت وصل است متدها را به `UsersApiClient` می‌دهد؛ وگرنه `notConfigured` |
| `lib/features/auth/src/data/sources.dart` | اینترفیس source و `AuthDataFault` |
| `lib/features/auth/src/data/repositories.dart` | `Result` برای UI؛ خطاهای داده را به failure محصول نگاشت می‌کند |
| `lib/features/auth/src/domain/repositories.dart` | پورت دامنه |
| `lib/features/auth/src/domain/models.dart` | `OtpChallenge`؛ `codePrefix` جدا از طول رقم |
| `lib/features/auth/src/domain/identifier.dart` | طبقه‌بندی موبایل/ایمیل |

`lib/features/auth/src/data/fake/` فقط بک‌اند جعلی توسعه است. در `BACKEND_MODE=remote` از درخت ریلیز حذف منطقی شده. رفتار remote را آنجا پیاده نکن.

### UI — ظاهر را عوض نکن مگر باگ اتصال

| فایل | نقش |
|---|---|
| `lib/features/auth/src/presentation/auth_flow.dart` | ماشین سفر. D-139: signed-in فقط All Set / Welcome Back |
| `lib/features/auth/src/presentation/auth_entry_screen.dart` + `auth_entry_controller.dart` | ورود شناسه |
| `lib/features/auth/src/presentation/auth_otp_screen.dart` + `auth_otp_controller.dart` | OTP؛ طول از `codeDigits` |
| `lib/features/auth/src/presentation/username_screen.dart` | نام کاربری |
| `lib/features/auth/src/presentation/auth_create_password_screen.dart` | ساخت رمز ثبت‌نام |
| `lib/features/auth/src/presentation/auth_password_screen.dart` + `auth_password_controller.dart` | ورود با رمز |
| `lib/features/auth/src/presentation/password/password_rules.dart` | آستانه ۱۱–۱۲۸ به‌اضافهٔ قوانین محلی |
| `lib/shared/session/session.dart` | `signedOut` / `signedIn` / `expired` |

اگر مرحلهٔ `changeTicket` در UI نیست، مسیر موجود create-password را با دادهٔ بلیت وصل کن؛ صفحهٔ جدید خارج از Figma نساز مگر سفر فعلی واقعاً آن حالت را ندارد. قبل از صفحهٔ تازه، `docs/agents/registers/decisions.md` را رعایت کن.

### تست موجود

`test/features/auth/users_api_client_test.dart` قرارداد کلاینت با transport ساختگی است. رفتار جدید را اینجا و در تست امنیتی جدید بشکن، نه با تست زندهٔ SMS در CI.

---

## ترتیب پیاده‌سازی

1. پورت ذخیرهٔ کوکی (خواندن/نوشتن/پاک کردن) پشت اینترفیس. domain مقدار کوکی را لاگ نکند.
2. `IoJsonTransport` بعد از هر پاسخ کوکی‌های نام‌برده را persist کند و در سازنده restore کند. `clearSession` هر دو را پاک کند.
3. `RemoteSessionRestore` فقط بعد از restore.
4. شکاف‌های قرارداد: `canUseOtp`، `requestId` پایدار، timeout OTP، `loginRequired`، `mustChangePassword`، `Current`، نگاشت `errorCode`.
5. ۴۰۱ سراسری روی transport احراز هویت → `SessionStatus.expired` و پاک کردن ذخیره.
6. اصلاح `network_security_config` برای ریلیز.
7. تست‌های زیر. معماری: `dart run tool/check_architecture.dart`.

تصمیم تازه اگر رفتار محصول را عوض کرد در `docs/agents/registers/decisions.md` با شمارهٔ بعدی ثبت شود. D-152 را نقض نکن: endpoint جدید اختراع نکن.

---

## تست‌های امنیتی اجباری

این‌ها باید در `flutter test` بدون شبکه و بدون چاپ راز سبز شوند:

1. بدنهٔ `PlayerLogin` و `Complete` اگر به logger بیفتد، فیلد `password` و مقدارش `[REDACTED]` است. تست یک body واقعی را از `PiiRedactor` رد کند.
2. لاگ transport در شکست شبکه شامل body، `Cookie`، و `AuthToken` نیست. یک شکست ساختگی بساز و sink را جمع کن.
3. بعد از `logout()` هم jar حافظه خالی است هم ذخیرهٔ امن.
4. restore: کوکی ذخیره‌شده قبل از اولین درخواست در هدر `Cookie` هست؛ مقدار در assertion تست فقط داخل harness بماند و به `print` نرود.
5. کوکی با هاست دیگر ارسال نمی‌شود (jar host-only).
6. `Set-Cookie` جدید جایگزین مقدار قبلی در ذخیره می‌شود (چرخش).
7. پاسخ ۴۰۱ ذخیره را پاک می‌کند و سشن را `expired` می‌کند، نه `signedIn`.
8. رمز در `UsersApiClient` بعد از `signIn` / `completeRegistration` در فیلد ماندگار کلاس نیست.
9. `requestId` دو بار SendCode ناموفق همان رشته است؛ بعد از ۲۰۰ عوض می‌شود.
10. `canUseOtp == false` مسیر `SendPlayerLoginCode` را صدا نمی‌زند.
11. `Complete` با `registered: true` و `loginRequired: false` شکست است.
12. `mustChangePassword: true` کاربر را signed-in نمی‌کند و `changeTicket` را برای `ChangeInitialPassword` نگه می‌دارد.
13. کانفیگ prod + `BACKEND_MODE=fake` هنوز پرتاب می‌کند. `REMOTE_API_BASE` با اسلش آخر نامعتبر است.
14. تست معماری فایل جدید را اگر قانون لایه را بشکند رد کند. کوکی و رمز وارد `presentation/` به‌صورت ذخیره نشوند.

تست زنده (دستی، نه CI): یک شمارهٔ واقعی، OTP، Complete، kill اپ، راه‌اندازی دوباره، `Me` بدون وارد کردن دوبارهٔ رمز اگر `remember: true` بود. لاگ دستگاه را برای نبودن رمز و `AuthToken` نگاه کن.

---

## تعریف تمام

- remote با dart-defineهای `BACKEND_MODE`، `REMOTE_API_BASE`، `REMOTE_API_ORIGIN` به گیت‌وی وصل می‌شود.
- رمز فقط روی HTTPS و فقط داخل JSON همان درخواست است و بعد از ارسال در UI نمی‌ماند.
- `AuthToken` فقط کوکی است، در Keystore/Keychain می‌ماند، در لاگ نیست، با Logout و ۴۰۱ پاک می‌شود.
- سفر D-139 سالم است: Complete به‌تنهایی وارد بازی نمی‌کند.
- `flutter test` مسیر auth و تست‌های امنیتی بالا سبز است.
- بک‌اند و harness پنل دست نخورده‌اند.
