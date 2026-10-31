import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/balance/balance.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:mygame_p2e/shared/profile/profile.dart';
import 'package:mygame_p2e/shared/widgets/player_avatar.dart';
import 'package:p2e_design_system/design_system.dart';

/// Home App Bar content over the hero. Profile, help and add-coins accept a
/// press and do not open a page (D-133).
class HomeAppBarContent extends ConsumerWidget {
  const HomeAppBarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final balance = ref.watch(balanceProvider).value;
    final profile = ref.watch(profileProvider).value;
    final name = profile?.displayName.trim() ?? '';
    final avatar = profile?.avatar;
    final unknown = strings.homeValueUnknown;
    final points = balance == null
        ? unknown
        : formatCount(balance.points, languageCode: language);
    final coins = balance == null
        ? unknown
        : formatCount(balance.coins, languageCode: language);
    return AppBarContent(
      elementId: 'home.app-bar',
      configuration: HomeAppBar(
        avatar: AppBarAvatar(
          text: name.isEmpty ? unknown : name.characters.first.toUpperCase(),
          content: avatar?.mode == PlayerAvatarMode.character
              ? PlayerAvatar(
                  letter: name.isEmpty
                      ? 'A'
                      : name.characters.first.toUpperCase(),
                  theme: avatar!.theme,
                  character: avatar.character,
                  size: PlayerAvatarSize.compact,
                )
              : null,
        ),
        wallet: AppBarWallet(
          points: points,
          unit: strings.homePointsUnit,
          coins: coins,
          pointsSemanticLabel: strings.homePointsLabel(points),
          coinsSemanticLabel: strings.homeCoinsLabel(coins),
        ),
        profile: AppBarAction(
          label: strings.homeProfile,
          onPressed: _pressWithoutRoute,
        ),
        help: AppBarAction(
          label: strings.homeHelp,
          onPressed: _pressWithoutRoute,
        ),
        addCoins: AppBarAction(
          label: strings.homeAddCoins,
          onPressed: _pressWithoutRoute,
        ),
      ),
    );
  }
}

/// D-133: the control is pressable before a destination exists.
void _pressWithoutRoute() {}
