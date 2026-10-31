import 'dart:convert';

import '../domain/game_details.dart';
import '../domain/models.dart';

/// Parses game-details schema v1. Extra or missing fields throw [FormatException].
GameDetails parseGameDetails(String body) {
  final decoded = jsonDecode(body);
  if (decoded is! Map<String, Object?>) {
    throw const FormatException('Game details must be an object');
  }
  return _GameJson(decoded, '').object();
}

final class _GameJson {
  _GameJson(this.value, this.path);
  final Map<String, Object?> value;
  final String path;

  GameDetails object() {
    _exact({
      'schemaVersion',
      'id',
      'kind',
      'name',
      'icon',
      'access',
      'studio',
      'rating',
      'downloads',
      'installSizeBytes',
      'install',
      'media',
      'about',
      'events',
      'reviews',
      'similar',
      'moreByStudio',
    });
    if (integer('schemaVersion') != 1) {
      throw FormatException('$path.schemaVersion must be 1');
    }
    final id = ident('id');
    return GameDetails(
      id: id,
      kind: _enum(text('kind'), GameKind.values, 'kind'),
      name: text('name'),
      icon: image('icon'),
      access: _access(text('access'), 'access'),
      studio: _child('studio').studio(),
      rating: _child('rating').rating(),
      downloads: count('downloads'),
      installSizeBytes: count('installSizeBytes'),
      install: _child('install').install(),
      media: list('media').map((item) => item.media()).toList(),
      about: _child('about').about(),
      events: list('events').map((item) => item.event()).toList(),
      reviews: _child('reviews').reviews(),
      similar: list('similar').map((item) => item.related()).toList(),
      moreByStudio: list('moreByStudio').map((item) => item.related()).toList(),
    );
  }

  GameStudio studio() {
    _exact({'id', 'name', 'registeredMark', 'tagline', 'logo', 'cover'});
    return GameStudio(
      id: ident('id'),
      name: text('name'),
      registeredMark: flag('registeredMark'),
      tagline: text('tagline'),
      logo: image('logo'),
      cover: image('cover'),
    );
  }

  GameRating rating() {
    _exact({'average', 'count', 'distribution'});
    final distribution = _child('distribution');
    distribution._exact({'1', '2', '3', '4', '5'});
    return GameRating(
      average: distributionAverage(number('average')),
      count: count('count'),
      distribution: [
        for (final star in ['5', '4', '3', '2', '1']) distribution.count(star),
      ],
    );
  }

  GameInstall install() {
    _exact({'method', 'url'});
    if (text('method') != 'external') {
      throw FormatException('$path.method must be external');
    }
    return GameInstall(url: https('url'));
  }

  GameMedia media() {
    final type = text('type');
    if (type == 'image') {
      _exact({'type', 'image', 'alt'});
      return GameMedia.image(image: image('image'), alt: text('alt'));
    }
    if (type == 'video') {
      _exact({'type', 'thumbnail', 'url', 'alt'});
      return GameMedia.video(
        thumbnail: image('thumbnail'),
        url: https('url'),
        alt: text('alt'),
      );
    }
    throw FormatException('$path.type must be image or video');
  }

  GameAbout about() {
    _exact({'description', 'updatedOn', 'platforms'});
    return GameAbout(
      description: text('description'),
      updatedOn: _date('updatedOn'),
      platforms: [
        for (final item in stringList('platforms'))
          _enum(item, GamePlatform.values, 'platforms'),
      ],
    );
  }

  GameEvent event() {
    _exact({'id', 'title', 'description', 'banner', 'rewardPoints', 'action'});
    final action = _child('action');
    action._exact({'type', 'url'});
    if (action.text('type') != 'external') {
      throw FormatException('${action.path}.type must be external');
    }
    return GameEvent(
      id: ident('id'),
      title: text('title'),
      description: text('description'),
      banner: image('banner'),
      rewardPoints: count('rewardPoints'),
      url: action.https('url'),
    );
  }

  GameReviews reviews() {
    _exact({'aiSummary', 'total', 'items'});
    final summary = value['aiSummary'];
    String? textSummary;
    if (summary != null) {
      if (summary is! Map<String, Object?>) {
        throw FormatException('$path.aiSummary must be an object or null');
      }
      final node = _GameJson(summary, '$path.aiSummary');
      node._exact({'text'});
      textSummary = node.text('text');
    }
    return GameReviews(
      summary: textSummary,
      total: count('total'),
      items: list('items').map((item) => item.review()).toList(),
    );
  }

  GameReview review() {
    _exact({'id', 'author', 'rating', 'createdOn', 'text'});
    return GameReview(
      id: ident('id'),
      author: _child('author').author(),
      rating: distributionAverage(number('rating')),
      createdOn: _date('createdOn'),
      text: text('text'),
    );
  }

