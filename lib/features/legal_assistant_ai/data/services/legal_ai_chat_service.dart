// features/legal_assistant_ai/data/services/legal_ai_chat_service.dart
import 'dart:math';

import '../../domain/entities/ai_message.dart';

/// Service für Legal AI Chat Operationen
class LegalAiChatService {
  final List<AiMessage> _chatHistory = [];
  final Random _random = Random();

  LegalAiChatService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock Chat-Verlauf
    _chatHistory.addAll([
      AiMessage.user(content: 'Hallo, ich habe eine Frage zum Mietrecht.'),
      AiMessage.ai(
        content:
            'Gerne helfe ich Ihnen bei Fragen zum Mietrecht. Was möchten Sie wissen?',
        context: 'Mietrecht',
        suggestions: [
          'Kündigung durch Mieter',
          'Kündigung durch Vermieter',
          'Miethöhe und Erhöhung',
          'Schäden und Reparaturen',
        ],
      ),
      AiMessage.user(content: 'Mein Vermieter möchte die Miete erhöhen.'),
      AiMessage.ai(
        content:
            'Mietpreiserhöhungen sind gesetzlich geregelt. Der Vermieter kann die Miete nur unter bestimmten Voraussetzungen erhöhen. Wurde Ihnen eine schriftliche Erhöhung mit Begründung zugestellt?',
        context: 'Mietrecht',
        suggestions: [
          'Mietspiegel prüfen',
          'Mieterverein kontaktieren',
          'Widerspruch einlegen',
        ],
      ),
      AiMessage.user(content: 'Ich habe eine Frage zum Arbeitsrecht.'),
      AiMessage.ai(
        content:
            'Gerne helfe ich Ihnen bei arbeitsrechtlichen Fragen. Was ist Ihr spezifisches Anliegen?',
        context: 'Arbeitsrecht',
        suggestions: [
          'Kündigungsschutz',
          'Arbeitsvertrag',
          'Überstunden',
          'Urlaubsanspruch',
        ],
      ),
    ]);
  }

  // Chat Operationen
  Future<AiMessage> sendMessage(String message, {String? context}) async {
    // Simuliere Verarbeitungszeit
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

    // Erstelle Benutzer-Nachricht
    final userMessage = AiMessage.user(content: message, context: context);
    _chatHistory.add(userMessage);

    // Generiere AI-Antwort basierend auf Kontext
    final aiResponse = _generateAiResponse(message, context);
    _chatHistory.add(aiResponse);

    return aiResponse;
  }

  AiMessage _generateAiResponse(String message, String? context) {
    final responses = {
      'Mietrecht': [
        'Im Mietrecht gibt es klare gesetzliche Regelungen. Können Sie mir mehr Details zu Ihrer Situation geben?',
        'Die Mietpreisbremse und der Mietspiegel sind wichtige Instrumente. Welche Art von Mietangelegenheit betrifft Sie?',
        'Bei Mietstreitigkeiten ist es wichtig, alle Schriftstücke zu sammeln. Haben Sie bereits schriftliche Kommunikation?',
        'Die Kündigungsfrist beträgt normalerweise 3 Monate. Wurde Ihnen eine schriftliche Kündigung zugestellt?',
      ],
      'Arbeitsrecht': [
        'Das Arbeitsrecht schützt Arbeitnehmer vor unrechtmäßigen Kündigungen. Was ist Ihr spezifisches Anliegen?',
        'Der Kündigungsschutz gilt nach 6 Monaten Betriebszugehörigkeit. Wie lange arbeiten Sie bereits im Unternehmen?',
        'Bei Arbeitsstreitigkeiten können Sie sich an den Betriebsrat oder Gewerkschaft wenden. Haben Sie das bereits getan?',
        'Überstunden müssen vergütet oder durch Freizeit ausgeglichen werden. Wie ist das bei Ihnen geregelt?',
      ],
      'Familienrecht': [
        'Im Familienrecht steht das Kindeswohl im Vordergrund. Können Sie mir Ihre Situation schildern?',
        'Bei Sorgerechtsfragen ist eine anwaltliche Beratung oft sinnvoll. Haben Sie bereits einen Anwalt kontaktiert?',
        'Das Familiengericht entscheidet im Sinne des Kindeswohls. Welche Aspekte sind für Sie wichtig?',
        'Der Unterhaltsanspruch richtet sich nach der Leistungsfähigkeit. Haben Sie bereits eine Berechnung?',
      ],
      'Strafrecht': [
        'Im Strafrecht gilt der Grundsatz "in dubio pro reo". Was ist Ihr spezifisches Anliegen?',
        'Die Beweislast liegt bei der Staatsanwaltschaft. Haben Sie bereits einen Anwalt?',
        'Bei strafrechtlichen Vorwürfen ist anwaltliche Beratung dringend zu empfehlen.',
        'Das Strafverfahren folgt bestimmten Fristen. Wurden Sie bereits vernommen?',
      ],
    };

    final suggestions = [
      'Weitere Informationen anfordern',
      'Dokumente sammeln',
      'Anwaltliche Beratung',
      'Behörden kontaktieren',
      'Rechtschutzversicherung prüfen',
    ];

    String response;
    if (context != null && responses.containsKey(context)) {
      final contextResponses = responses[context]!;
      response = contextResponses[_random.nextInt(contextResponses.length)];
    } else {
      response =
          'Ich verstehe Ihre Frage. Können Sie mir mehr Details geben, damit ich Ihnen besser helfen kann?';
    }

    return AiMessage.ai(
      content: response,
      context: context,
      suggestions: suggestions,
      metadata: {
        'confidence': _random.nextDouble() * 0.3 + 0.7, // 70-100%
        'processing_time': _random.nextInt(1000) + 500,
        'model_version': 'legal-ai-v1.2',
      },
    );
  }

  Future<List<AiMessage>> getChatHistory() async {
    await Future.delayed(Duration(milliseconds: 200));
    return List.from(_chatHistory);
  }

  Future<void> saveMessage(AiMessage message) async {
    await Future.delayed(Duration(milliseconds: 100));
    _chatHistory.add(message);
  }

  Future<void> deleteMessage(String messageId) async {
    await Future.delayed(Duration(milliseconds: 100));
    _chatHistory.removeWhere((message) => message.id == messageId);
  }

  Future<void> clearChatHistory() async {
    await Future.delayed(Duration(milliseconds: 200));
    _chatHistory.clear();
  }

  Future<List<AiMessage>> searchMessages(String query) async {
    await Future.delayed(Duration(milliseconds: 300));
    final lowercaseQuery = query.toLowerCase();
    return _chatHistory.where((message) {
      return message.content.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<List<AiMessage>> getMessagesByContext(String context) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _chatHistory.where((message) {
      return message.context == context;
    }).toList();
  }

  Future<Map<String, dynamic>> getMessageStatistics() async {
    await Future.delayed(Duration(milliseconds: 200));
    
    final userMessages = _chatHistory.where((m) => m.sender == 'user').length;
    final aiMessages = _chatHistory.where((m) => m.sender == 'ai').length;
    final contexts = <String, int>{};
    
    for (final message in _chatHistory) {
      if (message.context != null) {
        contexts[message.context!] = (contexts[message.context!] ?? 0) + 1;
      }
    }
    
    return {
      'total_messages': _chatHistory.length,
      'user_messages': userMessages,
      'ai_messages': aiMessages,
      'contexts': contexts,
    };
  }

  Future<void> exportChatHistory() async {
    await Future.delayed(Duration(milliseconds: 500));
    // Mock Export Implementation
  }

  Future<void> importChatHistory(List<AiMessage> messages) async {
    await Future.delayed(Duration(milliseconds: 300));
    _chatHistory.clear();
    _chatHistory.addAll(messages);
  }
} 