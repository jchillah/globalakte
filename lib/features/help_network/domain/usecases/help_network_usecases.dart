// features/help_network/domain/usecases/help_network_usecases.dart

import '../entities/help_chat.dart';
import '../entities/help_offer.dart';
import '../entities/help_request.dart';
import '../repositories/help_network_repository.dart';

/// Use Cases für das Hilfe-Netzwerk
class HelpNetworkUseCases {
  final HelpNetworkRepository _repository;

  const HelpNetworkUseCases(this._repository);

  // Help Request Use Cases
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

  Future<HelpRequest?> getHelpRequest(String id) async {
    return await _repository.getHelpRequest(id);
  }

  Future<HelpRequest> createHelpRequest(HelpRequest request) async {
    return await _repository.createHelpRequest(request);
  }

  Future<HelpRequest> updateHelpRequest(HelpRequest request) async {
    return await _repository.updateHelpRequest(request);
  }

  Future<bool> deleteHelpRequest(String id) async {
    return await _repository.deleteHelpRequest(id);
  }

  // Help Offer Use Cases
  Future<List<HelpOffer>> getAllHelpOffers() async {
    return await _repository.getAllHelpOffers();
  }

  Future<List<HelpOffer>> getHelpOffersByRequest(String helpRequestId) async {
    return await _repository.getHelpOffersByRequest(helpRequestId);
  }

  Future<List<HelpOffer>> getHelpOffersByHelper(String helperId) async {
    return await _repository.getHelpOffersByHelper(helperId);
  }

  Future<List<HelpOffer>> getHelpOffersByStatus(String status) async {
    return await _repository.getHelpOffersByStatus(status);
  }

  Future<HelpOffer?> getHelpOffer(String id) async {
    return await _repository.getHelpOffer(id);
  }

  Future<HelpOffer> createHelpOffer(HelpOffer offer) async {
    return await _repository.createHelpOffer(offer);
  }

  Future<HelpOffer> updateHelpOffer(HelpOffer offer) async {
    return await _repository.updateHelpOffer(offer);
  }

  Future<bool> deleteHelpOffer(String id) async {
    return await _repository.deleteHelpOffer(id);
  }

  Future<bool> acceptHelpOffer(String offerId) async {
    return await _repository.acceptHelpOffer(offerId);
  }

  Future<bool> rejectHelpOffer(String offerId) async {
    return await _repository.rejectHelpOffer(offerId);
  }

  // Chat Use Cases
  Future<List<HelpChat>> getChatMessages(String helpRequestId) async {
    return await _repository.getChatMessages(helpRequestId);
  }

  Future<HelpChat> sendChatMessage(HelpChat message) async {
    return await _repository.sendChatMessage(message);
  }

  Future<bool> markChatMessageAsRead(String messageId) async {
    return await _repository.markChatMessageAsRead(messageId);
  }

  // Statistics Use Cases
  Future<Map<String, dynamic>> generateHelpStatistics() async {
    return await _repository.generateHelpStatistics();
  }

  // Notification Use Cases
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    return await _repository.getUserNotifications(userId);
  }

  Future<bool> markNotificationAsRead(String notificationId) async {
    return await _repository.markNotificationAsRead(notificationId);
  }

  Future<bool> sendPushNotification(
      String userId, String title, String message) async {
    return await _repository.sendPushNotification(userId, title, message);
  }

  // Backup and Export Use Cases
  Future<Map<String, dynamic>> exportHelpData() async {
    return await _repository.exportHelpData();
  }

  Future<bool> importHelpData(Map<String, dynamic> data) async {
    return await _repository.importHelpData(data);
  }

  Future<Map<String, dynamic>> createBackup() async {
    return await _repository.createBackup();
  }

  Future<bool> restoreBackup(Map<String, dynamic> backup) async {
    return await _repository.restoreBackup(backup);
  }
}
