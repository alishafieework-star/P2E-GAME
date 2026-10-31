# Overrides

Raw values that bypass tokens. Choosing another existing token is not an override.
Every entry matches a code annotation `// OVERRIDE(O-###): reason`. CI lists annotations without an entry and entries without code.

| Id | Date | File | Value | Reason | Remove when | Status |
|---|---|---|---|---|---|---|
| O-001 | 2026-10-28 | `lib/features/auth/src/presentation/password/widgets/password_strength.dart` | `Color(0xFFFF9F0A)` | Password strength Fair level takes the HTML prototype `--amber`; no amber token exists in the skin or journey tokens (HTML `--rose/--primary/--green` already ship as journey tokens). | A designer-approved amber token is added to the skin or journey tokens. | provisional |
| O-002 | 2026-10-31 | `lib/features/onboarding/src/presentation/onboarding_board.dart` | `HtmlJourneyTokens.obPuHover * 2.0` (12.0) | Increased podium avatar bobbing amplitude from 6px to 12px per user request for smooth visibility and fluidity. | Token `obPuHover` is updated in Figma/HTML tokens. | provisional |
| O-003 | 2026-10-31 | `packages/design_system/lib/src/components/fields/app_otp_field.dart` | `420ms, 45ms, -6.0dp, 1.04 scale` | OTP success cascading wave (okWave) reconstructed from HTML prototype CSS (--spring, 420ms, 45ms stagger, -6px, 1.04). | A designer-approved OTP motion token is added to field tokens. | provisional |
