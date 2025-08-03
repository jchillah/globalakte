// features/case_timeline/domain/repositories/case_file_repository.dart
import '../entities/case_file.dart';
import '../entities/timeline_event.dart';

/// CaseFileRepository Interface - Definiert die Fallakten-Operationen
abstract class CaseFileRepository {
  /// Fallakte erstellen
  Future<CaseFile> createCaseFile(CaseFile caseFile);

  /// Fallakte abrufen
  Future<CaseFile?> getCaseFile(String id);

  /// Alle Fallakten abrufen
  Future<List<CaseFile>> getAllCaseFiles();

  /// Fallakten nach Status filtern
  Future<List<CaseFile>> getCaseFilesByStatus(String status);

  /// Fallakten nach Kategorie filtern
  Future<List<CaseFile>> getCaseFilesByCategory(String category);

  /// Fallakten suchen
  Future<List<CaseFile>> searchCaseFiles(String query);

  /// Fallakte aktualisieren
  Future<CaseFile> updateCaseFile(CaseFile caseFile);

  /// Fallakte löschen
  Future<void> deleteCaseFile(String id);

  /// Timeline Event erstellen
  Future<TimelineEvent> createTimelineEvent(TimelineEvent event);

  /// Timeline Events für eine Fallakte abrufen
  Future<List<TimelineEvent>> getTimelineEvents(String caseFileId);

  /// Timeline Event aktualisieren
  Future<TimelineEvent> updateTimelineEvent(TimelineEvent event);

  /// Timeline Event löschen
  Future<void> deleteTimelineEvent(String id);

  /// Dokument zu Fallakte hinzufügen
  Future<void> addDocumentToCaseFile(String caseFileId, String documentId);

  /// Dokument von Fallakte entfernen
  Future<void> removeDocumentFromCaseFile(String caseFileId, String documentId);

  /// ePA-Integration Status prüfen
  Future<bool> checkEpaIntegration(String caseFileId);

  /// ePA-Integration aktivieren
  Future<void> enableEpaIntegration(String caseFileId);

  /// ePA-Integration deaktivieren
  Future<void> disableEpaIntegration(String caseFileId);

  /// ePA-Status abrufen
  Future<String?> getEpaStatus(String caseFileId);

  /// Fallakte mit ePA synchronisieren
  Future<void> syncWithEpa(String caseFileId);

  /// Statistiken abrufen
  Future<Map<String, dynamic>> getCaseFileStatistics();

  /// Backup erstellen
  Future<void> createBackup();

  /// Backup wiederherstellen
  Future<void> restoreBackup(String backupId);

  /// Validierung für Fallakte
  bool isValidCaseFile(CaseFile caseFile);

  /// Validierung für Timeline Event
  bool isValidTimelineEvent(TimelineEvent event);

  /// Generiert eine eindeutige Fallnummer
  Future<String> generateCaseNumber();

  /// Prüft ob Fallnummer bereits existiert
  Future<bool> isCaseNumberExists(String caseNumber);
}
