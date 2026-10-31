import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/balance/balance.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:mygame_p2e/shared/platform/notification_permission.dart';
import 'package:mygame_p2e/shared/preferences/device_preferences.dart';
import 'package:mygame_p2e/shared/profile/profile.dart';
import 'package:mygame_p2e/shared/session/session.dart';
import 'package:mygame_p2e/shared/widgets/journey_confetti.dart';
import 'package:mygame_p2e/shared/widgets/player_avatar.dart';
import 'package:p2e_design_system/design_system.dart';

import 'auth_entry_controller.dart';
import 'auth_flow.dart';
import 'journey_support.dart';
import 'widgets/journey_layout.dart';

export 'avatar_screen.dart' show AvatarScreen;
export 'journey_support.dart' show showAuthHelp;
export 'username_screen.dart' show UsernameScreen;

SkinRoleValues _roles(BuildContext context) =>
    SkinTheme.of(context).valuesFor(Theme.of(context).brightness);

TextStyle _text(String name) => AuthTextTokens.byName[name]!;

/// Allow Notifications (HTML `screens.notif`). Centered header, no app bar.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auto-dispose flow state must outlive the async permission/preference
    // calls on this page, or the router redirects back to /entry.
    ref.watch(authFlowProvider);
    final strings = AppLocalizations.of(context);
    Future<void> answer(bool enabled) async {
      final current =
          ref.read(devicePreferencesProvider).value ??
          const DevicePreferences();
      await ref
          .read(devicePreferencesProvider.notifier)
          .save(current.copyWith(notificationsAsked: true));
      if (context.mounted) {
        journeyGo(context, AuthStep.allSet, notificationsOn: enabled);
      }
    }

    return JourneyPage(
      elementId: 'auth.notifications.page',
      header: JourneyHeader(
        lead: const _Bell(),
        title: strings.authNotifyTitle,
        bodyText: strings.authNotifyBody,
      ),
      items: JourneyItems(
        children: [
          for (final row in [
            (AppIconId.targetCheck, strings.authNotifyMission),
            (AppIconId.calendar, strings.authNotifyDaily),
            (AppIconId.pokerChip, strings.authNotifyPayment),
          ])
            JourneyItem(
              icon: AssetAppIcon(
                row.$1,
                style: AppIconStyle.fill,
                size: HtmlJourneyTokens.avatarLetterLarge,
                color: HtmlJourneyTokens.splashGradientMid,
              ),
              text: row.$2,
            ),
        ],
      ),
      actions: [
        AppButton(
          elementId: 'auth.notifications.page.next',
          family: AppButtonFamily.fill,
          tone: AppButtonTone.accent,
          label: strings.authNotifyAllow,
          onPressed: () async {
            final status = await ref
                .read(notificationPermissionPortProvider)
                .request();
            await answer(status == NotificationPermissionStatus.granted);
          },
        ),
        AppButton(
          elementId: 'auth.notifications.page.secondary',
          label: strings.authNotifyLater,
          type: AppButtonType.text,
          onPressed: () => answer(false),
        ),
      ],
    );
  }
}

