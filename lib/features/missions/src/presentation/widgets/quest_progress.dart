import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mygame_p2e/shared/widgets/reward_badge.dart';
import 'package:p2e_design_system/design_system.dart';

/// One quest step reward, display-ready (`+250` once earned, `1,000` before).
@immutable
class QuestStepReward {
  const QuestStepReward({required this.amount, required this.unit});
  final String amount, unit;
}

/// Feature-internal stepped progress from the quest card `18457:13272`.
/// Markers: start (crown), one per step (verified when done, waiting badge
/// otherwise) and the final step (trophy). Each theme keeps its own marker
/// colors (E-105). Rewards sit above step markers; the last one aligns to the
/// end so it stays inside the track.
class QuestProgress extends StatelessWidget {
  const QuestProgress({
    super.key,
    required this.elementId,
    required this.rewards,
    required this.completed,
    required this.started,
    required this.semanticLabel,
  }) : assert(rewards.length > 0),
       assert(completed >= 0 && completed <= rewards.length),
       assert(completed == 0 || started);

  final String elementId;
  final List<QuestStepReward> rewards;
  final int completed;
  final bool started;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final steps = rewards.length;
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const marker = HomeTokens.progressMarker;
          final free = math.max(
            0.0,
            constraints.maxWidth - (steps + 1) * marker,
          );
          // Source segments are fixed except the last, which fills. Narrow
          // hosts or many steps share the width instead of overflowing.
          final fixed =
              free - (steps - 1) * HomeTokens.progressSegment >=
              HomeTokens.progressSegment;
          final segments = [
            for (var i = 0; i < steps; i++)
              !fixed
                  ? free / steps
                  : i < steps - 1
                  ? HomeTokens.progressSegment
                  : free - (steps - 1) * HomeTokens.progressSegment,
          ];
          // Distance from the start edge to the end of each step marker.
          final markerEnds = [
            for (var i = 0, end = marker; i < steps; i++)
              end += segments[i] + marker,
          ];
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Each reward is centered on its marker; the last one ends with
              // its marker. The tallest reward sets the row height.
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  const SizedBox(width: double.infinity),
                  for (var i = 0; i < steps; i++)
                    SizedBox(
                      width: i == steps - 1
                          ? markerEnds[i]
                          : (markerEnds[i] - marker / 2) * 2,
                      child: Align(
                        heightFactor: 1,
                        alignment: i == steps - 1
                            ? AlignmentDirectional.bottomEnd
                            : AlignmentDirectional.bottomCenter,
                        child: RewardBadge(
                          elementId: '$elementId.reward:$i',
                          appearance: RewardBadgeAppearance.step,
                          emphasis: i < completed
                              ? RewardBadgeEmphasis.active
                              : RewardBadgeEmphasis.upcoming,
                          amount: rewards[i].amount,
                          unit: rewards[i].unit,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: HomeTokens.progressRewardGap),
              Row(
                children: [
                  _Marker(
                    icon: AppIconId.crown,
                    done: started,
                    idleIcon: HomePaints.progressStartIdleIcon,
                  ),
                  for (var i = 0; i < steps; i++) ...[
                    SizedBox(
                      width: segments[i],
                      height: HomeTokens.progressTrackHeight,
                      child: ColoredBox(
                        color:
                            (i < completed
                                    ? HomePaints.progressSegmentDone
                                    : HomePaints.progressSegmentPending)
                                .resolve(context),
                      ),
                    ),
                    _Marker(
                      icon: i == steps - 1
                          ? AppIconId.trophy
                          : i < completed
                          ? AppIconId.verified
                          : AppIconId.workspacePremium_2,
                      done: i < completed,
                      idleIcon: HomePaints.progressWaitingIcon,
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker({
    required this.icon,
    required this.done,
    required this.idleIcon,
  });
  final AppIconId icon;
  final bool done;
  final ThemedPaint idleIcon;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color:
          (done ? HomePaints.progressMarkerDone : HomePaints.progressMarkerIdle)
              .resolve(context),
      borderRadius: const BorderRadiusDirectional.all(
        Radius.circular(HomeTokens.progressMarkerRadius),
      ),
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.all(
        HomeTokens.progressMarkerPadding,
      ),
      child: AssetAppIcon(
        icon,
        style: AppIconStyle.fill,
        size: HomeTokens.progressIcon,
        color: (done ? HomePaints.progressDoneIcon : idleIcon).resolve(context),
      ),
    ),
  );
}
