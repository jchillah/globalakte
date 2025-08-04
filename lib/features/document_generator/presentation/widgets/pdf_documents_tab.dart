// features/document_generator/presentation/widgets/pdf_documents_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_config.dart';
import '../../domain/entities/pdf_document.dart';
import '../../domain/usecases/pdf_generator_usecases.dart';

/// Widget für den PDF-Dokumente-Tab
class PdfDocumentsTab extends StatefulWidget {
  final List<PdfDocument> documents;
  final bool isLoading;
  final PdfGeneratorUseCases useCases;
  final VoidCallback onDataChanged;

  const PdfDocumentsTab({
    super.key,
    required this.documents,
    required this.isLoading,
    required this.useCases,
    required this.onDataChanged,
  });

  @override
  State<PdfDocumentsTab> createState() => _PdfDocumentsTabState();
}

class _PdfDocumentsTabState extends State<PdfDocumentsTab> {
  IconData _getDocumentIcon(String templateType) {
    switch (templateType.toLowerCase()) {
      case 'contract':
        return Icons.description;
      case 'letter':
        return Icons.mail;
      case 'application':
        return Icons.assignment;
      case 'report':
        return Icons.assessment;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getDocumentColor(String templateType) {
    switch (templateType.toLowerCase()) {
      case 'contract':
        return Colors.blue;
      case 'letter':
        return Colors.green;
      case 'application':
        return Colors.orange;
      case 'report':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getDocumentTypeName(String templateType) {
    switch (templateType.toLowerCase()) {
      case 'contract':
        return 'Vertrag';
      case 'letter':
        return 'Brief';
      case 'application':
        return 'Antrag';
      case 'report':
        return 'Bericht';
      default:
        return templateType;
    }
  }

  Future<void> _sharePdf(BuildContext context, Uint8List pdfBytes) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Simuliere Teilen
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: const Text('PDF geteilt!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Fehler beim Teilen: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _printPdf(BuildContext context, Uint8List pdfBytes) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Simuliere Drucken
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: const Text('PDF wird gedruckt!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Fehler beim Drucken: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _uploadToEpa(BuildContext context, PdfDocument document) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final success =
          await widget.useCases.uploadPdfToEpa(document.id, 'demo-case-id');

      if (mounted) {
        if (success) {
          messenger.showSnackBar(
            SnackBar(
              content: const Text('PDF erfolgreich in ePA hochgeladen!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          messenger.showSnackBar(
            SnackBar(
              content: const Text('Fehler beim Hochladen in ePA'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Fehler beim Hochladen: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _deleteDocument(
      BuildContext context, PdfDocument document) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final success = await widget.useCases.deletePdfDocument(document.id);
      if (mounted) {
        if (success) {
          messenger.showSnackBar(
            SnackBar(
              content: const Text('Dokument gelöscht!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          widget.onDataChanged();
        } else {
          messenger.showSnackBar(
            SnackBar(
              content: const Text('Fehler beim Löschen'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Fehler beim Löschen: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _showDocumentDetails(PdfDocument document) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        document.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppConfig.defaultPadding),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Typ: ${_getDocumentTypeName(document.templateType)}'),
                        Text('Autor: ${document.author ?? 'Unbekannt'}'),
                        Text('Erstellt: ${document.formattedCreatedAt}'),
                        if (document.updatedAt != null)
                          Text('Aktualisiert: ${document.formattedUpdatedAt}'),
                        if (document.tags.isNotEmpty)
                          Text('Tags: ${document.tags.join(', ')}'),
                        const SizedBox(height: AppConfig.defaultPadding),
                        const Text('PDF-Vorschau:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppConfig.smallPadding),
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(AppConfig.defaultPadding),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppConfig.defaultRadius),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // PDF-Header simulieren
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(
                                    AppConfig.defaultPadding),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade300)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      document.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade700,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Erstellt am ${document.formattedCreatedAt}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              // PDF-Inhalt simulieren
                              Padding(
                                padding: const EdgeInsets.all(
                                    AppConfig.defaultPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dokument-Inhalt',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(
                                        height: AppConfig.smallPadding),
                                    Text(
                                      'Dies ist eine Vorschau des generierten PDF-Dokuments. '
                                      'In einer echten Implementierung würde hier das gerenderte PDF angezeigt werden.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const SizedBox(
                                        height: AppConfig.defaultPadding),
                                    Container(
                                      padding: const EdgeInsets.all(
                                          AppConfig.defaultPadding),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(
                                            AppConfig.defaultRadius),
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dokument-Metadaten:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                              'Template: ${document.templateType}'),
                                          Text(
                                              'Autor: ${document.author ?? 'Unbekannt'}'),
                                          if (document.tags.isNotEmpty)
                                            Text(
                                                'Tags: ${document.tags.join(', ')}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConfig.defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _sharePdf(context, Uint8List(100)),
                        child: const Text('Teilen'),
                      ),
                    ),
                    const SizedBox(width: AppConfig.defaultPadding),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _printPdf(context, Uint8List(100)),
                        child: const Text('Drucken'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            itemCount: widget.documents.length,
            itemBuilder: (context, index) {
              final document = widget.documents[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
                child: ListTile(
                  leading: Icon(
                    _getDocumentIcon(document.templateType),
                    color: _getDocumentColor(document.templateType),
                  ),
                  title: Text(document.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Typ: ${_getDocumentTypeName(document.templateType)}'),
                      Text('Autor: ${document.author ?? 'Unbekannt'}'),
                      Text('Erstellt: ${document.formattedCreatedAt}'),
                      if (document.tags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: document.tags
                              .map((tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor:
                                        Colors.blue.withValues(alpha: 0.1),
                                  ))
                              .toList(),
                        ),
                      const SizedBox(height: 8),
                      // PDF-Vorschau direkt in der Karte
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.picture_as_pdf,
                                    size: 16, color: Colors.red[700]),
                                const SizedBox(width: 4),
                                Text(
                                  'PDF-Vorschau',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              document.content.isNotEmpty
                                  ? document.content.length > 100
                                      ? '${document.content.substring(0, 100)}...'
                                      : document.content
                                  : 'Kein Inhalt verfügbar',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _showDocumentDetails(document),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      switch (value) {
                        case 'share':
                          await _sharePdf(context, Uint8List(100));
                          break;
                        case 'print':
                          await _printPdf(context, Uint8List(100));
                          break;
                        case 'epa':
                          await _uploadToEpa(context, document);
                          break;
                        case 'delete':
                          await _deleteDocument(context, document);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share),
                            SizedBox(width: 8),
                            Text('Teilen'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'print',
                        child: Row(
                          children: [
                            Icon(Icons.print),
                            SizedBox(width: 8),
                            Text('Drucken'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'epa',
                        child: Row(
                          children: [
                            Icon(Icons.upload),
                            SizedBox(width: 8),
                            Text('ePA hochladen'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Löschen',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
