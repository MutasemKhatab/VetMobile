import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static Future<bool> requestCalendarPermissions(BuildContext context) async {
    // Check current status
    PermissionStatus calendarStatus =
        await Permission.calendarFullAccess.status;

    if (calendarStatus.isGranted) {
      return true;
    }

    // Request permission
    calendarStatus = await Permission.calendarFullAccess.request();

    // If denied, show dialog explaining why it's needed
    if (calendarStatus.isDenied) {
      _showPermissionDialog(context,
          "Calendar permission is needed to add vaccine reminders to your calendar.");
      return false;
    }

    // If permanently denied, open app settings
    if (calendarStatus.isPermanentlyDenied) {
      _showSettingsDialog(context);
      return false;
    }

    return calendarStatus.isGranted;
  }

  static void _showPermissionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permission Required'),
        content:
            const Text('Calendar permissions are required for this feature. '
                'Please enable them in your app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
