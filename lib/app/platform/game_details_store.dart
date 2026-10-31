import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../core/storage/file_json_store.dart';
import '../../core/storage/json_store.dart';

/// App cache files for game details and bookmarks (D-123).
JsonStore openGameDetailsStore() => FileJsonStore(
  getApplicationCacheDirectory().then(
    (directory) => Directory('${directory.path}/p2e-json'),
  ),
);
