// features/document_generator/domain/usecases/pdf_generator_usecases.dart

import 'dart:typed_data';

import '../entities/pdf_document.dart';
import '../entities/pdf_template.dart';
import '../repositories/pdf_generator_repository.dart';

/// Use Cases für PDF-Generator
class PdfGeneratorUseCases {
  final PdfGeneratorRepository _repository;

  const PdfGeneratorUseCases(this._repository);

  /// PDF-Dokument erstellen
  Future<PdfDocument> createPdfDocument(PdfDocument document) async {
    return await _repository.createPdfDocument(document);
  }

  /// PDF-Dokument laden
  Future<PdfDocument?> getPdfDocument(String id) async {
    return await _repository.getPdfDocument(id);
  }

  /// Alle PDF-Dokumente laden
  Future<List<PdfDocument>> getAllPdfDocuments() async {
    return await _repository.getAllPdfDocuments();
  }

  /// PDF-Dokument aktualisieren
  Future<PdfDocument> updatePdfDocument(PdfDocument document) async {
    return await _repository.updatePdfDocument(document);
  }

  /// PDF-Dokument löschen
  Future<bool> deletePdfDocument(String id) async {
    return await _repository.deletePdfDocument(id);
  }

  /// PDF-Dokumente nach Template-Typ filtern
  Future<List<PdfDocument>> getPdfDocumentsByTemplateType(
      String templateType) async {
    return await _repository.getPdfDocumentsByTemplateType(templateType);
  }

  /// PDF-Dokumente nach Autor filtern
  Future<List<PdfDocument>> getPdfDocumentsByAuthor(String author) async {
    return await _repository.getPdfDocumentsByAuthor(author);
  }

  /// PDF-Dokumente nach Tags filtern
  Future<List<PdfDocument>> getPdfDocumentsByTags(List<String> tags) async {
    return await _repository.getPdfDocumentsByTags(tags);
  }

  /// PDF-Dokumente suchen
  Future<List<PdfDocument>> searchPdfDocuments(String query) async {
    return await _repository.searchPdfDocuments(query);
  }

  /// PDF-Template erstellen
  Future<PdfTemplate> createPdfTemplate(PdfTemplate template) async {
    return await _repository.createPdfTemplate(template);
  }

  /// PDF-Template laden
  Future<PdfTemplate?> getPdfTemplate(String id) async {
    return await _repository.getPdfTemplate(id);
  }

  /// Alle PDF-Templates laden
  Future<List<PdfTemplate>> getAllPdfTemplates() async {
    return await _repository.getAllPdfTemplates();
  }

  /// Aktive PDF-Templates laden
  Future<List<PdfTemplate>> getActivePdfTemplates() async {
    return await _repository.getActivePdfTemplates();
  }

  /// PDF-Template aktualisieren
  Future<PdfTemplate> updatePdfTemplate(PdfTemplate template) async {
    return await _repository.updatePdfTemplate(template);
  }

  /// PDF-Template löschen
  Future<bool> deletePdfTemplate(String id) async {
    return await _repository.deletePdfTemplate(id);
  }

  /// PDF-Templates nach Kategorie filtern
  Future<List<PdfTemplate>> getPdfTemplatesByCategory(String category) async {
    return await _repository.getPdfTemplatesByCategory(category);
  }

  /// PDF-Templates nach Typ filtern
  Future<List<PdfTemplate>> getPdfTemplatesByType(String templateType) async {
    return await _repository.getPdfTemplatesByType(templateType);
  }

  /// PDF aus Template generieren
  Future<Uint8List> generatePdfFromTemplate(
    String templateId,
    Map<String, dynamic> data,
  ) async {
    return await _repository.generatePdfFromTemplate(templateId, data);
  }

  /// PDF aus HTML generieren
  Future<Uint8List> generatePdfFromHtml(String html) async {
    return await _repository.generatePdfFromHtml(html);
  }

  /// PDF-Vorschau generieren
  Future<String> generatePdfPreview(
      String templateId, Map<String, dynamic> data) async {
    return await _repository.generatePdfPreview(templateId, data);
  }

  /// PDF-Dokument exportieren
  Future<String> exportPdfDocument(String documentId, String format) async {
    return await _repository.exportPdfDocument(documentId, format);
  }

  /// PDF-Dokument teilen
  Future<bool> sharePdfDocument(String documentId, String platform) async {
    return await _repository.sharePdfDocument(documentId, platform);
  }

  /// PDF-Dokument drucken
  Future<bool> printPdfDocument(String documentId) async {
    return await _repository.printPdfDocument(documentId);
  }

  /// PDF-Dokument in ePA hochladen
  Future<bool> uploadPdfToEpa(String documentId, String caseId) async {
    return await _repository.uploadPdfToEpa(documentId, caseId);
  }

  /// PDF-Statistiken generieren
  Future<Map<String, dynamic>> generatePdfStatistics() async {
    return await _repository.generatePdfStatistics();
  }

  /// PDF-Dokumente sichern
  Future<bool> backupPdfDocuments() async {
    return await _repository.backupPdfDocuments();
  }

