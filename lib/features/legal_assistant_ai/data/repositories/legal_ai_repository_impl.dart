// features/legal_assistant_ai/data/repositories/legal_ai_repository_impl.dart
import 'dart:convert';
import 'dart:math';

import '../../domain/entities/ai_message.dart';
import '../../domain/entities/legal_context.dart';
import '../../domain/repositories/legal_ai_repository.dart';

/// Implementation des Legal AI Repository mit Mock-Daten
class LegalAiRepositoryImpl implements LegalAiRepository {
  final List<AiMessage> _chatHistory = [];
  final List<LegalContext> _legalContexts = [];
  final Random _random = Random();

  LegalAiRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock rechtliche Kontexte
    _legalContexts.addAll([
      LegalContext.create(
        title: 'Mietrecht - Kündigung',
        description: 'Rechtliche Aspekte bei Mietkündigungen',
        category: 'Zivilrecht',
        keywords: ['Miete', 'Kündigung', 'Vermieter', 'Mieter'],
        legalFramework: {
          'gesetze': ['BGB § 573', 'BGB § 574'],
          'fristen': '3 Monate Kündigungsfrist',
        },
      ),
      LegalContext.create(
        title: 'Arbeitsrecht - Kündigungsschutz',
        description: 'Schutz vor unrechtmäßigen Kündigungen',
        category: 'Arbeitsrecht',
        keywords: ['Arbeitsvertrag', 'Kündigung', 'Kündigungsschutz'],
        legalFramework: {
          'gesetze': ['KSchG', 'BGB § 626'],
          'fristen': '4 Wochen Kündigungsfrist',
        },
      ),
      LegalContext.create(
        title: 'Familienrecht - Sorgerecht',
        description: 'Rechtliche Aspekte des Sorgerechts',
        category: 'Familienrecht',
        keywords: ['Sorgerecht', 'Kind', 'Eltern', 'Trennung'],
        legalFramework: {
          'gesetze': ['BGB § 1626', 'BGB § 1627'],
          'grundsatz': 'Kindeswohl steht im Vordergrund',
        },
      ),
    ]);

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
    ]);
  }

  @override
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
      ],
      'Arbeitsrecht': [
        'Das Arbeitsrecht schützt Arbeitnehmer vor unrechtmäßigen Kündigungen. Was ist Ihr spezifisches Anliegen?',
        'Der Kündigungsschutz gilt nach 6 Monaten Betriebszugehörigkeit. Wie lange arbeiten Sie bereits im Unternehmen?',
        'Bei Arbeitsstreitigkeiten können Sie sich an den Betriebsrat oder Gewerkschaft wenden. Haben Sie das bereits getan?',
      ],
      'Familienrecht': [
        'Im Familienrecht steht das Kindeswohl im Vordergrund. Können Sie mir Ihre Situation schildern?',
        'Bei Sorgerechtsfragen ist eine anwaltliche Beratung oft sinnvoll. Haben Sie bereits einen Anwalt kontaktiert?',
        'Das Familiengericht entscheidet im Sinne des Kindeswohls. Welche Aspekte sind für Sie wichtig?',
      ],
    };

    final suggestions = [
      'Weitere Informationen anfordern',
      'Dokumente sammeln',
      'Anwaltliche Beratung',
      'Behörden kontaktieren',
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
      },
    );
  }

  @override
  Future<List<AiMessage>> getChatHistory() async {
    await Future.delayed(Duration(milliseconds: 200));
    return List.from(_chatHistory);
  }

  @override
  Future<void> saveMessage(AiMessage message) async {
    await Future.delayed(Duration(milliseconds: 100));
    _chatHistory.add(message);
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await Future.delayed(Duration(milliseconds: 100));
    _chatHistory.removeWhere((message) => message.id == messageId);
  }

  @override
  Future<void> clearChatHistory() async {
    await Future.delayed(Duration(milliseconds: 200));
    _chatHistory.clear();
  }

  @override
  Future<List<LegalContext>> getLegalContexts() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_legalContexts);
  }

  @override
  Future<void> saveLegalContext(LegalContext context) async {
    await Future.delayed(Duration(milliseconds: 200));
    _legalContexts.add(context);
  }

  @override
  Future<void> updateLegalContext(LegalContext context) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _legalContexts.indexWhere((c) => c.id == context.id);
    if (index != -1) {
      _legalContexts[index] = context;
    }
  }

  @override
  Future<void> deleteLegalContext(String contextId) async {
    await Future.delayed(Duration(milliseconds: 100));
    _legalContexts.removeWhere((context) => context.id == contextId);
  }

  @override
  Future<List<LegalContext>> searchLegalContexts(String query) async {
    await Future.delayed(Duration(milliseconds: 400));
    final lowercaseQuery = query.toLowerCase();
    return _legalContexts.where((context) {
      return context.title.toLowerCase().contains(lowercaseQuery) ||
          context.description.toLowerCase().contains(lowercaseQuery) ||
          context.keywords
              .any((keyword) => keyword.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  @override
  Future<String> generateLegalDocument({
    required String template,
    required Map<String, dynamic> data,
    String? context,
  }) async {
    await Future.delayed(Duration(milliseconds: 1000));

    // Mock-Dokument-Generierung
    final document = '''
# Rechtliches Dokument

**Erstellt am:** ${DateTime.now().toString()}
**Kontext:** ${context ?? 'Allgemein'}

## Inhalt:
${data.entries.map((e) => '- ${e.key}: ${e.value}').join('\n')}

## Template:
$template

---
*Dieses Dokument wurde automatisch generiert und dient nur zu Demonstrationszwecken.*
    ''';

    return document;
  }

  @override
  Future<Map<String, dynamic>> analyzeLegalDocument(String document) async {
    await Future.delayed(Duration(milliseconds: 800));

    return {
      'word_count': document.split(' ').length,
      'paragraph_count': document.split('\n\n').length,
      'legal_terms': ['Vertrag', 'Kündigung', 'Recht', 'Gesetz'],
      'confidence_score': _random.nextDouble() * 0.3 + 0.7,
      'recommendations': [
        'Dokument von Anwalt prüfen lassen',
        'Rechtliche Begriffe klären',
        'Fristen beachten',
      ],
    };
  }

  @override
  Future<List<String>> getLegalRecommendations({
    required String situation,
    String? context,
  }) async {
    await Future.delayed(Duration(milliseconds: 600));

    final recommendations = [
      'Sammeln Sie alle relevanten Dokumente',
      'Führen Sie ein Protokoll aller Vorfälle',
      'Kontaktieren Sie einen Fachanwalt',
      'Prüfen Sie Ihre Versicherungsschutz',
      'Informieren Sie sich über Ihre Rechte',
    ];

    return recommendations.take(_random.nextInt(3) + 2).toList();
  }

  @override
  Future<bool> validateLegalInformation(String information) async {
    await Future.delayed(Duration(milliseconds: 400));

    // Mock-Validierung
    final validKeywords = [
      'gesetz',
      'recht',
      'vertrag',
      'kündigung',
      'anspruch'
    ];
    final lowercaseInfo = information.toLowerCase();

    return validKeywords.any((keyword) => lowercaseInfo.contains(keyword));
  }

  @override
  Future<String> exportChatHistory({String format = 'json'}) async {
    await Future.delayed(Duration(milliseconds: 500));

    if (format == 'json') {
      return jsonEncode({
        'messages': _chatHistory.map((m) => m.toMap()).toList(),
        'exported_at': DateTime.now().toIso8601String(),
      });
    } else {
      return _chatHistory.map((m) => '${m.sender}: ${m.content}').join('\n');
    }
  }

  @override
  Future<void> importChatHistory(String data, {String format = 'json'}) async {
    await Future.delayed(Duration(milliseconds: 300));

    if (format == 'json') {
      final jsonData = jsonDecode(data);
      final messages = (jsonData['messages'] as List)
          .map((m) => AiMessage.fromMap(m))
          .toList();
      _chatHistory.addAll(messages);
    } else {
      // Einfache Text-Import
      final lines = data.split('\n');
      for (final line in lines) {
        if (line.contains(': ')) {
          final parts = line.split(': ');
          if (parts.length >= 2) {
            final sender = parts[0];
            final content = parts.sublist(1).join(': ');
            _chatHistory.add(AiMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: content,
              sender: sender,
              timestamp: DateTime.now(),
            ));
          }
        }
      }
    }
  }
}
