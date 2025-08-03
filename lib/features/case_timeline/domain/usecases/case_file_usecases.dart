import '../entities/case_file.dart';
import '../entities/timeline_event.dart';
import '../repositories/case_file_repository.dart';

/// Use Case: Fallakte erstellen
class CreateCaseFileUseCase {
  final CaseFileRepository _repository;

  CreateCaseFileUseCase(this._repository);

  Future<CaseFile> call(CaseFile caseFile) async {
    if (!_repository.isValidCaseFile(caseFile)) {
      throw ArgumentError('Ungültige Fallakte-Daten');
    }

    // Generiere Fallnummer falls nicht vorhanden
    if (caseFile.caseNumber.isEmpty) {
      final caseNumber = await _repository.generateCaseNumber();
      caseFile = caseFile.copyWith(caseNumber: caseNumber);
    }

    return await _repository.createCaseFile(caseFile);
  }
}

/// Use Case: Fallakte abrufen
class GetCaseFileUseCase {
  final CaseFileRepository _repository;

  GetCaseFileUseCase(this._repository);

  Future<CaseFile?> call(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Fallakte-ID darf nicht leer sein');
    }

    return await _repository.getCaseFile(id);
  }
}

/// Use Case: Alle Fallakten abrufen
class GetAllCaseFilesUseCase {
  final CaseFileRepository _repository;

  GetAllCaseFilesUseCase(this._repository);

  Future<List<CaseFile>> call() async {
    return await _repository.getAllCaseFiles();
  }
}

/// Use Case: Fallakten nach Status filtern
class GetCaseFilesByStatusUseCase {
  final CaseFileRepository _repository;

  GetCaseFilesByStatusUseCase(this._repository);

  Future<List<CaseFile>> call(String status) async {
    if (status.isEmpty) {
      throw ArgumentError('Status darf nicht leer sein');
    }

    return await _repository.getCaseFilesByStatus(status);
  }
}

/// Use Case: Fallakten suchen
class SearchCaseFilesUseCase {
  final CaseFileRepository _repository;

  SearchCaseFilesUseCase(this._repository);

  Future<List<CaseFile>> call(String query) async {
    if (query.isEmpty) {
      return await _repository.getAllCaseFiles();
    }

    return await _repository.searchCaseFiles(query);
  }
}

/// Use Case: Fallakte aktualisieren
class UpdateCaseFileUseCase {
  final CaseFileRepository _repository;

  UpdateCaseFileUseCase(this._repository);

  Future<CaseFile> call(CaseFile caseFile) async {
    if (!_repository.isValidCaseFile(caseFile)) {
      throw ArgumentError('Ungültige Fallakte-Daten');
    }

    return await _repository.updateCaseFile(caseFile);
  }
}

/// Use Case: Fallakte löschen
class DeleteCaseFileUseCase {
  final CaseFileRepository _repository;

  DeleteCaseFileUseCase(this._repository);

  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Fallakte-ID darf nicht leer sein');
    }

    await _repository.deleteCaseFile(id);
  }
}

/// Use Case: Timeline Event erstellen
class CreateTimelineEventUseCase {
  final CaseFileRepository _repository;

  CreateTimelineEventUseCase(this._repository);

  Future<TimelineEvent> call(TimelineEvent event) async {
    if (!_repository.isValidTimelineEvent(event)) {
      throw ArgumentError('Ungültige Timeline Event-Daten');
    }

    return await _repository.createTimelineEvent(event);
  }
}

/// Use Case: Timeline Events abrufen
class GetTimelineEventsUseCase {
  final CaseFileRepository _repository;

  GetTimelineEventsUseCase(this._repository);

  Future<List<TimelineEvent>> call(String caseFileId) async {
    if (caseFileId.isEmpty) {
      throw ArgumentError('Fallakte-ID darf nicht leer sein');
    }

    return await _repository.getTimelineEvents(caseFileId);
  }
}

/// Use Case: Timeline Event aktualisieren
class UpdateTimelineEventUseCase {
  final CaseFileRepository _repository;

  UpdateTimelineEventUseCase(this._repository);

