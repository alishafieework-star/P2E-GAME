import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/tour/tour_target.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mygame_p2e/core/time/clock.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:mygame_p2e/shared/navigation/app_locations.dart';
import 'package:mygame_p2e/shared/widgets/collection_section.dart';
import 'package:mygame_p2e/shared/widgets/section_error.dart';
import 'package:p2e_design_system/design_system.dart';

import '../domain/models.dart';
import 'providers.dart';
import 'widgets/quest_card.dart';

/// Home Mission and Quest section `18457:13153`: a paged shelf of quest cards
/// with a live countdown. View All Missions opens the Mission tab.
class QuestHomeSection extends ConsumerStatefulWidget {
  const QuestHomeSection({super.key});

  @override
  ConsumerState<QuestHomeSection> createState() => _QuestHomeSectionState();
}

class _QuestHomeSectionState extends ConsumerState<QuestHomeSection> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final board = ref.watch(questBoardProvider);
    const id = 'home.quests';
    final header = AppSectionHeader(
      elementId: '$id.header',
      title: strings.homeSectionQuests,
      actionLabel: strings.homeViewAllMissions,
      onAction: () => context.go(AppLocations.missions),
    );
    final quests = board.value?.quests;
    if (quests == null || quests.isEmpty) {
      if (!board.hasError) return const SizedBox.shrink();
      return CollectionSection(
        elementId: id,
        header: header,
        content: SectionError(
          elementId: '$id.error',
          message: strings.homeSectionError,
          retryLabel: strings.homeRetry,
          retrying: board.isLoading,
          onRetry: () => ref.invalidate(questBoardProvider),
        ),
      );
    }
    final page = _page.clamp(0, quests.length - 1);
    String count(int value) => formatCount(value, languageCode: language);
    return CollectionSection(
      elementId: id,
      header: header,
      content: AppShelf(
        elementId: '$id.shelf',
        layout: AppShelfLayout.paged,
        spacing: AppShelfSpacing.relaxed,
        pageIndex: page,
        onPageChanged: (value) => setState(() => _page = value),
        children: [
          for (final (index, quest) in quests.indexed)
            _tourSlot(
              index,
              _QuestEntry(
                elementId: '$id.quest:${quest.id}',
                quest: quest,
                strings: strings,
                language: language,
              ),
            ),
        ],
      ),
      footer: quests.length > 1
          ? AppPageIndicator(
              elementId: '$id.pages',
              count: quests.length,
              index: page,
              semanticLabel: strings.homePageLabel(
                count(page + 1),
                count(quests.length),
              ),
            )
          : null,
    );
  }
}

class _QuestEntry extends ConsumerWidget {
  const _QuestEntry({
    required this.elementId,
    required this.quest,
    required this.strings,
    required this.language,
  });

  final String elementId, language;
  final Quest quest;
  final AppLocalizations strings;

  String _count(int value) => formatCount(value, languageCode: language);
  String _two(int value) => formatTwoDigits(value, languageCode: language);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Each card owns its second tick, so the section shell, header and page
    // indicator stay still between ticks.
    final now =
        ref.watch(secondTickerProvider).value ?? ref.read(clockProvider).now();
    final unit = strings.homePointsUnit;
    final done = quest.completedSteps, total = quest.steps.length;
    final left = quest.deadline.difference(now);
    final remaining = left.isNegative ? Duration.zero : left;
    final days = remaining.inDays,
        hours = remaining.inHours % 24,
        minutes = remaining.inMinutes % 60,
        seconds = remaining.inSeconds % 60;
    return QuestCard(
      elementId: elementId,
      icon: NetworkImage(quest.game.icon.toString()),
      gameName: quest.game.name,
      creator: quest.game.creator,
      showMark: quest.game.registeredMark,
      actionLabel: quest.started
          ? strings.homeQuestContinue
          : strings.homeQuestStart,
      caption: switch (quest.game.access) {
        QuestGameAccess.freeToPlay => strings.homeFreeToPlay,
        QuestGameAccess.inAppPurchases => strings.homeInAppPurchases,
      },
      onAction: () => context.push(AppLocations.quest(quest.id)),
      rewards: [
        for (final step in quest.steps)
          QuestStepReward(
            amount: step.completed
                ? formatGain(step.rewardPoints, languageCode: language)
                : _count(step.rewardPoints),
            unit: unit,
          ),
      ],
      completed: done,
      started: quest.started,
      progressLabel: strings.homeQuestProgress(_count(done), _count(total)),
      status: quest.started
          ? _status(strings, _count(done), _count(total))
          : [QuestStatusPart(strings.homeQuestNotStarted)],
      total: QuestTotal(
        earned: _count(quest.earnedPoints),
        possible: _count(quest.possiblePoints),
        unit: unit,
      ),
      countdown: [
        CountdownUnit(digits: _two(days), label: strings.homeCountdownDay),
        CountdownUnit(digits: _two(hours), label: strings.homeCountdownHour),
        CountdownUnit(
          digits: _two(minutes),
          label: strings.homeCountdownMinute,
        ),
        CountdownUnit(
          digits: _two(seconds),
          label: strings.homeCountdownSecond,
        ),
      ],
      countdownLabel: strings.homeCountdownLabel(days, hours, minutes, seconds),
    );
  }
}

const _doneMark = '\u0001', _totalMark = '\u0002';

/// Splits the localized status around its marker characters; compiled once.
final _statusSplit = RegExp(
  '[$_doneMark$_totalMark]|[^$_doneMark$_totalMark]+',
);

/// Splits the localized status around its numbers, which use the number
/// style. Word order follows the translation.
List<QuestStatusPart> _status(
  AppLocalizations strings,
  String done,
  String total,
) {
  final message = strings.homeQuestCompleted(_doneMark, _totalMark);
  return [
    for (final match in _statusSplit.allMatches(message))
      if (match[0] == _doneMark)
        QuestStatusPart(done, numeric: true)
      else if (match[0] == _totalMark)
        QuestStatusPart(total, numeric: true)
      else if (match[0]!.trim().isNotEmpty)
        QuestStatusPart(match[0]!.trim()),
  ];
}

/// The first quest card is the tour's missions slot (D-146).
Widget _tourSlot(int index, Widget card) =>
    index == 0 ? TourTarget(id: 'quests', child: card) : card;
