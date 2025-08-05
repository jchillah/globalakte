// features/epa_integration/data/repositories/epa_mock_data_repository.dart

import 'dart:math';

import '../../../../core/data/mock_data_repository.dart';

/// Mock Data Repository für EPA-Integration
/// Singleton-Pattern für zentrale Mock-Daten-Verwaltung
class EpaMockDataRepository {
  static final EpaMockDataRepository _instance =
      EpaMockDataRepository._internal();
  factory EpaMockDataRepository() => _instance;
  EpaMockDataRepository._internal();

  final MockDataRepository _mockData = MockDataRepository();

  /// EPA-Fälle laden
  List<Map<String, dynamic>> get epaCases => _mockData.epaCases;

  /// EPA-Dokumente laden
  List<Map<String, dynamic>> get epaDocuments => _mockData.epaDocuments;

  /// EPA-Benutzer laden
  List<Map<String, dynamic>> get epaUsers => _mockData.epaUsers;

  /// Neuen EPA-Fall erstellen
  Map<String, dynamic> createEpaCase({
    required String title,
    required String description,
    required String caseNumber,
    required String caseType,
    String status = 'active',
    String assignedUserId = 'user_001',
    String createdBy = 'system',
    List<String> tags = const [],
    String priority = 'medium',
    String? clientId,
    String? clientName,
    String? court,
    String? judge,
    DateTime? nextHearing,
    List<String> participants = const [],
  }) {
    return {
      'id': _mockData.getRandomId(),
      'title': title,
      'description': description,
      'caseNumber': caseNumber,
      'caseType': caseType,
      'status': status,
      'assignedUserId': assignedUserId,
      'createdBy': createdBy,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'closedAt': null,
      'tags': tags,
      'metadata': {
        'source': 'epa_system',
        'syncStatus': 'synced',
        'lastSync': DateTime.now().toIso8601String(),
      },
      'priority': priority,
      'clientId': clientId,
      'clientName': clientName,
      'court': court,
      'judge': judge,
      'nextHearing': nextHearing?.toIso8601String(),
      'participants': participants,
    };
  }

  /// Neues EPA-Dokument erstellen
  Map<String, dynamic> createEpaDocument({
    required String title,
    required String description,
    required String caseId,
    required String documentType,
    required String fileName,
    required int fileSize,
    required String mimeType,
    String status = 'available',
    String uploadedBy = 'system',
    List<String> tags = const [],
    bool isEncrypted = false,
    String category = 'other',
  }) {
    return {
      'id': _mockData.getRandomId(),
      'title': title,
      'description': description,
      'caseId': caseId,
      'documentType': documentType,
      'filePath': '/epa/documents/$fileName',
      'fileName': fileName,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'status': status,
      'uploadedBy': uploadedBy,
      'uploadedAt': DateTime.now(),
      'lastModified': DateTime.now(),
      'version': '1.0',
      'tags': tags,
      'metadata': {
        'source': 'epa_system',
        'syncStatus': 'synced',
        'lastSync': DateTime.now().toIso8601String(),
      },
      'isEncrypted': isEncrypted,
      'encryptionKeyId': isEncrypted ? 'key_${_mockData.getRandomId()}' : null,
      'checksum': 'sha256_${_mockData.getRandomId()}',
      'category': category,
    };
  }

  /// Neuen EPA-Benutzer erstellen
  Map<String, dynamic> createEpaUser({
    required String username,
    required String email,
    required String fullName,
    String role = 'user',
    String status = 'active',
    List<String> permissions = const [],
    String? department,
    String? phone,
  }) {
    return {
      'id': _mockData.getRandomId(),
      'username': username,
      'email': email,
      'fullName': fullName,
      'role': role,
      'status': status,
      'permissions': permissions,
      'department': department,
      'phone': phone,
      'createdAt': DateTime.now(),
      'lastLogin': DateTime.now(),
      'metadata': {
        'source': 'epa_system',
        'syncStatus': 'synced',
        'lastSync': DateTime.now().toIso8601String(),
      },
    };
  }

