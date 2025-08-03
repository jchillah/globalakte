import '../entities/document.dart';

/// Abstract Repository Interface für die Dokumentenverwaltung
abstract class DocumentRepository {
  /// Erstellt ein neues Dokument
  Future<Document> createDocument(Document document);
  
  /// Aktualisiert ein bestehendes Dokument
  Future<Document> updateDocument(Document document);
  
  /// Löscht ein Dokument
  Future<bool> deleteDocument(String documentId);
  
  /// Holt ein Dokument anhand der ID
  Future<Document?> getDocumentById(String documentId);
  
  /// Holt alle Dokumente
  Future<List<Document>> getAllDocuments();
  
  /// Holt alle Dokumente für einen bestimmten Fall
  Future<List<Document>> getDocumentsByCaseId(String caseId);
  
  /// Holt alle Dokumente einer bestimmten Kategorie
  Future<List<Document>> getDocumentsByCategory(DocumentCategory category);
  
  /// Holt alle Dokumente eines bestimmten Status
  Future<List<Document>> getDocumentsByStatus(DocumentStatus status);
  
  /// Sucht Dokumente nach Titel oder Beschreibung
  Future<List<Document>> searchDocuments(String query);
  
  /// Holt alle Dokumente eines Benutzers
  Future<List<Document>> getDocumentsByUser(String userId);
  
  /// Verschlüsselt ein Dokument
  Future<Document> encryptDocument(String documentId, String encryptionKeyId);
  
  /// Entschlüsselt ein Dokument
  Future<Document> decryptDocument(String documentId);
  
  /// Exportiert ein Dokument
  Future<String> exportDocument(String documentId, String format);
  
  /// Importiert ein Dokument
  Future<Document> importDocument(String filePath, String userId);
  
  /// Erstellt ein Backup aller Dokumente
  Future<String> createBackup();
  
  /// Stellt ein Backup wieder her
  Future<bool> restoreBackup(String backupPath);
  
  /// Synchronisiert Dokumente mit der Cloud
  Future<bool> syncWithCloud();
  
  /// Holt Dokumenten-Statistiken
  Future<Map<String, dynamic>> getDocumentStatistics();
  
  /// Validiert ein Dokument
  Future<bool> validateDocument(Document document);
  
  /// Generiert eine Dokumenten-ID
  Future<String> generateDocumentId();
  
  /// Prüft ob ein Dokument existiert
  Future<bool> documentExists(String documentId);
  
  /// Holt die Dateigröße eines Dokuments
  Future<int> getDocumentFileSize(String documentId);
  
  /// Prüft ob ein Dokument verschlüsselt ist
  Future<bool> isDocumentEncrypted(String documentId);
  
  /// Holt die Verschlüsselungs-Informationen eines Dokuments
  Future<Map<String, dynamic>?> getDocumentEncryptionInfo(String documentId);
} 