import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/navigation/app_locations.dart';
import 'package:mygame_p2e/shared/tour/tour_target.dart';
import 'package:mygame_p2e/shared/widgets/game_info_row.dart';
import 'package:mygame_p2e/shared/widgets/section_error.dart';
import 'package:p2e_design_system/design_system.dart';

import 'game_labels.dart';
import 'providers.dart';
import 'widgets/home_hero_banner.dart';

/// Home hero: promotional banner behind the chrome ([overlap]) and the
/// featured game row below it (Hero Section Card `18457:13089`).
class FeaturedGameHero extends ConsumerWidget {
  const FeaturedGameHero({super.key, required this.overlap, this.scroll});
  final double overlap;

  /// Live page scroll. The banner moves its layers without rebuilding them.
  final ScrollController? scroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final feed = ref.watch(homeGamesFeedProvider);
    final hero = feed.value?.hero;
    if (hero == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Loading reserves the hero; a feed without a hero keeps the chrome.
          SizedBox(
            height: feed.isLoading && !feed.hasError
                ? overlap + HomeTokens.heroCardHeight
                : overlap,
          ),
          if (feed.hasError)
            SectionError(
              elementId: 'home.hero.error',
              message: strings.homeSectionError,
              retryLabel: strings.homeRetry,
              retrying: feed.isLoading,
              onRetry: () => ref.invalidate(homeGamesFeedProvider),
            ),
        ],
      );
    }
    final game = hero.game;
    final box = hero.foregroundBox;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeHeroBanner(
          elementId: 'home.hero.banner',
          background: artwork(hero.background),
          foreground: hero.foreground == null
              ? null
              : artwork(hero.foreground!),
          foregroundBox: box == null
              ? null
              : HeroArtworkBox(
                  left: box.left,
                  top: box.top,
                  width: box.width,
                  height: box.height,
                ),
          overlap: overlap,
          scroll: scroll,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: HomeTokens.heroRowInset,
          ),
          child: TourTarget(
            id: 'featured',
            child: GameInfoRow(
              elementId: 'home.hero.game',
              layout: GameInfoLayout.featured,
              icon: artwork(game.icon ?? game.cover),
              name: game.name,
              creator: game.creator,
              showMark: game.registeredMark,
              actionLabel: strings.homePlayNow,
              caption: game.access.label(strings),
              onAction: () => context.push(
                AppLocations.gameFrom(
                  GoRouterState.of(context).uri.path,
                  game.id,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
