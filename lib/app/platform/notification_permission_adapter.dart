import 'package:permission_handler/permission_handler.dart';

import '../../shared/platform/notification_permission.dart';

/// PLATFORM(PE-004): the OS shows its own notification dialog.
final class PermissionHandlerNotificationAdapter
    implements NotificationPermissionPort {
  const PermissionHandlerNotificationAdapter();

  @override
  Future<NotificationPermissionStatus> request() async {
    final status = await Permission.notification.request();
    return switch (status) {
      PermissionStatus.granted ||
      PermissionStatus.limited ||
      PermissionStatus.provisional => NotificationPermissionStatus.granted,
      PermissionStatus.denied ||
      PermissionStatus.permanentlyDenied ||
      PermissionStatus.restricted => NotificationPermissionStatus.denied,
    };
  }
}
