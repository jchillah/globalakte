// features/help_network/data/repositories/help_network_mock_data_repository.dart

import '../../../../core/data/mock_data_repository.dart';

/// Mock-Data Repository speziell für Help Network
class HelpNetworkMockDataRepository {
  static final HelpNetworkMockDataRepository _instance =
      HelpNetworkMockDataRepository._internal();
  factory HelpNetworkMockDataRepository() => _instance;
  HelpNetworkMockDataRepository._internal();

  final MockDataRepository _mockData = MockDataRepository();

  /// Help Requests laden
  List<Map<String, dynamic>> get helpRequests => _mockData.helpRequests;

  /// Help Offers laden
  List<Map<String, dynamic>> get helpOffers => _mockData.helpOffers;

  /// Help Chats laden
  List<Map<String, dynamic>> get helpChats => _mockData.helpChats;

  /// Neuen Help Request erstellen
  Map<String, dynamic> createHelpRequest({
    required String title,
    required String description,
    required String category,
    required String requesterId,
    required String requesterName,
    String status = 'open',
    String priority = 'medium',
    String location = '',
    List<String> tags = const [],
    String urgency = 'normal',
    DateTime? deadline,
    int maxHelpers = 1,
  }) {
    return {
      'id': _mockData.getRandomId(),
      'title': title,
      'description': description,
      'category': category,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'status': status,
      'priority': priority,
      'location': location,
      'tags': tags,
      'urgency': urgency,
      'deadline': deadline ?? DateTime.now().add(const Duration(days: 7)),
      'maxHelpers': maxHelpers,
      'createdAt': DateTime.now(),
    };
  }

  /// Neues Help Offer erstellen
  Map<String, dynamic> createHelpOffer({
    required String helpRequestId,
    required String helperId,
    required String helperName,
    required String message,
    String status = 'pending',
    double? rating,
    String? review,
  }) {
    return {
      'id': _mockData.getRandomId(),
      'helpRequestId': helpRequestId,
      'helperId': helperId,
      'helperName': helperName,
      'message': message,
      'status': status,
      'rating': rating,
      'review': review,
      'createdAt': DateTime.now(),
    };
  }

  /// Neue Chat-Nachricht erstellen
  Map<String, dynamic> createChatMessage({
    required String helpRequestId,
    required String senderId,
    required String senderName,
    required String message,
    String messageType = 'text',
    String? attachmentUrl,
    bool isRead = false,
  }) {
    return {
      'id': _mockData.getRandomId(),
      'helpRequestId': helpRequestId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'messageType': messageType,
      'attachmentUrl': attachmentUrl,
      'timestamp': DateTime.now(),
      'isRead': isRead,
      'metadata': {
        'sessionId': 'session_$helpRequestId',
        'messageId': _mockData.getRandomId(),
      },
    };
  }

