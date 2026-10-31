import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../features/missions/missions.dart';
import '../../features/tour/tour.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/formatting/numbers.dart';
import '../../shared/tour/tour_target.dart';

/// Product tabs in Navigator source order (technical IDs from the Navigator
/// reference). The Navigator stays at every size class (D-102).
const appTabIds = ['home', 'mission', 'games', 'leaderboard', 'shop'];

/// Five-tab shell. The Shop badge waits for the shop feature.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final missions = ref.watch(missionBadgeCountProvider);
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          body: shell,
          bottomNavigationBar: TourTarget(
            id: 'navigator',
            child: AppNavigationBarHost(
              bar: AppNavigationBar(
                elementId: 'shell.navigation',
                destinations: [
                  AppNavigationDestination(
                    id: appTabIds[0],
                    label: strings.navHome,
                    icon: AppIconId.home,
                  ),
                  AppNavigationDestination(
                    id: appTabIds[1],
                    label: strings.navMission,
                    icon: AppIconId.targetCheck,
                    badge: missions == null
                        ? null
                        : AppNavigationBadge(
                            label: formatCount(
                              missions,
                              languageCode: language,
                            ),
                            semanticLabel: strings.navBadge(
                              strings.navMission,
                              formatCount(missions, languageCode: language),
                            ),
                          ),
                  ),
                  AppNavigationDestination(
                    id: appTabIds[2],
                    label: strings.navGames,
                    icon: AppIconId.stadiaController,
                  ),
                  AppNavigationDestination(
                    id: appTabIds[3],
                    label: strings.navLeaderboard,
                    icon: AppIconId.leaderboard,
                  ),
                  AppNavigationDestination(
                    id: appTabIds[4],
                    label: strings.navShop,
                    icon: AppIconId.store,
                  ),
                ],
                selectedDestinationId: appTabIds[shell.currentIndex],
                onDestinationSelected: (id) {
                  final index = appTabIds.indexOf(id);
                  shell.goBranch(
                    index,
                    initialLocation: index == shell.currentIndex,
                  );
                },
              ),
            ),
          ),
        ),
        const HomeTour(),
      ],
    );
  }
}
