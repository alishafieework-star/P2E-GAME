import 'dart:convert';

import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/core/storage/json_store.dart';

import '../domain/game_details.dart';
import '../domain/game_details_repository.dart';
import 'game_details_codec.dart';
import 'http_game_details_source.dart';

/// Stale-while-revalidate details cache (D-123).
final class CachedGameDetailsRepository implements GameDetailsRepository {
  const CachedGameDetailsRepository({
    required this.source,
    required this.store,
  });

  final HttpGameDetailsSource source;
  final JsonStore store;

  String _key(String languageCode, String id) => 'game/$languageCode/$id';

  @override
  Future<Result<GameDetailsSnapshot>> details(
    String id, {
    required String languageCode,
  }) async {
    final key = _key(languageCode, id);
    final cached = await _cached(key);
    try {
      final fetch = await source.fetch(
        id,
        languageCode: languageCode,
        etag: cached?.etag,
      );
      if (fetch.status == 304) {
        final details = cached?.parse();
        if (details == null) return const Failure(ServerFailure());
        return Success(GameDetailsSnapshot(details: details, offline: false));
      }
      if (fetch.status == 404) return const Failure(NotFoundFailure());
      if (fetch.status != 200) return const Failure(ServerFailure());
      final details = parseGameDetails(fetch.body);
      if (details.id != id) return const Failure(ServerFailure());
      await _save(key, fetch.etag, fetch.body);
      return Success(GameDetailsSnapshot(details: details, offline: false));
    } on FormatException {
      return const Failure(ServerFailure());
    } on OfflineFailure {
      return _cachedOr(cached, const OfflineFailure());
    } on TimeoutFailure {
      return _cachedOr(cached, const TimeoutFailure());
    } on NetworkFailure {
      return _cachedOr(cached, const NetworkFailure());
    }
  }

  Result<GameDetailsSnapshot> _cachedOr(
    _CacheRecord? cached,
    AppFailure failure,
  ) {
    final details = cached?.parse();
    if (details == null) return Failure(failure);
    return Success(GameDetailsSnapshot(details: details, offline: true));
  }

  Future<_CacheRecord?> _cached(String key) async {
    try {
      final raw = await store.read(key);
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, Object?>) return null;
      final body = decoded['body'];
      final etag = decoded['etag'];
      if (body is! String) return null;
      // The strict parse is deferred to [._CacheRecord.parse]; the etag must
      // be available before the network call, the details only if used.
      return _CacheRecord(etag: etag is String ? etag : null, body: body);
    } catch (_) {
      return null;
    }
  }

  Future<void> _save(String key, String? etag, String body) async {
    try {
      await store.write(key, jsonEncode({'etag': etag, 'body': body}));
    } catch (_) {
      // A failed write still returns the fresh payload.
    }
  }

  @override
  Future<void> clear() async {
    for (final key in await store.keys()) {
      if (key.startsWith('game/')) await store.delete(key);
    }
  }
}

final class _CacheRecord {
  _CacheRecord({required this.etag, required this.body});
  final String? etag;
  final String body;
  GameDetails? _parsed;

  /// The strict parse runs lazily: a fresh 200 response never pays for the
  /// cached body's parse. A corrupt cache behaves exactly like a missing one.
  GameDetails? parse() {
    final existing = _parsed;
    if (existing != null) return existing;
    try {
      return _parsed = parseGameDetails(body);
    } catch (_) {
      return null;
    }
  }
}
