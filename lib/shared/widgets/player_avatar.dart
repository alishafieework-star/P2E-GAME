import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p2e_design_system/design_system.dart';

/// Shared player picture. Sizes follow the HTML avatar scale (D-140).
enum PlayerAvatarSize {
  compact(
    HtmlJourneyTokens.avatarExtentCompact,
    HtmlJourneyTokens.avatarLetterCompact,
  ),
  small(
    HtmlJourneyTokens.avatarExtentSmall,
    HtmlJourneyTokens.avatarLetterSmall,
  ),
  medium(
    HtmlJourneyTokens.avatarExtentMedium,
    HtmlJourneyTokens.avatarLetterMedium,
  ),
  large(
    HtmlJourneyTokens.avatarExtentLarge,
    HtmlJourneyTokens.avatarLetterLarge,
  ),
  hero(HtmlJourneyTokens.avatarExtentHero, HtmlJourneyTokens.avatarLetterHero);

  const PlayerAvatarSize(this.extent, this.letterSize);
  final double extent;
  final double letterSize;
}

const playerAvatarNames = [
  'bolt',
  'mossy',
  'byte',
  'ember',
  'boo',
  'pip',
  'rook',
  'fizz',
  'grim',
  'nova',
  'chomp',
  'glitch',
];

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    super.key,
    required this.letter,
    required this.theme,
    this.character,
    this.size = PlayerAvatarSize.medium,
  });

  final String letter;
  final int theme;

  /// Null shows the letter. Otherwise an index into [playerAvatarNames].
  final int? character;
  final PlayerAvatarSize size;

  @override
  Widget build(BuildContext context) {
    final themes = HtmlJourneyTokens.avatarThemes;
    final paint = themes[theme.clamp(0, themes.length - 1)];
    final initial = letter.trim().isEmpty
        ? 'A'
        : letter.trim().substring(0, 1).toUpperCase();
    final index = character;
    return SizedBox.square(
      dimension: size.extent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: paint.container,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: index == null
              ? Center(
                  child: Text(
                    initial,
                    style: AuthTextTokens
                        .byName['English/Baseline/Headline-Small']!
                        .copyWith(
                          color: paint.onContainer,
                          fontSize: size.letterSize,
                          height: 1,
                          letterSpacing: 0,
                        ),
                  ),
                )
              : SvgPicture.asset(
                  'assets/images/avatars/${playerAvatarNames[index.clamp(0, playerAvatarNames.length - 1)]}.svg',
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                ),
        ),
      ),
    );
  }
}
