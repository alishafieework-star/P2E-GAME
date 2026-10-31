import 'dart:async';

import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/features/games/games.dart';
import 'package:mygame_p2e/features/games/games_data.dart';
import 'package:mygame_p2e/features/missions/missions.dart';
import 'package:mygame_p2e/features/missions/missions_data.dart';
import 'package:mygame_p2e/shared/balance/balance.dart';
import 'package:mygame_p2e/shared/profile/profile.dart';

/// In-process Home fixtures. No product API and no user credential is used.
enum HomeFixture {
  success,
  loading,
  empty,
  error,
  offline,
  long,
  brokenMedia,
  expiredQuest,
}

const homeLongText =
    'Northbound expedition sample title that keeps growing past a normal card line';

final _broken = Uri.parse('http://127.0.0.1:9/missing.png');

GamesRepository gamesFor(HomeFixture fixture, Uri media) => switch (fixture) {
  HomeFixture.loading => const _PendingGames(),
  HomeFixture.empty => const _EmptyGames(),
  HomeFixture.error => const _FailedGames(BusinessFailure('inspector_fixture')),
  HomeFixture.offline => const _FailedGames(OfflineFailure()),
  HomeFixture.long => _MappedGames(FakeGamesRepository(media), _longFeed),
  HomeFixture.brokenMedia => _MappedGames(
    FakeGamesRepository(media),
    _brokenFeed,
  ),
  HomeFixture.success || HomeFixture.expiredQuest => FakeGamesRepository(media),
};

QuestsRepository questsFor(HomeFixture fixture, Uri media, DateTime now) =>
    switch (fixture) {
      HomeFixture.loading => const _PendingQuests(),
      HomeFixture.empty => const _EmptyQuests(),
      HomeFixture.error => const _FailedQuests(
        BusinessFailure('inspector_fixture'),
      ),
      HomeFixture.offline => const _FailedQuests(OfflineFailure()),
      HomeFixture.long => _MappedQuests(
        FakeQuestsRepository(media, now: () => now),
        _longBoard,
      ),
      HomeFixture.expiredQuest => _MappedQuests(
        FakeQuestsRepository(media, now: () => now),
        _expiredBoard,
      ),
      HomeFixture.success ||
      HomeFixture.brokenMedia => FakeQuestsRepository(media, now: () => now),
    };

BalanceRepository balanceFor(HomeFixture fixture) => switch (fixture) {
  HomeFixture.loading => const _PendingBalance(),
  HomeFixture.error => const _FailedBalance(
    BusinessFailure('inspector_fixture'),
  ),
  HomeFixture.offline => const _FailedBalance(OfflineFailure()),
  HomeFixture.long => const _LongBalance(),
  _ => const _SampleBalance(),
};

ProfileRepository profileFor(HomeFixture fixture) =>
    fixture == HomeFixture.long ? const _LongProfile() : const _SampleProfile();

HomeGamesFeed _longFeed(HomeGamesFeed feed) => HomeGamesFeed(
  hero: feed.hero == null ? null : _mapHero(feed.hero!, _longGame),
  shelves: [
    for (final shelf in feed.shelves)
      GameShelf(
        kind: shelf.kind,
        games: [for (final game in shelf.games) _longGame(game)],
      ),
  ],
);

HomeGamesFeed _brokenFeed(HomeGamesFeed feed) => HomeGamesFeed(
  hero: feed.hero == null ? null : _mapHero(feed.hero!, _brokenGame),
  shelves: [
    for (final shelf in feed.shelves)
      GameShelf(
        kind: shelf.kind,
        games: [for (final game in shelf.games) _brokenGame(game)],
      ),
  ],
);

HeroPromotion _mapHero(
  HeroPromotion hero,
  GameSummary Function(GameSummary) map,
) {
  final broken = map == _brokenGame;
  return HeroPromotion(
    game: map(hero.game),
    background: broken ? _broken : hero.background,
    foreground: hero.foreground == null
        ? null
        : broken
        ? _broken
        : hero.foreground,
    foregroundBox: hero.foregroundBox,
  );
}

GameSummary _longGame(GameSummary game) => GameSummary(
  id: game.id,
  name: homeLongText,
  creator: homeLongText,
  cover: game.cover,
  rating: game.rating,
  rewardPoints: 9999999,
  access: game.access,
  registeredMark: game.registeredMark,
  icon: game.icon,
  banner: game.banner,
);