/// You're All Set (HTML `screens.allSet`).
class AllSetScreen extends ConsumerWidget {
  const AllSetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auto-dispose flow state must outlive the async permission/preference
    // calls on this page, or the router redirects back to /entry.
    ref.watch(authFlowProvider);
    final strings = AppLocalizations.of(context);
    final roles = _roles(context);
    final journey = currentJourney(context);
    final username = journey?.username.isNotEmpty == true
        ? journey!.username
        : 'player';
    final alertsOn = journey?.notificationsOn == true;
    return JourneyPage(
      elementId: 'auth.all-set.page',
      overlay: const Positioned.fill(
        child: IgnorePointer(child: JourneyConfetti()),
      ),
      header: JourneyHeader(
        large: true,
        lead: const Stack(
          clipBehavior: Clip.none,
          children: [
            _JourneyAvatar(),
            PositionedDirectional(end: 0, bottom: 0, child: _VerifiedBadge()),
          ],
        ),
        title: strings.authAllSetTitle,
        body: TextSpan(
          children: [
            TextSpan(text: '${strings.authAllSetBody} '),
            TextSpan(
              text: '@$username',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: roles.onSurfaceEmphasis,
              ),
            ),
          ],
        ),
      ),
      items: JourneyItems(
        children: [
          _Reward(
            label: strings.authAllSetBonus,
            points: strings.authAllSetPts,
          ),
          JourneyItem(
            icon: AssetAppIcon(
              AppIconId.check,
              size: HtmlJourneyTokens.avatarLetterLarge,
              color: HtmlJourneyTokens.success,
            ),
            text: journey?.email != null
                ? strings.authAllSetEmail
                : strings.authAllSetPhone,
          ),
          JourneyItem(
            icon: alertsOn
                ? AssetAppIcon(
                    AppIconId.check,
                    size: HtmlJourneyTokens.avatarLetterLarge,
                    color: HtmlJourneyTokens.success,
                  )
                : AssetAppIcon(
                    AppIconId.calendar,
                    style: AppIconStyle.fill,
                    size: HtmlJourneyTokens.avatarLetterLarge,
                    color: roles.onSurfaceVariant,
                  ),
            text: alertsOn
                ? strings.authAllSetAlertsOn
                : strings.authAllSetAlertsOff,
          ),
        ],
      ),
      actions: [
        AppButton(
          elementId: 'auth.all-set.page.next',
          family: AppButtonFamily.fill,
          tone: AppButtonTone.accent,
          label: strings.authStartPlaying,
          onPressed: () async {
            final current =
                ref.read(devicePreferencesProvider).value ??
                const DevicePreferences();
            final latest = currentJourney(context);
            final raw = latest?.email?.normalized ?? latest?.phoneRaw ?? '';
            await ref
                .read(devicePreferencesProvider.notifier)
                .save(
                  current.copyWith(
                    homeTourPending: true,
                    rememberedRaw: latest?.rememberDevice == true ? raw : '',
                    rememberedLabel: latest?.rememberDevice == true
                        ? (latest!.username.isEmpty ? raw : latest.username)
                        : '',
                  ),
                );
            final letter = latest == null || latest.username.isEmpty
                ? 'A'
                : latest.username.substring(0, 1);
            ref
                .read(profileSelectionProvider.notifier)
                .apply(
                  Profile(
                    displayName: latest?.username.isNotEmpty == true
                        ? latest!.username
                        : letter,
                    username: latest?.username ?? '',
                    avatar: latest?.avatarReady == true
                        ? PlayerAvatarSelection.character(
                            latest!.avatarCharacter,
                            theme: latest.avatarTheme,
                          )
                        : PlayerAvatarSelection.initial(
                            theme: latest?.avatarTheme ?? 0,
                          ),
                  ),
                );
            ref
                .read(sessionControllerProvider.notifier)
                .update(SessionStatus.signedIn);
          },
        ),
      ],
    );
  }
}

/// Welcome Back (HTML `screens.welcomeBack`).
class WelcomeBackScreen extends ConsumerWidget {
  const WelcomeBackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auto-dispose flow state must outlive the async permission/preference
    // calls on this page, or the router redirects back to /entry.
    ref.watch(authFlowProvider);
    final strings = AppLocalizations.of(context);
    final roles = _roles(context);
    final journey = currentJourney(context);
    final username = journey?.username.isNotEmpty == true
        ? journey!.username
        : 'player';
    return JourneyPage(
      elementId: 'auth.welcome.page',
      header: JourneyHeader(
        large: true,
        lead: const _JourneyAvatar(land: true),
        title: strings.authWelcomeTitle,
        body: TextSpan(
          children: [
            TextSpan(text: '${strings.authWelcomeBody} '),
            TextSpan(
              text: '@$username',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: roles.onSurfaceEmphasis,
              ),
            ),
            TextSpan(text: '. ${strings.authWelcomeBodyTail}'),
          ],
        ),
      ),
      items: const Center(child: _PointsPill()),
      actions: [
        AppButton(
          elementId: 'auth.welcome.page.next',
          family: AppButtonFamily.fill,
          tone: AppButtonTone.accent,
          label: strings.authLetsPlay,
          onPressed: () => ref
              .read(sessionControllerProvider.notifier)
              .update(SessionStatus.signedIn),
        ),
      ],
    );
  }
}

class _JourneyAvatar extends StatelessWidget {
  const _JourneyAvatar({this.land = false});
  final bool land;

  @override
  Widget build(BuildContext context) {
    final journey = currentJourney(context);
    final username = journey?.username ?? '';
    final letter = username.isEmpty ? 'A' : username.substring(0, 1);
    final avatar = PlayerAvatar(
      letter: letter,
      theme: journey?.avatarTheme ?? 0,
      character: journey?.avatarReady == true ? journey!.avatarCharacter : null,
      size: PlayerAvatarSize.hero,
    );
    return _Pop(
      curve: HtmlJourneyTokens.spring,
      duration: HtmlJourneyTokens.tourMove,
      delay: HtmlJourneyTokens.softInDelay * 0.66,
      from: HtmlJourneyTokens.landPopStart,
      child: avatar,
    );
  }
}

