import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:p2e_design_system/design_system.dart';

import '../domain/models.dart';
import 'account_setup.dart';
import 'auth_flow.dart';
import 'journey_support.dart';
import 'widgets/journey_layout.dart';

const _taken = {'ardeshir', 'ardeshir_r', 'admin', 'player', 'gamer', 'nova'};

enum _NameState { empty, invalid, short, checking, available, taken }

/// Choose a Username (HTML `screens.username`, D-140).
class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});
  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final name = TextEditingController();
  var status = _NameState.empty;
  var ideas = const <String>[];
  Timer? timer;
  var serial = 0;

  var primed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (primed) return;
    primed = true;
    final previous = currentJourney(context);
    if (previous != null && previous.username.isNotEmpty) {
      name.text = previous.username;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) changed(name.text);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    name.dispose();
    super.dispose();
  }

  static final _legal = RegExp(r'^[a-zA-Z0-9_]+$');

  /// HTML `ideaBase`: the first meaningful part of the email local part.
  String get _ideaBase {
    final email = currentJourney(context)?.email?.normalized;
    if (email == null || !email.contains('@')) return '';
    final parts = email.split('@').first.split(RegExp(r'[._]'));
    return parts.firstWhere((part) => part.length > 2, orElse: () => '');
  }

  void changed(String value) {
    timer?.cancel();
    final ticket = ++serial;
    if (value.isEmpty) {
      setState(() {
        status = _NameState.empty;
        ideas = const [];
      });
      final base = _ideaBase;
      if (base.isNotEmpty) _loadIdeas(base, ticket);
      return;
    }
    if (!_legal.hasMatch(value)) {
      setState(() {
        status = _NameState.invalid;
        ideas = const [];
      });
      return;
    }
    if (value.length < 3) {
      setState(() {
        status = _NameState.short;
        ideas = const [];
      });
      return;
    }
    setState(() {
      status = _NameState.checking;
      ideas = const [];
    });
    timer = Timer(HtmlJourneyTokens.unCheckMs, () async {
      final checked = await _lookup(value);
      if (!mounted || ticket != serial) return;
      setState(() {
        status = checked.available ? _NameState.available : _NameState.taken;
        ideas = checked.available ? const [] : checked.suggestions;
      });
    });
  }

  Future<void> _loadIdeas(String base, int ticket) async {
    var names = const <String>[];
    try {
      final result = await ProviderScope.containerOf(context)
          .read(accountSetupRepositoryProvider)
          .usernameIdeas(base);
      if (result is Success<List<String>>) names = result.value;
    } on StateError {
      names = ['${base}_r', '${base}_gg', '${base}_rash'];
    }
    if (!mounted || ticket != serial) return;
    setState(() => ideas = names);
  }

  Future<UsernameCheck> _lookup(String value) async {
    try {
      final result = await ProviderScope.containerOf(context)
          .read(accountSetupRepositoryProvider)
          .checkUsername(value);
      if (result is Success<UsernameCheck>) return result.value;
    } on StateError {
      // Hosts that have not composed the setup repository keep the local list.
    }
    final taken = _taken.contains(value.toLowerCase());
    return UsernameCheck(
      available: !taken,
      suggestions: taken
          ? ['${value}_r', '${value}_gg', '${value}_rash']
          : const [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final feedback = switch (status) {
      _NameState.invalid => FieldFeedback.error(strings.authUsernameInvalid),
      _NameState.short => FieldFeedback.error(strings.authUsernameShort),
      _ => const FieldFeedback.neutral(),
    };
    final badge = switch (status) {
      _NameState.checking => const UsernameStatusBadge(
        key: ValueKey('wait'),
        state: UsernameBadgeState.checking,
      ),
      _NameState.available => const UsernameStatusBadge(
        key: ValueKey('ok'),
        state: UsernameBadgeState.available,
      ),
      _NameState.taken => const UsernameStatusBadge(
        key: ValueKey('no'),
        state: UsernameBadgeState.taken,
      ),
      _ => null,
    };
    return JourneyStep(
      elementId: 'auth.username.page',
      title: strings.authUsernameTitle,
      body: strings.authUsernameBody,
      action: strings.authContinue,
      enabled: status == _NameState.available,
      onNext: () {
        final journey = currentJourney(context);
        final container = ProviderScope.containerOf(context);
        container
            .read(authFlowProvider.notifier)
            .accept(
              AccountJourney(
                AuthStep.createPassword,
                email: journey?.email,
                username: name.text.trim(),
                phoneRaw: journey?.phoneRaw ?? '',
                rememberDevice:
                    container.read(authFlowProvider)?.rememberDevice ?? false,
              ),
            );
        context.go(authStepPath(AuthStep.createPassword));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            elementId: 'auth.username.field',
            label: strings.authUsernameLabel,
            options: FieldInputOptions(
              controller: name,
              hint: strings.authUsernameHint,
              supportingText: strings.authUsernameRule,
              feedback: feedback,
              trailing: badge,
              autocorrect: false,
              enableSuggestions: false,
              inputFormatters: [LengthLimitingTextInputFormatter(16)],
              onChanged: changed,
            ),
          ),
          AnimatedSize(
            duration: HtmlJourneyTokens.badgePop,
            curve: HtmlJourneyTokens.ease,
            alignment: Alignment.topCenter,
            child: ideas.isEmpty
                ? const SizedBox(width: double.infinity)
                : UsernameIdeas(
                    key: ValueKey(ideas.join(',')),
                    names: ideas,
                    onPick: (idea) {
                      name.value = TextEditingValue(
                        text: idea,
                        selection: TextSelection.collapsed(offset: idea.length),
                      );
                      changed(idea);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// HTML `.ideas`: "Need ideas?" and up to three pill buttons.
class UsernameIdeas extends StatelessWidget {
  const UsernameIdeas({super.key, required this.names, required this.onPick});
  final List<String> names;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final label = AuthTextTokens.byName['English/Baseline/Label-Medium']!;
    final chip = AuthTextTokens.byName['English/Baseline/Button-Medium']!;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: HtmlJourneyTokens.unIdeasPadV,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          JourneyRise(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
              child: Text(
                strings.authUsernameIdeas,
                style: label.copyWith(color: roles.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(height: HtmlJourneyTokens.unIdeasGap),
          Row(
            children: [
              for (final (i, idea) in names.indexed) ...[
                if (i > 0) const SizedBox(width: HtmlJourneyTokens.unChipGap),
                Expanded(
                  child: JourneyRise(
                    delay: Duration(milliseconds: 50 * i),
                    child: _IdeaPill(
                      elementId: 'auth.username.idea$i',
                      text: idea,
                      style: chip.copyWith(
                        color: HtmlJourneyTokens.splashGradientMid,
                        fontSize: HtmlJourneyTokens.unChipText,
                        height:
                            HtmlJourneyTokens.unChipLine /
                            HtmlJourneyTokens.unChipText,
                        fontWeight: FontWeight.w600,
                      ),
                      onTap: () => onPick(idea),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _IdeaPill extends StatefulWidget {
  const _IdeaPill({
    required this.elementId,
    required this.text,
    required this.style,
    required this.onTap,
  });
  final String elementId, text;
  final TextStyle style;
  final VoidCallback onTap;

  @override
  State<_IdeaPill> createState() => _IdeaPillState();
}

class _IdeaPillState extends State<_IdeaPill> {
  var down = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.text,
      excludeSemantics: true,
      onTap: widget.onTap,
      child: GestureDetector(
        key: ValueKey(widget.elementId),
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => down = true),
        onTapUp: (_) => setState(() => down = false),
        onTapCancel: () => setState(() => down = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: down ? 0.95 : 1,
          duration: HtmlJourneyTokens.badgePop ~/ 2,
          curve: HtmlJourneyTokens.ease,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: HtmlJourneyTokens.splashGradientMid.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                HtmlJourneyTokens.unChipRadius,
              ),
            ),
            child: SizedBox(
              height: HtmlJourneyTokens.unChipH,
              child: Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
                  child: Text(
                    widget.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: widget.style,
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

enum UsernameBadgeState { checking, available, taken }

/// HTML `.status-badge`: spinner while checking, then a spring-in pill.
class UsernameStatusBadge extends StatefulWidget {
  const UsernameStatusBadge({super.key, required this.state});
  final UsernameBadgeState state;

  @override
  State<UsernameStatusBadge> createState() => _UsernameStatusBadgeState();
}

class _UsernameStatusBadgeState extends State<UsernameStatusBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController clock;

  bool get _checking => widget.state == UsernameBadgeState.checking;

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
    } else if (_checking) {
      if (!clock.isAnimating) clock.repeat();
    } else if (clock.value == 0 || clock.isAnimating) {
      clock.forward(from: 0);
    }
  }

  @override
  void dispose() {
    clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final roles = SkinTheme.of(context).valuesFor(Theme.of(context).brightness);
    final style = AuthTextTokens.byName['English/Baseline/Label-Small']!;
    if (_checking) {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: HtmlJourneyTokens.unBadgePadH,
          vertical: HtmlJourneyTokens.unBadgePadV,
        ),
        child: RotationTransition(
          turns: clock,
          child: AssetAppIcon(
            AppIconId.timer,
            size: HtmlJourneyTokens.unBadgeLine,
            color: roles.onSurfaceVariant,
          ),
        ),
      );
    }
    final ok = widget.state == UsernameBadgeState.available;
    final tone = ok ? HtmlJourneyTokens.success : HtmlJourneyTokens.jlRose;
    return AnimatedBuilder(
      animation: clock,
      builder: (context, child) => Transform.scale(
        scale: HtmlJourneyTokens.spring.transform(clock.value.clamp(0.0, 1.0)),
        child: child,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tone.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(HtmlJourneyTokens.unBadgeRadius),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: HtmlJourneyTokens.unBadgePadH,
            vertical: HtmlJourneyTokens.unBadgePadV,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AssetAppIcon(
                ok ? AppIconId.check : AppIconId.close,
                size: HtmlJourneyTokens.unBadgeLine,
                color: tone,
              ),
              Text(
                ok ? strings.authUsernameAvailable : strings.authUsernameTaken,
                maxLines: 1,
                style: style.copyWith(
                  color: tone,
                  fontSize: HtmlJourneyTokens.unBadgeText,
                  height:
                      HtmlJourneyTokens.unBadgeLine /
                      HtmlJourneyTokens.unBadgeText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
