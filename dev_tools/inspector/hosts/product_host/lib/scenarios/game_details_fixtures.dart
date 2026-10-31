import 'dart:async';

import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/features/games/games.dart';

enum GameDetailsFixture { success, loading, error, offline, notFound, minimal }

final class HostGameDetailsRepository implements GameDetailsRepository {
  const HostGameDetailsRepository(this.fixture);
  final GameDetailsFixture fixture;

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

GameDetails hostGameDetails({required String id, bool minimal = false}) {
  GameImage image(String name) => GameImage(
    url: Uri.parse('https://example.test/$name.png'),
    width: 64,
    height: 64,
    alt: name,
  );
  return GameDetails(
    id: id,
    kind: GameKind.downloadable,
    name: minimal ? 'Sample' : 'Clash of Clans',
    icon: image('icon'),
    access: minimal ? GameAccess.freeToPlay : GameAccess.inAppPurchases,
    studio: GameStudio(
      id: 'supercell',
      name: 'Supercell',
      registeredMark: !minimal,
      tagline: 'Mobile Game Development Company',
      logo: image('logo'),
      cover: image('cover'),
    ),
    rating: GameRating(
      average: minimal ? 0 : 4.5,
      count: minimal ? 0 : 40,
      distribution: minimal ? const [0, 0, 0, 0, 0] : const [20, 10, 5, 3, 2],
    ),
    downloads: minimal ? 0 : 500,
    installSizeBytes: 1024,
    install: GameInstall(url: Uri.parse('https://example.test/install')),
    media: minimal
        ? const []
        : [GameMedia.image(image: image('shot'), alt: 'Screenshot')],
    about: GameAbout(
      description: minimal ? 'Short.' : 'A long enough description to read.',
      updatedOn: DateTime.utc(2026, 11, 14),
      platforms: minimal ? const [] : const [GamePlatform.android],
    ),
    events: minimal
        ? const []
        : [
            GameEvent(
              id: 'event',
              title: 'Anniversary',
              description: 'Ten years.',
              banner: image('banner'),
              rewardPoints: 100,
              url: Uri.parse('https://example.test/event'),
            ),
          ],
    reviews: GameReviews(
      summary: minimal ? null : 'Players enjoy the strategy.',
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
              cover: image('sifu'),
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
              cover: image('brawl'),
              rating: 4.1,
              rewardPoints: 75,
              access: GameAccess.freeToPlay,
            ),
          ],
  );
}
