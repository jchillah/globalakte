// features/help_network/data/repositories/help_network_repository_impl.dart

import 'dart:math';

import '../../../../core/data/mock_data_repository.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../domain/entities/help_chat.dart';
import '../../domain/entities/help_offer.dart';
import '../../domain/entities/help_request.dart';
import '../../domain/repositories/help_network_repository.dart';
import 'help_network_mock_data_repository.dart';

/// Repository-Implementation für Help Network
class HelpNetworkRepositoryImpl implements HelpNetworkRepository {
  // Mock-Daten für Demo-Zwecke
  final List<HelpRequest> _helpRequests = [];
  final List<HelpOffer> _helpOffers = [];
  final List<HelpChat> _helpChats = [];
  final MockDataRepository _mockData = MockDataRepository();
  final HelpNetworkMockDataRepository _helpMockData =
      HelpNetworkMockDataRepository();
  final Random _random = Random();

  HelpNetworkRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Help Requests aus Mock-Data Repository laden
    final requestsData = _helpMockData.helpRequests;
    _helpRequests.addAll(requestsData.map((data) => HelpRequest.fromMap(data)));

    // Help Offers aus Mock-Data Repository laden
    final offersData = _helpMockData.helpOffers;
    _helpOffers.addAll(offersData.map((data) => HelpOffer.fromMap(data)));

