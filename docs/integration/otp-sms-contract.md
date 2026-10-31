# OTP SMS contract — D-071

Provisional development contract. The production message pattern is not defined.
Remote product builds do not autofill until that pattern exists.

## Message

- The SMS is at most 140 bytes, not 140 characters. Persian text uses two bytes
  per character.
- It contains exactly one code and the 11-character app hash, preferably on the
  last line.
- The hash depends on package name `ir.mci.mygame.p2e` and the signing
  certificate. Debug, release and Play App Signing each have a different hash.
- A device without Google Play Services keeps manual entry.

## Development pattern

`MyGame code: <code> <hash>`

The development code may include a letter, as in `P12345`. A digits-only
six-character pattern is not the development matcher. An ambiguous message,
with zero or more than one match, is ignored. The full SMS text is never stored
or logged.

## Platforms

Android uses SMS Retriever and fills the field without a prompt (PE-003). iOS
offers the oneTimeCode keyboard suggestion and does not read the inbox. One
parsed SMS code also submits itself (D-074). Typing still needs the button.
The listener starts before the send request and before resend.

`adb emu sms send` can place a development message on an emulator. It does not
prove Retriever on a device. That proof needs a real SMS, Play Services and the
matching signing certificate.
