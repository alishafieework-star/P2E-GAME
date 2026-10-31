import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/tour/tour_target.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:mygame_p2e/shared/navigation/app_locations.dart';
import 'package:mygame_p2e/shared/widgets/collection_section.dart';
import 'package:mygame_p2e/shared/widgets/section_error.dart';
import 'package:p2e_design_system/design_system.dart';

import '../domain/models.dart';
import 'game_labels.dart';
import 'providers.dart';

import 'package:mygame_p2e/shared/widgets/scroll_debug_log.dart';

import 'widgets/game_compact_card.dart';
import 'widgets/game_expand_card.dart';

/// A Home game section. Multiplayer is a paged shelf of expand cards; the
/// others scroll compact Detailed cards. View More opens the Games tab.
class GameShelfSection extends ConsumerStatefulWidget {
  const GameShelfSection({super.key, required this.kind});
  final GameShelfKind kind;

  @override
  ConsumerState<GameShelfSection> createState() => _GameShelfSectionState();
}

final _loggedShelves = <String>{};

class _GameShelfSectionState extends ConsumerState<GameShelfSection> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    // #region agent log
    final shelfWatch = Stopwatch()..start();
    // #endregion
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final feed = ref.watch(homeGamesFeedProvider);
    final id = 'home.${widget.kind.name}';
    final header = AppSectionHeader(
      elementId: '$id.header',
      title: switch (widget.kind) {
        GameShelfKind.recommended => strings.homeSectionRecommended,
        GameShelfKind.multiplayer => strings.homeSectionMultiplayer,
        GameShelfKind.competition => strings.homeSectionCompetition,
      },
      actionLabel: strings.homeViewMore,
      onAction: () => context.go(AppLocations.games),
    );
    final shelf = feed.value?.shelf(widget.kind);
    if (shelf == null || shelf.games.isEmpty) {
      if (!feed.hasError) return const SizedBox.shrink();
      return CollectionSection(
        elementId: id,
        header: header,
        content: SectionError(
          elementId: '$id.error',
          message: strings.homeSectionError,
          retryLabel: strings.homeRetry,
          retrying: feed.isLoading,
          onRetry: () => ref.invalidate(homeGamesFeedProvider),
        ),
      );
    }
    final paged = widget.kind == GameShelfKind.multiplayer;
    final unit = strings.homePointsUnit;
    final games = shelf.games;
    // #region agent log
    if (_loggedShelves.add(widget.kind.name)) {
      scrollDebugLog('B', 'game_shelf_section.dart:build', 'shelf built', {
        'kind': widget.kind.name,
        'children': games.length,
        'paged': paged,
      });
    }
    // #endregion
    final page = _page.clamp(0, games.length - 1);
    void open(GameSummary game) => context.push(
      AppLocations.gameFrom(GoRouterState.of(context).uri.path, game.id),
    );
    // #region agent log
    final shelfMs = shelfWatch.elapsedMilliseconds;
    if (shelfMs >= 15) {
      scrollDebugLog('G', 'game_shelf_section.dart:build', 'shelf build time', {
        'kind': widget.kind.name,
        'ms': shelfMs,
        'children': games.length,
      });
    }
    // #endregion
    return CollectionSection(
      elementId: id,
      header: header,
      content: AppShelf(
        elementId: '$id.shelf',
        layout: paged ? AppShelfLayout.paged : AppShelfLayout.scroll,
        pageIndex: page,
        onPageChanged: (value) => setState(() => _page = value),
        children: [
          for (final (index, game) in games.indexed)
            _tourSlot(
              widget.kind,
              index,
              paged
                  ? GameExpandCard(
                      elementId: '$id.game:${game.id}',
                      banner: artwork(game.banner ?? game.cover),
                      icon: artwork(game.icon ?? game.cover),
                      name: game.name,
                      creator: game.creator,
                      showMark: game.registeredMark,
                      actionLabel: strings.homePlayNow,
                      caption: game.access.label(strings),
                      rewardAmount: formatGain(
                        game.rewardPoints,
                        languageCode: language,
                      ),
                      rewardUnit: unit,
                      semanticLabel: strings.homeGameCard(
                        game.name,
                        game.creator,
                      ),
                      onPressed: () => open(game),
                      onAction: () => open(game),
                    )
                  : GameCompactCard(
                      elementId: '$id.game:${game.id}',
                      appearance: GameCompactCardAppearance.detailed,
                      image: artwork(game.cover),
                      name: game.name,
                      creator: game.creator,
                      showMark: game.registeredMark,
                      rating: formatRating(game.rating, languageCode: language),
                      ratingLabel: strings.homeRating(
                        formatRating(game.rating, languageCode: language),
                      ),
                      rewardAmount: formatGain(
                        game.rewardPoints,
                        languageCode: language,
                      ),
                      rewardUnit: unit,
                      onPressed: () => open(game),
                    ),
            ),
        ],
      ),
      footer: paged && games.length > 1
          ? AppPageIndicator(
              elementId: '$id.pages',
              count: games.length,
              index: page,
              semanticLabel: strings.homePageLabel(
                formatCount(page + 1, languageCode: language),
                formatCount(games.length, languageCode: language),
              ),
            )
          : null,
    );
  }
}

/// The first Recommended card is the tour's "points" slot (D-146). The slot is
/// a layout position, so a different game in it does not move the spotlight.
Widget _tourSlot(GameShelfKind kind, int index, Widget card) =>
    kind == GameShelfKind.recommended && index == 0
    ? TourTarget(id: 'score', child: card)
    : card;
