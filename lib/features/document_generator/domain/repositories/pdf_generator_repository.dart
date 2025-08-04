// features/document_generator/domain/repositories/pdf_generator_repository.dart

import 'dart:typed_data';

import '../entities/pdf_document.dart';
import '../entities/pdf_template.dart';

/// Repository-Interface für PDF-Generator
abstract class PdfGeneratorRepository {
  /// PDF-Dokument erstellen
  Future<PdfDocument> createPdfDocument(PdfDocument document);

  /// PDF-Dokument laden
  Future<PdfDocument?> getPdfDocument(String id);

  /// Alle PDF-Dokumente laden
  Future<List<PdfDocument>> getAllPdfDocuments();

  /// PDF-Dokument aktualisieren
  Future<PdfDocument> updatePdfDocument(PdfDocument document);

  /// PDF-Dokument löschen
  Future<bool> deletePdfDocument(String id);

  /// PDF-Dokumente nach Template-Typ filtern
  Future<List<PdfDocument>> getPdfDocumentsByTemplateType(String templateType);

  /// PDF-Dokumente nach Autor filtern
  Future<List<PdfDocument>> getPdfDocumentsByAuthor(String author);

  /// PDF-Dokumente nach Tags filtern
  Future<List<PdfDocument>> getPdfDocumentsByTags(List<String> tags);

  /// PDF-Dokumente suchen
  Future<List<PdfDocument>> searchPdfDocuments(String query);

  /// PDF-Template erstellen
  Future<PdfTemplate> createPdfTemplate(PdfTemplate template);

  /// PDF-Template laden
  Future<PdfTemplate?> getPdfTemplate(String id);

  /// Alle PDF-Templates laden
  Future<List<PdfTemplate>> getAllPdfTemplates();

  /// Aktive PDF-Templates laden
  Future<List<PdfTemplate>> getActivePdfTemplates();

  /// PDF-Template aktualisieren
  Future<PdfTemplate> updatePdfTemplate(PdfTemplate template);

  /// PDF-Template löschen
  Future<bool> deletePdfTemplate(String id);

  /// PDF-Templates nach Kategorie filtern
  Future<List<PdfTemplate>> getPdfTemplatesByCategory(String category);

  /// PDF-Templates nach Typ filtern
  Future<List<PdfTemplate>> getPdfTemplatesByType(String templateType);

  /// PDF aus Template generieren
  Future<Uint8List> generatePdfFromTemplate(
    String templateId,
    Map<String, dynamic> data,
  );

  /// PDF aus HTML generieren
  Future<Uint8List> generatePdfFromHtml(String html);

  /// PDF-Vorschau generieren
  Future<String> generatePdfPreview(
      String templateId, Map<String, dynamic> data);

  /// PDF-Dokument exportieren
  Future<String> exportPdfDocument(String documentId, String format);

  /// PDF-Dokument teilen
  Future<bool> sharePdfDocument(String documentId, String platform);

  /// PDF-Dokument drucken
  Future<bool> printPdfDocument(String documentId);

  /// PDF-Dokument in ePA hochladen
  Future<bool> uploadPdfToEpa(String documentId, String caseId);

  /// PDF-Statistiken generieren
  Future<Map<String, dynamic>> generatePdfStatistics();

  /// PDF-Dokumente sichern
  Future<bool> backupPdfDocuments();

  /// PDF-Dokumente wiederherstellen
  Future<bool> restorePdfDocuments(String backupPath);
}
