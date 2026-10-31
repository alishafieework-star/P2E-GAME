import 'package:flutter/widgets.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';

import '../domain/models.dart';

extension GameAccessLabel on GameAccess {
  String label(AppLocalizations strings) => switch (this) {
    GameAccess.freeToPlay => strings.homeFreeToPlay,
    GameAccess.inAppPurchases => strings.homeInAppPurchases,
  };
}

/// Network artwork for a sample or remote image URL.
ImageProvider artwork(Uri uri) => NetworkImage(uri.toString());
