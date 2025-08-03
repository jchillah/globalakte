// features/help_network/domain/usecases/help_network_usecases.dart
import '../entities/help_request.dart';
import '../entities/help_offer.dart';
import '../entities/help_chat.dart';
import '../repositories/help_network_repository.dart';

/// Use Cases für das Hilfe-Netzwerk
class HelpNetworkUseCases {
  final HelpNetworkRepository _repository;

  HelpNetworkUseCases(this._repository);

  // Hilfe-Anfragen Use Cases
  Future<List<HelpRequest>> getAllHelpRequests() async {
    return await _repository.getAllHelpRequests();
  }

  Future<List<HelpRequest>> getHelpRequestsByCategory(String category) async {
    return await _repository.getHelpRequestsByCategory(category);
  }

  Future<List<HelpRequest>> getHelpRequestsByStatus(String status) async {
    return await _repository.getHelpRequestsByStatus(status);
  }

  Future<List<HelpRequest>> getHelpRequestsByUser(String userId) async {
    return await _repository.getHelpRequestsByUser(userId);
  }

  Future<List<HelpRequest>> searchHelpRequests(String query) async {
    return await _repository.searchHelpRequests(query);
  }

  Future<HelpRequest?> getHelpRequestById(String id) async {
    return await _repository.getHelpRequestById(id);
  }

  Future<void> createHelpRequest({
    required String title,
    required String description,
    required String category,
    required String requesterId,
    required String requesterName,
    DateTime? deadline,
    String priority = 'medium',
    List<String> tags = const [],
    String? location,
    bool isUrgent = false,
    int? maxHelpers,
  }) async {
    final request = HelpRequest.create(
      title: title,
      description: description,
      category: category,
      requesterId: requesterId,
      requesterName: requesterName,
      deadline: deadline,
      priority: priority,
      tags: tags,
      location: location,
      isUrgent: isUrgent,
      maxHelpers: maxHelpers,
    );
    await _repository.createHelpRequest(request);
  }

  Future<void> updateHelpRequest(HelpRequest request) async {
    await _repository.updateHelpRequest(request);
  }

  Future<void> deleteHelpRequest(String id) async {
    await _repository.deleteHelpRequest(id);
  }

  Future<void> acceptHelpOffer(String requestId, String offerId) async {
    await _repository.acceptHelpOffer(requestId, offerId);
  }

  Future<void> rejectHelpOffer(String requestId, String offerId) async {
    await _repository.rejectHelpOffer(requestId, offerId);
  }

  Future<void> completeHelpRequest(String id) async {
    await _repository.completeHelpRequest(id);
  }

  // Hilfe-Angebote Use Cases
  Future<List<HelpOffer>> getHelpOffersByRequest(String requestId) async {
    return await _repository.getHelpOffersByRequest(requestId);
  }

  Future<List<HelpOffer>> getHelpOffersByUser(String userId) async {
    return await _repository.getHelpOffersByUser(userId);
  }

  Future<List<HelpOffer>> getHelpOffersByStatus(String status) async {
    return await _repository.getHelpOffersByStatus(status);
  }

  Future<HelpOffer?> getHelpOfferById(String id) async {
    return await _repository.getHelpOfferById(id);
  }

  Future<void> createHelpOffer({
    required String helpRequestId,
    required String helperId,
    required String helperName,
    required String message,
  }) async {
    final offer = HelpOffer.create(
      helpRequestId: helpRequestId,
      helperId: helperId,
      helperName: helperName,
      message: message,
    );
    await _repository.createHelpOffer(offer);
  }

  Future<void> updateHelpOffer(HelpOffer offer) async {
    await _repository.updateHelpOffer(offer);
  }

  Future<void> deleteHelpOffer(String id) async {
    await _repository.deleteHelpOffer(id);
  }

  Future<void> rateHelpOffer(String offerId, double rating, String? review) async {
    await _repository.rateHelpOffer(offerId, rating, review);
  }

  // Chat Use Cases
  Future<List<HelpChat>> getChatMessages(String requestId) async {
    return await _repository.getChatMessages(requestId);
  }

  Future<void> sendChatMessage({
    required String helpRequestId,
    required String senderId,
    required String senderName,
    required String message,
    String messageType = 'text',
    String? attachmentUrl,
  }) async {
    final chatMessage = HelpChat.create(
      helpRequestId: helpRequestId,
      senderId: senderId,
      senderName: senderName,
      message: message,
      messageType: messageType,
      attachmentUrl: attachmentUrl,
    );
    await _repository.sendChatMessage(chatMessage);
  }

  Future<void> markMessageAsRead(String messageId) async {
    await _repository.markMessageAsRead(messageId);
  }

  Future<void> deleteChatMessage(String messageId) async {
    await _repository.deleteChatMessage(messageId);
  }

  // Statistiken Use Cases
  Future<Map<String, dynamic>> getHelpNetworkStats() async {
    return await _repository.getHelpNetworkStats();
  }

  Future<List<Map<String, dynamic>>> getTopHelpers() async {
    return await _repository.getTopHelpers();
  }

  Future<List<Map<String, dynamic>>> getHelpCategories() async {
    return await _repository.getHelpCategories();
  }

  Future<Map<String, dynamic>> getUserHelpStats(String userId) async {
    return await _repository.getUserHelpStats(userId);
  }

  // Benachrichtigungen Use Cases
  Future<void> sendHelpRequestNotification(String requestId, String message) async {
    await _repository.sendHelpRequestNotification(requestId, message);
  }

  Future<void> sendHelpOfferNotification(String offerId, String message) async {
    await _repository.sendHelpOfferNotification(offerId, message);
  }

  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    return await _repository.getUserNotifications(userId);
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _repository.markNotificationAsRead(notificationId);
  }

  // Backup und Export Use Cases
  Future<String> exportHelpData(String userId, {String format = 'json'}) async {
    return await _repository.exportHelpData(userId, format: format);
  }

  Future<void> importHelpData(String data, {String format = 'json'}) async {
    await _repository.importHelpData(data, format: format);
  }

  Future<void> backupHelpNetwork() async {
    await _repository.backupHelpNetwork();
  }

  Future<void> restoreHelpNetwork(String backupId) async {
    await _repository.restoreHelpNetwork(backupId);
  }
} 