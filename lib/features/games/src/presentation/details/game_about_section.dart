import 'package:flutter/material.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/formatting/dates.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../domain/game_details.dart';
import 'widgets/game_about_card.dart';

/// About This Game. Read More expands the copy in place (D-121).
class GameAboutSection extends StatefulWidget {
  const GameAboutSection({super.key, required this.name, required this.about});

  final String name;
  final GameAbout about;

  @override
  State<GameAboutSection> createState() => _GameAboutSectionState();
}

class _GameAboutSectionState extends State<GameAboutSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final style = GameDetailsText.body;
    return LayoutBuilder(
      builder: (context, constraints) {
        final textWidth =
            constraints.maxWidth - GameDetailsTokens.pagePadding * 4;
        final painter = TextPainter(
          text: TextSpan(text: widget.about.description, style: style),
          maxLines: GameDetailsEngineering.aboutCollapsedLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: textWidth);
        final overflows = painter.didExceedMaxLines;
        painter.dispose();
        final platforms = widget.about.platforms;
        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: GameDetailsTokens.pagePadding,
          ),
          child: Column(
            children: [
              AppSectionHeader(
                elementId: 'game.details.about.header',
                lead: strings.gameAboutLead,
                subject: widget.name,
                actionLabel: overflows
                    ? (_expanded ? strings.gameReadLess : strings.gameReadMore)
                    : null,
                actionChevron: false,
                onAction: overflows
                    ? () => setState(() => _expanded = !_expanded)
                    : null,
              ),
              const SizedBox(height: GameDetailsTokens.cardGap),
              GameAboutCard(
                elementId: 'game.details.about.copy',
                description: widget.about.description,
                maxLines: _expanded
                    ? null
                    : GameDetailsEngineering.aboutCollapsedLines,
              ),
              const SizedBox(height: GameDetailsTokens.cardGap),
              Row(
                children: [
                  Expanded(
                    child: GameFactCard(
                      elementId: 'game.details.about.updated',
                      label: strings.gameUpdatedOn,
                      value: formatMediumDate(
                        widget.about.updatedOn,
                        languageCode: language,
                      ),
                    ),
                  ),
                  if (platforms.isNotEmpty) ...[
                    const SizedBox(width: GameDetailsTokens.factGap),
                    Expanded(
                      child: GameFactCard(
                        elementId: 'game.details.about.platforms',
                        label: strings.gameAvailableOn,
                        value: platforms
                            .map(
                              (platform) => switch (platform) {
                                GamePlatform.android =>
                                  strings.gamePlatformAndroid,
                                GamePlatform.ios => strings.gamePlatformIos,
                              },
                            )
                            .join(', '),
                        platform: platforms.contains(GamePlatform.android)
                            ? GameFactPlatform.android
                            : null,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
