// features/help_network/data/repositories/help_network_repository_impl.dart
import 'dart:convert';
import 'dart:math';

import '../../domain/entities/help_request.dart';
import '../../domain/entities/help_offer.dart';
import '../../domain/entities/help_chat.dart';
import '../../domain/repositories/help_network_repository.dart';

/// Implementation des Help Network Repository mit Mock-Daten
class HelpNetworkRepositoryImpl implements HelpNetworkRepository {
  final List<HelpRequest> _helpRequests = [];
  final List<HelpOffer> _helpOffers = [];
  final List<HelpChat> _chatMessages = [];
  final List<Map<String, dynamic>> _notifications = [];
  final Random _random = Random();

  HelpNetworkRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock Hilfe-Anfragen
    _helpRequests.addAll([
      HelpRequest.create(
        title: 'Hilfe bei Behördengang',
        description: 'Ich brauche Hilfe beim Ausfüllen von Formularen für die Arbeitsagentur.',
        category: 'Behörden',
        requesterId: 'user1',
        requesterName: 'Max Mustermann',
        priority: 'high',
        tags: ['Behörden', 'Formulare', 'Arbeitslosigkeit'],
        location: 'Berlin',
        isUrgent: true,
        maxHelpers: 2,
      ),
      HelpRequest.create(
        title: 'Übersetzung von Dokumenten',
        description: 'Suche jemanden, der mir bei der Übersetzung von medizinischen Dokumenten helfen kann.',
        category: 'Übersetzung',
        requesterId: 'user2',
        requesterName: 'Anna Schmidt',
        priority: 'medium',
        tags: ['Übersetzung', 'Medizin', 'Dokumente'],
        location: 'Hamburg',
        maxHelpers: 1,
      ),
      HelpRequest.create(
        title: 'Begleitung zum Arzt',
        description: 'Brauche Begleitung zu einem wichtigen Arzttermin.',
        category: 'Gesundheit',
        requesterId: 'user3',
        requesterName: 'Peter Müller',
        priority: 'urgent',
        tags: ['Gesundheit', 'Arzt', 'Begleitung'],
        location: 'München',
        isUrgent: true,
        maxHelpers: 1,
      ),
    ]);

    // Mock Hilfe-Angebote
    _helpOffers.addAll([
      HelpOffer.create(
        helpRequestId: _helpRequests[0].id,
        helperId: 'helper1',
        helperName: 'Lisa Weber',
        message: 'Ich kann Ihnen gerne bei den Formularen helfen. Habe Erfahrung mit Behörden.',
      ),
      HelpOffer.create(
        helpRequestId: _helpRequests[1].id,
        helperId: 'helper2',
        helperName: 'Dr. Hans Klein',
        message: 'Ich bin Arzt und kann bei der Übersetzung medizinischer Dokumente helfen.',
      ),
    ]);

    // Mock Chat-Nachrichten
    _chatMessages.addAll([
      HelpChat.create(
        helpRequestId: _helpRequests[0].id,
        senderId: 'user1',
        senderName: 'Max Mustermann',
        message: 'Hallo, vielen Dank für das Angebot!',
      ),
      HelpChat.create(
        helpRequestId: _helpRequests[0].id,
        senderId: 'helper1',
        senderName: 'Lisa Weber',
        message: 'Gerne! Wann können wir uns treffen?',
      ),
    ]);

