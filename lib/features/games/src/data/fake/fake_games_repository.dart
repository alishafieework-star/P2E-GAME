import 'package:mygame_p2e/core/errors/app_failure.dart';

import '../../domain/models.dart';
import '../../domain/repositories.dart';

/// D-102: in-process sample feed copied from the Home source
/// (docs/snapshots/2026-10-24_home/evidence/details.json). Artwork is served
/// by the development media origin and never ships in a release build.
final class FakeGamesRepository implements GamesRepository {
  const FakeGamesRepository(this.media);
  final Uri media;

  Uri _art(String file) => media.resolve('home/$file');

  GameSummary _game(
    String id,
    String name,
    String creator,
    double rating,
    int reward, {
    GameAccess access = GameAccess.freeToPlay,
    String? icon,
    String? banner,
  }) => GameSummary(
    id: id,
    name: name,
    creator: creator,
    cover: _art(icon ?? '$id.jpg'),
    icon: icon == null ? null : _art(icon),
    banner: banner == null ? null : _art(banner),
    rating: rating,
    rewardPoints: reward,
    access: access,
  );

  @override
  Future<Result<HomeGamesFeed>> homeFeed() async => Success(
    HomeGamesFeed(
      // Dark source artwork; the Light source places different sample art.
      // The hero row shows no rating or reward; those two values are filler.
      hero: HeroPromotion(
        game: _game(
          'clash_of_clans',
          'Clash of Clans',
          'Supercell',
          4.5,
          500,
          icon: 'featured_icon.png',
        ),
        background: _art('hero_background.jpg'),
        foreground: _art('hero_object.png'),
        foregroundBox: const ArtworkBox(
          left: 106,
          top: 121,
          width: 246,
          height: 248,
        ),
      ),
      shelves: [
        GameShelf(
          kind: GameShelfKind.recommended,
          games: [
            _game('sifu', 'Sifu', 'Kepler Interactive', 4.4, 520),
            _game('nine_kings', '9 Kings', 'Playdigious', 3.6, 250),
            _game('dome_keeper', 'Dome Keeper', 'Raw Fury', 2.1, 75),
            _game('oh_snack', 'Oh, Snack!', 'Tepes Ovidiu', 4.4, 50),
          ],
        ),
        // The source shows page 1 of 3; pages 2 and 3 reuse sample games.
        GameShelf(
          kind: GameShelfKind.multiplayer,
          games: [
            _game(
              'monopoly',
              'MONOPOLY',
              'Marmalade Game',
              4.9,
              1500,
              access: GameAccess.inAppPurchases,
              icon: 'monopoly_icon.png',
              banner: 'monopoly_banner.jpg',
            ),
            _game('chess', 'Chess', 'Chess.com', 4.9, 150, banner: 'chess.jpg'),
            _game(
              'backgammon',
              'Backgammon',
              'Easybrain',
              5.0,
              150,
              banner: 'backgammon.jpg',
            ),
          ],
        ),
        GameShelf(
          kind: GameShelfKind.competition,
          games: [
            _game('chess', 'Chess', 'Chess.com', 4.9, 150),
            _game('hokm', 'Hokm', 'Toofun Games', 4.3, 150),
            _game('backgammon', 'Backgammon', 'Easybrain', 5.0, 150),
            _game('poker', 'Poker', 'Zynga', 3.6, 150),
          ],
        ),
      ],
    ),
  );
}
