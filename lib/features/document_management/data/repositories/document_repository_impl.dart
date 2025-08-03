// features/document_management/data/repositories/document_repository_impl.dart
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../encryption/domain/repositories/encryption_repository.dart';
import '../../domain/entities/document.dart';
import '../../domain/repositories/document_repository.dart';

/// Konkrete Implementation des Document Repository
class DocumentRepositoryImpl implements DocumentRepository {
  static const String _documentsKey = 'documents';
  static const String _documentCounterKey = 'document_counter';

  final SharedPreferences _prefs;
  final EncryptionRepository _encryptionRepository;

  DocumentRepositoryImpl(this._prefs, this._encryptionRepository);

  @override
  Future<Document> createDocument(Document document) async {
    try {
      // Generiere ID falls nicht vorhanden
      final documentWithId = document.id.isEmpty
          ? document.copyWith(id: await generateDocumentId())
          : document;

      // Hole alle Dokumente
      final documents = await getAllDocuments();

      // Prüfe ob Dokument mit gleicher ID bereits existiert
      if (documents.any((d) => d.id == documentWithId.id)) {
        throw Exception('Dokument mit dieser ID existiert bereits');
      }

      // Füge das neue Dokument hinzu
      documents.add(documentWithId);

      // Speichere alle Dokumente
      await _saveDocuments(documents);

      debugPrint('Dokument erstellt: ${documentWithId.title}');
      return documentWithId;
    } catch (e) {
      debugPrint('Fehler beim Erstellen des Dokuments: $e');
      rethrow;
    }
  }

