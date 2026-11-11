import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/formatting/rewards.dart';
import '../../../../shared/preferences/device_preferences.dart';
import '../../../../shared/platform/external_links.dart';
import '../../../../shared/widgets/auth_intro.dart';
import '../../../../shared/widgets/complete_tap_envelope.dart';
import '../../../../shared/widgets/reward_pill.dart';
import '../domain/identifier.dart';
import '../domain/models.dart';
import 'auth_entry_controller.dart';
import 'auth_flow.dart';
import 'auth_messages.dart';
import 'entry/widgets/auth_entry_widgets.dart';

class AuthEntryScreen extends ConsumerStatefulWidget {
  const AuthEntryScreen({super.key});
  @override
  ConsumerState<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends ConsumerState<AuthEntryScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController editing;
  final focus = FocusNode();
  // Keep the editor/autofill subtree when the keyboard removes the idle frame.
  final formKey = GlobalKey();
  late final AnimationController _keyboardMotion;
  late final CurvedAnimation _keyboardCurve;
  bool? _keyboardOpen;
  AuthMessage? localToast;
  int toastKey = 0;
  @override
  void initState() {
    super.initState();
    editing = TextEditingController(
      text: ref.read(authEntryControllerProvider).raw,
    );
    focus.addListener(_focusChanged);
    // D-063: engineering duration. Reduced motion jumps without AnimatedSize.
    _keyboardMotion = AnimationController(
      vsync: this,
      duration: AuthEntryMotion.duration,
    );
    _keyboardCurve = CurvedAnimation(
      parent: _keyboardMotion,
      curve: AuthEntryMotion.curve,
    );
    // Per-frame rebuilds happen inside the animated subtrees (AnimatedBuilder
    // below); the screen itself rebuilds only when the transition starts or
    // settles, to flip the static/animated branch.
    _keyboardMotion.addStatusListener(_onKeyboardStatus);
  }

  void _focusChanged() {
    if (mounted) setState(() {});
  }

  void _onKeyboardStatus(AnimationStatus status) {
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final duration = reduced ? Duration.zero : AuthEntryMotion.duration;
    if (_keyboardMotion.duration != duration) {
      _keyboardMotion.duration = duration;
    }
    if (_keyboardOpen == null) {
      _keyboardOpen = keyboard;
      _keyboardMotion.value = keyboard ? 1 : 0;
      return;
    }
    if (_keyboardOpen == keyboard) return;
    _keyboardOpen = keyboard;
    if (reduced) {
      _keyboardMotion.value = keyboard ? 1 : 0;
      return;
    }
    if (keyboard) {
      _keyboardMotion.forward();
    } else {
      _keyboardMotion.reverse();
    }
  }

  @override
  void dispose() {
    _keyboardMotion.removeStatusListener(_onKeyboardStatus);
    _keyboardCurve.dispose();
    _keyboardMotion.dispose();
    focus.dispose();
    editing.dispose();
    super.dispose();
  }

