# Overrides

Raw values that bypass tokens. Choosing another existing token is not an override.
Every entry matches a code annotation `// OVERRIDE(O-###): reason`. CI lists annotations without an entry and entries without code.

| Id | Date | File | Value | Reason | Remove when | Status |
|---|---|---|---|---|---|---|
| O-001 | 2026-10-28 | `lib/features/auth/src/presentation/password/widgets/password_strength.dart` | `Color(0xFFFF9F0A)` | Password strength Fair level takes the HTML prototype `--amber`; no amber token exists in the skin or journey tokens (HTML `--rose/--primary/--green` already ship as journey tokens). | A designer-approved amber token is added to the skin or journey tokens. | provisional |
