import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/widgets/player_avatar.dart';
import 'package:p2e_design_system/design_system.dart';

import 'auth_flow.dart';
import 'journey_support.dart';

/// HTML `QUICK`: the initial plus four characters (indexes into the 12).
const _quick = <int?>[null, 0, 1, 5, 6];

/// Pick Your Avatar (HTML `screens.avatar`) and the All Avatars sheet.
class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});
  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  /// Null shows the initial letter.
  int? character;
  var theme = 0;

  String get _username => currentJourney(context)?.username ?? '';
  String get _letter => _username.isEmpty ? 'A' : _username.substring(0, 1);

  void _pickCharacter(int? value) => setState(() => character = value);

  void _allAvatars() {
    final strings = AppLocalizations.of(context);
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final head = AuthTextTokens.byName['English/Baseline/Headline-Small']!;
    final body = AuthTextTokens.byName['English/Baseline/Label-Medium']!;
    AppSheet.show<void>(
      context: context,
      elementId: 'auth.avatar.sheet',
      child: StatefulBuilder(
        builder: (sheetContext, refresh) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.authAvatarAll,
              style: head.copyWith(
                color: roles.color('On Surface/Emphasis'),
                fontSize: HtmlJourneyTokens.shTitle,
                height:
                    HtmlJourneyTokens.shTitleLine / HtmlJourneyTokens.shTitle,
              ),
            ),
            const SizedBox(height: HtmlJourneyTokens.jlTextGap),
            Text(
              strings.authAvatarSheetBody,
              style: body.copyWith(
                color: roles.color('On Surface/Base'),
                fontSize: HtmlJourneyTokens.shBody,
                height: HtmlJourneyTokens.shBodyLine / HtmlJourneyTokens.shBody,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: HtmlJourneyTokens.shGap),
            GridView.count(
              crossAxisCount: HtmlJourneyTokens.shGridCols,
              mainAxisSpacing: HtmlJourneyTokens.shGridGap,
              crossAxisSpacing: HtmlJourneyTokens.shGridGap,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final value in <int?>[
                  null,
                  for (var i = 0; i < playerAvatarNames.length; i++) i,
                ])
                  _AvatarChoice(
                    elementId: 'auth.avatar.all.${value ?? 'initial'}',
                    label: value == null
                        ? strings.authAvatarInitial
                        : playerAvatarNames[value],
                    selected: character == value,
                    ring: HtmlJourneyTokens.avatarThemes[theme].onContainer,
                    fit: true,
                    avatar: PlayerAvatar(
                      letter: _letter,
                      theme: theme,
                      character: value,
                      size: PlayerAvatarSize.hero,
                    ),
                    onTap: () {
                      _pickCharacter(value);
                      refresh(() {});
                    },
                  ),
              ],
            ),
            const SizedBox(height: HtmlJourneyTokens.shGap),
            AppButton(
              elementId: 'auth.avatar.sheet.done',
              family: AppButtonFamily.fill,
              tone: AppButtonTone.accent,
              label: strings.authAvatarDone,
              onPressed: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final title = AuthTextTokens.byName['English/Baseline/Label-Small']!
        .copyWith(
          color: roles.color('On Surface/Base'),
          fontSize: HtmlJourneyTokens.avTtl,
          height: HtmlJourneyTokens.avTtlLine / HtmlJourneyTokens.avTtl,
          fontWeight: FontWeight.w600,
        );
    final nick = AuthTextTokens.byName['English/Baseline/Headline-Small']!
        .copyWith(
          fontSize: HtmlJourneyTokens.avNick,
          height: HtmlJourneyTokens.avNickLine / HtmlJourneyTokens.avNick,
          fontWeight: FontWeight.w600,
        );
    final username = _username.isEmpty ? 'player' : _username;
    return JourneyStep(
      elementId: 'auth.avatar.page',
      title: strings.authAvatarTitle,
      body: strings.authAvatarBody,
      action: strings.authContinue,
      enabled: true,
      onNext: () => journeyGo(
        context,
        AuthStep.notifications,
        avatarCharacter: character ?? 0,
        avatarTheme: theme,
        avatarReady: character != null,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                PlayerAvatar(
                  letter: _letter,
                  theme: theme,
                  character: character,
                  size: PlayerAvatarSize.hero,
                ),
                PositionedDirectional(
                  end: 0,
                  bottom: 0,
                  child: _EditBadge(onPressed: _allAvatars),
                ),
              ],
            ),
            const SizedBox(height: HtmlJourneyTokens.avTopGap),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '@',
                  style: nick.copyWith(
                    color: HtmlJourneyTokens.splashGradientMid,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  username,
                  style: nick.copyWith(
                    color: roles.color('On Surface/Emphasis'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: HtmlJourneyTokens.avGap),
            Text(strings.authAvatarChoose, style: title),
            const SizedBox(height: HtmlJourneyTokens.avGrpGap),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: HtmlJourneyTokens.avListGap,
                children: [
                  for (final (i, value) in _quick.indexed)
                    _AvatarChoice(
                      elementId: 'auth.avatar.quick.$i',
                      label: value == null
                          ? strings.authAvatarInitial
                          : playerAvatarNames[value],
                      selected: character == value,
                      ring: HtmlJourneyTokens
                          .avatarThemes[character == value ? theme : i]
                          .onContainer,
                      avatar: PlayerAvatar(
                        letter: _letter,
                        theme: character == value ? theme : i,
                        character: value,
                        size: PlayerAvatarSize.large,
                      ),
                      onTap: () {
                        if (character == value) return;
                        setState(() {
                          character = value;
                          theme = i;
                        });
                      },
                    ),
                  _MoreButton(
                    label: strings.authAvatarMore,
                    onTap: _allAvatars,
                  ),
                ],
              ),
            ),
            const SizedBox(height: HtmlJourneyTokens.avGap),
            Text(strings.authAvatarTheme, style: title),
            const SizedBox(height: HtmlJourneyTokens.avGrpGap),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: HtmlJourneyTokens.avListGap,
              children: [
                for (var i = 0; i < HtmlJourneyTokens.avatarThemes.length; i++)
                  _ThemeDot(
                    elementId: 'auth.avatar.theme.$i',
                    theme: HtmlJourneyTokens.avatarThemes[i],
                    selected: theme == i,
                    onTap: () => setState(() => theme = i),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A circular choice with the HTML ring (`aria-pressed`), hover and press.
class _AvatarChoice extends StatefulWidget {
  const _AvatarChoice({
    required this.elementId,
    required this.label,
    required this.selected,
    required this.ring,
    required this.avatar,
    required this.onTap,
    this.fit = false,
  });
  final String elementId, label;
  final bool selected, fit;
  final Color ring;
  final Widget avatar;
  final VoidCallback onTap;

  @override
  State<_AvatarChoice> createState() => _AvatarChoiceState();
}

class _AvatarChoiceState extends State<_AvatarChoice> {
  var down = false;
  var hover = false;

  Widget _stack(Widget disc) => Stack(
    fit: StackFit.expand,
    children: [
      ClipOval(child: disc),
      if (widget.selected)
        _Ring(
          color: widget.ring,
          width: HtmlJourneyTokens.avRing,
          inset: HtmlJourneyTokens.avRingInset,
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final scale = down ? 0.92 : (hover ? 1.08 : 1.0);
    final disc = widget.fit
        ? FittedBox(fit: BoxFit.contain, child: widget.avatar)
        : widget.avatar;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.label,
      excludeSemantics: true,
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => hover = true),
        onExit: (_) => setState(() => hover = false),
        child: GestureDetector(
          key: ValueKey(widget.elementId),
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => down = true),
          onTapUp: (_) => setState(() => down = false),
          onTapCancel: () => setState(() => down = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: scale,
            duration: HtmlJourneyTokens.badgePop * 0.66,
            curve: HtmlJourneyTokens.spring,
            child: widget.fit
                ? _stack(disc)
                : SizedBox.square(
                    dimension: HtmlJourneyTokens.avQuick,
                    child: _stack(disc),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Coloured border with a white inner ring, popping in with the spring.
class _Ring extends StatelessWidget {
  const _Ring({required this.color, required this.width, required this.inset});
  final Color color;
  final double width, inset;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: HtmlJourneyTokens.badgePop,
    curve: HtmlJourneyTokens.spring,
    builder: (context, t, child) => Transform.scale(
      scale: 1.12 - 0.12 * t,
      child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
    ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: width),
      ),
      child: Padding(
        padding: EdgeInsets.all(width),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: HtmlJourneyTokens.obWhite,
              width: inset - width,
            ),
          ),
        ),
      ),
    ),
  );
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        key: const ValueKey('auth.avatar.more'),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: roles.surfaceContainerBase,
          ),
          child: SizedBox.square(
            dimension: HtmlJourneyTokens.avQuick,
            child: Center(
              child: AssetAppIcon(
                AppIconId.moreHorizontal,
                size: HtmlJourneyTokens.avatarLetterLarge,
                color: roles.onSurfaceEmphasis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeDot extends StatefulWidget {
  const _ThemeDot({
    required this.elementId,
    required this.theme,
    required this.selected,
    required this.onTap,
  });
  final String elementId;
  final JourneyAvatarTheme theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_ThemeDot> createState() => _ThemeDotState();
}

class _ThemeDotState extends State<_ThemeDot> {
  var down = false;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: widget.selected,
    excludeSemantics: true,
    label: widget.elementId,
    onTap: widget.onTap,
    child: GestureDetector(
      key: ValueKey(widget.elementId),
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => down = true),
      onTapUp: (_) => setState(() => down = false),
      onTapCancel: () => setState(() => down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: down ? 0.92 : 1,
        duration: HtmlJourneyTokens.badgePop * 0.66,
        curve: HtmlJourneyTokens.spring,
        child: SizedBox.square(
          dimension: HtmlJourneyTokens.avTheme,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.theme.container,
                  ),
                ),
              ),
              if (widget.selected)
                Positioned.fill(
                  child: _Ring(
                    color: widget.theme.onContainer,
                    width: HtmlJourneyTokens.avThemeRing,
                    inset: HtmlJourneyTokens.avThemeInset,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// HTML `.big .badge`: the 32px edit button with a spring pop-in and hover tilt.
class _EditBadge extends StatefulWidget {
  const _EditBadge({required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<_EditBadge> createState() => _EditBadgeState();
}

class _EditBadgeState extends State<_EditBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController clock;
  var hover = false;

  @override
  void initState() {
    super.initState();
    clock = AnimationController(
      vsync: this,
      duration: HtmlJourneyTokens.badgePop,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      clock.value = 1;
    } else if (clock.value == 0) {
      Future<void>.delayed(HtmlJourneyTokens.softInDelay, () {
        if (mounted) clock.forward();
      });
    }
  }

  @override
  void dispose() {
    clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final turns = hover ? HtmlJourneyTokens.avatarBadgeHoverDegrees / 360 : 0.0;
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        key: const ValueKey('auth.avatar.edit'),
        onTap: widget.onPressed,
        child: Transform.rotate(
          angle: turns * math.pi * 2,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: clock,
              curve: HtmlJourneyTokens.spring,
            ),
            child: AnimatedScale(
              scale: hover ? HtmlJourneyTokens.avatarBadgeHoverScale : 1,
              duration: HtmlJourneyTokens.badgePop ~/ 2,
              curve: HtmlJourneyTokens.spring,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: roles.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(
                  dimension: HtmlJourneyTokens.avEdit,
                  child: Center(
                    child: AssetAppIcon(
                      AppIconId.edit,
                      size: HtmlJourneyTokens.cardRadius,
                      color: roles.onSurfaceEmphasis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
