import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Result of the real system notification dialog (D-140).
enum NotificationPermissionStatus { granted, denied, unavailable }

abstract interface class NotificationPermissionPort {
  Future<NotificationPermissionStatus> request();
}

final class UnavailableNotificationPermission
    implements NotificationPermissionPort {
  const UnavailableNotificationPermission();

  @override
  Future<NotificationPermissionStatus> request() async =>
      NotificationPermissionStatus.unavailable;
}

final notificationPermissionPortProvider = Provider<NotificationPermissionPort>(
  (_) => const UnavailableNotificationPermission(),
);
