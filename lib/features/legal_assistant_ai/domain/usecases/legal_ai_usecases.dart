import '../entities/ai_message.dart';
import '../entities/legal_context.dart';
import '../repositories/legal_ai_repository.dart';

/// Use Case für das Senden von Nachrichten an den AI-Assistenten
class SendMessageUseCase {
  final LegalAiRepository _repository;

  const SendMessageUseCase(this._repository);

  Future<AiMessage> call(String message, {String? context}) async {
    return await _repository.sendMessage(message, context: context);
  }
}

/// Use Case für das Laden des Chat-Verlaufs
class GetChatHistoryUseCase {
  final LegalAiRepository _repository;

  const GetChatHistoryUseCase(this._repository);

  Future<List<AiMessage>> call() async {
    return await _repository.getChatHistory();
  }
}

/// Use Case für das Speichern von Nachrichten
class SaveMessageUseCase {
  final LegalAiRepository _repository;

  const SaveMessageUseCase(this._repository);

  Future<void> call(AiMessage message) async {
    await _repository.saveMessage(message);
  }
}

/// Use Case für das Löschen von Nachrichten
class DeleteMessageUseCase {
  final LegalAiRepository _repository;

  const DeleteMessageUseCase(this._repository);

  Future<void> call(String messageId) async {
    await _repository.deleteMessage(messageId);
  }
}

/// Use Case für das Löschen des Chat-Verlaufs
class ClearChatHistoryUseCase {
  final LegalAiRepository _repository;

  const ClearChatHistoryUseCase(this._repository);

  Future<void> call() async {
    await _repository.clearChatHistory();
  }
}

/// Use Case für das Laden von rechtlichen Kontexten
class GetLegalContextsUseCase {
  final LegalAiRepository _repository;

  const GetLegalContextsUseCase(this._repository);

  Future<List<LegalContext>> call() async {
    return await _repository.getLegalContexts();
  }
}

/// Use Case für das Speichern von rechtlichen Kontexten
class SaveLegalContextUseCase {
  final LegalAiRepository _repository;

  const SaveLegalContextUseCase(this._repository);

  Future<void> call(LegalContext context) async {
    await _repository.saveLegalContext(context);
  }
}

/// Use Case für das Aktualisieren von rechtlichen Kontexten
class UpdateLegalContextUseCase {
  final LegalAiRepository _repository;

  const UpdateLegalContextUseCase(this._repository);

  Future<void> call(LegalContext context) async {
    await _repository.updateLegalContext(context);
  }
}

/// Use Case für das Löschen von rechtlichen Kontexten
class DeleteLegalContextUseCase {
  final LegalAiRepository _repository;

  const DeleteLegalContextUseCase(this._repository);

  Future<void> call(String contextId) async {
    await _repository.deleteLegalContext(contextId);
  }
}

/// Use Case für das Suchen nach rechtlichen Kontexten
class SearchLegalContextsUseCase {
  final LegalAiRepository _repository;

  const SearchLegalContextsUseCase(this._repository);

  Future<List<LegalContext>> call(String query) async {
    return await _repository.searchLegalContexts(query);
  }
}

/// Use Case für das Generieren von rechtlichen Dokumenten
class GenerateLegalDocumentUseCase {
  final LegalAiRepository _repository;

  const GenerateLegalDocumentUseCase(this._repository);

  Future<String> call({
    required String template,
    required Map<String, dynamic> data,
    String? context,
  }) async {
    return await _repository.generateLegalDocument(
      template: template,
      data: data,
      context: context,
    );
  }
}

/// Use Case für das Analysieren von rechtlichen Dokumenten
class AnalyzeLegalDocumentUseCase {
  final LegalAiRepository _repository;

  const AnalyzeLegalDocumentUseCase(this._repository);

  Future<Map<String, dynamic>> call(String document) async {
    return await _repository.analyzeLegalDocument(document);
  }
}

/// Use Case für das Abrufen von rechtlichen Empfehlungen
class GetLegalRecommendationsUseCase {
  final LegalAiRepository _repository;

  const GetLegalRecommendationsUseCase(this._repository);

  Future<List<String>> call({
    required String situation,
    String? context,
  }) async {
    return await _repository.getLegalRecommendations(
      situation: situation,
      context: context,
    );
  }
}

/// Use Case für das Validieren von rechtlichen Informationen
class ValidateLegalInformationUseCase {
  final LegalAiRepository _repository;

  const ValidateLegalInformationUseCase(this._repository);

  Future<bool> call(String information) async {
    return await _repository.validateLegalInformation(information);
  }
}

/// Use Case für das Exportieren des Chat-Verlaufs
class ExportChatHistoryUseCase {
  final LegalAiRepository _repository;

  const ExportChatHistoryUseCase(this._repository);

  Future<String> call({String format = 'json'}) async {
    return await _repository.exportChatHistory(format: format);
  }
}

/// Use Case für das Importieren des Chat-Verlaufs
class ImportChatHistoryUseCase {
  final LegalAiRepository _repository;

  const ImportChatHistoryUseCase(this._repository);

  Future<void> call(String data, {String format = 'json'}) async {
    await _repository.importChatHistory(data, format: format);
  }
} 