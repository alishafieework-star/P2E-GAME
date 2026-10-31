import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:p2e_design_system/design_system.dart';

/// Honest destination for reviews and studio lists that have no design yet.
class GameRoutePlaceholder extends StatelessWidget {
  const GameRoutePlaceholder({
    super.key,
    required this.elementId,
    required this.title,
  });

  final String elementId, title;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PageScaffold(
      elementId: elementId,
      child: Column(
        children: [
          Text(strings.shellComingSoon(title)),
          AppButton(
            elementId: '$elementId.back',
            label: strings.shellBack,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