  /// Help Request nach ID finden
  Map<String, dynamic>? findHelpRequestById(String id) {
    try {
      return helpRequests.firstWhere((req) => req['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Help Offer nach ID finden
  Map<String, dynamic>? findHelpOfferById(String id) {
    try {
      return helpOffers.firstWhere((offer) => offer['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Chat-Nachrichten für Help Request laden
  List<Map<String, dynamic>> getChatMessagesForRequest(String helpRequestId) {
    return helpChats
        .where((chat) => chat['helpRequestId'] == helpRequestId)
        .toList();
  }

  /// Help Offers für Request laden
  List<Map<String, dynamic>> getOffersForRequest(String helpRequestId) {
    return helpOffers
        .where((offer) => offer['helpRequestId'] == helpRequestId)
        .toList();
  }

  /// Help Requests filtern
  List<Map<String, dynamic>> filterHelpRequests({
    String? category,
    String? status,
    String? priority,
    String? location,
    List<String>? tags,
    String? searchQuery,
  }) {
    return helpRequests.where((request) {
      if (category != null && request['category'] != category) return false;
      if (status != null && request['status'] != status) return false;
      if (priority != null && request['priority'] != priority) return false;
      if (location != null && request['location'] != location) return false;
      if (tags != null && !tags.any((tag) => request['tags'].contains(tag))) {
        return false;
      }
      if (searchQuery != null) {
        final query = searchQuery.toLowerCase();
        final title = request['title'].toString().toLowerCase();
        final description = request['description'].toString().toLowerCase();
        final requestTags = request['tags'].join(' ').toLowerCase();
        if (!title.contains(query) &&
            !description.contains(query) &&
            !requestTags.contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  /// Help Offers filtern
  List<Map<String, dynamic>> filterHelpOffers({
    String? status,
    String? helperId,
    String? helpRequestId,
  }) {
    return helpOffers.where((offer) {
      if (status != null && offer['status'] != status) return false;
      if (helperId != null && offer['helperId'] != helperId) return false;
      if (helpRequestId != null && offer['helpRequestId'] != helpRequestId) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Statistiken generieren
  Map<String, dynamic> generateStatistics() {
    final totalRequests = helpRequests.length;
    final openRequests =
        helpRequests.where((req) => req['status'] == 'open').length;
    final completedRequests =
        helpRequests.where((req) => req['status'] == 'completed').length;
    final totalOffers = helpOffers.length;
    final acceptedOffers =
        helpOffers.where((offer) => offer['status'] == 'accepted').length;

    // Top Helfer berechnen
    final helperStats = <String, Map<String, dynamic>>{};
    for (final offer in helpOffers) {
      final helperId = offer['helperId'] as String;
      final helperName = offer['helperName'] as String;

      if (!helperStats.containsKey(helperId)) {
        helperStats[helperId] = {
          'name': helperName,
          'acceptedOffers': 0,
          'totalRating': 0.0,
          'ratingCount': 0,
        };
      }

      if (offer['status'] == 'accepted') {
        helperStats[helperId]!['acceptedOffers'] =
            (helperStats[helperId]!['acceptedOffers'] as int) + 1;
      }

      if (offer['rating'] != null) {
        final rating = offer['rating'] as double;
        helperStats[helperId]!['totalRating'] =
            (helperStats[helperId]!['totalRating'] as double) + rating;
        helperStats[helperId]!['ratingCount'] =
            (helperStats[helperId]!['ratingCount'] as int) + 1;
      }
    }

    // Top Helfer sortieren
    final topHelpers = helperStats.values.toList()
      ..sort((a, b) =>
          (b['acceptedOffers'] as int).compareTo(a['acceptedOffers'] as int));

    // Durchschnittsbewertung berechnen
    for (final helper in topHelpers) {
      if (helper['ratingCount'] > 0) {
        helper['averageRating'] =
            (helper['totalRating'] as double) / (helper['ratingCount'] as int);
      } else {
        helper['averageRating'] = 0.0;
      }
    }

    // Kategorien-Statistiken
    final categoryStats = <String, Map<String, int>>{};
    for (final request in helpRequests) {
      final category = request['category'] as String;
      if (!categoryStats.containsKey(category)) {
        categoryStats[category] = {
          'total': 0,
          'open': 0,
          'completed': 0,
        };
      }

      categoryStats[category]!['total'] =
          (categoryStats[category]!['total'] as int) + 1;
      if (request['status'] == 'open') {
        categoryStats[category]!['open'] =
            (categoryStats[category]!['open'] as int) + 1;
      } else if (request['status'] == 'completed') {
        categoryStats[category]!['completed'] =
            (categoryStats[category]!['completed'] as int) + 1;
      }
    }

    return {
      'totalRequests': totalRequests,
      'openRequests': openRequests,
      'completedRequests': completedRequests,
      'totalOffers': totalOffers,
      'acceptedOffers': acceptedOffers,
      'topHelpers': topHelpers.take(5).toList(),
      'categories': categoryStats.entries
          .map((entry) => {
                'category': entry.key,
                'total': entry.value['total'],
                'open': entry.value['open'],
                'completed': entry.value['completed'],
              })
          .toList(),
    };
  }

  /// Benutzer-Benachrichtigungen generieren
  List<Map<String, dynamic>> generateUserNotifications(String userId) {
    final notifications = <Map<String, dynamic>>[];

    // Neue Nachrichten
    final userChats = helpChats
        .where((chat) => chat['senderId'] != userId && !chat['isRead'])
        .toList();

    for (final chat in userChats) {
      notifications.add({
        'id': _mockData.getRandomId(),
        'title': 'Neue Nachricht',
        'message':
            'Sie haben eine neue Nachricht von ${chat['senderName']} erhalten',
        'type': 'message',
        'category': 'help_network',
        'isRead': false,
        'createdAt': chat['timestamp'],
        'data': {
          'senderId': chat['senderId'],
          'senderName': chat['senderName'],
          'helpRequestId': chat['helpRequestId'],
        },
      });
    }

    // Neue Angebote für eigene Requests
    final userRequests =
        helpRequests.where((req) => req['requesterId'] == userId).toList();
    for (final request in userRequests) {
      final newOffers = helpOffers
          .where((offer) =>
              offer['helpRequestId'] == request['id'] &&
              offer['status'] == 'pending')
          .toList();

      for (final offer in newOffers) {
        notifications.add({
          'id': _mockData.getRandomId(),
          'title': 'Neues Hilfsangebot',
          'message':
              '${offer['helperName']} hat Ihnen ein Hilfsangebot gemacht',
          'type': 'offer',
          'category': 'help_network',
          'isRead': false,
          'createdAt': offer['createdAt'],
          'data': {
            'helperId': offer['helperId'],
            'helperName': offer['helperName'],
            'helpRequestId': request['id'],
            'offerId': offer['id'],
          },
        });
      }
    }

    return notifications;
  }

  /// Daten exportieren
  Map<String, dynamic> exportData() {
    return {
      'helpRequests': helpRequests,
      'helpOffers': helpOffers,
      'helpChats': helpChats,
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.0',
    };
  }

  /// Daten importieren
  void importData(Map<String, dynamic> data) {
    // In einer echten Implementierung würde hier die Daten importiert werden
    // Für Mock-Zwecke wird nichts gemacht
  }

  /// Backup erstellen
  Map<String, dynamic> createBackup() {
    return {
      'data': exportData(),
      'backupId': _mockData.getRandomId(),
      'createdAt': DateTime.now().toIso8601String(),
      'itemCount': {
        'requests': helpRequests.length,
        'offers': helpOffers.length,
        'chats': helpChats.length,
      },
    };
  }

  /// Backup wiederherstellen
  bool restoreBackup(Map<String, dynamic> backup) {
    try {
      final data = backup['data'] as Map<String, dynamic>;
      importData(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
