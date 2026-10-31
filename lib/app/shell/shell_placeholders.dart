import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../l10n/generated/app_localizations.dart';

/// Honest placeholder for a tab whose feature has not landed (D-102).
class TabPlaceholder extends StatelessWidget {
  const TabPlaceholder({super.key, required this.tab});
  final String tab;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final name = switch (tab) {
      'mission' => strings.navMission,
      'games' => strings.navGames,
      'leaderboard' => strings.navLeaderboard,
      _ => strings.navShop,
    };
    return PageScaffold(
      elementId: 'shell.$tab.page',
      child: Text(strings.shellComingSoon(name)),
    );
  }
}

enum DetailKind { game, quest }

/// Honest placeholder for a detail page opened from Home (D-102).
class DetailPlaceholder extends StatelessWidget {
  const DetailPlaceholder({super.key, required this.kind});
  final DetailKind kind;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final title = switch (kind) {
      DetailKind.game => strings.shellGameDetails,
      DetailKind.quest => strings.shellQuestDetails,
    };
    return PageScaffold(
      elementId: 'shell.${kind.name}.page',
      child: Column(
        children: [
          Text(strings.shellComingSoon(title)),
          AppButton(
            elementId: 'shell.${kind.name}.back',
            label: strings.shellBack,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
