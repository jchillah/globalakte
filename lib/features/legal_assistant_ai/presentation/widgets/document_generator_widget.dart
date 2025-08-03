// features/legal_assistant_ai/presentation/widgets/document_generator_widget.dart
import 'package:flutter/material.dart';

import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../domain/usecases/legal_ai_usecases.dart';

/// Widget für die Dokument-Generierung
class DocumentGeneratorWidget extends StatefulWidget {
  final GenerateLegalDocumentUseCase generateDocumentUseCase;
  final String selectedContext;
  final bool isLoading;

  const DocumentGeneratorWidget({
    super.key,
    required this.generateDocumentUseCase,
    required this.selectedContext,
    required this.isLoading,
  });

  @override
  State<DocumentGeneratorWidget> createState() =>
      _DocumentGeneratorWidgetState();
}

class _DocumentGeneratorWidgetState extends State<DocumentGeneratorWidget> {
  final TextEditingController _templateController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  String? _generatedDocument;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _initializeTemplate();
  }

  void _initializeTemplate() {
    _templateController.text = '''
# Rechtliches Dokument

**Betreff:** {{betreff}}
**Datum:** {{datum}}
**Parteien:** {{parteien}}

## Sachverhalt
{{sachverhalt}}

## Rechtliche Bewertung
{{bewertung}}

## Empfehlungen
{{empfehlungen}}

---
*Erstellt mit GlobalAkte Legal AI*
    ''';
  }

  @override
  void dispose() {
    _templateController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _generateDocument() async {
    if (_templateController.text.trim().isEmpty) {
      SnackBarUtils.showErrorSnackBar(
        context,
        'Bitte geben Sie eine Vorlage ein',
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      // Parse JSON data
      Map<String, dynamic> data = {};
      if (_dataController.text.trim().isNotEmpty) {
        try {
          data = Map<String, dynamic>.from(
            // Simple JSON parsing for demo
            _parseSimpleJson(_dataController.text),
          );
        } catch (e) {
          SnackBarUtils.showErrorSnackBar(
            context,
            'Ungültiges JSON-Format: $e',
          );
          setState(() => _isGenerating = false);
          return;
        }
      }

      final document = await widget.generateDocumentUseCase(
        template: _templateController.text,
        data: data,
        context:
            widget.selectedContext.isNotEmpty ? widget.selectedContext : null,
      );

      if (!mounted) return;

      setState(() {
        _generatedDocument = document;
        _isGenerating = false;
      });

      SnackBarUtils.showSuccessSnackBar(
        context,
        'Dokument erfolgreich generiert',
      );
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Fehler bei der Dokument-Generierung: $e',
      );
      setState(() => _isGenerating = false);
    }
  }

  Map<String, dynamic> _parseSimpleJson(String text) {
    final lines = text.split('\n');
    final Map<String, dynamic> result = {};

    for (final line in lines) {
      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join(':').trim();
          result[key] = value;
        }
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dokument-Generator',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          // Template-Bereich
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vorlage',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  GlobalTextField(
                    controller: _templateController,
                    label: 'Dokument-Vorlage',
                    hint: 'Geben Sie Ihre Vorlage ein...',
                    maxLines: 10,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Daten-Bereich
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daten (JSON-Format)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  GlobalTextField(
                    controller: _dataController,
                    label: 'Daten',
                    hint:
                        'betreff: Mietkündigung\ndatum: 2024-01-15\nparteien: Mieter und Vermieter\nsachverhalt: ...',
                    maxLines: 8,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Kontext-Anzeige
          if (widget.selectedContext.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kontext: ${widget.selectedContext}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Generieren-Button
          SizedBox(
            width: double.infinity,
            child: GlobalButton(
              onPressed:
                  widget.isLoading || _isGenerating ? null : _generateDocument,
              text: 'Dokument generieren',
              isLoading: _isGenerating,
            ),
          ),

          const SizedBox(height: 16),

          // Generiertes Dokument
          if (_generatedDocument != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.description, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Generiertes Dokument',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            // Copy to clipboard
                            // Clipboard.setData(ClipboardData(text: _generatedDocument!));
                            SnackBarUtils.showSuccessSnackBar(
                              context,
                              'Dokument kopiert',
                            );
                          },
                          icon: const Icon(Icons.copy),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        _generatedDocument!,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
