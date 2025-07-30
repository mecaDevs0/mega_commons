import 'dart:convert';

import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../../../mega_commons.dart';

class MegaOneSignalConfig {
  MegaOneSignalConfig._();

  static String oneSignalBoxKey = 'onesignal';

  static Future<void> configure({
    required String appKey,
  }) async {
    final Box userIdBox = MegaDataCache.box<String>();
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(appKey);
    await OneSignal.Notifications.requestPermission(true);

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('=============== ONE SIGNAL FOREGROUND NOTIFICATION ===============');
      // Added jsonEncode for better formatting and to avoid issues with complex objects.
      print('Payload: \${jsonEncode(event.notification.rawPayload)}');
      print('================================================================');
      // Explicitly display the notification.
      event.notification.display();
    });

    OneSignal.Notifications.addClickListener((event) {
      print('=============== ONE SIGNAL CLICKED NOTIFICATION ===============');
      // Added jsonEncode for better formatting and to avoid issues with complex objects.
      print('Payload: \${jsonEncode(event.notification.rawPayload)}');
      print('=============================================================');
    });

    OneSignal.User.pushSubscription.addObserver((changes) async {
      final String? userId = changes.current.id;
      MegaLogger.info('=============== ONE SIGNAL LOG ===============');
      MegaLogger.info('UserId: \$userId');
      MegaLogger.info('==============================================');

      if (userId != null) {
        await userIdBox.put(oneSignalBoxKey, userId);
      }
    });
  }

  static Box<String> get cacheBox => MegaDataCache.box<String>();

  static String? fromCache() {
    return cacheBox.get(oneSignalBoxKey);
  }
}

