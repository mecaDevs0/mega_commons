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

    OneSignal.User.pushSubscription.addObserver((changes) async {
      final String? userId = changes.current.id;
      MegaLogger.info('=============== ONE SIGNAL LOG ===============');
      MegaLogger.info('UserId: $userId');
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
