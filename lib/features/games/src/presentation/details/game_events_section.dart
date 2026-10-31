import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:mygame_p2e/shared/navigation/app_locations.dart';
import 'package:mygame_p2e/shared/platform/external_links.dart';
import 'package:mygame_p2e/shared/widgets/collection_section.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../../../missions/missions.dart';
import '../../domain/game_details.dart';
import '../game_labels.dart';
import 'widgets/event_offer_card.dart';

/// Events from the game payload, with this game's quests first (D-124).
class GameEventsSection extends ConsumerStatefulWidget {
  const GameEventsSection({
    super.key,
    required this.gameId,
    required this.events,
  });

  final String gameId;
  final List<GameEvent> events;

  @override
  ConsumerState<GameEventsSection> createState() => _GameEventsSectionState();
}

class _GameEventsSectionState extends ConsumerState<GameEventsSection> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final quests = ref.watch(gameQuestsProvider(widget.gameId));
    final count = quests.length + widget.events.length;
    if (count == 0) return const SizedBox.shrink();
    final page = _page.clamp(0, count - 1);
    return CollectionSection(
      elementId: 'game.details.events',
      header: AppSectionHeader(
        elementId: 'game.details.events.header',
        title: strings.gameEvents,
      ),
      content: AppShelf(
        elementId: 'game.details.events.shelf',
        layout: AppShelfLayout.paged,
        spacing: AppShelfSpacing.relaxed,
        pageIndex: page,
        onPageChanged: (value) => setState(() => _page = value),
        children: [
          for (final quest in quests)
            EventOfferCard(
              elementId: 'game.details.events.quest:${quest.id}',
              image: artwork(quest.game.banner ?? quest.game.icon),
              title: quest.game.offerTitle ?? quest.game.name,
              description: quest.game.offerSummary ?? quest.game.name,
              rewardAmount: formatGain(
                quest.possiblePoints,
                languageCode: language,
              ),
              rewardUnit: strings.homePointsUnit,
              semanticLabel: quest.game.offerTitle ?? quest.game.name,
              onPressed: () => context.push(AppLocations.quest(quest.id)),
            ),
          for (final event in widget.events)
            EventOfferCard(
              elementId: 'game.details.events.event:${event.id}',
              image: artwork(event.banner.url),
              title: event.title,
              description: event.description,
              rewardAmount: formatGain(
                event.rewardPoints,
                languageCode: language,
              ),
              rewardUnit: strings.homePointsUnit,
              semanticLabel: event.title,
              onPressed: event.url == null
                  ? null
                  : () =>
                        ref.read(externalLinkPortProvider).openUri(event.url!),
            ),
        ],
      ),
      footer: count > 1
          ? AppPageIndicator(
              elementId: 'game.details.events.pages',
              count: count,
              index: page,
              semanticLabel: strings.homePageLabel(
                formatCount(page + 1, languageCode: language),
                formatCount(count, languageCode: language),
              ),
            )
          : null,
    );
  }
}