    // Mock Benachrichtigungen
    _notifications.addAll([
      {
        'id': 'notif1',
        'userId': 'user1',
        'title': 'Neues Hilfe-Angebot',
        'message': 'Lisa Weber hat Ihnen ein Angebot gemacht.',
        'timestamp': DateTime.now().toIso8601String(),
        'isRead': false,
      },
    ]);
  }

  // Hilfe-Anfragen Implementation
  @override
  Future<List<HelpRequest>> getAllHelpRequests() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_helpRequests);
  }

  @override
  Future<List<HelpRequest>> getHelpRequestsByCategory(String category) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpRequests.where((request) => request.category == category).toList();
  }

  @override
  Future<List<HelpRequest>> getHelpRequestsByStatus(String status) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpRequests.where((request) => request.status == status).toList();
  }

  @override
  Future<List<HelpRequest>> getHelpRequestsByUser(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpRequests.where((request) => request.requesterId == userId).toList();
  }

  @override
  Future<List<HelpRequest>> searchHelpRequests(String query) async {
    await Future.delayed(Duration(milliseconds: 400));
    final lowercaseQuery = query.toLowerCase();
    return _helpRequests.where((request) {
      return request.title.toLowerCase().contains(lowercaseQuery) ||
          request.description.toLowerCase().contains(lowercaseQuery) ||
          request.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  @override
  Future<HelpRequest?> getHelpRequestById(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      return _helpRequests.firstWhere((request) => request.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createHelpRequest(HelpRequest request) async {
    await Future.delayed(Duration(milliseconds: 200));
    _helpRequests.add(request);
  }

  @override
  Future<void> updateHelpRequest(HelpRequest request) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _helpRequests.indexWhere((r) => r.id == request.id);
    if (index != -1) {
      _helpRequests[index] = request;
    }
  }

  @override
  Future<void> deleteHelpRequest(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _helpRequests.removeWhere((request) => request.id == id);
  }

  @override
  Future<void> acceptHelpOffer(String requestId, String offerId) async {
    await Future.delayed(Duration(milliseconds: 300));
    final requestIndex = _helpRequests.indexWhere((r) => r.id == requestId);
    final offerIndex = _helpOffers.indexWhere((o) => o.id == offerId);
    
    if (requestIndex != -1 && offerIndex != -1) {
      // Update request status
      final request = _helpRequests[requestIndex];
      final updatedRequest = request.copyWith(
        status: 'in_progress',
        acceptedHelpers: [...request.acceptedHelpers, _helpOffers[offerIndex].helperId],
      );
      _helpRequests[requestIndex] = updatedRequest;

      // Update offer status
      final offer = _helpOffers[offerIndex];
      final updatedOffer = offer.copyWith(status: 'accepted');
      _helpOffers[offerIndex] = updatedOffer;
    }
  }

  @override
  Future<void> rejectHelpOffer(String requestId, String offerId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final offerIndex = _helpOffers.indexWhere((o) => o.id == offerId);
    if (offerIndex != -1) {
      final offer = _helpOffers[offerIndex];
      final updatedOffer = offer.copyWith(status: 'rejected');
      _helpOffers[offerIndex] = updatedOffer;
    }
  }

  @override
  Future<void> completeHelpRequest(String id) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _helpRequests.indexWhere((r) => r.id == id);
    if (index != -1) {
      final request = _helpRequests[index];
      final updatedRequest = request.copyWith(status: 'completed');
      _helpRequests[index] = updatedRequest;
    }
  }

  // Hilfe-Angebote Implementation
  @override
  Future<List<HelpOffer>> getHelpOffersByRequest(String requestId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpOffers.where((offer) => offer.helpRequestId == requestId).toList();
  }

  @override
  Future<List<HelpOffer>> getHelpOffersByUser(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpOffers.where((offer) => offer.helperId == userId).toList();
  }

  @override
  Future<List<HelpOffer>> getHelpOffersByStatus(String status) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpOffers.where((offer) => offer.status == status).toList();
  }

  @override
  Future<HelpOffer?> getHelpOfferById(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      return _helpOffers.firstWhere((offer) => offer.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createHelpOffer(HelpOffer offer) async {
    await Future.delayed(Duration(milliseconds: 200));
    _helpOffers.add(offer);
  }

  @override
  Future<void> updateHelpOffer(HelpOffer offer) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _helpOffers.indexWhere((o) => o.id == offer.id);
    if (index != -1) {
      _helpOffers[index] = offer;
    }
  }

  @override
  Future<void> deleteHelpOffer(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _helpOffers.removeWhere((offer) => offer.id == id);
  }

  @override
  Future<void> rateHelpOffer(String offerId, double rating, String? review) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _helpOffers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      final offer = _helpOffers[index];
      final updatedOffer = offer.copyWith(
        rating: rating,
        review: review,
      );
      _helpOffers[index] = updatedOffer;
    }
  }

  // Chat Implementation
  @override
  Future<List<HelpChat>> getChatMessages(String requestId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _chatMessages
        .where((message) => message.helpRequestId == requestId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  Future<void> sendChatMessage(HelpChat message) async {
    await Future.delayed(Duration(milliseconds: 100));
    _chatMessages.add(message);
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    await Future.delayed(Duration(milliseconds: 100));
    final index = _chatMessages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final message = _chatMessages[index];
      final updatedMessage = message.copyWith(isRead: true);
      _chatMessages[index] = updatedMessage;
    }
  }

  @override
  Future<void> deleteChatMessage(String messageId) async {
    await Future.delayed(Duration(milliseconds: 100));
    _chatMessages.removeWhere((message) => message.id == messageId);
  }

  // Statistiken Implementation
  @override
  Future<Map<String, dynamic>> getHelpNetworkStats() async {
    await Future.delayed(Duration(milliseconds: 400));
    return {
      'total_requests': _helpRequests.length,
      'open_requests': _helpRequests.where((r) => r.isOpen).length,
      'completed_requests': _helpRequests.where((r) => r.status == 'completed').length,
      'total_offers': _helpOffers.length,
      'accepted_offers': _helpOffers.where((o) => o.isAccepted).length,
      'total_messages': _chatMessages.length,
      'active_helpers': _helpOffers.map((o) => o.helperId).toSet().length,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getTopHelpers() async {
    await Future.delayed(Duration(milliseconds: 300));
    final helperStats = <String, Map<String, dynamic>>{};
    
    for (final offer in _helpOffers) {
      if (!helperStats.containsKey(offer.helperId)) {
        helperStats[offer.helperId] = {
          'helperId': offer.helperId,
          'helperName': offer.helperName,
          'totalOffers': 0,
          'acceptedOffers': 0,
          'averageRating': 0.0,
          'ratings': <double>[],
        };
      }
      
      final stats = helperStats[offer.helperId]!;
      stats['totalOffers'] = (stats['totalOffers'] as int) + 1;
      
      if (offer.isAccepted) {
        stats['acceptedOffers'] = (stats['acceptedOffers'] as int) + 1;
      }
      
      if (offer.rating != null) {
        (stats['ratings'] as List<double>).add(offer.rating!);
      }
    }

    // Calculate average ratings
    for (final stats in helperStats.values) {
      final ratings = stats['ratings'] as List<double>;
      if (ratings.isNotEmpty) {
        stats['averageRating'] = ratings.reduce((a, b) => a + b) / ratings.length;
      }
    }

    return helperStats.values.toList()
      ..sort((a, b) => (b['acceptedOffers'] as int).compareTo(a['acceptedOffers'] as int));
  }

  @override
  Future<List<Map<String, dynamic>>> getHelpCategories() async {
    await Future.delayed(Duration(milliseconds: 200));
    final categoryStats = <String, Map<String, dynamic>>{};
    
    for (final request in _helpRequests) {
      if (!categoryStats.containsKey(request.category)) {
        categoryStats[request.category] = {
          'category': request.category,
          'totalRequests': 0,
          'openRequests': 0,
          'completedRequests': 0,
        };
      }
      
      final stats = categoryStats[request.category]!;
      stats['totalRequests'] = (stats['totalRequests'] as int) + 1;
      
      if (request.isOpen) {
        stats['openRequests'] = (stats['openRequests'] as int) + 1;
      } else if (request.status == 'completed') {
        stats['completedRequests'] = (stats['completedRequests'] as int) + 1;
      }
    }

    return categoryStats.values.toList();
  }

  @override
  Future<Map<String, dynamic>> getUserHelpStats(String userId) async {
    await Future.delayed(Duration(milliseconds: 300));
    final userRequests = _helpRequests.where((r) => r.requesterId == userId).toList();
    final userOffers = _helpOffers.where((o) => o.helperId == userId).toList();
    
    return {
      'totalRequests': userRequests.length,
      'openRequests': userRequests.where((r) => r.isOpen).length,
      'completedRequests': userRequests.where((r) => r.status == 'completed').length,
      'totalOffers': userOffers.length,
      'acceptedOffers': userOffers.where((o) => o.isAccepted).length,
      'averageRating': userOffers
          .where((o) => o.rating != null)
          .map((o) => o.rating!)
          .fold(0.0, (sum, rating) => sum + rating) / 
          userOffers.where((o) => o.rating != null).length,
    };
  }

  // Benachrichtigungen Implementation
  @override
  Future<void> sendHelpRequestNotification(String requestId, String message) async {
    await Future.delayed(Duration(milliseconds: 100));
    // Mock implementation
  }

  @override
  Future<void> sendHelpOfferNotification(String offerId, String message) async {
    await Future.delayed(Duration(milliseconds: 100));
    // Mock implementation
  }

  @override
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _notifications.where((n) => n['userId'] == userId).toList();
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    await Future.delayed(Duration(milliseconds: 100));
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notifications[index]['isRead'] = true;
    }
  }

  // Backup und Export Implementation
  @override
  Future<String> exportHelpData(String userId, {String format = 'json'}) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    if (format == 'json') {
      return jsonEncode({
        'helpRequests': _helpRequests
            .where((r) => r.requesterId == userId)
            .map((r) => r.toMap())
            .toList(),
        'helpOffers': _helpOffers
            .where((o) => o.helperId == userId)
            .map((o) => o.toMap())
            .toList(),
        'chatMessages': _chatMessages
            .where((m) => m.senderId == userId)
            .map((m) => m.toMap())
            .toList(),
        'exported_at': DateTime.now().toIso8601String(),
      });
    } else {
      return 'Export format not supported';
    }
  }

  @override
  Future<void> importHelpData(String data, {String format = 'json'}) async {
    await Future.delayed(Duration(milliseconds: 300));
    // Mock implementation
  }

  @override
  Future<void> backupHelpNetwork() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // Mock implementation
  }

  @override
  Future<void> restoreHelpNetwork(String backupId) async {
    await Future.delayed(Duration(milliseconds: 800));
    // Mock implementation
  }
} 