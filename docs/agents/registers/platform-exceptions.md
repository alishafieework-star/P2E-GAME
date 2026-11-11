# Platform exceptions (iOS vs Android)

Default: identical look, motion and behavior (D-012). Each exception needs an id here and `// PLATFORM(PE-###): reason`
in `lib/app/platform`. Add new exceptions only after testing shows a real problem.

| Id | Date | Area | iOS | Android | Reason | Status |
|---|---|---|---|---|---|---|
| PE-001 | 2026-10-19 | Scroll physics / overscroll | Bounce | Stretch | Users feel it physically; changes no visual design. | approved |
| PE-002 | 2026-10-19 | System back | Edge-swipe back | System / predictive back via `PopScope` | Required by each OS. | approved |
| PE-003 | 2026-10-24 | OTP SMS | Keyboard oneTimeCode suggestion; the user taps to fill | SMS Retriever fills the field with no prompt. Debug and profile also receive `SMS_RECEIVED` so an emulator message reaches the same parser. Release does not. | iOS cannot read the inbox. Android Retriever needs the app hash. Emulator injection does not reach Retriever, so debug/profile listen for the delivered SMS too. Manual entry stays on both. | superseded by PE-005 |
| PE-005 | 2026-11-10 | Player OTP SMS | Keyboard oneTimeCode suggestion. The player taps it. Digits-only suggestions keep the challenge letter. | SMS User Consent asks to read that one message from `+9810000001950`. Agreeing fills the field and does not press Verify. Denial, timeout or missing Play services leaves typing. No inbox permission. | The OS consent dialog is per message. iOS cannot read the SMS. The sender filter accepts one number, so other senders stay manual. | approved |
| PE-004 | 2026-10-26 | Notification permission | The system prompt. This Windows workspace does not build or run that prompt. | `POST_NOTIFICATIONS` on Android 13 and later, then the system prompt. | The OS owns the dialog. The app does not draw a fake one (D-140). | approved |
