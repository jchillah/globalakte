// features/legal_assistant_ai/domain/repositories/legal_ai_repository.dart
import '../entities/ai_message.dart';
import '../entities/legal_context.dart';

/// Repository Interface für Legal AI Features
abstract class LegalAiRepository {
  /// Sendet eine Nachricht an den AI-Assistenten
  Future<AiMessage> sendMessage(String message, {String? context});

  /// Lädt den Chat-Verlauf
  Future<List<AiMessage>> getChatHistory();

  /// Speichert eine Nachricht
  Future<void> saveMessage(AiMessage message);

  /// Löscht eine Nachricht
  Future<void> deleteMessage(String messageId);

  /// Löscht den gesamten Chat-Verlauf
  Future<void> clearChatHistory();

  /// Lädt verfügbare rechtliche Kontexte
  Future<List<LegalContext>> getLegalContexts();

  /// Speichert einen rechtlichen Kontext
  Future<void> saveLegalContext(LegalContext context);

  /// Aktualisiert einen rechtlichen Kontext
  Future<void> updateLegalContext(LegalContext context);

  /// Löscht einen rechtlichen Kontext
  Future<void> deleteLegalContext(String contextId);

  /// Sucht nach rechtlichen Kontexten
  Future<List<LegalContext>> searchLegalContexts(String query);

  /// Generiert rechtliche Dokumente basierend auf Kontext
  Future<String> generateLegalDocument({
    required String template,
    required Map<String, dynamic> data,
    String? context,
  });

  /// Analysiert rechtliche Dokumente
  Future<Map<String, dynamic>> analyzeLegalDocument(String documentContent);

  /// Gibt rechtliche Empfehlungen
  Future<List<String>> getLegalRecommendations({
    required String situation,
    String? context,
  });

  /// Validiert rechtliche Informationen
  Future<bool> validateLegalInformation(String information);

  /// Exportiert Chat-Verlauf
  Future<String> exportChatHistory({String format = 'json'});

  /// Importiert Chat-Verlauf
  Future<void> importChatHistory(String data, {String format = 'json'});

  /// Sucht nach Nachrichten
  Future<List<AiMessage>> searchMessages(String query);

  /// Lädt Nachrichten nach Kontext
  Future<List<AiMessage>> getMessagesByContext(String context);

  /// Lädt Nachrichten-Statistiken
  Future<Map<String, dynamic>> getMessageStatistics();

  /// Lädt rechtliche Kontexte nach Kategorie
  Future<List<LegalContext>> getLegalContextsByCategory(String category);

  /// Lädt einen rechtlichen Kontext nach ID
  Future<LegalContext?> getLegalContextById(String id);

  /// Lädt alle Kategorien
  Future<List<String>> getCategories();

  /// Lädt Kontexte nach Keywords
  Future<List<LegalContext>> getContextsByKeywords(List<String> keywords);

  /// Lädt Kontext-Statistiken
  Future<Map<String, dynamic>> getContextStatistics();

  /// Lädt beliebte Kontexte
  Future<List<LegalContext>> getPopularContexts({int limit = 5});

  /// Exportiert Legal AI Daten
  Future<String> exportLegalData();

  /// Importiert Legal AI Daten
  Future<void> importLegalData(String data);

  /// Backup von Legal AI Daten
  Future<void> backupLegalData();

  /// Wiederherstellung von Legal AI Daten
  Future<void> restoreLegalData();

  /// Lädt Legal AI Statistiken
  Future<Map<String, dynamic>> getLegalAiStats();

  /// Trainiert das Legal AI Modell
  Future<void> trainLegalModel(List<Map<String, dynamic>> trainingData);

  /// Lädt Modell-Performance
  Future<Map<String, dynamic>> getModelPerformance();
}