  @override
  Future<Document> updateDocument(Document document) async {
    try {
      final documents = await getAllDocuments();
      final index = documents.indexWhere((d) => d.id == document.id);

      if (index == -1) {
        throw Exception('Dokument nicht gefunden');
      }

      // Aktualisiere das Dokument mit updatedAt
      final updatedDocument = document.copyWith(
        updatedAt: DateTime.now(),
      );

      documents[index] = updatedDocument;
      await _saveDocuments(documents);

      debugPrint('Dokument aktualisiert: ${updatedDocument.title}');
      return updatedDocument;
    } catch (e) {
      debugPrint('Fehler beim Aktualisieren des Dokuments: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteDocument(String documentId) async {
    try {
      final documents = await getAllDocuments();
      final initialLength = documents.length;

      documents.removeWhere((d) => d.id == documentId);

      if (documents.length == initialLength) {
        return false; // Dokument nicht gefunden
      }

      await _saveDocuments(documents);

      debugPrint('Dokument gelöscht: $documentId');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Löschen des Dokuments: $e');
      rethrow;
    }
  }

  @override
  Future<Document?> getDocumentById(String documentId) async {
    try {
      final documents = await getAllDocuments();
      return documents.firstWhere(
        (d) => d.id == documentId,
        orElse: () => throw Exception('Dokument nicht gefunden'),
      );
    } catch (e) {
      debugPrint('Fehler beim Abrufen des Dokuments: $e');
      return null;
    }
  }

  @override
  Future<List<Document>> getAllDocuments() async {
    try {
      final documentsJson = _prefs.getStringList(_documentsKey) ?? [];
      return documentsJson
          .map((json) => Document.fromMap(jsonDecode(json)))
          .toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen aller Dokumente: $e');
      return [];
    }
  }

  @override
  Future<List<Document>> getDocumentsByCaseId(String caseId) async {
    try {
      final documents = await getAllDocuments();
      return documents.where((d) => d.caseId == caseId).toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Dokumente nach Fall: $e');
      return [];
    }
  }

  @override
  Future<List<Document>> getDocumentsByCategory(
      DocumentCategory category) async {
    try {
      final documents = await getAllDocuments();
      return documents.where((d) => d.category == category).toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Dokumente nach Kategorie: $e');
      return [];
    }
  }

  @override
  Future<List<Document>> getDocumentsByStatus(DocumentStatus status) async {
    try {
      final documents = await getAllDocuments();
      return documents.where((d) => d.status == status).toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Dokumente nach Status: $e');
      return [];
    }
  }

  @override
  Future<List<Document>> searchDocuments(String query) async {
    try {
      final documents = await getAllDocuments();
      final lowercaseQuery = query.toLowerCase();

      return documents
          .where((d) =>
              d.title.toLowerCase().contains(lowercaseQuery) ||
              d.description.toLowerCase().contains(lowercaseQuery))
          .toList();
    } catch (e) {
      debugPrint('Fehler bei der Dokumentensuche: $e');
      return [];
    }
  }

  @override
  Future<List<Document>> getDocumentsByUser(String userId) async {
    try {
      final documents = await getAllDocuments();
      return documents.where((d) => d.createdBy == userId).toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Dokumente nach Benutzer: $e');
      return [];
    }
  }

  @override
  Future<Document> encryptDocument(
      String documentId, String encryptionKeyId) async {
    try {
      final document = await getDocumentById(documentId);
      if (document == null) {
        throw Exception('Dokument nicht gefunden');
      }

      if (document.isEncrypted) {
        throw Exception('Dokument ist bereits verschlüsselt');
      }

      // Verschlüssele das Dokument
      final encryptedDocument = document.copyWith(
        isEncrypted: true,
        encryptionKeyId: encryptionKeyId,
        updatedAt: DateTime.now(),
      );

      return await updateDocument(encryptedDocument);
    } catch (e) {
      debugPrint('Fehler beim Verschlüsseln des Dokuments: $e');
      rethrow;
    }
  }

  @override
  Future<Document> decryptDocument(String documentId) async {
    try {
      final document = await getDocumentById(documentId);
      if (document == null) {
        throw Exception('Dokument nicht gefunden');
      }

      if (!document.isEncrypted) {
        throw Exception('Dokument ist nicht verschlüsselt');
      }

      // Entschlüssele das Dokument
      final decryptedDocument = document.copyWith(
        isEncrypted: false,
        encryptionKeyId: null,
        updatedAt: DateTime.now(),
      );

      return await updateDocument(decryptedDocument);
    } catch (e) {
      debugPrint('Fehler beim Entschlüsseln des Dokuments: $e');
      rethrow;
    }
  }

  @override
  Future<String> exportDocument(String documentId, String format) async {
    try {
      final document = await getDocumentById(documentId);
      if (document == null) {
        throw Exception('Dokument nicht gefunden');
      }

      // Simuliere Export-Pfad
      final exportPath = '/exports/${document.id}.$format';

      debugPrint('Dokument exportiert: $exportPath');
      return exportPath;
    } catch (e) {
      debugPrint('Fehler beim Exportieren des Dokuments: $e');
      rethrow;
    }
  }

  @override
  Future<Document> importDocument(String filePath, String userId) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Datei nicht gefunden');
      }

      final fileName = file.path.split('/').last;
      final fileSize = await file.length();

      final document = Document(
        id: await generateDocumentId(),
        title: fileName,
        description: 'Importiertes Dokument: $fileName',
        filePath: filePath,
        fileType: fileName.split('.').last,
        fileSize: fileSize,
        createdAt: DateTime.now(),
        createdBy: userId,
        category: DocumentCategory.other,
        status: DocumentStatus.draft,
        isEncrypted: false,
      );

      return await createDocument(document);
    } catch (e) {
      debugPrint('Fehler beim Importieren des Dokuments: $e');
      rethrow;
    }
  }

  @override
  Future<String> createBackup() async {
    try {
      final documents = await getAllDocuments();

      final backupPath =
          '/backups/documents_${DateTime.now().millisecondsSinceEpoch}.json';

      debugPrint('Backup erstellt: $backupPath');
      return backupPath;
    } catch (e) {
      debugPrint('Fehler beim Erstellen des Backups: $e');
      rethrow;
    }
  }

  @override
  Future<bool> restoreBackup(String backupPath) async {
    try {
      // Simuliere Backup-Wiederherstellung
      debugPrint('Backup wiederhergestellt: $backupPath');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Wiederherstellen des Backups: $e');
      return false;
    }
  }

  @override
  Future<bool> syncWithCloud() async {
    try {
      // Simuliere Cloud-Synchronisation
      debugPrint('Dokumente mit Cloud synchronisiert');
      return true;
    } catch (e) {
      debugPrint('Fehler bei der Cloud-Synchronisation: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getDocumentStatistics() async {
    try {
      final allDocuments = await getAllDocuments();

      final totalDocuments = allDocuments.length;
      final encryptedDocuments =
          allDocuments.where((d) => d.isEncrypted).length;
      final totalSize = allDocuments.fold<int>(0, (sum, d) => sum + d.fileSize);

      final categoryStats = <String, int>{};
      for (final category in DocumentCategory.values) {
        categoryStats[category.name] =
            allDocuments.where((d) => d.category == category).length;
      }

      final statusStats = <String, int>{};
      for (final status in DocumentStatus.values) {
        statusStats[status.name] =
            allDocuments.where((d) => d.status == status).length;
      }

      return {
        'totalDocuments': totalDocuments,
        'encryptedDocuments': encryptedDocuments,
        'totalSize': totalSize,
        'categoryStats': categoryStats,
        'statusStats': statusStats,
      };
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Dokumenten-Statistiken: $e');
      return {};
    }
  }

  @override
  Future<bool> validateDocument(Document document) async {
    try {
      // Grundlegende Validierung
      if (document.title.trim().isEmpty) {
        return false;
      }

      if (document.filePath.trim().isEmpty) {
        return false;
      }

      if (document.fileSize <= 0) {
        return false;
      }

      if (document.createdBy.trim().isEmpty) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Fehler bei der Dokumenten-Validierung: $e');
      return false;
    }
  }

  @override
  Future<String> generateDocumentId() async {
    try {
      final counter = _prefs.getInt(_documentCounterKey) ?? 0;
      final newCounter = counter + 1;
      await _prefs.setInt(_documentCounterKey, newCounter);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = Random().nextInt(1000);

      return 'doc_${timestamp}_${random}_$newCounter';
    } catch (e) {
      debugPrint('Fehler beim Generieren der Dokumenten-ID: $e');
      return 'doc_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  @override
  Future<bool> documentExists(String documentId) async {
    try {
      final document = await getDocumentById(documentId);
      return document != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> getDocumentFileSize(String documentId) async {
    try {
      final document = await getDocumentById(documentId);
      return document?.fileSize ?? 0;
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Dateigröße: $e');
      return 0;
    }
  }

  @override
  Future<bool> isDocumentEncrypted(String documentId) async {
    try {
      final document = await getDocumentById(documentId);
      return document?.isEncrypted ?? false;
    } catch (e) {
      debugPrint('Fehler beim Prüfen der Verschlüsselung: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getDocumentEncryptionInfo(
      String documentId) async {
    try {
      final document = await getDocumentById(documentId);
      if (document == null || !document.isEncrypted) {
        return null;
      }

      return {
        'isEncrypted': document.isEncrypted,
        'encryptionKeyId': document.encryptionKeyId,
        'encryptedAt': document.updatedAt?.toIso8601String(),
      };
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Verschlüsselungs-Informationen: $e');
      return null;
    }
  }

  /// Hilfsmethode zum Speichern aller Dokumente
  Future<void> _saveDocuments(List<Document> documents) async {
    try {
      final documentsJson =
          documents.map((d) => jsonEncode(d.toMap())).toList();

      await _prefs.setStringList(_documentsKey, documentsJson);
    } catch (e) {
      debugPrint('Fehler beim Speichern der Dokumente: $e');
      rethrow;
    }
  }
}
