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
  Future<HelpRequest?> getHelpRequest(String id);
  Future<HelpRequest> createHelpRequest(HelpRequest request);
  Future<HelpRequest> updateHelpRequest(HelpRequest request);
  Future<bool> deleteHelpRequest(String id);

  // Hilfe-Angebote
  Future<List<HelpOffer>> getAllHelpOffers();
  Future<List<HelpOffer>> getHelpOffersByRequest(String helpRequestId);
  Future<List<HelpOffer>> getHelpOffersByHelper(String helperId);
  Future<List<HelpOffer>> getHelpOffersByStatus(String status);
  Future<HelpOffer?> getHelpOffer(String id);
  Future<HelpOffer> createHelpOffer(HelpOffer offer);
  Future<HelpOffer> updateHelpOffer(HelpOffer offer);
  Future<bool> deleteHelpOffer(String id);
  Future<bool> acceptHelpOffer(String offerId);
  Future<bool> rejectHelpOffer(String offerId);

  // Chat-Funktionalität
  Future<List<HelpChat>> getChatMessages(String helpRequestId);
  Future<HelpChat> sendChatMessage(HelpChat message);
  Future<bool> markChatMessageAsRead(String messageId);

  // Statistiken
  Future<Map<String, dynamic>> generateHelpStatistics();

  // Benachrichtigungen
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId);
  Future<bool> markNotificationAsRead(String notificationId);
  Future<bool> sendPushNotification(String userId, String title, String message);

  // Backup und Export
  Future<Map<String, dynamic>> exportHelpData();
  Future<bool> importHelpData(Map<String, dynamic> data);
  Future<Map<String, dynamic>> createBackup();
  Future<bool> restoreBackup(Map<String, dynamic> backup);
}
