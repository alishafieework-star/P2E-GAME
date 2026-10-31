import 'models.dart';

/// A raster the server describes. The app never bundles it (D-122).
final class GameImage {
  const GameImage({required this.url, this.width, this.height, this.alt = ''});

  final Uri url;
  final int? width, height;
  final String alt;
}

enum GameKind { downloadable }

enum GamePlatform { android, ios }

enum GameMediaKind { image, video }

final class GameStudio {
  const GameStudio({
    required this.id,
    required this.name,
    required this.registeredMark,
    required this.tagline,
    required this.logo,
    required this.cover,
  });

  final String id, name, tagline;
  final bool registeredMark;
  final GameImage logo, cover;
}

final class GameRating {
  const GameRating({
    required this.average,
    required this.count,
    required this.distribution,
  });

  final double average;
  final int count;

  /// Counts for stars 5, 4, 3, 2 and 1, in that order.
  final List<int> distribution;
}

final class GameInstall {
  const GameInstall({required this.url});
  final Uri url;
}

final class GameMedia {
  const GameMedia.image({required GameImage this.image, this.alt = ''})
    : kind = GameMediaKind.image,
      thumbnail = null,
      url = null;

  const GameMedia.video({
    required GameImage this.thumbnail,
    required Uri this.url,
    this.alt = '',
  }) : kind = GameMediaKind.video,
       image = null;

  final GameMediaKind kind;
  final GameImage? image, thumbnail;
  final Uri? url;
  final String alt;
}

final class GameAbout {
  const GameAbout({
    required this.description,
    required this.updatedOn,
    required this.platforms,
  });

  final String description;
  final DateTime updatedOn;
  final List<GamePlatform> platforms;
}

final class GameEvent {
  const GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.banner,
    required this.rewardPoints,
    this.url,
  });

  final String id, title, description;
  final GameImage banner;
  final int rewardPoints;
  final Uri? url;
}

final class GameReviewAuthor {
  const GameReviewAuthor({required this.id, required this.name, this.avatar});

  final String id, name;
  final GameImage? avatar;
}

final class GameReview {
  const GameReview({
    required this.id,
    required this.author,
    required this.rating,
    required this.createdOn,
    required this.text,
  });

  final String id, text;
  final GameReviewAuthor author;
  final double rating;
  final DateTime createdOn;
}

final class GameReviews {
  const GameReviews({
    required this.summary,
    required this.total,
    required this.items,
  });

  final String? summary;
  final int total;
  final List<GameReview> items;
}

/// A game named by a details payload, enough to draw a compact card.
final class RelatedGame {
  const RelatedGame({
    required this.id,
    required this.name,
    required this.studioName,
    required this.studioMark,
    required this.cover,
    required this.rating,
    required this.rewardPoints,
    required this.access,
  });

  final String id, name, studioName;
  final bool studioMark;
  final GameImage cover;
  final double rating;
  final int rewardPoints;
  final GameAccess access;
}

final class GameDetails {
  const GameDetails({
    required this.id,
    required this.kind,
    required this.name,
    required this.icon,
    required this.access,
    required this.studio,
    required this.rating,
    required this.downloads,
    required this.installSizeBytes,
    required this.install,
    required this.media,
    required this.about,
    required this.events,
    required this.reviews,
    required this.similar,
    required this.moreByStudio,
  });

  final String id, name;
  final GameKind kind;
  final GameImage icon;
  final GameAccess access;
  final GameStudio studio;
  final GameRating rating;
  final int downloads, installSizeBytes;
  final GameInstall install;
  final List<GameMedia> media;
  final GameAbout about;
  final List<GameEvent> events;
  final GameReviews reviews;
  final List<RelatedGame> similar, moreByStudio;
}

/// A details read. [offline] means the body came from the device cache.
final class GameDetailsSnapshot {
  const GameDetailsSnapshot({required this.details, required this.offline});

  final GameDetails details;
  final bool offline;
}