    // Help Chats aus Mock-Data Repository laden
    final chatsData = _helpMockData.helpChats;
    _helpChats.addAll(chatsData.map((data) => HelpChat.fromMap(data)));
  }

  @override
  Future<HelpRequest> createHelpRequest(HelpRequest request) async {
    await Future.delayed(Duration(milliseconds: 400 + _random.nextInt(600)));
    _helpRequests.add(request);
    AppLogger.info('Hilfe-Anfrage erstellt: ${request.title}');
    return request;
  }

  @override
  Future<HelpRequest?> getHelpRequest(String id) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    try {
      return _helpRequests.firstWhere((req) => req.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<HelpRequest>> getAllHelpRequests() async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(700)));
    AppLogger.info('Alle Hilfe-Anfragen geladen: ${_helpRequests.length}');
    return List.from(_helpRequests);
  }

  @override
  Future<HelpRequest> updateHelpRequest(HelpRequest request) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    final index = _helpRequests.indexWhere((req) => req.id == request.id);
    if (index != -1) {
      _helpRequests[index] = request;
      AppLogger.info('Hilfe-Anfrage aktualisiert: ${request.title}');
      return _helpRequests[index];
    }
    throw Exception('Hilfe-Anfrage nicht gefunden: ${request.id}');
  }

  @override
  Future<bool> deleteHelpRequest(String id) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    final initialLength = _helpRequests.length;
    _helpRequests.removeWhere((req) => req.id == id);
    final success = _helpRequests.length < initialLength;
    if (success) {
      AppLogger.info('Hilfe-Anfrage gelöscht: $id');
    }
    return success;
  }

  @override
  Future<List<HelpRequest>> getHelpRequestsByCategory(String category) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _helpRequests.where((req) => req.category == category).toList();
  }

  @override
  Future<List<HelpRequest>> getHelpRequestsByStatus(String status) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _helpRequests.where((req) => req.status == status).toList();
  }

  @override
  Future<List<HelpRequest>> getHelpRequestsByUser(String userId) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _helpRequests.where((req) => req.requesterId == userId).toList();
  }

  @override
  Future<List<HelpRequest>> searchHelpRequests(String query) async {
    await Future.delayed(Duration(milliseconds: 400 + _random.nextInt(500)));
    final lowercaseQuery = query.toLowerCase();
    return _helpRequests
        .where((req) =>
            req.title.toLowerCase().contains(lowercaseQuery) ||
            req.description.toLowerCase().contains(lowercaseQuery) ||
            req.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
        .toList();
  }

  @override
  Future<HelpOffer> createHelpOffer(HelpOffer offer) async {
    await Future.delayed(Duration(milliseconds: 400 + _random.nextInt(600)));
    _helpOffers.add(offer);
    AppLogger.info('Hilfe-Angebot erstellt: ${offer.helperName}');
    return offer;
  }

  @override
  Future<HelpOffer?> getHelpOffer(String id) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    try {
      return _helpOffers.firstWhere((offer) => offer.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<HelpOffer>> getAllHelpOffers() async {
    await Future.delayed(Duration(milliseconds: 400 + _random.nextInt(600)));
    AppLogger.info('Alle Hilfe-Angebote geladen: ${_helpOffers.length}');
    return List.from(_helpOffers);
  }

  @override
  Future<HelpOffer> updateHelpOffer(HelpOffer offer) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    final index = _helpOffers.indexWhere((o) => o.id == offer.id);
    if (index != -1) {
      _helpOffers[index] = offer;
      AppLogger.info('Hilfe-Angebot aktualisiert: ${offer.helperName}');
      return _helpOffers[index];
    }
    throw Exception('Hilfe-Angebot nicht gefunden: ${offer.id}');
  }

  @override
  Future<bool> deleteHelpOffer(String id) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    final initialLength = _helpOffers.length;
    _helpOffers.removeWhere((offer) => offer.id == id);
    final success = _helpOffers.length < initialLength;
    if (success) {
      AppLogger.info('Hilfe-Angebot gelöscht: $id');
    }
    return success;
  }

  @override
  Future<List<HelpOffer>> getHelpOffersByRequest(String helpRequestId) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _helpOffers
        .where((offer) => offer.helpRequestId == helpRequestId)
        .toList();
  }

  @override
  Future<List<HelpOffer>> getHelpOffersByHelper(String helperId) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _helpOffers.where((offer) => offer.helperId == helperId).toList();
  }

  @override
  Future<List<HelpOffer>> getHelpOffersByStatus(String status) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _helpOffers.where((offer) => offer.status == status).toList();
  }

  @override
  Future<bool> acceptHelpOffer(String offerId) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    final offer = _helpOffers.firstWhere((o) => o.id == offerId);
    final updatedOffer = offer.copyWith(status: 'accepted');
    final index = _helpOffers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      _helpOffers[index] = updatedOffer;
      AppLogger.info('Hilfe-Angebot akzeptiert: $offerId');
      return true;
    }
    return false;
  }

  @override
  Future<bool> rejectHelpOffer(String offerId) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    final offer = _helpOffers.firstWhere((o) => o.id == offerId);
    final updatedOffer = offer.copyWith(status: 'rejected');
    final index = _helpOffers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      _helpOffers[index] = updatedOffer;
      AppLogger.info('Hilfe-Angebot abgelehnt: $offerId');
      return true;
    }
    return false;
  }

  @override
  Future<HelpChat> sendChatMessage(HelpChat message) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    _helpChats.add(message);
    AppLogger.info('Chat-Nachricht gesendet: ${message.senderName}');
    return message;
  }

  @override
  Future<List<HelpChat>> getChatMessages(String helpRequestId) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _helpChats
        .where((chat) => chat.helpRequestId == helpRequestId)
        .toList();
  }

  @override
  Future<bool> markChatMessageAsRead(String messageId) async {
    await Future.delayed(Duration(milliseconds: 100 + _random.nextInt(200)));
    final index = _helpChats.indexWhere((chat) => chat.id == messageId);
    if (index != -1) {
      final message = _helpChats[index];
      _helpChats[index] = message.copyWith(isRead: true);
      return true;
    }
    return false;
  }

  @override
  Future<Map<String, dynamic>> generateHelpStatistics() async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(800)));
    AppLogger.info('Help Network Statistiken generiert');

    // Verwende das Help Network Mock-Data Repository für bessere Statistiken
    return _helpMockData.generateStatistics();
  }

  @override
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    AppLogger.info('Benutzer-Benachrichtigungen geladen für: $userId');

    // Verwende das Help Network Mock-Data Repository für Benachrichtigungen
    return _helpMockData.generateUserNotifications(userId);
  }

  @override
  Future<bool> markNotificationAsRead(String notificationId) async {
    await Future.delayed(Duration(milliseconds: 100 + _random.nextInt(200)));
    AppLogger.info('Benachrichtigung als gelesen markiert: $notificationId');
    return true;
  }

  @override
  Future<bool> sendPushNotification(
      String userId, String title, String message) async {
    await Future.delayed(Duration(milliseconds: 400 + _random.nextInt(600)));
    AppLogger.info('Push-Benachrichtigung gesendet an $userId: $title');
    return true;
  }

  @override
  Future<Map<String, dynamic>> exportHelpData() async {
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1200)));
    AppLogger.info('Help Network Daten exportiert');

    // Verwende das Help Network Mock-Data Repository für Export
    return _helpMockData.exportData();
  }

  @override
  Future<bool> importHelpData(Map<String, dynamic> data) async {
    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(1500)));
    AppLogger.info('Help Network Daten importiert');

    try {
      _helpMockData.importData(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> createBackup() async {
    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(2000)));
    AppLogger.info('Help Network Backup erstellt');

    // Verwende das Help Network Mock-Data Repository für Backup
    return _helpMockData.createBackup();
  }

  @override
  Future<bool> restoreBackup(Map<String, dynamic> backup) async {
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1500)));
    AppLogger.info('Help Network Backup wiederhergestellt');

    // Verwende das Help Network Mock-Data Repository für Restore
    return _helpMockData.restoreBackup(backup);
  }
}