  GameReviewAuthor author() {
    _exact({'id', 'name', 'avatar'});
    final avatar = value['avatar'];
    return GameReviewAuthor(
      id: ident('id'),
      name: text('name'),
      avatar: avatar == null ? null : image('avatar'),
    );
  }

  RelatedGame related() {
    _exact({
      'id',
      'name',
      'studio',
      'cover',
      'rating',
      'rewardPoints',
      'access',
    });
    final studio = _child('studio');
    studio._exact({'name', 'registeredMark'});
    return RelatedGame(
      id: ident('id'),
      name: text('name'),
      studioName: studio.text('name'),
      studioMark: studio.flag('registeredMark'),
      cover: image('cover'),
      rating: distributionAverage(number('rating')),
      rewardPoints: count('rewardPoints'),
      access: _access(text('access'), 'access'),
    );
  }

  GameImage image(String key) {
    final node = _child(key);
    node._exact({'url', 'width', 'height', 'alt'});
    return GameImage(
      url: node.absolute('url'),
      width: node.optionalCount('width'),
      height: node.optionalCount('height'),
      alt: node.text('alt', allowEmpty: true),
    );
  }

  void _exact(Set<String> keys) {
    final extra = value.keys.where((key) => !keys.contains(key)).toList();
    final missing = keys.where((key) => !value.containsKey(key)).toList();
    if (extra.isNotEmpty || missing.isNotEmpty) {
      throw FormatException('$path keys extra=$extra missing=$missing');
    }
  }

  _GameJson _child(String key) {
    final child = value[key];
    if (child is! Map) throw FormatException('$path.$key must be an object');
    return _GameJson(child.cast<String, Object?>(), '$path.$key');
  }

  List<_GameJson> list(String key) {
    final child = value[key];
    if (child is! List) throw FormatException('$path.$key must be a list');
    final nodes = <_GameJson>[];
    for (var index = 0; index < child.length; index++) {
      final item = child[index];
      if (item is! Map) {
        throw FormatException('$path.$key[$index] must be an object');
      }
      nodes.add(_GameJson(item.cast<String, Object?>(), '$path.$key[$index]'));
    }
    return nodes;
  }

  List<String> stringList(String key) {
    final child = value[key];
    if (child is! List || child.any((item) => item is! String)) {
      throw FormatException('$path.$key must be a list of strings');
    }
    return [for (final item in child) item as String];
  }

  String text(String key, {bool allowEmpty = false}) {
    final child = value[key];
    if (child is! String || (!allowEmpty && child.trim().isEmpty)) {
      throw FormatException('$path.$key must be a non-blank string');
    }
    return child;
  }

  String ident(String key) {
    final child = text(key);
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(child)) {
      throw FormatException('$path.$key must be a lowercase id');
    }
    return child;
  }

  bool flag(String key) {
    final child = value[key];
    if (child is! bool) throw FormatException('$path.$key must be a boolean');
    return child;
  }

  int integer(String key) {
    final child = value[key];
    if (child is! int) throw FormatException('$path.$key must be an integer');
    return child;
  }

  int count(String key) {
    final child = integer(key);
    if (child < 0) throw FormatException('$path.$key must be >= 0');
    return child;
  }

  int? optionalCount(String key) {
    if (value[key] == null) return null;
    return count(key);
  }

  num number(String key) {
    final child = value[key];
    if (child is! num) throw FormatException('$path.$key must be a number');
    return child;
  }

  double distributionAverage(num value) {
    if (value < 0 || value > 5) {
      throw FormatException('$path rating must be from 0 to 5');
    }
    return value.toDouble();
  }

  Uri absolute(String key) {
    final uri = Uri.tryParse(text(key));
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw FormatException('$path.$key must be an absolute URL');
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw FormatException('$path.$key must be http or https');
    }
    return uri;
  }

  Uri https(String key) {
    final uri = absolute(key);
    if (uri.scheme != 'https') {
      throw FormatException('$path.$key must be https');
    }
    return uri;
  }

  DateTime _date(String key) {
    final raw = text(key);
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(raw)) {
      throw FormatException('$path.$key must be YYYY-MM-DD');
    }
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) throw FormatException('$path.$key is not a date');
    return DateTime.utc(parsed.year, parsed.month, parsed.day);
  }

  T _enum<T extends Enum>(String raw, List<T> values, String key) {
    for (final value in values) {
      if (value.name == raw) return value;
    }
    throw FormatException('$path.$key has no value $raw');
  }

  GameAccess _access(String raw, String key) =>
      _enum(raw, GameAccess.values, key);
}
