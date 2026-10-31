# Inspector sweep v2

`p2e-sweep-v1.1` is unchanged. Professional runs add a separate `p2e-sweep-v2` document inside `p2e-inspector-bundle-v2`.

## What is sampled

- Environment rows are a deterministic pairwise matrix over locale order, text scale, brightness, platform, keyboard, keyboard height, safe-area profile, reduced motion, bold text, high contrast and skin. The same seed reproduces the same rows. An explicit environment list may replace generation.
- Sizes are engineering boundaries: 251/252/253, 599/600/601, 839/840/841, short, tall, landscape and one asymmetric inset. Marketing phone presets are not added.
- A scenario id is recorded when the product host supplies one. The sweep does not tap, type or navigate through the product UI. The host may mount a registered route before the samples start. Semantics compilation is paused during the matrix because continuous rebuilds trip framework semantics assertions; the Accessibility tab audits a settled page separately.
- Refinement probes only an observed pass/fail bracket. A single transition is binary-searched to 1 logical pixel. More than one transition switches to local samples. Unsampled pixels are not reported as failures.
- Minimization starts from the smallest sampled failing size and removes environment factors that are not required to keep that failure. The result is an exact replay snapshot.

## What a report is not

- Not pixel equality and not sampled colors.
- Not a TalkBack, VoiceOver or WCAG certification. Accessibility findings describe the semantics tree built in this embed. Accessible names are not exported; duplicate names are a fingerprint only.
- Not a device benchmark. Performance counts are diagnostic.
- Not an Android emulator substitute. Real IME, lifecycle, permissions, TLS and GPU behavior stay on the emulator.

## Privacy

Bundle keys that look like passwords, OTP values or raw input are removed. Route and scenario ids are not user content. Password, OTP and identifier owners are omitted from duplicate-name fingerprints.
