/// Product locations shared by features and the app shell.
abstract final class AppLocations {
  static const home = '/home';
  static const missions = '/missions';
  static const games = '/games';
  static const leaderboard = '/leaderboard';
  static const shop = '/shop';

  /// Tab roots in Navigator order.
  static const tabs = [home, missions, games, leaderboard, shop];

  static String game(String id) => '/game/${Uri.encodeComponent(id)}';
  static String quest(String id) => '/quest/${Uri.encodeComponent(id)}';

  /// Game details nested under the tab the player is already on (D-121).
  static String gameOn(String tab, String id) =>
      '$tab/game/${Uri.encodeComponent(id)}';

  static String reviewsOn(String tab, String id) =>
      '${gameOn(tab, id)}/reviews';

  static String studioOn(String tab, String studioId) =>
      '$tab/studio/${Uri.encodeComponent(studioId)}';

  static String tabOf(String path) {
    for (final tab in tabs) {
      if (path == tab || path.startsWith('$tab/')) return tab;
    }
    return home;
  }

  static String gameFrom(String path, String id) => gameOn(tabOf(path), id);
}
