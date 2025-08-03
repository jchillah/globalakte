// features/help_network/domain/repositories/help_network_repository.dart
import '../entities/help_chat.dart';
import '../entities/help_offer.dart';
import '../entities/help_request.dart';

/// Repository Interface für das Hilfe-Netzwerk
abstract class HelpNetworkRepository {
  // Hilfe-Anfragen
  Future<List<HelpRequest>> getAllHelpRequests();
  Future<List<HelpRequest>> getHelpRequestsByCategory(String category);
  Future<List<HelpRequest>> getHelpRequestsByStatus(String status);
  Future<List<HelpRequest>> getHelpRequestsByUser(String userId);
  Future<List<HelpRequest>> searchHelpRequests(String query);
  Future<HelpRequest?> getHelpRequestById(String id);
  Future<void> createHelpRequest(HelpRequest request);
  Future<void> updateHelpRequest(HelpRequest request);
  Future<void> deleteHelpRequest(String id);
  Future<void> acceptHelpOffer(String requestId, String offerId);
  Future<void> rejectHelpOffer(String requestId, String offerId);
  Future<void> completeHelpRequest(String id);

  // Hilfe-Angebote
  Future<List<HelpOffer>> getHelpOffersByRequest(String requestId);
  Future<List<HelpOffer>> getHelpOffersByUser(String userId);
  Future<List<HelpOffer>> getHelpOffersByStatus(String status);
  Future<HelpOffer?> getHelpOfferById(String id);
  Future<void> createHelpOffer(HelpOffer offer);
  Future<void> updateHelpOffer(HelpOffer offer);
  Future<void> deleteHelpOffer(String id);
  Future<void> rateHelpOffer(String offerId, double rating, String? review);

  // Chat-Funktionalität
  Future<List<HelpChat>> getChatMessages(String requestId);
  Future<void> sendChatMessage(HelpChat message);
  Future<void> markMessageAsRead(String messageId);
  Future<void> deleteChatMessage(String messageId);

  // Statistiken und Analytics
  Future<Map<String, dynamic>> getHelpNetworkStats();
  Future<List<Map<String, dynamic>>> getTopHelpers();
  Future<List<Map<String, dynamic>>> getHelpCategories();
  Future<Map<String, dynamic>> getUserHelpStats(String userId);

  // Benachrichtigungen
  Future<void> sendHelpRequestNotification(String requestId, String message);
  Future<void> sendHelpOfferNotification(String offerId, String message);
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId);
  Future<void> markNotificationAsRead(String notificationId);

  // Backup und Export
  Future<String> exportHelpData(String userId, {String format = 'json'});
  Future<void> importHelpData(String data, {String format = 'json'});
  Future<void> backupHelpNetwork();
  Future<void> restoreHelpNetwork(String backupId);
}
