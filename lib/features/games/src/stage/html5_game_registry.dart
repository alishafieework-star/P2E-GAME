import 'dart:core';

/// [D-150] HTML5 game stage registry.
///
/// Maps game IDs to web URLs or asset paths for instant execution inside
/// [Html5GameStage].
abstract final class Html5GameRegistry {
  /// When true during this test phase, any game without a specific URL
  /// automatically opens the [defaultGameUrl] inside the in-app stage,
  /// preventing fallback to external browser launching.
  static bool fallbackAllGames = true;

  static final Map<String, Uri> _entries = {
    'clash_of_clans': Uri.parse('http://hamrahgameland.ir/Games/10/'),
    'sample': Uri.parse('http://hamrahgameland.ir/Games/10/'),
    'sifu': Uri.parse('http://hamrahgameland.ir/Games/10/'),
    'sample_html5': Uri(
      scheme: 'asset',
      path: 'tool/fake_backend/fixtures/games/sample_html5.html',
    ),
  };

  /// The active test game URL.
  static final Uri defaultGameUrl = Uri.parse(
    'http://hamrahgameland.ir/Games/10/',
  );

  /// Registers or overrides an HTML5 game target URL.
  static void register(String gameId, Uri url) {
    _entries[gameId] = url;
  }

  /// Removes an HTML5 game target URL.
  static void unregister(String gameId) {
    _entries.remove(gameId);
  }

  /// Returns the target URI if the game is an HTML5 instant game; null otherwise.
  static Uri? urlFor(String gameId) {
    if (_entries.containsKey(gameId)) return _entries[gameId];
    if (fallbackAllGames) return defaultGameUrl;
    return null;
  }

  /// Whether the specified [gameId] is configured as an HTML5 instant game.
  static bool isHtml5(String gameId) {
    return _entries.containsKey(gameId) || fallbackAllGames;
  }
}