GameSummary _brokenGame(GameSummary game) => GameSummary(
  id: game.id,
  name: game.name,
  creator: game.creator,
  cover: _broken,
  rating: game.rating,
  rewardPoints: game.rewardPoints,
  access: game.access,
  registeredMark: game.registeredMark,
  icon: _broken,
  banner: _broken,
);

QuestBoard _longBoard(QuestBoard board) => QuestBoard(
  attentionCount: board.attentionCount,
  quests: [
    for (final quest in board.quests)
      Quest(
        id: quest.id,
        game: QuestGame(
          gameId: quest.game.gameId,
          name: homeLongText,
          creator: homeLongText,
          icon: quest.game.icon,
          banner: quest.game.banner,
          offerTitle: quest.game.offerTitle,
          offerSummary: quest.game.offerSummary,
          access: quest.game.access,
          registeredMark: quest.game.registeredMark,
        ),
        steps: quest.steps,
        started: quest.started,
        deadline: quest.deadline,
      ),
  ],
);

QuestBoard _expiredBoard(QuestBoard board) => QuestBoard(
  attentionCount: board.attentionCount,
  quests: [
    for (final quest in board.quests)
      Quest(
        id: quest.id,
        game: quest.game,
        steps: quest.steps,
        started: quest.started,
        deadline: DateTime.utc(2020, 1, 1),
      ),
  ],
);

final class _MappedGames implements GamesRepository {
  _MappedGames(this.inner, this.map);
  final GamesRepository inner;
  final HomeGamesFeed Function(HomeGamesFeed feed) map;
  @override
  Future<Result<HomeGamesFeed>> homeFeed() async =>
      (await inner.homeFeed()).map(map);
}

final class _MappedQuests implements QuestsRepository {
  _MappedQuests(this.inner, this.map);
  final QuestsRepository inner;
  final QuestBoard Function(QuestBoard board) map;
  @override
  Future<Result<QuestBoard>> board() async => (await inner.board()).map(map);
}

final class _PendingGames implements GamesRepository {
  const _PendingGames();
  @override
  Future<Result<HomeGamesFeed>> homeFeed() =>
      Completer<Result<HomeGamesFeed>>().future;
}

final class _PendingQuests implements QuestsRepository {
  const _PendingQuests();
  @override
  Future<Result<QuestBoard>> board() => Completer<Result<QuestBoard>>().future;
}

final class _PendingBalance implements BalanceRepository {
  const _PendingBalance();
  @override
  Future<Result<Balance>> current() => Completer<Result<Balance>>().future;
}

final class _EmptyGames implements GamesRepository {
  const _EmptyGames();
  @override
  Future<Result<HomeGamesFeed>> homeFeed() async =>
      const Success(HomeGamesFeed(hero: null, shelves: []));
}

final class _EmptyQuests implements QuestsRepository {
  const _EmptyQuests();
  @override
  Future<Result<QuestBoard>> board() async =>
      const Success(QuestBoard(quests: [], attentionCount: 0));
}

final class _FailedGames implements GamesRepository {
  const _FailedGames(this.failure);
  final AppFailure failure;
  @override
  Future<Result<HomeGamesFeed>> homeFeed() async => Failure(failure);
}

final class _FailedQuests implements QuestsRepository {
  const _FailedQuests(this.failure);
  final AppFailure failure;
  @override
  Future<Result<QuestBoard>> board() async => Failure(failure);
}

final class _FailedBalance implements BalanceRepository {
  const _FailedBalance(this.failure);
  final AppFailure failure;
  @override
  Future<Result<Balance>> current() async => Failure(failure);
}

final class _LongBalance implements BalanceRepository {
  const _LongBalance();
  @override
  Future<Result<Balance>> current() async =>
      const Success(Balance(points: 9999999, coins: 999999));
}

final class _SampleBalance implements BalanceRepository {
  const _SampleBalance();
  @override
  Future<Result<Balance>> current() async =>
      const Success(Balance(points: 5325, coins: 150));
}

final class _LongProfile implements ProfileRepository {
  const _LongProfile();
  @override
  Future<Result<Profile>> current() async =>
      const Success(Profile(displayName: homeLongText));
}

final class _SampleProfile implements ProfileRepository {
  const _SampleProfile();
  @override
  Future<Result<Profile>> current() async =>
      const Success(Profile(displayName: 'Alex'));
}