  Future<TimelineEvent> call(TimelineEvent event) async {
    if (!_repository.isValidTimelineEvent(event)) {
      throw ArgumentError('Ungültige Timeline Event-Daten');
    }

    return await _repository.updateTimelineEvent(event);
  }
}

/// Use Case: Timeline Event löschen
class DeleteTimelineEventUseCase {
  final CaseFileRepository _repository;

  DeleteTimelineEventUseCase(this._repository);

  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Event-ID darf nicht leer sein');
    }

    await _repository.deleteTimelineEvent(id);
  }
}

/// Use Case: Dokument zu Fallakte hinzufügen
class AddDocumentToCaseFileUseCase {
  final CaseFileRepository _repository;

  AddDocumentToCaseFileUseCase(this._repository);

  Future<void> call(String caseFileId, String documentId) async {
    if (caseFileId.isEmpty || documentId.isEmpty) {
      throw ArgumentError('Fallakte-ID und Dokument-ID dürfen nicht leer sein');
    }

    await _repository.addDocumentToCaseFile(caseFileId, documentId);
  }
}

/// Use Case: Dokument von Fallakte entfernen
class RemoveDocumentFromCaseFileUseCase {
  final CaseFileRepository _repository;

  RemoveDocumentFromCaseFileUseCase(this._repository);

  Future<void> call(String caseFileId, String documentId) async {
    if (caseFileId.isEmpty || documentId.isEmpty) {
      throw ArgumentError('Fallakte-ID und Dokument-ID dürfen nicht leer sein');
    }

    await _repository.removeDocumentFromCaseFile(caseFileId, documentId);
  }
}

/// Use Case: ePA-Integration aktivieren
class EnableEpaIntegrationUseCase {
  final CaseFileRepository _repository;

  EnableEpaIntegrationUseCase(this._repository);

  Future<void> call(String caseFileId) async {
    if (caseFileId.isEmpty) {
      throw ArgumentError('Fallakte-ID darf nicht leer sein');
    }

    await _repository.enableEpaIntegration(caseFileId);
  }
}

/// Use Case: ePA-Integration deaktivieren
class DisableEpaIntegrationUseCase {
  final CaseFileRepository _repository;

  DisableEpaIntegrationUseCase(this._repository);

  Future<void> call(String caseFileId) async {
    if (caseFileId.isEmpty) {
      throw ArgumentError('Fallakte-ID darf nicht leer sein');
    }

    await _repository.disableEpaIntegration(caseFileId);
  }
}

/// Use Case: ePA-Status abrufen
class GetEpaStatusUseCase {
  final CaseFileRepository _repository;

  GetEpaStatusUseCase(this._repository);

  Future<String?> call(String caseFileId) async {
    if (caseFileId.isEmpty) {
      throw ArgumentError('Fallakte-ID darf nicht leer sein');
    }

    return await _repository.getEpaStatus(caseFileId);
  }
}

/// Use Case: Mit ePA synchronisieren
class SyncWithEpaUseCase {
  final CaseFileRepository _repository;

  SyncWithEpaUseCase(this._repository);

  Future<void> call(String caseFileId) async {
    if (caseFileId.isEmpty) {
      throw ArgumentError('Fallakte-ID darf nicht leer sein');
    }

    await _repository.syncWithEpa(caseFileId);
  }
}

/// Use Case: Statistiken abrufen
class GetCaseFileStatisticsUseCase {
  final CaseFileRepository _repository;

  GetCaseFileStatisticsUseCase(this._repository);

  Future<Map<String, dynamic>> call() async {
    return await _repository.getCaseFileStatistics();
  }
}

/// Use Case: Backup erstellen
class CreateBackupUseCase {
  final CaseFileRepository _repository;

  CreateBackupUseCase(this._repository);

  Future<void> call() async {
    await _repository.createBackup();
  }
}

/// Use Case: Backup wiederherstellen
class RestoreBackupUseCase {
  final CaseFileRepository _repository;

  RestoreBackupUseCase(this._repository);

  Future<void> call(String backupId) async {
    if (backupId.isEmpty) {
      throw ArgumentError('Backup-ID darf nicht leer sein');
    }

    await _repository.restoreBackup(backupId);
  }
} 