  /// PDF-Dokumente wiederherstellen
  Future<bool> restorePdfDocuments(String backupPath) async {
    return await _repository.restorePdfDocuments(backupPath);
  }

  /// PDF-Dokument mit Template erstellen
  Future<PdfDocument> createPdfDocumentWithTemplate(
    String templateId,
    String title,
    Map<String, dynamic> data,
    String author,
    List<String> tags,
  ) async {
    final template = await _repository.getPdfTemplate(templateId);
    if (template == null) {
      throw Exception('Template nicht gefunden: $templateId');
    }

    // HTML-Inhalt aus Template mit eingegebenen Daten generieren
    final htmlContent = _generateHtmlFromTemplate(template, data);

    // PDF-Bytes generieren
    final pdfBytes =
        await _repository.generatePdfFromTemplate(templateId, data);

    // Dokument mit den eingegebenen Daten erstellen
    final document = PdfDocument(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: _extractTextFromHtml(htmlContent), // Text-Inhalt extrahieren
      templateType: template.templateType,
      metadata: {
        'templateId': templateId,
        'author': author,
        'data': data,
        'htmlContent': htmlContent,
        'pdfBytes': pdfBytes.length,
        'generatedAt': DateTime.now().toIso8601String(),
      },
      createdAt: DateTime.now(),
      author: author,
      tags: tags,
    );

    return await _repository.createPdfDocument(document);
  }

  /// HTML aus Template generieren
  String _generateHtmlFromTemplate(
      PdfTemplate template, Map<String, dynamic> data) {
    String html = template.htmlTemplate;

    // Template-Variablen ersetzen mit Userflow-Behandlung
    for (final entry in data.entries) {
      final placeholder = '{{${entry.key}}}';
      final value = _processTextForPdf(entry.value?.toString() ?? '');
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

  /// Text für PDF-Verarbeitung optimieren (Userflow-Behandlung)
  String _processTextForPdf(String text) {
    if (text.isEmpty) return text;

    // Lange Wörter umbrechen
    text = _wrapLongWords(text);

    // Zeilenumbrüche für bessere Lesbarkeit
    text = _addLineBreaks(text);

    // HTML-Entities korrekt behandeln
    text = _escapeHtmlEntities(text);

    return text;
  }

  /// Lange Wörter umbrechen
  String _wrapLongWords(String text) {
    const maxWordLength = 20; // Maximale Wortlänge vor Umbruch
    final words = text.split(' ');
    final processedWords = words.map((word) {
      if (word.length > maxWordLength) {
        // Wort in der Mitte umbrechen
        final mid = (word.length / 2).round();
        return '${word.substring(0, mid)}&shy;${word.substring(mid)}';
      }
      return word;
    });
    return processedWords.join(' ');
  }

  /// Zeilenumbrüche für bessere Lesbarkeit hinzufügen
  String _addLineBreaks(String text) {
    // Nach Satzzeichen Zeilenumbrüche hinzufügen
    text = text.replaceAllMapped(
      RegExp(r'([.!?])\s+'),
      (match) => '${match.group(1)}<br><br>${match.group(2) ?? ''}',
    );

    // Lange Absätze in kleinere Teile aufteilen
    const maxLineLength = 80;
    if (text.length > maxLineLength) {
      final sentences = text.split(RegExp(r'[.!?]'));
      final processedSentences = sentences.map((sentence) {
        if (sentence.trim().length > maxLineLength) {
          // Satz in kleinere Teile aufteilen
          final words = sentence.trim().split(' ');
          final lines = <String>[];
          String currentLine = '';

          for (final word in words) {
            if ((currentLine + word).length > maxLineLength) {
              if (currentLine.isNotEmpty) {
                lines.add(currentLine.trim());
                currentLine = word;
              } else {
                currentLine = word;
              }
            } else {
              currentLine += (currentLine.isEmpty ? '' : ' ') + word;
            }
          }

          if (currentLine.isNotEmpty) {
            lines.add(currentLine.trim());
          }

          return lines.join('<br>');
        }
        return sentence.trim();
      });

      text = processedSentences.where((s) => s.isNotEmpty).join('. ');
    }

    return text;
  }

  /// HTML-Entities korrekt behandeln
  String _escapeHtmlEntities(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  /// Text aus HTML extrahieren
  String _extractTextFromHtml(String html) {
    // Einfache HTML-Tag-Entfernung für bessere Lesbarkeit
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '') // HTML-Tags entfernen
        .replaceAll('&nbsp;', ' ') // HTML-Entities ersetzen
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  /// PDF-Dokument validieren
  bool validatePdfDocument(PdfDocument document) {
    if (document.title.isEmpty) return false;
    if (document.content.isEmpty) return false;
    if (document.templateType.isEmpty) return false;
    return true;
  }

  /// PDF-Template validieren
  bool validatePdfTemplate(PdfTemplate template) {
    if (template.name.isEmpty) return false;
    if (template.htmlTemplate.isEmpty) return false;
    if (template.templateType.isEmpty) return false;
    return true;
  }
}
