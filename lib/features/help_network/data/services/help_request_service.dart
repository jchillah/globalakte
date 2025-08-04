// features/help_network/data/services/help_request_service.dart
import '../../domain/entities/help_request.dart';

/// Service für Help Request Operationen
class HelpRequestService {
  final List<HelpRequest> _helpRequests = [];

  HelpRequestService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock Hilfe-Anfragen
    _helpRequests.addAll([
      HelpRequest.create(
        title: 'Hilfe bei Behördengang',
        description:
            'Ich brauche Hilfe beim Ausfüllen von Formularen für die Arbeitsagentur.',
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
        description:
            'Suche jemanden, der mir bei der Übersetzung von medizinischen Dokumenten helfen kann.',
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
  }

  // CRUD Operationen
  Future<List<HelpRequest>> getAllHelpRequests() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_helpRequests);
  }

  Future<List<HelpRequest>> getHelpRequestsByCategory(String category) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpRequests
        .where((request) => request.category == category)
        .toList();
  }

  Future<List<HelpRequest>> getHelpRequestsByStatus(String status) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpRequests.where((request) => request.status == status).toList();
  }

  Future<List<HelpRequest>> getHelpRequestsByUser(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpRequests
        .where((request) => request.requesterId == userId)
        .toList();
  }

  Future<List<HelpRequest>> searchHelpRequests(String query) async {
    await Future.delayed(Duration(milliseconds: 400));
    final lowercaseQuery = query.toLowerCase();
    return _helpRequests.where((request) {
      return request.title.toLowerCase().contains(lowercaseQuery) ||
          request.description.toLowerCase().contains(lowercaseQuery) ||
          request.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Future<HelpRequest?> getHelpRequestById(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      return _helpRequests.firstWhere((request) => request.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createHelpRequest(HelpRequest request) async {
    await Future.delayed(Duration(milliseconds: 200));
    _helpRequests.add(request);
  }

  Future<void> updateHelpRequest(HelpRequest request) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _helpRequests.indexWhere((r) => r.id == request.id);
    if (index != -1) {
      _helpRequests[index] = request;
    }
  }

  Future<void> deleteHelpRequest(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _helpRequests.removeWhere((request) => request.id == id);
  }

  Future<void> acceptHelpOffer(String requestId, String helperId) async {
    await Future.delayed(Duration(milliseconds: 300));
    final requestIndex = _helpRequests.indexWhere((r) => r.id == requestId);

    if (requestIndex != -1) {
      final request = _helpRequests[requestIndex];
      final updatedRequest = request.copyWith(
        status: 'in_progress',
        acceptedHelpers: [...request.acceptedHelpers, helperId],
      );
      _helpRequests[requestIndex] = updatedRequest;
    }
  }

  Future<void> completeHelpRequest(String requestId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final requestIndex = _helpRequests.indexWhere((r) => r.id == requestId);
    if (requestIndex != -1) {
      final request = _helpRequests[requestIndex];
      final updatedRequest = request.copyWith(
        status: 'completed',
      );
      _helpRequests[requestIndex] = updatedRequest;
    }
  }

  Future<void> cancelHelpRequest(String requestId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final requestIndex = _helpRequests.indexWhere((r) => r.id == requestId);
    if (requestIndex != -1) {
      final request = _helpRequests[requestIndex];
      final updatedRequest = request.copyWith(status: 'cancelled');
      _helpRequests[requestIndex] = updatedRequest;
    }
  }
}
