import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:mygame_p2e/shared/formatting/dates.dart';
import 'package:mygame_p2e/shared/formatting/initials.dart';
import 'package:mygame_p2e/shared/formatting/numbers.dart';
import 'package:mygame_p2e/shared/formatting/quantities.dart';
import 'package:mygame_p2e/shared/navigation/app_locations.dart';
import 'package:mygame_p2e/shared/platform/external_links.dart';
import 'package:mygame_p2e/shared/profile/profile.dart';
import 'package:mygame_p2e/shared/widgets/collection_section.dart';
import 'package:mygame_p2e/shared/widgets/scroll_debug_log.dart';
import 'package:p2e_design_system/design_system.dart';

import '../../domain/game_details.dart';
import '../../stage/html5_game_registry.dart';
import '../../stage/html5_game_stage.dart';
import '../game_details_providers.dart';
import '../game_labels.dart';
import '../widgets/game_compact_card.dart';
import 'game_about_section.dart';
import 'game_events_section.dart';
import 'widgets/game_media_tile.dart';
import 'widgets/game_media_viewer.dart';
import 'widgets/game_primary_data.dart';
import 'widgets/game_ratings.dart';
import 'widgets/studio_card.dart';

var _detailsScrollSamples = 0;

/// Downloadable game details. One screen for every game id (D-121).
class GameDetailsScreen extends ConsumerStatefulWidget {
  const GameDetailsScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends ConsumerState<GameDetailsScreen> {
  Animation<double>? _entrance;
  var _revealed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_revealed) return;
    final animation = ModalRoute.of(context)?.animation;
    if (animation == null ||
        (animation.status == AnimationStatus.completed &&
            animation.value == 1 &&
            ModalRoute.of(context)?.offstage != true) ||
        MediaQuery.disableAnimationsOf(context)) {
      _revealed = true;
      return;
    }
    if (!identical(_entrance, animation)) {
      _entrance?.removeStatusListener(_revealWhenEntranceEnds);
      _entrance = animation;
      animation.addStatusListener(_revealWhenEntranceEnds);
    }
  }

  /// D-132: the entrance plays before the loaded body. The read starts
  /// immediately; a late response keeps the loading state on this page.
  /// The first frame of a push is briefly offstage and reports the animation
  /// as already finished; that report is not the end of the entrance.
  void _revealWhenEntranceEnds(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    final route = ModalRoute.of(context);
    final animation = _entrance;
    if (route == null ||
        route.offstage ||
        animation == null ||
        animation.value < 1) {
      return;
    }
    animation.removeStatusListener(_revealWhenEntranceEnds);
    setState(() => _revealed = true);
  }

  @override
  void dispose() {
    _entrance?.removeStatusListener(_revealWhenEntranceEnds);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final details = ref.watch(gameDetailsProvider(id, language));
    return _page(
      context,
      ref,
      id,
      strings,
      language,
      _revealed ? details : const AsyncLoading(),
    );
  }

  void _openMedia(BuildContext context, GameDetails details, int index) {
    final strings = AppLocalizations.of(context);
    final reduced = MediaQuery.disableAnimationsOf(context);
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder<void>(
        opaque: false,
        transitionDuration: reduced
            ? Duration.zero
            : GameDetailsEngineering.viewerTransition,
        reverseTransitionDuration: reduced
            ? Duration.zero
            : GameDetailsEngineering.viewerTransition,
        pageBuilder: (routeContext, _, _) => GameMediaViewer(
          key: const ValueKey('game.details.media.viewer'),
          images: [
            for (final item in details.media)
              artwork(
                (item.kind == GameMediaKind.video
                        ? item.thumbnail!
                        : item.image!)
                    .url,
              ),
          ],
          labels: [for (final item in details.media) item.alt],
          initialIndex: index,
          backLabel: strings.shellBack,
          onClose: () => Navigator.of(routeContext).pop(),
        ),
        transitionsBuilder: (context, animation, _, child) =>
            _ViewerFade(animation: animation, child: child),
      ),
    );
  }

  Widget _page(
    BuildContext context,
    WidgetRef ref,
    String id,
    AppLocalizations strings,
    String language,
    AsyncValue<GameDetailsSnapshot> details,
  ) {
    return PageScaffold(
      key: const ValueKey('game.details.page'),
      elementId: 'game.details.page',
      layout: PageScaffoldLayout.viewport,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _GameDetailsBar(id: id),
            Expanded(
              child: details.when(
                loading: () => Center(
                  child: Semantics(
                    label: strings.gameLoading,
                    child: const CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => _GameDetailsMessage(
                  message: error is NotFoundFailure
                      ? strings.gameNotFound
                      : strings.gameLoadError,
                  retryLabel: error is NotFoundFailure
                      ? null
                      : strings.homeRetry,
                  onRetry: error is NotFoundFailure
                      ? null
                      : () => ref.invalidate(gameDetailsProvider(id, language)),
                ),
                data: (snapshot) => _GameDetailsBody(
                  id: id,
                  snapshot: snapshot,
                  onOpenMedia: (index) =>
                      _openMedia(context, snapshot.details, index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Starts quickly on the way in and on the way out. Opacity only, so the
/// full-screen picture is not scaled every frame.
class _ViewerFade extends StatefulWidget {
  const _ViewerFade({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  State<_ViewerFade> createState() => _ViewerFadeState();
}

class _ViewerFadeState extends State<_ViewerFade> {
  late final CurvedAnimation _opacity = CurvedAnimation(
    parent: widget.animation,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeOut,
  );

  @override
  void dispose() {
    _opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}

class _GameDetailsBar extends ConsumerWidget {
  const _GameDetailsBar({required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final name = ref.watch(profileProvider).value?.displayName ?? '';
    final initial = profileInitial(name);
    return AppBarContent(
      elementId: 'game.details.app-bar',
      configuration: DownloadableGameAppBar(
        avatar: AppBarAvatar(
          text: initial.isEmpty ? strings.homeValueUnknown : initial,
        ),
        back: AppBarAction(
          label: strings.shellBack,
          onPressed: () => _leave(context),
        ),
        downloads: AppBarAction(label: strings.gameDownloads, onPressed: null),
        bookmark: AppBarAction(label: strings.gameBookmark, onPressed: null),
        profile: AppBarAction(label: strings.homeProfile, onPressed: null),
      ),
    );
  }
}

class _GameDetailsMessage extends StatelessWidget {
  const _GameDetailsMessage({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String? retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(GameDetailsTokens.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: GameDetailsText.body.copyWith(
                color: GameDetailsRoles.body.resolve(context),
              ),
            ),
            if (retryLabel != null) ...[
              const SizedBox(height: GameDetailsTokens.cardGap),
              AppButton(
                elementId: 'game.details.retry',
                label: retryLabel!,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GameDetailsBody extends ConsumerWidget {
  const _GameDetailsBody({
    required this.id,
    required this.snapshot,
    required this.onOpenMedia,
  });

  final String id;
  final GameDetailsSnapshot snapshot;
  final ValueChanged<int> onOpenMedia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final details = snapshot.details;
    final wide = SizeClass.of(context) != SizeClass.compact;
    final saved = ref.watch(gameBookmarksProvider).value?.contains(id) ?? false;
    final reviews = details.rating;
    final reviewCompact = formatCompact(reviews.count, languageCode: language);
    final downloads = formatCompact(details.downloads, languageCode: language);
    final size = formatBytes(details.installSizeBytes, languageCode: language);
    final ratingText = formatRating(reviews.average, languageCode: language);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: wide ? AdaptiveTokens.contentMaxWidth : double.infinity,
        ),
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            // #region agent log
            if (notification.depth != 0) return false;
            _detailsScrollSamples++;
            if (_detailsScrollSamples % 12 != 0) return false;
            final pixels = notification.metrics.pixels;
            scrollDebugLog(
              'E',
              'game_details_screen.dart:scroll',
              'details scroll sample',
              {
                'pixels': pixels.toStringAsFixed(0),
                'max': notification.metrics.maxScrollExtent.toStringAsFixed(0),
              },
            );
            return false;
            // #endregion
          },
          child: ListView(
            children: [
              if (snapshot.offline)
                Padding(
                  padding: const EdgeInsetsDirectional.all(
                    GameDetailsTokens.pagePadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          strings.gameOffline,
                          style: GameDetailsText.body.copyWith(
                            color: GameDetailsRoles.body.resolve(context),
                          ),
                        ),
                      ),
                      AppButton(
                        elementId: 'game.details.offline.retry',
                        label: strings.homeRetry,
                        onPressed: () =>
                            ref.invalidate(gameDetailsProvider(id, language)),
                      ),
                    ],
                  ),
                ),
              GamePrimaryData(
                elementId: 'game.details.primary',
                icon: artwork(details.icon.url),
                name: details.name,
                creator: details.studio.name,
                showMark: details.studio.registeredMark,
                accessLabel: details.access.label(strings),
                ratingValue: ratingText,
                reviewCount: reviewCompact.amount,
                reviewUnit: reviewCompact.unit,
                ratingCaption: strings.gameReviews,
                downloadsValue: downloads.amount,
                downloadsUnit: downloads.unit,
                downloadsCaption: strings.gameDownloads,
                sizeValue: size.amount,
                sizeUnit: size.unit,
                downloadLabel: Html5GameRegistry.isHtml5(details.id)
                    ? strings.homePlayNow
                    : strings.gameDownload,
                bookmarkLabel: saved
                    ? strings.gameBookmarked
                    : strings.gameBookmark,
                statsLabel: strings.gameStatsLabel(
                  ratingText,
                  '${reviewCompact.amount}${reviewCompact.unit}',
                  '${downloads.amount}${downloads.unit}',
                  '${size.amount} ${size.unit}',
                ),
                bookmarked: saved,
                onDownload: () {
                  final html5Url = Html5GameRegistry.urlFor(details.id);
                  if (html5Url != null) {
                    Html5GameStage.open(
                      context,
                      gameId: details.id,
                      url: html5Url,
                      gameName: details.name,
                    );
                    return;
                  }
                  ref
                      .read(externalLinkPortProvider)
                      .openUri(details.install.url);
                },
                onBookmark: () =>
                    ref.read(gameBookmarksProvider.notifier).toggle(id),
              ),
              if (details.media.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    vertical: GameDetailsTokens.mediaPadVertical,
                  ),
                  child: AppShelf(
                    elementId: 'game.details.media',
                    spacing: AppShelfSpacing.relaxed,
                    children: [
                      for (var index = 0; index < details.media.length; index++)
                        GameMediaTile(
                          elementId: 'game.details.media:$index',
                          image: artwork(
                            details.media[index].kind == GameMediaKind.video
                                ? details.media[index].thumbnail!.url
                                : details.media[index].image!.url,
                          ),
                          video:
                              details.media[index].kind == GameMediaKind.video,
                          semanticLabel: details.media[index].alt,
                          onPressed: () => onOpenMedia(index),
                        ),
                    ],
                  ),
                ),
              GameAboutSection(name: details.name, about: details.about),
              GameEventsSection(gameId: id, events: details.events),
              if (reviews.count > 0 || details.reviews.items.isNotEmpty)
                _Reviews(details: details),
              if (details.similar.isNotEmpty)
                _RelatedShelf(
                  elementId: 'game.details.similar',
                  lead: strings.gameMoreLikeLead,
                  subject: details.name,
                  games: details.similar,
                  detailed: true,
                ),
              if (details.moreByStudio.isNotEmpty) _Studio(details: details),
            ],
          ),
        ),
      ),
    );
  }
}

class _Reviews extends StatelessWidget {
  const _Reviews({required this.details});
  final GameDetails details;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final rating = details.rating;
    final compact = formatCompact(rating.count, languageCode: language);
    final total = rating.count == 0
        ? rating.distribution.fold<int>(0, (sum, count) => sum + count)
        : rating.count;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: GameDetailsTokens.pagePadding,
      ),
      child: Column(
        children: [
          AppSectionHeader(
            elementId: 'game.details.reviews.header',
            title: strings.gameRatings,
            actionLabel: strings.gameSeeAll,
            actionChevron: false,
            onAction: () => _push(
              context,
              AppLocations.reviewsOn(
                AppLocations.tabOf(_path(context)),
                details.id,
              ),
            ),
          ),
          const SizedBox(height: GameDetailsTokens.cardGap),
          RatingSummary(
            elementId: 'game.details.reviews.summary',
            average: formatRating(rating.average, languageCode: language),
            rating: rating.average,
            count: compact.amount,
            countUnit: compact.unit,
            caption: strings.gameReviews,
            semanticLabel: strings.homeRating(
              formatRating(rating.average, languageCode: language),
            ),
            labels: [
              for (var star = 5; star >= 1; star--)
                formatCount(star, languageCode: language),
            ],
            fractions: [
              for (final count in rating.distribution)
                total == 0 ? 0.0 : (count / total).clamp(0, 1).toDouble(),
            ],
          ),
          if (details.reviews.summary != null) ...[
            const SizedBox(height: GameDetailsTokens.cardGap),
            AiSummaryCard(
              elementId: 'game.details.reviews.ai',
              title: strings.gameSummarizedByAi,
              summary: details.reviews.summary!,
              likeLabel: strings.gameLike,
              dislikeLabel: strings.gameDislike,
              moreLabel: strings.gameMore,
            ),
          ],
          if (details.reviews.items.isNotEmpty) ...[
            const SizedBox(height: GameDetailsTokens.cardGap),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: GameDetailsRoles.reviewDivider.resolve(context),
                  ),
                ),
              ),
              child: const SizedBox(height: GameDetailsTokens.cardGap),
            ),
            for (final review in details.reviews.items) ...[
              ReviewTile(
                elementId: 'game.details.reviews.item:${review.id}',
                initial: profileInitial(review.author.name),
                author: review.author.name,
                rating: review.rating,
                ratingLabel: strings.homeRating(
                  formatRating(review.rating, languageCode: language),
                ),
                date: formatMediumDate(
                  review.createdOn,
                  languageCode: language,
                ),
                text: review.text,
                moreLabel: strings.gameMore,
                colorIndex: review.author.id.hashCode & 3,
                avatar: review.author.avatar == null
                    ? null
                    : artwork(review.author.avatar!.url),
              ),
              const SizedBox(height: GameDetailsTokens.cardGap),
            ],
          ],
          if (details.reviews.total > details.reviews.items.length) ...[
            if (details.reviews.items.isEmpty)
              const SizedBox(height: GameDetailsTokens.cardGap),
            AppButton(
              elementId: 'game.details.reviews.more',
              label: strings.gameSeeMoreComments,
              family: AppButtonFamily.fill,
              size: AppButtonSize.medium,
              type: AppButtonType.outlined,
              onPressed: () => _push(
                context,
                AppLocations.reviewsOn(
                  AppLocations.tabOf(_path(context)),
                  details.id,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RelatedShelf extends StatelessWidget {
  const _RelatedShelf({
    required this.elementId,
    required this.lead,
    required this.subject,
    required this.games,
    required this.detailed,
  });

  final String elementId, lead, subject;
  final List<RelatedGame> games;
  final bool detailed;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return CollectionSection(
      elementId: elementId,
      header: AppSectionHeader(
        elementId: '$elementId.header',
        lead: lead,
        subject: subject,
        actionLabel: strings.homeViewMore,
        actionChevron: false,
        onAction: () => GoRouter.maybeOf(context)?.go(AppLocations.games),
      ),
      content: AppShelf(
        elementId: '$elementId.shelf',
        children: [
          for (final game in games) _card(context, strings, language, game),
        ],
      ),
    );
  }

  Widget _card(
    BuildContext context,
    AppLocalizations strings,
    String language,
    RelatedGame game,
  ) {
    final rating = formatRating(game.rating, languageCode: language);
    return GameCompactCard(
      elementId: '$elementId.game:${game.id}',
      appearance: detailed
          ? GameCompactCardAppearance.detailed
          : GameCompactCardAppearance.simple,
      image: artwork(game.cover.url),
      name: game.name,
      creator: detailed ? game.studioName : null,
      showMark: game.studioMark,
      rating: rating,
      ratingLabel: strings.homeRating(rating),
      rewardAmount: formatGain(game.rewardPoints, languageCode: language),
      rewardUnit: strings.homePointsUnit,
      onPressed: () =>
          _push(context, AppLocations.gameFrom(_path(context), game.id)),
    );
  }
}

class _Studio extends StatelessWidget {
  const _Studio({required this.details});
  final GameDetails details;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final studio = details.studio;
    return Padding(
      padding: const EdgeInsetsDirectional.all(GameDetailsTokens.pagePadding),
      child: Column(
        children: [
          AppSectionHeader(
            elementId: 'game.details.studio.header',
            lead: strings.gameMoreByLead,
            subject: studio.name,
            showMark: studio.registeredMark,
          ),
          const SizedBox(height: GameDetailsTokens.cardGap),
          StudioCard(
            elementId: 'game.details.studio.card',
            cover: artwork(studio.cover.url),
            logo: artwork(studio.logo.url),
            name: studio.name,
            tagline: studio.tagline,
            showMark: studio.registeredMark,
            actionLabel: strings.gameSeeAllStudio(studio.name),
            onAction: () => _push(
              context,
              AppLocations.studioOn(
                AppLocations.tabOf(_path(context)),
                studio.id,
              ),
            ),
            games: [
              for (final game in details.moreByStudio)
                GameCompactCard(
                  elementId: 'game.details.studio.game:${game.id}',
                  appearance: GameCompactCardAppearance.simple,
                  image: artwork(game.cover.url),
                  name: game.name,
                  rating: formatRating(game.rating, languageCode: language),
                  ratingLabel: strings.homeRating(
                    formatRating(game.rating, languageCode: language),
                  ),
                  rewardAmount: formatGain(
                    game.rewardPoints,
                    languageCode: language,
                  ),
                  rewardUnit: strings.homePointsUnit,
                  onPressed: () => _push(
                    context,
                    AppLocations.gameFrom(_path(context), game.id),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

String _path(BuildContext context) =>
    GoRouter.maybeOf(context)?.state.uri.path ?? AppLocations.home;

void _push(BuildContext context, String location) {
  GoRouter.maybeOf(context)?.push(location);
}

void _leave(BuildContext context) {
  final router = GoRouter.maybeOf(context);
  if (router == null) return;
  if (router.canPop()) {
    router.pop();
  } else {
    router.go(AppLocations.tabOf(router.state.uri.path));
  }
}
