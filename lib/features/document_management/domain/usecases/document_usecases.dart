// features/document_management/domain/usecases/document_usecases.dart
import '../entities/document.dart';
import '../repositories/document_repository.dart';

/// Use Case: Dokument erstellen
class CreateDocumentUseCase {
  final DocumentRepository _repository;

  CreateDocumentUseCase(this._repository);

  Future<Document> call(Document document) async {
    // Validiere das Dokument
    final isValid = await _repository.validateDocument(document);
    if (!isValid) {
      throw Exception('Dokument ist nicht gültig');
    }

    // Generiere eine neue ID falls nicht vorhanden
    final documentWithId = document.id.isEmpty
        ? document.copyWith(id: await _repository.generateDocumentId())
        : document;

    // Erstelle das Dokument
    return await _repository.createDocument(documentWithId);
  }
}

/// Use Case: Dokument aktualisieren
class UpdateDocumentUseCase {
  final DocumentRepository _repository;

  UpdateDocumentUseCase(this._repository);

  Future<Document> call(Document document) async {
    // Prüfe ob das Dokument existiert
    final exists = await _repository.documentExists(document.id);
    if (!exists) {
      throw Exception('Dokument nicht gefunden');
    }

    // Validiere das Dokument
    final isValid = await _repository.validateDocument(document);
    if (!isValid) {
      throw Exception('Dokument ist nicht gültig');
    }

    // Aktualisiere das Dokument
    return await _repository.updateDocument(document);
  }
}

/// Use Case: Dokument löschen
class DeleteDocumentUseCase {
  final DocumentRepository _repository;

  DeleteDocumentUseCase(this._repository);

  Future<bool> call(String documentId) async {
    // Prüfe ob das Dokument existiert
    final exists = await _repository.documentExists(documentId);
    if (!exists) {
      throw Exception('Dokument nicht gefunden');
    }

    // Lösche das Dokument
    return await _repository.deleteDocument(documentId);
  }
}

/// Use Case: Dokument anhand ID abrufen
class GetDocumentByIdUseCase {
  final DocumentRepository _repository;

  GetDocumentByIdUseCase(this._repository);

  Future<Document?> call(String documentId) async {
    return await _repository.getDocumentById(documentId);
  }
}

/// Use Case: Alle Dokumente abrufen
class GetAllDocumentsUseCase {
  final DocumentRepository _repository;

  GetAllDocumentsUseCase(this._repository);

  Future<List<Document>> call() async {
    return await _repository.getAllDocuments();
  }
}

/// Use Case: Dokumente nach Fall abrufen
class GetDocumentsByCaseIdUseCase {
  final DocumentRepository _repository;

  GetDocumentsByCaseIdUseCase(this._repository);

  Future<List<Document>> call(String caseId) async {
    return await _repository.getDocumentsByCaseId(caseId);
  }
}

/// Use Case: Dokumente nach Kategorie abrufen
class GetDocumentsByCategoryUseCase {
  final DocumentRepository _repository;

  GetDocumentsByCategoryUseCase(this._repository);

  Future<List<Document>> call(DocumentCategory category) async {
    return await _repository.getDocumentsByCategory(category);
  }
}

/// Use Case: Dokumente nach Status abrufen
class GetDocumentsByStatusUseCase {
  final DocumentRepository _repository;

  GetDocumentsByStatusUseCase(this._repository);

  Future<List<Document>> call(DocumentStatus status) async {
    return await _repository.getDocumentsByStatus(status);
  }
}

/// Use Case: Dokumente suchen
class SearchDocumentsUseCase {
  final DocumentRepository _repository;

  SearchDocumentsUseCase(this._repository);

  Future<List<Document>> call(String query) async {
    if (query.trim().isEmpty) {
      return await _repository.getAllDocuments();
    }
    return await _repository.searchDocuments(query);
  }
}

/// Use Case: Dokumente nach Benutzer abrufen
class GetDocumentsByUserUseCase {
  final DocumentRepository _repository;

  GetDocumentsByUserUseCase(this._repository);

