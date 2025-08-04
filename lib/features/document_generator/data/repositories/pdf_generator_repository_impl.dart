// features/document_generator/data/repositories/pdf_generator_repository_impl.dart

import 'dart:math';
import 'dart:typed_data';

import '../../../../core/data/mock_data_repository.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../domain/entities/pdf_document.dart';
import '../../domain/entities/pdf_template.dart';
import '../../domain/repositories/pdf_generator_repository.dart';
import 'pdf_mock_data_repository.dart';

/// Repository-Implementation für PDF-Generator
class PdfGeneratorRepositoryImpl implements PdfGeneratorRepository {
  // Mock-Daten für Demo-Zwecke
  final List<PdfDocument> _documents = [];
  final List<PdfTemplate> _templates = [];
  final MockDataRepository _mockData = MockDataRepository();
  final PdfMockDataRepository _pdfMockData = PdfMockDataRepository();
  final Random _random = Random();

  PdfGeneratorRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Templates aus PDF Mock-Data Repository laden
    final templatesData = _pdfMockData.templates;
    _templates.addAll([
      PdfTemplate(
        id: templatesData['legal_letter']!['id'] as String,
        name: templatesData['legal_letter']!['name'] as String,
        description: templatesData['legal_letter']!['description'] as String,
        templateType: templatesData['legal_letter']!['templateType'] as String,
        htmlTemplate: templatesData['legal_letter']!['htmlTemplate'] as String,
        defaultData: Map<String, dynamic>.from(
            templatesData['legal_letter']!['defaultData'] as Map),
        requiredFields: List<String>.from(
            templatesData['legal_letter']!['requiredFields'] as List),
        optionalFields: List<String>.from(
            templatesData['legal_letter']!['optionalFields'] as List),
        createdAt: DateTime.now(),
        category: templatesData['legal_letter']!['category'] as String,
        version: templatesData['legal_letter']!['version'] as String,
      ),
      PdfTemplate(
        id: templatesData['contract']!['id'] as String,
        name: templatesData['contract']!['name'] as String,
        description: templatesData['contract']!['description'] as String,
        templateType: templatesData['contract']!['templateType'] as String,
        htmlTemplate: templatesData['contract']!['htmlTemplate'] as String,
        defaultData: Map<String, dynamic>.from(
            templatesData['contract']!['defaultData'] as Map),
        requiredFields: List<String>.from(
            templatesData['contract']!['requiredFields'] as List),
        optionalFields: List<String>.from(
            templatesData['contract']!['optionalFields'] as List),
        createdAt: DateTime.now(),
        category: templatesData['contract']!['category'] as String,
        version: templatesData['contract']!['version'] as String,
      ),
      PdfTemplate(
        id: templatesData['application']!['id'] as String,
        name: templatesData['application']!['name'] as String,
        description: templatesData['application']!['description'] as String,
        templateType: templatesData['application']!['templateType'] as String,
        htmlTemplate: templatesData['application']!['htmlTemplate'] as String,
        defaultData: Map<String, dynamic>.from(
            templatesData['application']!['defaultData'] as Map),
        requiredFields: List<String>.from(
            templatesData['application']!['requiredFields'] as List),
        optionalFields: List<String>.from(
            templatesData['application']!['optionalFields'] as List),
        createdAt: DateTime.now(),
        category: templatesData['application']!['category'] as String,
        version: templatesData['application']!['version'] as String,
      ),
    ]);

