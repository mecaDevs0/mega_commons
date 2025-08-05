import 'dart:convert';

import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../data/mega_data_cache.dart';
import '../utils/mega_logger.dart';

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
      final payload = event.notification.rawPayload ?? <String, dynamic>{};
      print('Payload: ${jsonEncode(payload)}');
      print('================================================================');
      
      // Processar notificação customizada se necessário
      _processNotificationPayload(payload);
      
      // Explicitly display the notification.
      event.notification.display();
    });

    OneSignal.Notifications.addClickListener((event) {
      print('=============== ONE SIGNAL CLICKED NOTIFICATION ===============');
      // Added jsonEncode for better formatting and to avoid issues with complex objects.
      final payload = event.notification.rawPayload ?? <String, dynamic>{};
      print('Payload: ${jsonEncode(payload)}');
      print('=============================================================');
      
      // Processar navegação da notificação
      _handleNotificationClick(payload);
    });

    OneSignal.User.pushSubscription.addObserver((changes) async {
      final String? playerId = changes.current.id;
      final String? token = changes.current.token;
      
      MegaLogger.info('=============== ONE SIGNAL LOG ===============');
      MegaLogger.info('Player ID: $playerId');
      MegaLogger.info('Push Token: $token');
      MegaLogger.info('==============================================');

      if (playerId != null) {
        await userIdBox.put(oneSignalBoxKey, playerId);
        
        // Registrar o player_id no backend automaticamente se o usuário estiver logado
        await _registerPlayerIdInBackend(playerId);
      }
    });
  }

  /// Registra o player_id no backend quando um usuário está logado
  static Future<void> _registerPlayerIdInBackend(String playerId) async {
    try {
      // Importar dependências necessárias para verificar se o usuário está logado
      final profile = MegaDataCache.box().get('profile');
      
      if (profile != null) {
        // Usuário está logado, registrar o player_id
        print('OneSignal: Registrando player_id no backend: $playerId');
        
        // Aqui você pode fazer a chamada para sua API para associar o player_id ao usuário
        // Exemplo: await UserProfileProvider().registerDeviceId(playerId);
      }
    } catch (e) {
      print('OneSignal: Erro ao registrar player_id no backend: $e');
    }
  }

  /// Processa payload de notificação customizada
  static void _processNotificationPayload(Map<String, dynamic> payload) {
    try {
      // Extrair dados customizados da notificação
      final customData = payload['custom_data'] as Map<String, dynamic>?;
      
      if (customData != null) {
        print('OneSignal: Dados customizados recebidos: $customData');
        
        // Aqui você pode processar dados específicos do seu app
        // Por exemplo, atualizar badges, cache local, etc.
      }
    } catch (e) {
      print('OneSignal: Erro ao processar payload: $e');
    }
  }

  /// Trata clique em notificação para navegação
  static void _handleNotificationClick(Map<String, dynamic> payload) {
    try {
      // Extrair informações de navegação
      final String? screen = payload['screen_route'] as String?;
      final String? appointmentId = payload['appointment_id'] as String?;
      final String? notificationType = payload['notification_type'] as String?;

      print('OneSignal: Navegação - Screen: $screen, Appointment: $appointmentId, Type: $notificationType');

      // Aqui você pode implementar a lógica de navegação
      // Por exemplo, usando Get.toNamed() ou similar
      
    } catch (e) {
      print('OneSignal: Erro ao processar clique na notificação: $e');
    }
  }

  static Box<String> get cacheBox => MegaDataCache.box<String>();

  static String? fromCache() {
    return cacheBox.get(oneSignalBoxKey);
  }

  /// Força o registro do player_id atual no backend
  static Future<void> forceRegisterCurrentPlayerId() async {
    final playerId = fromCache();
    if (playerId != null) {
      await _registerPlayerIdInBackend(playerId);
    }
  }
}