/// Spring scale-in used by the header avatar (HTML `avIn`).
class _Pop extends StatefulWidget {
  const _Pop({
    required this.child,
    required this.curve,
    required this.duration,
    required this.delay,
    required this.from,
  });
  final Widget child;
  final Curve curve;
  final Duration duration, delay;
  final double from;

  @override
  State<_Pop> createState() => _PopState();
}

class _PopState extends State<_Pop> with SingleTickerProviderStateMixin {
  late final AnimationController clock;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    clock = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      clock.value = 1;
    } else if (clock.value == 0 && timer == null) {
      timer = Timer(widget.delay, () {
        if (mounted) clock.forward();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: clock,
    builder: (context, child) {
      final t = widget.curve.transform(clock.value);
      final scale = widget.from + (1 - widget.from) * t;
      return Opacity(
        opacity: clock.value.clamp(0.0, 1.0),
        child: Transform.scale(scale: scale, child: child),
      );
    },
    child: widget.child,
  );
}

/// Counts up from zero to the welcome offer or the current balance.
class _CountUp extends StatefulWidget {
  const _CountUp({
    required this.fromOffer,
    required this.style,
    required this.delay,
  });
  final bool fromOffer;
  final TextStyle style;
  final Duration delay;

  @override
  State<_CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<_CountUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController clock;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    clock = AnimationController(
      vsync: this,
      duration: HtmlJourneyTokens.countUp,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      clock.value = 1;
    } else if (clock.value == 0 && timer == null) {
      timer = Timer(widget.delay, () {
        if (mounted) clock.forward();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    final offer = container.read(authEntryControllerProvider).welcomeOffer;
    final balance = container.read(balanceProvider).value;
    final target = widget.fromOffer
        ? offer?.points ?? 3500
        : balance?.points ?? 0;
    final language = Localizations.localeOf(context).languageCode;
    return AnimatedBuilder(
      animation: clock,
      builder: (context, _) {
        final shown = (target * HtmlJourneyTokens.ease.transform(clock.value))
            .round();
        return Text(
          widget.fromOffer
              ? formatGain(shown, languageCode: language)
              : formatCount(shown, languageCode: language),
          style: widget.style.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        );
      },
    );
  }
}

/// HTML `.reward`: pink crown tile, animated "+3,500 pts" and a caption.
class _Reward extends StatelessWidget {
  const _Reward({required this.label, required this.points});
  final String label, points;

  @override
  Widget build(BuildContext context) {
    final roles = _roles(context);
    final amount = _text('English/Baseline/Number-Large').copyWith(
      color: roles.onSurfaceEmphasis,
      fontSize: HtmlJourneyTokens.jlRewardAmt,
      height: 1,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );
    final unit = _text('English/Baseline/Label-Medium').copyWith(
      color: roles.onSurfaceMuted,
      fontSize: HtmlJourneyTokens.jlBody,
      height: HtmlJourneyTokens.jlBodyLine / HtmlJourneyTokens.jlBody,
      fontWeight: FontWeight.w400,
    );
    final caption = _text('English/Baseline/Label-Small').copyWith(
      color: roles.onSurfaceBase,
      fontSize: HtmlJourneyTokens.jlRewardSub,
      height: HtmlJourneyTokens.jlRewardSubLine / HtmlJourneyTokens.jlRewardSub,
      fontWeight: FontWeight.w500,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: roles.surfaceContainerBase,
        borderRadius: BorderRadius.circular(HtmlJourneyTokens.jlItemRadius),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(HtmlJourneyTokens.jlRewardPad),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: roles.containerPink,
                borderRadius: BorderRadius.circular(
                  HtmlJourneyTokens.jlRewardIcRadius,
                ),
              ),
              child: SizedBox.square(
                dimension: HtmlJourneyTokens.jlRewardIc,
                child: Center(
                  child: _Pop(
                    curve: HtmlJourneyTokens.spring,
                    duration: HtmlJourneyTokens.countUp * 0.77,
                    delay: HtmlJourneyTokens.softInDelay * 3,
                    from: 0.4,
                    child: AssetAppIcon(
                      AppIconId.crown,
                      style: AppIconStyle.fill,
                      size: HtmlJourneyTokens.avatarLetterLarge,
                      color: roles.primaryPink,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: HtmlJourneyTokens.jlRewardGap),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        _CountUp(
                          fromOffer: true,
                          style: amount,
                          delay: HtmlJourneyTokens.countUpDelay,
                        ),
                        const SizedBox(width: 4),
                        Text(points, style: unit),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(label, style: caption),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// HTML `.chip` on Welcome Back: crown disc, count and "pts".
class _PointsPill extends StatelessWidget {
  const _PointsPill();

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final roles = _roles(context);
    final amount = _text('English/Baseline/Number-Large').copyWith(
      color: roles.onSurfaceEmphasis,
      fontSize: HtmlJourneyTokens.jlBody,
      height: HtmlJourneyTokens.jlBodyLine / HtmlJourneyTokens.jlBody,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );
    final unit = _text('English/Baseline/Label-Small').copyWith(
      color: roles.onSurfaceVariant,
      fontSize: HtmlJourneyTokens.jlRewardSub,
      height: HtmlJourneyTokens.jlRewardSubLine / HtmlJourneyTokens.jlRewardSub,
      fontWeight: FontWeight.w400,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: roles.surfaceContainerBase,
        borderRadius: BorderRadius.circular(HtmlJourneyTokens.jlChipH / 2),
      ),
      child: SizedBox(
        height: HtmlJourneyTokens.jlChipH,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, end: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: roles.containerPink,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(
                  dimension: HtmlJourneyTokens.jlChipIc,
                  child: Center(
                    child: AssetAppIcon(
                      AppIconId.crown,
                      style: AppIconStyle.fill,
                      size: HtmlJourneyTokens.cardRadius,
                      color: roles.primaryPink,
                    ),
                  ),
                ),
              ),
              _CountUp(
                fromOffer: false,
                style: amount,
                delay: HtmlJourneyTokens.softInDelay * 2,
              ),
              Text(strings.authAllSetPts, style: unit),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    final roles = _roles(context);
    return _Pop(
      curve: HtmlJourneyTokens.spring,
      duration: HtmlJourneyTokens.badgePop,
      delay: HtmlJourneyTokens.verifiedDelay,
      from: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: roles.surfaceContainerHighest,
          shape: BoxShape.circle,
          border: Border.all(
            color: roles.surfaceBase,
            width: HtmlJourneyTokens.jlBadgeBorder,
          ),
        ),
        child: SizedBox.square(
          dimension: HtmlJourneyTokens.jlBadge,
          child: Center(
            child: AssetAppIcon(
              AppIconId.verified,
              size: HtmlJourneyTokens.avatarExtentCompact / 2,
              color: HtmlJourneyTokens.splashGradientMid,
            ),
          ),
        ),
      ),
    );
  }
}

/// HTML `.bellc`: tinted circle, two pulsing rings and a swinging bell.
class _Bell extends StatefulWidget {
  const _Bell();

  @override
  State<_Bell> createState() => _BellState();
}

class _BellState extends State<_Bell> with TickerProviderStateMixin {
  late final AnimationController pulse;
  late final AnimationController swing;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    pulse = AnimationController(
      vsync: this,
      duration: HtmlJourneyTokens.bellPulse,
    );
    swing = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      pulse.stop();
      swing.value = 1;
    } else if (!pulse.isAnimating) {
      pulse.repeat();
      timer ??= Timer(HtmlJourneyTokens.softInDelay * 3, () async {
        for (var i = 0; i < 2 && mounted; i++) {
          await swing.forward(from: 0);
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    pulse.dispose();
    swing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: HtmlJourneyTokens.jlCircle,
      child: AnimatedBuilder(
        animation: Listenable.merge([pulse, swing]),
        builder: (context, _) {
          final s = swing.value;
          final angle = math.sin(s * math.pi * 4) * (1 - s) * 0.26;
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              _PulseRing(t: pulse.value),
              _PulseRing(t: (pulse.value + 0.5) % 1),
              JourneyCircle(
                child: Transform.rotate(
                  angle: angle,
                  alignment: const Alignment(0, -0.64),
                  child: AssetAppIcon(
                    AppIconId.notifications,
                    style: AppIconStyle.fill,
                    size: HtmlJourneyTokens.avatarLetterHero - 6,
                    color: HtmlJourneyTokens.splashGradientMid,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) => Transform.scale(
    scale: 1 + (HtmlJourneyTokens.bellPulseScale - 1) * t,
    child: Opacity(
      opacity: (1 - t).clamp(0.0, 1.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: HtmlJourneyTokens.splashGradientMid.withValues(alpha: 0.35),
            width: HtmlJourneyTokens.legalProgressExtent,
          ),
        ),
        child: const SizedBox.square(dimension: HtmlJourneyTokens.jlCircle),
      ),
    ),
  );
}
