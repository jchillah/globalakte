// features/notifications/domain/usecases/notification_usecases.dart
import '../entities/notification_item.dart';
import '../entities/push_settings.dart';
import '../repositories/notification_repository.dart';

/// Use Cases für Benachrichtigungen
class NotificationUseCases {
  final NotificationRepository _repository;

  NotificationUseCases(this._repository);

  // Benachrichtigungen abrufen
  Future<List<NotificationItem>> getAllNotifications() async {
    return await _repository.getAllNotifications();
  }

  Future<List<NotificationItem>> getUnreadNotifications() async {
    return await _repository.getUnreadNotifications();
  }

  Future<NotificationItem?> getNotificationById(String id) async {
    return await _repository.getNotificationById(id);
  }

  // Benachrichtigungen verwalten
  Future<void> createNotification({
    required String title,
    required String message,
    required String type,
    String? category,
    Map<String, dynamic>? metadata,
    String? actionUrl,
    List<String>? tags,
  }) async {
    final notification = NotificationItem.create(
      title: title,
      message: message,
      type: type,
      category: category,
      metadata: metadata,
      actionUrl: actionUrl,
      tags: tags,
    );
    await _repository.saveNotification(notification);
  }

  Future<void> markNotificationAsRead(String id) async {
    await _repository.markAsRead(id);
  }

  Future<void> markAllNotificationsAsRead() async {
    await _repository.markAllAsRead();
  }

  Future<void> deleteNotification(String id) async {
    await _repository.deleteNotification(id);
  }

  Future<void> clearAllNotifications() async {
    await _repository.clearAllNotifications();
  }

  // Ungelesene Anzahl abrufen
  Future<int> getUnreadCount() async {
    return await _repository.getUnreadCount();
  }

  // Push-Einstellungen verwalten
  Future<PushSettings> getPushSettings() async {
    return await _repository.getPushSettings();
  }

  Future<void> updatePushSettings(PushSettings settings) async {
    await _repository.updatePushSettings(settings);
  }

  Future<void> togglePushNotifications(bool enabled) async {
    final settings = await _repository.getPushSettings();
    final updatedSettings = settings.copyWith(
      isEnabled: enabled,
      lastUpdated: DateTime.now(),
    );
    await _repository.updatePushSettings(updatedSettings);
  }

  Future<void> updateNotificationPreferences({
    bool? caseNotifications,
    bool? documentNotifications,
    bool? appointmentNotifications,
    bool? systemNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) async {
    final settings = await _repository.getPushSettings();
    final updatedSettings = settings.copyWith(
      caseNotifications: caseNotifications,
      documentNotifications: documentNotifications,
      appointmentNotifications: appointmentNotifications,
      systemNotifications: systemNotifications,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      lastUpdated: DateTime.now(),
    );
    await _repository.updatePushSettings(updatedSettings);
  }

  // Device Token verwalten
  Future<String?> getDeviceToken() async {
    return await _repository.getDeviceToken();
  }

  Future<void> saveDeviceToken(String token) async {
    await _repository.saveDeviceToken(token);
  }

  // Benachrichtigungen filtern
  Future<List<NotificationItem>> getNotificationsByType(String type) async {
    return await _repository.getNotificationsByType(type);
  }

  Future<List<NotificationItem>> getNotificationsByCategory(String category) async {
    return await _repository.getNotificationsByCategory(category);
  }

  Future<List<NotificationItem>> searchNotifications(String query) async {
    return await _repository.searchNotifications(query);
  }

  // Push-Benachrichtigungen senden
  Future<bool> sendPushNotification({
    required String title,
    required String message,
    String? category,
    Map<String, dynamic>? data,
  }) async {
    return await _repository.sendPushNotification(
      title: title,
      message: message,
      category: category,
      data: data,
    );
  }

  // System-Benachrichtigungen erstellen
  Future<void> createSystemNotification({
    required String title,
    required String message,
    String type = 'info',
    Map<String, dynamic>? metadata,
  }) async {
    await createNotification(
      title: title,
      message: message,
      type: type,
      category: 'system',
      metadata: metadata,
    );
  }

  Future<void> createCaseNotification({
    required String title,
    required String message,
    String? caseId,
    Map<String, dynamic>? metadata,
  }) async {
    await createNotification(
      title: title,
      message: message,
      type: 'info',
      category: 'case',
      metadata: {
        'caseId': caseId,
        ...?metadata,
      },
    );
  }

  Future<void> createDocumentNotification({
    required String title,
    required String message,
    String? documentId,
    Map<String, dynamic>? metadata,
  }) async {
    await createNotification(
      title: title,
      message: message,
      type: 'info',
      category: 'document',
      metadata: {
        'documentId': documentId,
        ...?metadata,
      },
    );
  }

  Future<void> createAppointmentNotification({
    required String title,
    required String message,
    String? appointmentId,
    Map<String, dynamic>? metadata,
  }) async {
    await createNotification(
      title: title,
      message: message,
      type: 'info',
      category: 'appointment',
      metadata: {
        'appointmentId': appointmentId,
        ...?metadata,
      },
    );
  }

  // Export/Import
  Future<String> exportNotifications({String format = 'json'}) async {
    return await _repository.exportNotifications(format: format);
  }

  Future<void> importNotifications(String data, {String format = 'json'}) async {
    await _repository.importNotifications(data, format: format);
  }

  // Statistiken abrufen
  Future<Map<String, dynamic>> getNotificationStats() async {
    return await _repository.getNotificationStats();
  }

  // Benachrichtigungen nach Datum filtern
  Future<List<NotificationItem>> getNotificationsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allNotifications = await _repository.getAllNotifications();
    return allNotifications.where((notification) {
      return notification.timestamp.isAfter(startDate) &&
          notification.timestamp.isBefore(endDate);
    }).toList();
  }

  // Benachrichtigungen nach Priorität sortieren
  Future<List<NotificationItem>> getNotificationsByPriority() async {
    final allNotifications = await _repository.getAllNotifications();
    
    // Sortiere nach Priorität: error > warning > info > success
    final priorityOrder = {'error': 0, 'warning': 1, 'info': 2, 'success': 3};
    
    allNotifications.sort((a, b) {
      final priorityA = priorityOrder[a.type] ?? 2;
      final priorityB = priorityOrder[b.type] ?? 2;
      
      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }
      
      // Bei gleicher Priorität nach Datum sortieren (neueste zuerst)
      return b.timestamp.compareTo(a.timestamp);
    });
    
    return allNotifications;
  }
} 