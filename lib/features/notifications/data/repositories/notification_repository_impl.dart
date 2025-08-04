// features/notifications/data/repositories/notification_repository_impl.dart
import 'dart:convert';
import 'dart:math';

import '../../domain/entities/notification_item.dart';
import '../../domain/entities/push_settings.dart';
import '../../domain/repositories/notification_repository.dart';

/// Mock Implementation des Notification Repository
class NotificationRepositoryImpl implements NotificationRepository {
  final List<NotificationItem> _notifications = [];
  PushSettings _pushSettings = PushSettings.defaultSettings();
  String? _deviceToken;
  final Random _random = Random();

  NotificationRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock-Benachrichtigungen
    _notifications.addAll([
      NotificationItem.create(
        title: 'Neue Fallakte erstellt',
        message: 'Fallakte "Müller vs. Schmidt" wurde erfolgreich erstellt.',
        type: 'success',
        category: 'case',
        metadata: {'caseId': 'CASE-001'},
        tags: ['fallakte', 'neu'],
      ),
      NotificationItem.create(
        title: 'Dokument hochgeladen',
        message: 'Ein neues Dokument wurde zu Ihrer Fallakte hinzugefügt.',
        type: 'info',
        category: 'document',
        metadata: {'documentId': 'DOC-001'},
        tags: ['dokument', 'upload'],
      ),
      NotificationItem.create(
        title: 'Termin erinnerung',
        message: 'Ihr Termin morgen um 14:00 Uhr steht an.',
        type: 'warning',
        category: 'appointment',
        metadata: {'appointmentId': 'APT-001'},
        tags: ['termin', 'erinnerung'],
      ),
      NotificationItem.create(
        title: 'System-Wartung',
        message: 'Geplante Wartung am 15. Dezember von 02:00-04:00 Uhr.',
        type: 'info',
        category: 'system',
        tags: ['wartung', 'system'],
      ),
      NotificationItem.create(
        title: 'Fehler beim Upload',
        message:
            'Das Dokument konnte nicht hochgeladen werden. Bitte versuchen Sie es erneut.',
        type: 'error',
        category: 'document',
        metadata: {'documentId': 'DOC-002'},
        tags: ['fehler', 'upload'],
      ),
    ]);
  }

  @override
  Future<List<NotificationItem>> getAllNotifications() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_notifications);
  }

  @override
  Future<List<NotificationItem>> getUnreadNotifications() async {
    await Future.delayed(Duration(milliseconds: 200));
    return _notifications
        .where((notification) => !notification.isRead)
        .toList();
  }

  @override
  Future<NotificationItem?> getNotificationById(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      return _notifications.firstWhere((notification) => notification.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveNotification(NotificationItem notification) async {
    await Future.delayed(Duration(milliseconds: 200));
    _notifications.add(notification);
  }

  @override
  Future<void> updateNotification(NotificationItem notification) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      _notifications[index] = notification;
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _notifications.removeWhere((notification) => notification.id == id);
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].markAsRead();
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(Duration(milliseconds: 300));
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].markAsRead();
      }
    }
  }

  @override
  Future<void> clearAllNotifications() async {
    await Future.delayed(Duration(milliseconds: 200));
    _notifications.clear();
  }

  @override
  Future<int> getUnreadCount() async {
    await Future.delayed(Duration(milliseconds: 100));
    return _notifications.where((notification) => !notification.isRead).length;
  }

  @override
  Future<PushSettings> getPushSettings() async {
    await Future.delayed(Duration(milliseconds: 150));
    return _pushSettings;
  }

  @override
  Future<void> savePushSettings(PushSettings settings) async {
    await Future.delayed(Duration(milliseconds: 200));
    _pushSettings = settings;
  }

  @override
  Future<void> updatePushSettings(PushSettings settings) async {
    await Future.delayed(Duration(milliseconds: 200));
    _pushSettings = settings;
  }

  @override
  Future<String?> getDeviceToken() async {
    await Future.delayed(Duration(milliseconds: 100));
    return _deviceToken;
  }

  @override
  Future<void> saveDeviceToken(String token) async {
    await Future.delayed(Duration(milliseconds: 150));
    _deviceToken = token;
  }

  @override
  Future<void> deleteDeviceToken() async {
    await Future.delayed(Duration(milliseconds: 100));
    _deviceToken = null;
  }

  @override
  Future<List<NotificationItem>> getNotificationsByType(String type) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _notifications
        .where((notification) => notification.type == type)
        .toList();
  }

  @override
  Future<List<NotificationItem>> getNotificationsByCategory(
      String category) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _notifications
        .where((notification) => notification.category == category)
        .toList();
  }

  @override
  Future<List<NotificationItem>> searchNotifications(String query) async {
    await Future.delayed(Duration(milliseconds: 300));
    final lowercaseQuery = query.toLowerCase();
    return _notifications.where((notification) {
      return notification.title.toLowerCase().contains(lowercaseQuery) ||
          notification.message.toLowerCase().contains(lowercaseQuery) ||
          (notification.tags
                  ?.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ??
              false);
    }).toList();
  }

  @override
  Future<String> exportNotifications({String format = 'json'}) async {
    await Future.delayed(Duration(milliseconds: 500));

    if (format == 'json') {
      return jsonEncode({
        'notifications': _notifications.map((n) => n.toMap()).toList(),
        'exported_at': DateTime.now().toIso8601String(),
      });
    } else {
      return _notifications
          .map((n) =>
              '[${n.timestamp.toString()}] ${n.type.toUpperCase()}: ${n.title} - ${n.message}')
          .join('\n');
    }
  }

  @override
  Future<void> importNotifications(String data,
      {String format = 'json'}) async {
    await Future.delayed(Duration(milliseconds: 400));

    if (format == 'json') {
      final jsonData = jsonDecode(data);
      final notifications = (jsonData['notifications'] as List)
          .map((n) => NotificationItem.fromMap(n))
          .toList();
      _notifications.addAll(notifications);
    } else {
      // Einfache Text-Import (nicht vollständig implementiert)
      // Mock-Implementierung - in Produktion würde hier echtes Logging stehen
    }
  }

  @override
  Future<bool> sendPushNotification({
    required String title,
    required String message,
    String? category,
    Map<String, dynamic>? data,
  }) async {
    await Future.delayed(Duration(milliseconds: 800));

    // Mock Push-Benachrichtigung senden
    // In Produktion würde hier echtes Logging stehen

    // Simuliere Erfolg/Fehler
    return _random.nextBool();
  }

  @override
  Future<Map<String, dynamic>> getNotificationStats() async {
    await Future.delayed(Duration(milliseconds: 400));

    final total = _notifications.length;
    final unread = _notifications.where((n) => !n.isRead).length;
    final byType = <String, int>{};
    final byCategory = <String, int>{};

    for (final notification in _notifications) {
      byType[notification.type] = (byType[notification.type] ?? 0) + 1;
      if (notification.category != null) {
        byCategory[notification.category!] =
            (byCategory[notification.category!] ?? 0) + 1;
      }
    }

    return {
      'total': total,
      'unread': unread,
      'read': total - unread,
      'by_type': byType,
      'by_category': byCategory,
      'last_updated': DateTime.now().toIso8601String(),
    };
  }
}
