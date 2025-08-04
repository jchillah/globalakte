// features/help_network/data/services/help_notification_service.dart

/// Service für Help Notification Operationen
class HelpNotificationService {
  final List<Map<String, dynamic>> _notifications = [];

  HelpNotificationService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock Benachrichtigungen
    _notifications.addAll([
      {
        'id': 'notif1',
        'userId': 'user1',
        'title': 'Neues Hilfe-Angebot',
        'message': 'Lisa Weber hat Ihnen ein Angebot gemacht.',
        'timestamp': DateTime.now().toIso8601String(),
        'isRead': false,
        'type': 'offer',
        'relatedId': '1754331441373',
      },
      {
        'id': 'notif2',
        'userId': 'helper1',
        'title': 'Angebot angenommen',
        'message': 'Ihr Angebot wurde von Max Mustermann angenommen.',
        'timestamp':
            DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
        'isRead': true,
        'type': 'acceptance',
        'relatedId': '1754331441373',
      },
      {
        'id': 'notif3',
        'userId': 'user2',
        'title': 'Neue Nachricht',
        'message': 'Dr. Hans Klein hat Ihnen eine Nachricht gesendet.',
        'timestamp':
            DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
        'isRead': false,
        'type': 'message',
        'relatedId': '1754331441374',
      },
    ]);
  }

  // Notification Operationen
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _notifications
        .where((notification) => notification['userId'] == userId)
        .toList()
      ..sort((a, b) => DateTime.parse(b['timestamp'])
          .compareTo(DateTime.parse(a['timestamp'])));
  }

  Future<List<Map<String, dynamic>>> getUnreadNotifications(
      String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _notifications
        .where((notification) =>
            notification['userId'] == userId && notification['isRead'] == false)
        .toList();
  }

  Future<Map<String, dynamic>?> getNotificationById(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      return _notifications
          .firstWhere((notification) => notification['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createNotification(Map<String, dynamic> notification) async {
    await Future.delayed(Duration(milliseconds: 200));
    _notifications.add(notification);
  }

  Future<void> markNotificationAsRead(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      _notifications[index]['isRead'] = true;
    }
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    for (int i = 0; i < _notifications.length; i++) {
      final notification = _notifications[i];
      if (notification['userId'] == userId && notification['isRead'] == false) {
        _notifications[i]['isRead'] = true;
      }
    }
  }

  Future<void> deleteNotification(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _notifications.removeWhere((notification) => notification['id'] == id);
  }

  Future<void> deleteAllNotifications(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    _notifications
        .removeWhere((notification) => notification['userId'] == userId);
  }

  Future<int> getUnreadNotificationCount(String userId) async {
    await Future.delayed(Duration(milliseconds: 100));
    return _notifications
        .where((notification) =>
            notification['userId'] == userId && notification['isRead'] == false)
        .length;
  }

  Future<List<Map<String, dynamic>>> getNotificationsByType(
      String userId, String type) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _notifications
        .where((notification) =>
            notification['userId'] == userId && notification['type'] == type)
        .toList();
  }

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'general',
    String? relatedId,
  }) async {
    await Future.delayed(Duration(milliseconds: 200));

    final notification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': userId,
      'title': title,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      'isRead': false,
      'type': type,
      'relatedId': relatedId,
    };

    _notifications.add(notification);
  }

  Future<void> sendOfferNotification(
      String requestId, String requesterId, String helperName) async {
    await sendNotification(
      userId: requesterId,
      title: 'Neues Hilfe-Angebot',
      message: '$helperName hat Ihnen ein Angebot gemacht.',
      type: 'offer',
      relatedId: requestId,
    );
  }

  Future<void> sendAcceptanceNotification(
      String requestId, String helperId, String requesterName) async {
    await sendNotification(
      userId: helperId,
      title: 'Angebot angenommen',
      message: 'Ihr Angebot wurde von $requesterName angenommen.',
      type: 'acceptance',
      relatedId: requestId,
    );
  }

  Future<void> sendMessageNotification(
      String requestId, String userId, String senderName) async {
    await sendNotification(
      userId: userId,
      title: 'Neue Nachricht',
      message: '$senderName hat Ihnen eine Nachricht gesendet.',
      type: 'message',
      relatedId: requestId,
    );
  }

  Future<void> sendCompletionNotification(
      String requestId, String userId, String requesterName) async {
    await sendNotification(
      userId: userId,
      title: 'Hilfe abgeschlossen',
      message: 'Die Hilfe für $requesterName wurde erfolgreich abgeschlossen.',
      type: 'completion',
      relatedId: requestId,
    );
  }

  Future<List<Map<String, dynamic>>> getRecentNotifications(String userId,
      {int limit = 20}) async {
    await Future.delayed(Duration(milliseconds: 300));
    final userNotifications = _notifications
        .where((notification) => notification['userId'] == userId)
        .toList();

    userNotifications.sort((a, b) => DateTime.parse(b['timestamp'])
        .compareTo(DateTime.parse(a['timestamp'])));

    return userNotifications.take(limit).toList();
  }
}