  Future<List<Document>> call(String userId) async {
    return await _repository.getDocumentsByUser(userId);
  }
}

/// Use Case: Dokument verschlüsseln
class EncryptDocumentUseCase {
  final DocumentRepository _repository;

  EncryptDocumentUseCase(this._repository);

  Future<Document> call(String documentId, String encryptionKeyId) async {
    // Prüfe ob das Dokument existiert
    final exists = await _repository.documentExists(documentId);
    if (!exists) {
      throw Exception('Dokument nicht gefunden');
    }

    // Prüfe ob das Dokument bereits verschlüsselt ist
    final isEncrypted = await _repository.isDocumentEncrypted(documentId);
    if (isEncrypted) {
      throw Exception('Dokument ist bereits verschlüsselt');
    }

    // Verschlüssele das Dokument
    return await _repository.encryptDocument(documentId, encryptionKeyId);
  }
}

/// Use Case: Dokument entschlüsseln
class DecryptDocumentUseCase {
  final DocumentRepository _repository;

  DecryptDocumentUseCase(this._repository);

  Future<Document> call(String documentId) async {
    // Prüfe ob das Dokument existiert
    final exists = await _repository.documentExists(documentId);
    if (!exists) {
      throw Exception('Dokument nicht gefunden');
    }

    // Prüfe ob das Dokument verschlüsselt ist
    final isEncrypted = await _repository.isDocumentEncrypted(documentId);
    if (!isEncrypted) {
      throw Exception('Dokument ist nicht verschlüsselt');
    }

    // Entschlüssele das Dokument
    return await _repository.decryptDocument(documentId);
  }
}

/// Use Case: Dokument exportieren
class ExportDocumentUseCase {
  final DocumentRepository _repository;

  ExportDocumentUseCase(this._repository);

  Future<String> call(String documentId, String format) async {
    // Prüfe ob das Dokument existiert
    final exists = await _repository.documentExists(documentId);
    if (!exists) {
      throw Exception('Dokument nicht gefunden');
    }

    // Validiere das Format
    final validFormats = ['pdf', 'docx', 'txt', 'html'];
    if (!validFormats.contains(format.toLowerCase())) {
      throw Exception('Ungültiges Export-Format');
    }

    // Exportiere das Dokument
    return await _repository.exportDocument(documentId, format);
  }
}

/// Use Case: Dokument importieren
class ImportDocumentUseCase {
  final DocumentRepository _repository;

  ImportDocumentUseCase(this._repository);

  Future<Document> call(String filePath, String userId) async {
    // Validiere die Datei
    if (filePath.isEmpty) {
      throw Exception('Dateipfad ist leer');
    }

    // Importiere das Dokument
    return await _repository.importDocument(filePath, userId);
  }
}

/// Use Case: Backup erstellen
class CreateBackupUseCase {
  final DocumentRepository _repository;

  CreateBackupUseCase(this._repository);

  Future<String> call() async {
    return await _repository.createBackup();
  }
}

/// Use Case: Backup wiederherstellen
class RestoreBackupUseCase {
  final DocumentRepository _repository;

  RestoreBackupUseCase(this._repository);

  Future<bool> call(String backupPath) async {
    if (backupPath.isEmpty) {
      throw Exception('Backup-Pfad ist leer');
    }

    return await _repository.restoreBackup(backupPath);
  }
}

/// Use Case: Mit Cloud synchronisieren
class SyncWithCloudUseCase {
  final DocumentRepository _repository;

  SyncWithCloudUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.syncWithCloud();
  }
}

/// Use Case: Dokumenten-Statistiken abrufen
class GetDocumentStatisticsUseCase {
  final DocumentRepository _repository;

  GetDocumentStatisticsUseCase(this._repository);

  Future<Map<String, dynamic>> call() async {
    return await _repository.getDocumentStatistics();
  }
}

/// Use Case: Dokument validieren
class ValidateDocumentUseCase {
  final DocumentRepository _repository;

  ValidateDocumentUseCase(this._repository);

  Future<bool> call(Document document) async {
    return await _repository.validateDocument(document);
  }
}
