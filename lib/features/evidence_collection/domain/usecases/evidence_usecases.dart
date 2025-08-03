// features/evidence_collection/domain/usecases/evidence_usecases.dart
import '../entities/evidence_item.dart';
import '../repositories/evidence_repository.dart';

/// Use Case: Alle Beweismittel abrufen
class GetAllEvidenceUseCase {
  final EvidenceRepository repository;

  GetAllEvidenceUseCase(this.repository);

  Future<List<EvidenceItem>> call() async {
    return await repository.getAllEvidence();
  }
}

/// Use Case: Beweismittel nach ID abrufen
class GetEvidenceByIdUseCase {
  final EvidenceRepository repository;

  GetEvidenceByIdUseCase(this.repository);

  Future<EvidenceItem?> call(String id) async {
    return await repository.getEvidenceById(id);
  }
}

/// Use Case: Beweismittel nach Fall-ID abrufen
class GetEvidenceByCaseIdUseCase {
  final EvidenceRepository repository;

  GetEvidenceByCaseIdUseCase(this.repository);

  Future<List<EvidenceItem>> call(String caseId) async {
    return await repository.getEvidenceByCaseId(caseId);
  }
}

/// Use Case: Beweismittel nach Status abrufen
class GetEvidenceByStatusUseCase {
  final EvidenceRepository repository;

  GetEvidenceByStatusUseCase(this.repository);

  Future<List<EvidenceItem>> call(String status) async {
    return await repository.getEvidenceByStatus(status);
  }
}

/// Use Case: Beweismittel nach Typ abrufen
class GetEvidenceByTypeUseCase {
  final EvidenceRepository repository;

  GetEvidenceByTypeUseCase(this.repository);

  Future<List<EvidenceItem>> call(String type) async {
    return await repository.getEvidenceByType(type);
  }
}

/// Use Case: Neues Beweismittel speichern
class SaveEvidenceUseCase {
  final EvidenceRepository repository;

  SaveEvidenceUseCase(this.repository);

  Future<void> call(EvidenceItem evidence) async {
    await repository.saveEvidence(evidence);
  }
}

/// Use Case: Beweismittel aktualisieren
class UpdateEvidenceUseCase {
  final EvidenceRepository repository;

  UpdateEvidenceUseCase(this.repository);

  Future<void> call(EvidenceItem evidence) async {
    await repository.updateEvidence(evidence);
  }
}

/// Use Case: Beweismittel löschen
class DeleteEvidenceUseCase {
  final EvidenceRepository repository;

  DeleteEvidenceUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteEvidence(id);
  }
}

/// Use Case: Beweismittel suchen
class SearchEvidenceUseCase {
  final EvidenceRepository repository;

  SearchEvidenceUseCase(this.repository);

  Future<List<EvidenceItem>> call(String query) async {
    return await repository.searchEvidence(query);
  }
}

/// Use Case: Beweismittel-Statistiken abrufen
class GetEvidenceStatisticsUseCase {
  final EvidenceRepository repository;

  GetEvidenceStatisticsUseCase(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getEvidenceStatistics();
  }
}

/// Use Case: Beweismittel exportieren
class ExportEvidenceUseCase {
  final EvidenceRepository repository;

  ExportEvidenceUseCase(this.repository);

  Future<String> call({String format = 'json'}) async {
    return await repository.exportEvidence(format: format);
  }
}

/// Use Case: Beweismittel importieren
class ImportEvidenceUseCase {
  final EvidenceRepository repository;

  ImportEvidenceUseCase(this.repository);

  Future<void> call(String data, {String format = 'json'}) async {
    await repository.importEvidence(data, format: format);
  }
}

/// Use Case: Beweismittel validieren
class ValidateEvidenceUseCase {
  final EvidenceRepository repository;

  ValidateEvidenceUseCase(this.repository);

  Future<bool> call(EvidenceItem evidence) async {
    return await repository.validateEvidence(evidence);
  }
}

/// Use Case: Beweismittel verifizieren
class VerifyEvidenceUseCase {
  final EvidenceRepository repository;

  VerifyEvidenceUseCase(this.repository);

  Future<void> call(String id, String verifiedBy) async {
    await repository.verifyEvidence(id, verifiedBy);
  }
}

/// Use Case: Beweismittel ablehnen
class RejectEvidenceUseCase {
  final EvidenceRepository repository;

  RejectEvidenceUseCase(this.repository);

  Future<void> call(String id, String reason) async {
    await repository.rejectEvidence(id, reason);
  }
}

/// Use Case: Beweismittel archivieren
class ArchiveEvidenceUseCase {
  final EvidenceRepository repository;

  ArchiveEvidenceUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.archiveEvidence(id);
  }
}

/// Use Case: Beweismittel-Kette erstellen
class CreateEvidenceChainUseCase {
  final EvidenceRepository repository;

  CreateEvidenceChainUseCase(this.repository);

  Future<void> call(List<String> evidenceIds, String chainName) async {
    await repository.createEvidenceChain(evidenceIds, chainName);
  }
}

/// Use Case: Beweismittel-Kette abrufen
class GetEvidenceChainUseCase {
  final EvidenceRepository repository;

  GetEvidenceChainUseCase(this.repository);

  Future<List<EvidenceItem>> call(String chainId) async {
    return await repository.getEvidenceChain(chainId);
  }
}

/// Use Case: Beweismittel-Kette löschen
class DeleteEvidenceChainUseCase {
  final EvidenceRepository repository;

  DeleteEvidenceChainUseCase(this.repository);

  Future<void> call(String chainId) async {
    await repository.deleteEvidenceChain(chainId);
  }
} 