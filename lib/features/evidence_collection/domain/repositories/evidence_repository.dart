// features/evidence_collection/domain/repositories/evidence_repository.dart
import '../entities/evidence_item.dart';

/// Repository Interface für Beweismittel-Verwaltung
abstract class EvidenceRepository {
  /// Alle Beweismittel abrufen
  Future<List<EvidenceItem>> getAllEvidence();

  /// Beweismittel nach ID abrufen
  Future<EvidenceItem?> getEvidenceById(String id);

  /// Beweismittel nach Fall-ID abrufen
  Future<List<EvidenceItem>> getEvidenceByCaseId(String caseId);

  /// Beweismittel nach Status abrufen
  Future<List<EvidenceItem>> getEvidenceByStatus(String status);

  /// Beweismittel nach Typ abrufen
  Future<List<EvidenceItem>> getEvidenceByType(String type);

  /// Neues Beweismittel speichern
  Future<void> saveEvidence(EvidenceItem evidence);

  /// Beweismittel aktualisieren
  Future<void> updateEvidence(EvidenceItem evidence);

  /// Beweismittel löschen
  Future<void> deleteEvidence(String id);

  /// Beweismittel suchen
  Future<List<EvidenceItem>> searchEvidence(String query);

  /// Beweismittel-Statistiken abrufen
  Future<Map<String, dynamic>> getEvidenceStatistics();

  /// Beweismittel exportieren
  Future<String> exportEvidence({String format = 'json'});

  /// Beweismittel importieren
  Future<void> importEvidence(String data, {String format = 'json'});

  /// Beweismittel validieren
  Future<bool> validateEvidence(EvidenceItem evidence);

  /// Beweismittel verifizieren
  Future<void> verifyEvidence(String id, String verifiedBy);

  /// Beweismittel ablehnen
  Future<void> rejectEvidence(String id, String reason);

  /// Beweismittel archivieren
  Future<void> archiveEvidence(String id);

  /// Beweismittel-Kette erstellen
  Future<void> createEvidenceChain(List<String> evidenceIds, String chainName);

  /// Beweismittel-Kette abrufen
  Future<List<EvidenceItem>> getEvidenceChain(String chainId);

  /// Beweismittel-Kette löschen
  Future<void> deleteEvidenceChain(String chainId);
} 