    // Dokumente aus PDF Mock-Data Repository laden
    final documentsData = _pdfMockData.documents;
    _documents.addAll([
      PdfDocument(
        id: documentsData[0]['id'] as String,
        title: documentsData[0]['title'] as String,
        content: documentsData[0]['content'] as String,
        templateType: documentsData[0]['templateType'] as String,
        metadata:
            Map<String, dynamic>.from(documentsData[0]['metadata'] as Map),
        createdAt: documentsData[0]['createdAt'] as DateTime,
        author: documentsData[0]['author'] as String,
        tags: List<String>.from(documentsData[0]['tags'] as List),
      ),
      PdfDocument(
        id: documentsData[1]['id'] as String,
        title: documentsData[1]['title'] as String,
        content: documentsData[1]['content'] as String,
        templateType: documentsData[1]['templateType'] as String,
        metadata:
            Map<String, dynamic>.from(documentsData[1]['metadata'] as Map),
        createdAt: documentsData[1]['createdAt'] as DateTime,
        author: documentsData[1]['author'] as String,
        tags: List<String>.from(documentsData[1]['tags'] as List),
      ),
    ]);
  }

  @override
  Future<PdfDocument> createPdfDocument(PdfDocument document) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    _documents.add(document);
    AppLogger.info('PDF-Dokument erstellt: ${document.title}');
    return document;
  }

  @override
  Future<PdfDocument?> getPdfDocument(String id) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    try {
      return _documents.firstWhere((doc) => doc.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<PdfDocument>> getAllPdfDocuments() async {
    await Future.delayed(Duration(milliseconds: 400 + _random.nextInt(600)));
    AppLogger.info('Alle PDF-Dokumente geladen: ${_documents.length}');
    return List.from(_documents);
  }

  @override
  Future<PdfDocument> updatePdfDocument(PdfDocument document) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    final index = _documents.indexWhere((doc) => doc.id == document.id);
    if (index != -1) {
      _documents[index] = document.copyWith(updatedAt: DateTime.now());
      AppLogger.info('PDF-Dokument aktualisiert: ${document.title}');
      return _documents[index];
    }
    throw Exception('PDF-Dokument nicht gefunden: ${document.id}');
  }

  @override
  Future<bool> deletePdfDocument(String id) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    final initialLength = _documents.length;
    _documents.removeWhere((doc) => doc.id == id);
    final success = _documents.length < initialLength;
    if (success) {
      AppLogger.info('PDF-Dokument gelöscht: $id');
    }
    return success;
  }

  @override
  Future<List<PdfDocument>> getPdfDocumentsByTemplateType(
      String templateType) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _documents.where((doc) => doc.templateType == templateType).toList();
  }

  @override
  Future<List<PdfDocument>> getPdfDocumentsByAuthor(String author) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _documents.where((doc) => doc.author == author).toList();
  }

  @override
  Future<List<PdfDocument>> getPdfDocumentsByTags(List<String> tags) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _documents
        .where((doc) => doc.tags.any((tag) => tags.contains(tag)))
        .toList();
  }

  @override
  Future<List<PdfDocument>> searchPdfDocuments(String query) async {
    await Future.delayed(Duration(milliseconds: 400 + _random.nextInt(500)));
    final lowercaseQuery = query.toLowerCase();
    return _documents
        .where((doc) =>
            doc.title.toLowerCase().contains(lowercaseQuery) ||
            doc.content.toLowerCase().contains(lowercaseQuery) ||
            doc.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
        .toList();
  }

  @override
  Future<PdfTemplate> createPdfTemplate(PdfTemplate template) async {
    await Future.delayed(Duration(milliseconds: 400 + _random.nextInt(600)));
    _templates.add(template);
    AppLogger.info('PDF-Template erstellt: ${template.name}');
    return template;
  }

  @override
  Future<PdfTemplate?> getPdfTemplate(String id) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    try {
      return _templates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<PdfTemplate>> getAllPdfTemplates() async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return List.from(_templates);
  }

  @override
  Future<List<PdfTemplate>> getActivePdfTemplates() async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _templates.where((template) => template.isActive).toList();
  }

  @override
  Future<PdfTemplate> updatePdfTemplate(PdfTemplate template) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    final index = _templates.indexWhere((t) => t.id == template.id);
    if (index != -1) {
      _templates[index] = template.copyWith(updatedAt: DateTime.now());
      AppLogger.info('PDF-Template aktualisiert: ${template.name}');
      return _templates[index];
    }
    throw Exception('PDF-Template nicht gefunden: ${template.id}');
  }

  @override
  Future<bool> deletePdfTemplate(String id) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    final initialLength = _templates.length;
    _templates.removeWhere((template) => template.id == id);
    final success = _templates.length < initialLength;
    if (success) {
      AppLogger.info('PDF-Template gelöscht: $id');
    }
    return success;
  }

  @override
  Future<List<PdfTemplate>> getPdfTemplatesByCategory(String category) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _templates
        .where((template) => template.category == category)
        .toList();
  }

  @override
  Future<List<PdfTemplate>> getPdfTemplatesByType(String templateType) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    return _templates
        .where((template) => template.templateType == templateType)
        .toList();
  }

  @override
  Future<Uint8List> generatePdfFromTemplate(
    String templateId,
    Map<String, dynamic> data,
  ) async {
    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(2000)));
    AppLogger.info('PDF aus Template generiert: $templateId');

    // Simuliere PDF-Generierung mit verbesserter Datenübertragung
    final template = await getPdfTemplate(templateId);
    if (template == null) {
      throw Exception('Template nicht gefunden: $templateId');
    }

    // HTML aus Template mit eingegebenen Daten generieren
    String html = template.htmlTemplate;
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

    // PDF-Bytes basierend auf generiertem HTML simulieren
    final contentLength = html.length;
    final pdfBytes =
        List.generate(800 + contentLength, (index) => _random.nextInt(256));

    AppLogger.info(
        'PDF generiert mit ${data.length} Datenfeldern und $contentLength Zeichen Inhalt');
    return Uint8List.fromList(pdfBytes);
  }

  @override
  Future<Uint8List> generatePdfFromHtml(String html) async {
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1500)));
    AppLogger.info('PDF aus HTML generiert');

    // Simuliere PDF-Generierung aus HTML
    final contentLength = html.length;
    final pdfBytes =
        List.generate(600 + contentLength, (index) => _random.nextInt(256));
    return Uint8List.fromList(pdfBytes);
  }

  @override
  Future<String> generatePdfPreview(
      String templateId, Map<String, dynamic> data) async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));
    AppLogger.info('PDF-Vorschau generiert: $templateId');

    // Verwende das PDF Mock-Data Repository für bessere Vorschau
    return _pdfMockData.generatePreview(templateId, data);
  }

  @override
  Future<String> exportPdfDocument(String documentId, String format) async {
    await Future.delayed(Duration(milliseconds: 600 + _random.nextInt(1000)));
    AppLogger.info('PDF-Dokument exportiert: $documentId ($format)');

    // Simuliere Export-Pfad
    return '/exports/document_${documentId}_${DateTime.now().millisecondsSinceEpoch}.$format';
  }

  @override
  Future<bool> sharePdfDocument(String documentId, String platform) async {
    await Future.delayed(Duration(milliseconds: 400 + _random.nextInt(600)));
    AppLogger.info('PDF-Dokument geteilt: $documentId über $platform');
    return true;
  }

  @override
  Future<bool> printPdfDocument(String documentId) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));
    AppLogger.info('PDF-Dokument gedruckt: $documentId');
    return true;
  }

  @override
  Future<bool> uploadPdfToEpa(String documentId, String caseId) async {
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1200)));
    AppLogger.info('PDF in ePA hochgeladen: $documentId für Fall $caseId');
    return true;
  }

  @override
  Future<Map<String, dynamic>> generatePdfStatistics() async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(800)));
    AppLogger.info('PDF-Statistiken generiert');

    // Verwende das PDF Mock-Data Repository für bessere Statistiken
    final documentsData = _documents
        .map((doc) => {
              'id': doc.id,
              'title': doc.title,
              'templateType': doc.templateType,
              'createdAt': doc.createdAt,
            })
        .toList();

    final templatesData = _templates
        .map((template) => {
              'id': template.id,
              'name': template.name,
              'category': template.category,
            })
        .toList();

    return _pdfMockData.generateStatistics(documentsData, templatesData);
  }

  @override
  Future<bool> backupPdfDocuments() async {
    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(2000)));
    AppLogger.info('PDF-Dokumente gesichert');
    return true;
  }

  @override
  Future<bool> restorePdfDocuments(String backupPath) async {
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1500)));
    AppLogger.info('PDF-Dokumente wiederhergestellt: $backupPath');
    return true;
  }
}