  void showMessage(AuthMessage message) => setState(() {
    localToast = message;
    toastKey++;
  });
  void openLink(ExternalLink link) {
    context.push('/legal/${link.name}');
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final state = ref.watch(authEntryControllerProvider);
    final controller = ref.read(authEntryControllerProvider.notifier);
    ref.listen(authEntryControllerProvider, (previous, next) {
      if (next.toast != null && previous?.toastSerial != next.toastSerial) {
        showMessage(next.toast!);
      }
      if (next.destination != null &&
          previous?.destination != next.destination) {
        TextInput.finishAutofillContext();
        focus.unfocus();
        context.push(authStepPath(next.destination!));
      }
    });
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    final animating =
        !MediaQuery.disableAnimationsOf(context) && _keyboardMotion.isAnimating;
    // Per-tick values resolve inside these frames, not in the screen build.
    Widget revealed(Widget Function(double shown) frame) => AnimatedBuilder(
      animation: _keyboardCurve,
      builder: (context, _) => frame(1 - _keyboardCurve.value),
    );
    final node = keyboard
        ? switch (state.identifier) {
            Phone() => '18618:12126',
            Email() => '18618:12651',
            _ => '18618:12447',
          }
        : '18608:11451';
    final helper = state.identifier is Phone
        ? strings.authPhoneHelper
        : state.identifier is Email
        ? strings.authEmailHelper
        : null;
    final cta = state.identifier is Phone
        ? strings.authContinuePhone
        : state.identifier is Email
        ? strings.authContinueEmail
        : strings.authContinue;
    final remembered =
        ref.watch(devicePreferencesProvider).value?.rememberedRaw ?? '';
    final rememberedLabel =
        ref.watch(devicePreferencesProvider).value?.rememberedLabel ??
        remembered;
    final language = Localizations.localeOf(context).languageCode;
    final offer = state.welcomeOffer;
    final amount = offer == null
        ? ''
        : formatWelcomeBonus(offer.points, languageCode: language);
    Widget button({bool semantics = true}) {
      final control = CompleteTapEnvelope(
        child: AppButton(
          elementId: 'auth.entry.continue',
          key: const ValueKey('auth.continue'),
          family: AppButtonFamily.fill,
          tone: AppButtonTone.accent,
          label: cta,
          loading: state.busy,
          loadingSemanticsLabel: strings.authLoading,
          onPressed: state.canSubmit
              ? () => unawaited(controller.submit())
              : null,
        ),
      );
      if (semantics) return control;
      return ExcludeSemantics(child: IgnorePointer(child: control));
    }

    List<Widget> idleFieldChrome({required bool semantics}) => [
      const SizedBox(height: AuthEntryTokens.fieldGap),
      AppCheckbox(
        elementId: 'auth.entry.remember',
        label: strings.authRemember,
        value: state.rememberDevice,
        onChanged: state.busy ? null : (_) => controller.rememberToggled(),
      ),
      SizedBox(
        height:
            AuthEntryTokens.formGap -
            (FieldMotion.tapExtent - AuthEntryTokens.radioVisualHeight),
      ),
      button(semantics: semantics),
    ];
    List<Widget> idleFooter() => [
      LabeledDivider(
        elementId: 'auth.entry.divider',
        label: strings.authDivider,
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AuthEntryTokens.socialSectionHeight,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AuthEntryTokens.pageInset),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final brand in SocialAuthBrand.values) ...[
                if (brand != SocialAuthBrand.playStation)
                  const SizedBox(width: AuthEntryTokens.socialGap),
                Expanded(
                  child: SocialAuthTile(
                    elementId: 'auth.entry.social.${brand.name.toLowerCase()}',
                    brand: brand,
                    label: switch (brand) {
                      SocialAuthBrand.playStation => strings.authPlayStation,
                      SocialAuthBrand.xbox => strings.authXbox,
                      SocialAuthBrand.google => strings.authGoogle,
                    },
                    onPressed: state.busy
                        ? null
                        : () => unawaited(
                            controller.socialRequested(
                              SocialProvider.values.byName(brand.name),
                            ),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.all(AuthEntryTokens.pageInset),
        child: LinkText(
          enabled: !state.busy,
          elementId: 'auth.entry.legal',
          segments: [
            LinkTextSegment(strings.authLegalStart),
            LinkTextSegment(
              strings.authTerms,
              onTap: () => openLink(ExternalLink.terms),
            ),
            LinkTextSegment(strings.authLegalAnd),
            LinkTextSegment(
              strings.authPrivacy,
              onTap: () => openLink(ExternalLink.privacy),
            ),
            LinkTextSegment(strings.authLegalEnd),
          ],
        ),
      ),
    ];
    Widget top({required bool idleChrome}) => Column(
      key: formKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthIntro(title: strings.authTitle, subtitle: strings.authSubtitle),
        if (offer != null)
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AuthEntryTokens.formInset,
              vertical: AuthEntryTokens.bonusInset,
            ),
            child: RewardPill(
              amount: amount,
              unit: strings.authPoints,
              label: strings.authWelcome,
            ),
          ),
        Padding(
          padding: const EdgeInsetsDirectional.all(AuthEntryTokens.formInset),
          child: ButtonHitRegion(
            child: AutofillGroup(
              onDisposeAction: AutofillContextAction.cancel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (remembered.isNotEmpty)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        bottom: AuthEntryTokens.fieldGap,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(rememberedLabel),
                          AppButton(
                            elementId: 'auth.entry.continue-as',
                            label: strings.authContinueAs,
                            onPressed: state.busy
                                ? null
                                : () {
                                    controller.identifierChanged(remembered);
                                    unawaited(controller.submit());
                                  },
                          ),
                          AppButton(
                            elementId: 'auth.entry.not-you',
                            label: strings.authNotYou,
                            type: AppButtonType.text,
                            onPressed: state.busy
                                ? null
                                : () async {
                                    final current =
                                        ref
                                            .read(devicePreferencesProvider)
                                            .value ??
                                        const DevicePreferences();
                                    await ref
                                        .read(
                                          devicePreferencesProvider.notifier,
                                        )
                                        .save(
                                          current.copyWith(
                                            rememberedRaw: '',
                                            rememberedLabel: '',
                                          ),
                                        );
                                  },
                          ),
                        ],
                      ),
                    ),
                  AppTextField(
                    elementId: 'auth.entry.identifier',
                    label: strings.authIdentifier,
                    options: FieldInputOptions(
                      controller: editing,
                      focusNode: focus,
                      hint: strings.authHint,
                      supportingText: helper,
                      enabled: !state.busy,
                      feedback: state.fieldError == null
                          ? const FieldFeedback.neutral()
                          : FieldFeedback.error(
                              message(strings, state.fieldError!),
                            ),
                      identifierPrivacy: true,
                      wrapHint: true,
                      presentation: state.identifier is Phone
                          ? FieldInputPresentation.phoneNumber
                          : FieldInputPresentation.source,
                      textDirection: TextDirection.ltr,
                      // PHYSICAL: identifiers retain typed LTR editing in every locale.
                      textAlign: TextAlign.left,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.go,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.telephoneNumber,
                        AutofillHints.username,
                      ],
                      onChanged: controller.identifierChanged,
                      onSubmitted: (_) {
                        if (state.canSubmit) unawaited(controller.submit());
                      },
                    ),
                  ),
                  if (idleChrome && !animating)
                    ...idleFieldChrome(semantics: true),
                  if (idleChrome && animating)
                    revealed(
                      (shown) => _Reveal(
                        shown: shown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: idleFieldChrome(semantics: shown >= 0.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (idleChrome && !animating) ...idleFooter(),
        if (idleChrome && animating)
          revealed(
            (shown) => _Reveal(
              shown: shown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: idleFooter(),
              ),
            ),
          ),
      ],
    );
    Widget keyboardBar({bool semantics = true}) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AuthEntryTokens.keyboardGap),
        child: ButtonHitRegion(
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AdaptiveTokens.contentMaxWidth,
              ),
              child: button(semantics: semantics),
            ),
          ),
        ),
      ),
    );
    return ElementIdentity(
      elementId: 'auth.entry.screen',
      runtimeLocator: UiIdentityScope.resolve(context),
      componentId: 'screen.auth-entry',
      structureRef: 'screen.auth-entry',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: node,
      componentSetId: null,
      rawSetName: '',
      rawVariantName: '',
      variants: const {},
      declared: {'loading': state.busy},
      resolved: const {},
      child: PageScaffold(
        elementId: 'auth.entry.page',
        layout: PageScaffoldLayout.viewport,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: focus.unfocus,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: const ValueKey('auth.scroll'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!animating && !keyboard)
                            SizedBox(
                              height:
                                  MediaQuery.paddingOf(context).top +
                                  AuthEntryTokens.heroHeight,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  PositionedDirectional(
                                    top: 0,
                                    start: 0,
                                    end: 0,
                                    child: const HeroBanner(
                                      elementId: 'auth.entry.hero',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (!animating && keyboard)
                            SizedBox(height: MediaQuery.paddingOf(context).top),
                          if (animating)
                            revealed(
                              (shown) => SizedBox(
                                height:
                                    MediaQuery.paddingOf(context).top +
                                    AuthEntryTokens.heroHeight * shown,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    PositionedDirectional(
                                      top: 0,
                                      start: 0,
                                      end: 0,
                                      child: Opacity(
                                        opacity: shown.clamp(0.0, 1.0),
                                        child: const HeroBanner(
                                          elementId: 'auth.entry.hero',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: AdaptiveTokens.contentMaxWidth,
                              ),
                              child: animating
                                  ? revealed(
                                      (shown) => Padding(
                                        padding: EdgeInsetsDirectional.all(
                                          AuthEntryTokens.bodyStroke * shown,
                                        ),
                                        child: top(idleChrome: true),
                                      ),
                                    )
                                  : keyboard
                                  ? top(idleChrome: false)
                                  : AuthEntryBodyFrame(
                                      elementId: 'auth.entry.body',
                                      child: top(idleChrome: true),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!animating && keyboard) keyboardBar(),
                  if (animating)
                    revealed(
                      (shown) => _Reveal(
                        shown: 1 - shown,
                        alignment: AlignmentDirectional.bottomCenter,
                        child: keyboardBar(semantics: (1 - shown) >= 0.5),
                      ),
                    ),
                ],
              ),
              if (localToast != null)
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: AppToast(
                    key: ValueKey(toastKey),
                    elementId: 'auth.entry.toast',
                    message: message(strings, localToast!),
                    onDismiss: () {
                      if (mounted) setState(() => localToast = null);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.shown,
    required this.child,
    this.alignment = AlignmentDirectional.topCenter,
  });

  final double shown;
  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final factor = shown.clamp(0.0, 1.0);
    return ClipRect(
      child: Align(
        alignment: alignment,
        heightFactor: factor,
        child: Opacity(opacity: factor, child: child),
      ),
    );
  }
}

String message(AppLocalizations strings, AuthMessage value) => switch (value) {
  AuthMessage.offline => strings.authOffline,
  AuthMessage.server => strings.authServer,
  AuthMessage.notConfigured => strings.authNotConfigured,
  AuthMessage.socialUnavailable => strings.authSocialUnavailable,
  AuthMessage.blocked => strings.authBlocked,
  AuthMessage.invalidCode => strings.authOtpInvalid,
  AuthMessage.prefixMismatch => strings.authOtpPrefix,
  AuthMessage.invalidPassword => strings.authPasswordInvalid,
  AuthMessage.rateLimited => strings.authRateLimited,
  AuthMessage.unknown => strings.authUnknown,
  AuthMessage.urlMissing => strings.authUrlMissing,
  AuthMessage.urlFailed => strings.authUrlFailed,
};
