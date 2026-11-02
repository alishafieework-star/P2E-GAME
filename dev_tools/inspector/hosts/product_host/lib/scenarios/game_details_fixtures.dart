import 'dart:async';

import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/features/games/games.dart';

enum GameDetailsFixture { success, loading, error, offline, notFound, minimal }

final class HostGameDetailsRepository implements GameDetailsRepository {
  const HostGameDetailsRepository(
    this.fixture, {
    this.mediaBase = 'http://127.0.0.1:8788',
  });
  final GameDetailsFixture fixture;
  final String mediaBase;

  @override
  Future<void> clear() async {}

  @override
  Future<Result<GameDetailsSnapshot>> details(
    String id, {
    required String languageCode,
  }) {
    final details = hostGameDetails(
      id: id,
      minimal: fixture == GameDetailsFixture.minimal,
      mediaBase: mediaBase,
    );
    return switch (fixture) {
      GameDetailsFixture.loading =>
        Completer<Result<GameDetailsSnapshot>>().future,
      GameDetailsFixture.error => Future.value(const Failure(ServerFailure())),
      GameDetailsFixture.notFound => Future.value(
        const Failure(NotFoundFailure()),
      ),
      GameDetailsFixture.offline => Future.value(
        Success(GameDetailsSnapshot(details: details, offline: true)),
      ),
      GameDetailsFixture.minimal || GameDetailsFixture.success => Future.value(
        Success(GameDetailsSnapshot(details: details, offline: false)),
      ),
    };
  }
}

final class HostBookmarks implements GameBookmarkStore {
  final _ids = <String>{};

  @override
  Future<Set<String>> read() async => _ids;

  @override
  Future<void> write(Set<String> ids) async {
    _ids
      ..clear()
      ..addAll(ids);
  }

  @override
  Future<void> clear() async => _ids.clear();
}

GameDetails hostGameDetails({
  required String id,
  bool minimal = false,
  String mediaBase = 'http://127.0.0.1:8788',
}) {
  final base = mediaBase.replaceAll(RegExp(r'/+$'), '');
  GameImage homeImage(String name, {int width = 512, int height = 512}) =>
      GameImage(
        url: Uri.parse('$base/home/$name'),
        width: width,
        height: height,
        alt: name,
      );
  GameImage gameImage(String name, {int width = 1600, int height = 739}) =>
      GameImage(
        url: Uri.parse('$base/games/$name'),
        width: width,
        height: height,
        alt: name,
      );

  return GameDetails(
    id: id,
    kind: GameKind.downloadable,
    name: minimal ? 'Sample' : 'Clash of Clans',
    icon: homeImage('featured_icon.png'),
    access: minimal ? GameAccess.freeToPlay : GameAccess.inAppPurchases,
    studio: GameStudio(
      id: 'supercell',
      name: 'Supercell',
      registeredMark: !minimal,
      tagline: 'Mobile Game Development Company',
      logo: homeImage('featured_icon.png'),
      cover: homeImage('hero_background.jpg'),
    ),
    rating: GameRating(
      average: minimal ? 0 : 4.5,
      count: minimal ? 0 : 40,
      distribution: minimal ? const [0, 0, 0, 0, 0] : const [20, 10, 5, 3, 2],
    ),
    downloads: minimal ? 0 : 500,
    installSizeBytes: 1024,
    install: GameInstall(url: Uri.parse('https://example.com/install')),
    media: minimal
        ? const []
        : [
            GameMedia.image(
              image: gameImage('media_1.jpg'),
              alt: 'Screenshot 1',
            ),
            GameMedia.image(
              image: gameImage('media_2.jpg'),
              alt: 'Screenshot 2',
            ),
            GameMedia.image(
              image: gameImage('media_3.jpg'),
              alt: 'Screenshot 3',
            ),
            GameMedia.image(
              image: gameImage('media_4.jpg'),
              alt: 'Screenshot 4',
            ),
          ],
    about: GameAbout(
      description: minimal ? 'Short.' : 'ALL FOR THE CROWN!\n\nBuild a formidable team, attack enemy towers, and use strategy skills to defend your own in multiplayer PvP card battles. Unlock 100+ unique cards, build an unrivalled battle deck, and defend your King’s Tower using strategy, wit, and Skeletons.',
      updatedOn: DateTime.utc(2026, 11, 14),
      platforms: minimal ? const [] : const [GamePlatform.android],
    ),
    events: minimal
        ? const []
        : [
            GameEvent(
              id: 'event',
              title: 'Hero Electro Wizard & Evolved Electro Giant',
              description: 'Hero Electro Wizard is even more stunning than before! Activate his Hero ability to stun nearby enemies with twin beams of shocking proportions.',
              banner: gameImage('event_electro.jpg', width: 1200, height: 600),
              rewardPoints: 1500,
              url: Uri.parse('https://example.com/event'),
            ),
          ],
    reviews: GameReviews(
      summary: minimal
          ? null
          : 'Players enjoy the strategy and competitive battles.',
      total: minimal ? 0 : 1,
      items: minimal
          ? const []
          : [
              GameReview(
                id: 'note',
                author: const GameReviewAuthor(id: 'ada', name: 'Ada'),
                rating: 4,
                createdOn: DateTime.utc(2026, 10, 5),
                text: 'Good game.',
              ),
            ],
    ),
    similar: minimal
        ? const []
        : [
            RelatedGame(
              id: 'sifu',
              name: 'Sifu',
              studioName: 'Kepler Interactive',
              studioMark: true,
              cover: homeImage('sifu.jpg'),
              rating: 4.4,
              rewardPoints: 50,
              access: GameAccess.freeToPlay,
            ),
          ],
    moreByStudio: minimal
        ? const []
        : [
            RelatedGame(
              id: 'brawl_stars',
              name: 'Brawl Stars',
              studioName: 'Supercell',
              studioMark: true,
              cover: homeImage('featured_icon.png'),
              rating: 4.1,
              rewardPoints: 75,
              access: GameAccess.freeToPlay,
            ),
          ],
  );
}
