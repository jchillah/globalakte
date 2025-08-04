// features/notifications/domain/repositories/notification_repository.dart
import '../entities/notification_item.dart';
import '../entities/push_settings.dart';

/// Repository Interface für Benachrichtigungen
abstract class NotificationRepository {
  // Benachrichtigungen verwalten
  Future<List<NotificationItem>> getAllNotifications();
  Future<List<NotificationItem>> getUnreadNotifications();
  Future<NotificationItem?> getNotificationById(String id);
  Future<void> saveNotification(NotificationItem notification);
  Future<void> updateNotification(NotificationItem notification);
  Future<void> deleteNotification(String id);
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> clearAllNotifications();
  Future<int> getUnreadCount();

  // Push-Einstellungen verwalten
  Future<PushSettings> getPushSettings();
  Future<void> savePushSettings(PushSettings settings);
  Future<void> updatePushSettings(PushSettings settings);
  Future<String?> getDeviceToken();
  Future<void> saveDeviceToken(String token);
  Future<void> deleteDeviceToken();

  // Benachrichtigungen filtern
  Future<List<NotificationItem>> getNotificationsByType(String type);
  Future<List<NotificationItem>> getNotificationsByCategory(String category);
  Future<List<NotificationItem>> searchNotifications(String query);

  // Export/Import
  Future<String> exportNotifications({String format = 'json'});
  Future<void> importNotifications(String data, {String format = 'json'});

  // Push-Benachrichtigungen senden
  Future<bool> sendPushNotification({
    required String title,
    required String message,
    String? category,
    Map<String, dynamic>? data,
  });

  // Benachrichtigungsstatistiken
  Future<Map<String, dynamic>> getNotificationStats();
} 