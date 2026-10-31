import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../core/storage/file_json_store.dart';
import '../../core/storage/json_store.dart';

/// Support-directory store for device flags. Sign-out does not clear it (D-142).
JsonStore openDevicePreferencesStore() => FileJsonStore(
  getApplicationSupportDirectory().then(
    (directory) => Directory('${directory.path}/p2e-device'),
  ),
);
