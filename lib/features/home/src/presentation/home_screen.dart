import 'package:flutter/material.dart';
import 'package:mygame_p2e/features/games/games.dart';
import 'package:mygame_p2e/features/missions/missions.dart';
import 'package:p2e_design_system/design_system.dart';

import 'package:mygame_p2e/shared/widgets/scroll_debug_log.dart';

import 'home_app_bar.dart';

/// Home composes feature sections in the Figma Home order (OD-9). It owns no
/// game or quest state. The App Bar scrolls with the content over the hero.
/// D-104: a status-bar scrim appears once content scrolls under the clock, the
/// hero parallax follows the scroll, and Medium/Expanded center a 600 column.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  var _scrollEvents = 0;
  int? _lastScrollMicros;

  @override
  void initState() {
    super.initState();
    installScrollFrameLog();
    // #region agent log
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final view = View.of(context);
      scrollDebugLog(
        'F',
        'home_screen.dart:view',
        'vignette omitted for test',
        {
          'omitVignette': scrollDebugOmitVignette,
          'dpr': view.devicePixelRatio.toStringAsFixed(2),
          'physicalWidth': view.physicalSize.width.toStringAsFixed(0),
          'physicalHeight': view.physicalSize.height.toStringAsFixed(0),
        },
      );
    });
    // #endregion
    _scroll.addListener(_logScroll);
  }

  void _logScroll() {
    // #region agent log
    _scrollEvents++;
    if (_scrollEvents % 20 != 0) return;
    final now = DateTime.now().microsecondsSinceEpoch;
    final gapMs = _lastScrollMicros == null
        ? 0
        : (now - _lastScrollMicros!) / 1000;
    _lastScrollMicros = now;
    scrollDebugLog('E', 'home_screen.dart:scroll', 'home scroll sample', {
      'offset': _scroll.hasClients ? _scroll.offset.toStringAsFixed(1) : 'none',
      'events': _scrollEvents,
      'gapMs': gapMs.toStringAsFixed(1),
    });
    // #endregion
  }

  @override
  void dispose() {
    _scroll.removeListener(_logScroll);
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // #region agent log
    final _buildWatch = Stopwatch()..start();
    // #endregion
    final top = MediaQuery.paddingOf(context).top;
    final spec = AppBarSpec.lookup(
      AppBarCategory.home,
      Theme.of(context).brightness,
    );
    assert(spec != null, 'Missing Home app-bar spec');
    final chrome = spec?.contentHeight ?? 0.0;
    final surface = SkinTheme.of(context)
        .valuesFor(Theme.of(context).brightness)
        .color('Surface/Base');
    final page = Stack(
      children: [
        CustomScrollView(
          key: const ValueKey('home.page'),
          controller: _scroll,
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  FeaturedGameHero(overlap: top + chrome, scroll: _scroll),
                  PositionedDirectional(
                    top: top,
                    start: 0,
                    end: 0,
                    child: const HomeAppBarContent(),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: GameShelfSection(kind: GameShelfKind.recommended),
            ),
            const SliverToBoxAdapter(
              child: GameShelfSection(kind: GameShelfKind.multiplayer),
            ),
            const SliverToBoxAdapter(
              child: GameShelfSection(kind: GameShelfKind.competition),
            ),
            SliverToBoxAdapter(child: QuestHomeSection()),
          ],
        ),
        if (top > 0)
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: _StatusBarScrim(
              controller: _scroll,
              height: top,
              color: surface,
            ),
          ),
      ],
    );
    // #region agent log
    final buildMs = _buildWatch.elapsedMilliseconds;
    if (buildMs >= 30) {
      scrollDebugLog('G', 'home_screen.dart:build', 'home build', {
        'ms': buildMs,
      });
    }
    // #endregion
    if (SizeClass.of(context) == SizeClass.compact) return page;
    return ColoredBox(
      color: surface,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(width: AdaptiveTokens.contentMaxWidth, child: page),
      ),
    );
  }
}

/// Status-bar scrim once content scrolls under the clock (D-104).
/// Rebuilds only when the offset crosses zero (D-129).
class _StatusBarScrim extends StatefulWidget {
  const _StatusBarScrim({
    required this.controller,
    required this.height,
    required this.color,
  });

  final ScrollController controller;
  final double height;
  final Color color;

  @override
  State<_StatusBarScrim> createState() => _StatusBarScrimState();
}

class _StatusBarScrimState extends State<_StatusBarScrim> {
  var _shown = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_sync);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void didUpdateWidget(_StatusBarScrim oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;
    oldWidget.controller.removeListener(_sync);
    widget.controller.addListener(_sync);
    _sync();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_sync);
    super.dispose();
  }

  void _sync() {
    if (!mounted) return;
    final shown = widget.controller.hasClients && widget.controller.offset > 0;
    if (shown == _shown) return;
    setState(() => _shown = shown);
  }

  @override
  Widget build(BuildContext context) {
    if (!_shown) return const SizedBox.shrink();
    return IgnorePointer(
      child: ColoredBox(
        key: const ValueKey('home.status-scrim'),
        color: widget.color,
        child: SizedBox(height: widget.height, width: double.infinity),
      ),
    );
  }
}