  /// EPA-Fall nach ID finden
  Map<String, dynamic>? findEpaCaseById(String id) {
    try {
      return epaCases.firstWhere((caseData) => caseData['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// EPA-Dokument nach ID finden
  Map<String, dynamic>? findEpaDocumentById(String id) {
    try {
      return epaDocuments.firstWhere((doc) => doc['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// EPA-Benutzer nach ID finden
  Map<String, dynamic>? findEpaUserById(String id) {
    try {
      return epaUsers.firstWhere((user) => user['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// EPA-Dokumente nach Fall-ID filtern
  List<Map<String, dynamic>> getDocumentsByCaseId(String caseId) {
    return epaDocuments.where((doc) => doc['caseId'] == caseId).toList();
  }

  /// EPA-Fälle nach Status filtern
  List<Map<String, dynamic>> getCasesByStatus(String status) {
    return epaCases.where((caseData) => caseData['status'] == status).toList();
  }

  /// EPA-Fälle nach Priorität filtern
  List<Map<String, dynamic>> getCasesByPriority(String priority) {
    return epaCases
        .where((caseData) => caseData['priority'] == priority)
        .toList();
  }

  /// EPA-Dokumente nach Typ filtern
  List<Map<String, dynamic>> getDocumentsByType(String documentType) {
    return epaDocuments
        .where((doc) => doc['documentType'] == documentType)
        .toList();
  }

  /// EPA-Statistiken generieren
  Map<String, dynamic> generateEpaStatistics() {
    final totalCases = epaCases.length;
    final activeCases = epaCases.where((c) => c['status'] == 'active').length;
    final closedCases = epaCases.where((c) => c['status'] == 'closed').length;
    final totalDocuments = epaDocuments.length;
    final encryptedDocuments =
        epaDocuments.where((d) => d['isEncrypted'] == true).length;
    final totalUsers = epaUsers.length;
    final activeUsers = epaUsers.where((u) => u['status'] == 'active').length;

    return {
      'totalCases': totalCases,
      'activeCases': activeCases,
      'closedCases': closedCases,
      'totalDocuments': totalDocuments,
      'encryptedDocuments': encryptedDocuments,
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
      'syncStatus': 'synced',
      'lastSync': DateTime.now().toIso8601String(),
    };
  }

  /// EPA-Daten exportieren
  Map<String, dynamic> exportEpaData() {
    return {
      'cases': epaCases,
      'documents': epaDocuments,
      'users': epaUsers,
      'statistics': generateEpaStatistics(),
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.0',
    };
  }

  /// EPA-Daten importieren
  void importEpaData(Map<String, dynamic> data) {
    // Mock-Import-Funktionalität
    // In einer echten Implementierung würde hier die Daten validiert und importiert
  }

  /// EPA-Backup erstellen
  Map<String, dynamic> createEpaBackup() {
    return {
      'backupId': _mockData.getRandomId(),
      'data': exportEpaData(),
      'createdAt': DateTime.now().toIso8601String(),
      'size':
          '${epaCases.length + epaDocuments.length + epaUsers.length} records',
    };
  }

  /// EPA-Backup wiederherstellen
  void restoreEpaBackup(Map<String, dynamic> backup) {
    // Mock-Restore-Funktionalität
    // In einer echten Implementierung würde hier das Backup wiederhergestellt
  }

  /// EPA-Synchronisation simulieren
  Future<Map<String, dynamic>> syncWithEpa() async {
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));

    return {
      'syncStatus': 'success',
      'syncedCases': epaCases.length,
      'syncedDocuments': epaDocuments.length,
      'syncedUsers': epaUsers.length,
      'syncTimestamp': DateTime.now().toIso8601String(),
      'conflicts': 0,
      'errors': 0,
    };
  }

  /// EPA-Konflikte auflösen
  List<Map<String, dynamic>> resolveEpaConflicts() {
    return [
      {
        'conflictId': _mockData.getRandomId(),
        'type': 'case_update',
        'localVersion': 'v1.2',
        'remoteVersion': 'v1.3',
        'resolved': true,
        'resolution': 'merge',
        'resolvedAt': DateTime.now().toIso8601String(),
      },
      {
        'conflictId': _mockData.getRandomId(),
        'type': 'document_upload',
        'localVersion': 'v1.0',
        'remoteVersion': 'v1.1',
        'resolved': true,
        'resolution': 'keep_remote',
        'resolvedAt': DateTime.now().toIso8601String(),
      },
    ];
  }
}
