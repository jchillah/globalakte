// features/epa_integration/data/api/epa_api_client.dart
import '../models/epa_case.dart';
import '../models/epa_document.dart';
import '../models/epa_response.dart';
import '../models/epa_user.dart';

/// Interface für den ePA API Client
abstract class EpaApiClient {
  /// Authentifizierung mit ePA-System
  Future<EpaResponse<EpaUser>> authenticate(String username, String password);

  /// ePA-Fälle abrufen
  Future<EpaResponse<List<EpaCase>>> getCases({
    String? userId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Einzelnen ePA-Fall abrufen
  Future<EpaResponse<EpaCase>> getCase(String caseId);

  /// ePA-Dokumente für einen Fall abrufen
  Future<EpaResponse<List<EpaDocument>>> getCaseDocuments(String caseId);

  /// Einzelnes ePA-Dokument abrufen
  Future<EpaResponse<EpaDocument>> getDocument(String documentId);

  /// ePA-Dokument herunterladen
  Future<EpaResponse<String>> downloadDocument(String documentId);

  /// ePA-Fall erstellen
  Future<EpaResponse<EpaCase>> createCase(EpaCase epaCase);

  /// ePA-Fall aktualisieren
  Future<EpaResponse<EpaCase>> updateCase(String caseId, EpaCase epaCase);

  /// ePA-Dokument hochladen
  Future<EpaResponse<EpaDocument>> uploadDocument(
      String caseId, EpaDocument document);

  /// ePA-Fall löschen
  Future<EpaResponse<bool>> deleteCase(String caseId);

  /// ePA-Dokument löschen
  Future<EpaResponse<bool>> deleteDocument(String documentId);

  /// Synchronisationsstatus abrufen
  Future<EpaResponse<Map<String, dynamic>>> getSyncStatus();

  /// Offline-Änderungen synchronisieren
  Future<EpaResponse<Map<String, dynamic>>> syncOfflineChanges(
      List<Map<String, dynamic>> changes);

  /// Konflikt-Lösung für synchronisierte Daten
  Future<EpaResponse<Map<String, dynamic>>> resolveConflicts(
      List<Map<String, dynamic>> conflicts);

  /// API-Status prüfen
  Future<EpaResponse<Map<String, dynamic>>> checkApiStatus();

  /// Token erneuern
  Future<EpaResponse<String>> refreshToken(String refreshToken);

  /// Benutzer abmelden
  Future<EpaResponse<bool>> logout();

  /// Ressourcen freigeben
  void dispose();
}
