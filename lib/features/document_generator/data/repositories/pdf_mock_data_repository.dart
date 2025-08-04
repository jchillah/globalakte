// features/document_generator/data/repositories/pdf_mock_data_repository.dart

import 'dart:math';

import '../../../../core/data/mock_data_repository.dart';

/// Mock-Data Repository speziell für PDF-Generator
class PdfMockDataRepository {
  static final PdfMockDataRepository _instance =
      PdfMockDataRepository._internal();
  factory PdfMockDataRepository() => _instance;
  PdfMockDataRepository._internal();

  final MockDataRepository _mockData = MockDataRepository();
  final Random _random = Random();

  /// PDF Templates laden
  Map<String, Map<String, dynamic>> get templates => _mockData.pdfTemplates;

  /// PDF Documents laden
  List<Map<String, dynamic>> get documents => _mockData.pdfDocuments;

  /// Neues PDF Document erstellen
  Map<String, dynamic> createDocument({
    required String title,
    required String content,
    required String templateType,
    required String author,
    List<String> tags = const [],
    Map<String, dynamic> metadata = const {},
  }) {
    return {
      'id': _mockData.getRandomId(),
      'title': title,
      'content': content,
      'templateType': templateType,
      'metadata': {
        'author': author,
        'generatedAt': DateTime.now().toIso8601String(),
        ...metadata,
      },
      'createdAt': DateTime.now(),
      'author': author,
      'tags': tags,
    };
  }

  /// PDF Template erstellen
  Map<String, dynamic> createTemplate({
    required String name,
    required String description,
    required String templateType,
    required String htmlTemplate,
    required Map<String, dynamic> defaultData,
    required List<String> requiredFields,
    List<String> optionalFields = const [],
    String category = 'Allgemein',
    String version = '1.0',
  }) {
    return {
      'id': _mockData.getRandomId(),
      'name': name,
      'description': description,
      'templateType': templateType,
      'htmlTemplate': htmlTemplate,
      'defaultData': defaultData,
      'requiredFields': requiredFields,
      'optionalFields': optionalFields,
      'category': category,
      'version': version,
      'createdAt': DateTime.now(),
      'isActive': true,
    };
  }

  /// PDF Statistics generieren
  Map<String, dynamic> generateStatistics(List<Map<String, dynamic>> documents,
      List<Map<String, dynamic>> templates) {
    return {
      'totalDocuments': documents.length,
      'totalTemplates': templates.length,
      'documentsByType': {
        'legal_letter':
            documents.where((d) => d['templateType'] == 'legal_letter').length,
        'contract':
            documents.where((d) => d['templateType'] == 'contract').length,
        'application':
            documents.where((d) => d['templateType'] == 'application').length,
      },
      'templatesByCategory': {
        'Recht': templates.where((t) => t['category'] == 'Recht').length,
        'Vertrag': templates.where((t) => t['category'] == 'Vertrag').length,
        'Antrag': templates.where((t) => t['category'] == 'Antrag').length,
      },
      'recentDocuments': documents
          .take(5)
          .map((d) => {
                'id': d['id'],
                'title': d['title'],
                'createdAt': d['createdAt'],
              })
          .toList(),
      'popularTemplates': templates
          .take(3)
          .map((t) => {
                'id': t['id'],
                'name': t['name'],
                'category': t['category'],
              })
          .toList(),
    };
  }

  /// PDF Preview generieren
  String generatePreview(String templateId, Map<String, dynamic> data) {
    final template = templates[templateId];
    if (template == null) return 'Template nicht gefunden';

    String html = template['htmlTemplate'] as String;

    // Template-Variablen ersetzen
    for (final entry in data.entries) {
      final placeholder = '{{${entry.key}}}';
      final value = entry.value?.toString() ?? '';
      html = html.replaceAll(placeholder, value);
    }

    // Standard-Variablen ersetzen
    final now = DateTime.now();
    html = html.replaceAll(
        '{{currentDate}}', '${now.day}.${now.month}.${now.year}');
    html = html.replaceAll('{{currentTime}}',
        '${now.hour}:${now.minute.toString().padLeft(2, '0')}');

    return html;
  }

  /// PDF Bytes simulieren
  List<int> generatePdfBytes(String templateId, Map<String, dynamic> data) {
    // Simuliere PDF-Generierung
    final template = templates[templateId];
    if (template == null) return [];

    // Generiere zufällige PDF-Bytes basierend auf Template und Daten
    final contentLength = data.values.join('').length;
    return List.generate(500 + contentLength, (index) => _random.nextInt(256));
  }

  /// Dokument nach ID finden
  Map<String, dynamic>? findDocumentById(
      String id, List<Map<String, dynamic>> documents) {
    try {
      return documents.firstWhere((doc) => doc['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Template nach ID finden
  Map<String, dynamic>? findTemplateById(String id) {
    try {
      return templates.values.firstWhere((template) => template['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Dokumente filtern
  List<Map<String, dynamic>> filterDocuments(
    List<Map<String, dynamic>> documents, {
    String? templateType,
    String? author,
    List<String>? tags,
    String? searchQuery,
  }) {
    return documents.where((doc) {
      if (templateType != null && doc['templateType'] != templateType) {
        return false;
      }
      if (author != null && doc['author'] != author) return false;
      if (tags != null && !tags.any((tag) => doc['tags'].contains(tag))) {
        return false;
      }
      if (searchQuery != null) {
        final query = searchQuery.toLowerCase();
        final title = doc['title'].toString().toLowerCase();
        final content = doc['content'].toString().toLowerCase();
        final docTags = doc['tags'].join(' ').toLowerCase();
        if (!title.contains(query) &&
            !content.contains(query) &&
            !docTags.contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  /// Templates filtern
  List<Map<String, dynamic>> filterTemplates({
    String? category,
    String? templateType,
    bool? isActive,
  }) {
    return templates.values.where((template) {
      if (category != null && template['category'] != category) return false;
      if (templateType != null && template['templateType'] != templateType) {
        return false;
      }
      if (isActive != null && template['isActive'] != isActive) return false;
      return true;
    }).toList();
  }
}
