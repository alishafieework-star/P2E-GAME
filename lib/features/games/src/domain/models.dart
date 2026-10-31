/// Price model shown under a game's primary action.
enum GameAccess { freeToPlay, inAppPurchases }

/// A box inside the hero reference frame (402×343). Each artwork places its
/// own foreground.
final class ArtworkBox {
  const ArtworkBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
  final double left, top, width, height;
}

final class GameSummary {
  const GameSummary({
    required this.id,
    required this.name,
    required this.creator,
    required this.cover,
    required this.rating,
    required this.rewardPoints,
    required this.access,
    this.registeredMark = true,
    this.icon,
    this.banner,
  });
  final String id, name, creator;
  final bool registeredMark;

  /// Square artwork; also the fallback for a missing icon or banner.
  final Uri cover;
  final Uri? icon, banner;
  final double rating;
  final int rewardPoints;
  final GameAccess access;
}

final class HeroPromotion {
  const HeroPromotion({
    required this.game,
    required this.background,
    this.foreground,
    this.foregroundBox,
  }) : assert((foreground == null) == (foregroundBox == null));
  final GameSummary game;
  final Uri background;
  final Uri? foreground;
  final ArtworkBox? foregroundBox;
}

enum GameShelfKind { recommended, multiplayer, competition }

final class GameShelf {
  const GameShelf({required this.kind, required this.games});
  final GameShelfKind kind;
  final List<GameSummary> games;
}

final class HomeGamesFeed {
  const HomeGamesFeed({required this.hero, required this.shelves});
  final HeroPromotion? hero;
  final List<GameShelf> shelves;

  GameShelf? shelf(GameShelfKind kind) {
    for (final shelf in shelves) {
      if (shelf.kind == kind) return shelf;
    }
    return null;
  }
}
