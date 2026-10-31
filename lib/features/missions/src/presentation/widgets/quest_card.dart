import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/widgets/game_info_row.dart';
import 'package:mygame_p2e/shared/widgets/reward_badge.dart';
import 'package:p2e_design_system/design_system.dart';

import 'countdown.dart';
import 'quest_progress.dart';

export 'countdown.dart' show CountdownUnit;
export 'quest_progress.dart' show QuestStepReward;

/// One piece of the localized quest status. Numbers use the number style.
@immutable
class QuestStatusPart {
  const QuestStatusPart(this.text, {this.numeric = false}) : assert(text != '');
  final String text;
  final bool numeric;
}

/// Display-ready total reward: earned of possible, with one unit.
@immutable
class QuestTotal {
  const QuestTotal({
    required this.earned,
    required this.possible,
    required this.unit,
  });
  final String earned, possible, unit;
}

/// Presentational Mission and Quest card `18457:13272`. Every string arrives
/// display-ready; the caller owns formatting, time and navigation.
class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.elementId,
    required this.icon,
    required this.gameName,
    required this.creator,
    required this.actionLabel,
    required this.rewards,
    required this.completed,
    required this.started,
    required this.progressLabel,
    required this.status,
    required this.total,
    required this.countdown,
    required this.countdownLabel,
    this.caption,
    this.showMark = true,
    this.onAction,
    this.runtimeLocator,
  }) : assert(status.length > 0);

  final String elementId, gameName, creator, actionLabel;
  final ImageProvider icon;
  final List<QuestStepReward> rewards;
  final int completed;
  final bool started;
  final String progressLabel, countdownLabel;
  final List<QuestStatusPart> status;
  final QuestTotal total;
  final List<CountdownUnit> countdown;
  final String? caption;
  final bool showMark;
  final VoidCallback? onAction;
  final UiRuntimeLocator? runtimeLocator;

  static const _radius = BorderRadiusDirectional.all(
    Radius.circular(HomeTokens.questRadius),
  );

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = HomeRoles.questStatus.resolve(context);
    return ElementIdentity(
      elementId: elementId,
      runtimeLocator: UiIdentityScope.resolve(
        context,
        override: runtimeLocator,
      ),
      componentId: 'quest.card',
      structureRef: 'quest.card',
      fileKey: '7PGTHT5CQzbTsWZQnPIQce',
      variantId: dark ? '18457:13272' : '18457:15685',
      componentSetId: null,
      rawSetName: 'Game Card',
      rawVariantName: started ? 'started' : 'not-started',
      variants: {'started': started.toString()},
      resolved: const {},
      declared: {'steps': rewards.length, 'completed': completed},
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: HomeStrokes.quest.resolve(context),
          borderRadius: _radius,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: HomeRoles.questSurface.resolve(context),
            borderRadius: _radius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameInfoRow(
                elementId: '$elementId.info',
                layout: GameInfoLayout.quest,
                icon: icon,
                name: gameName,
                creator: creator,
                actionLabel: actionLabel,
                caption: caption,
                showMark: showMark,
                onAction: onAction,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: HomeTokens.questBodyPadHorizontal,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadiusDirectional.all(
                    Radius.circular(HomeTokens.questPanelRadius),
                  ),
                  child: ColoredBox(
                    color: HomeRoles.questPanel.resolve(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomPaint(
                          foregroundPainter: _BottomRule(
                            HomeRoles.questDivider.resolve(context),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              HomeTokens.questTrackPadHorizontal,
                              HomeTokens.questTrackInsetTop,
                              HomeTokens.questTrackPadHorizontal,
                              HomeTokens.questTrackInsetBottom,
                            ),
                            child: QuestProgress(
                              elementId: '$elementId.progress',
                              rewards: rewards,
                              completed: completed,
                              started: started,
                              semanticLabel: progressLabel,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.all(
                            HomeTokens.questDetailsPadding,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: HomeTokens.questStatusGap,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    for (final part in status)
                                      Text(
                                        part.text,
                                        style:
                                            (part.numeric
                                                    ? HomeText.questStatusNumber
                                                    : HomeText.questStatus)
                                                .copyWith(color: statusColor),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: HomeTokens.questDetailsGap),
                              RewardBadge(
                                elementId: '$elementId.total',
                                appearance: RewardBadgeAppearance.total,
                                amount: total.earned,
                                secondaryAmount: total.possible,
                                unit: total.unit,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.all(
                  HomeTokens.questFooterPadding,
                ),
                child: Countdown(
                  units: countdown,
                  semanticLabel: countdownLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Source divider: a centered stroke on the bottom edge of the track area.
class _BottomRule extends CustomPainter {
  _BottomRule(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      Paint()
        ..color = color
        ..strokeWidth = HomeTokens.questDividerWidth,
    );
  }

  @override
  bool shouldRepaint(_BottomRule oldDelegate) => oldDelegate.color != color;
}
