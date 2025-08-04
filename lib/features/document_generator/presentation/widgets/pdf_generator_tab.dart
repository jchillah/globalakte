// features/document_generator/presentation/widgets/pdf_generator_tab.dart

import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../domain/entities/pdf_template.dart';
import '../../domain/usecases/pdf_generator_usecases.dart';

/// Widget für den PDF-Generator-Tab
class PdfGeneratorTab extends StatefulWidget {
  final PdfGeneratorUseCases useCases;
  final List<PdfTemplate> templates;
  final bool isLoading;
  final VoidCallback onDataChanged;

  const PdfGeneratorTab({
    super.key,
    required this.useCases,
    required this.templates,
    required this.isLoading,
    required this.onDataChanged,
  });

  @override
  State<PdfGeneratorTab> createState() => _PdfGeneratorTabState();
}

class _PdfGeneratorTabState extends State<PdfGeneratorTab> {
  String _selectedTemplateId = '';
  final Map<String, TextEditingController> _formControllers = {};
  final Map<String, dynamic> _formData = {};

  void _initializeFormControllers(PdfTemplate template) {
    _formControllers.clear();
    _formData.clear();

    for (final field in template.allFields) {
      _formControllers[field] = TextEditingController(
        text: template.defaultData[field]?.toString() ?? '',
      );
      _formData[field] = template.defaultData[field]?.toString() ?? '';
    }
  }

  Future<void> _generatePdf() async {
    if (_selectedTemplateId.isEmpty) {
      SnackBarUtils.showError(context, 'Bitte ein Template auswählen');
      return;
    }

    try {
      // Form-Daten sammeln
      for (final entry in _formControllers.entries) {
        _formData[entry.key] = entry.value.text;
      }

      // PDF generieren
      await widget.useCases.generatePdfFromTemplate(
        _selectedTemplateId,
        _formData,
      );

      // Dokument erstellen
      final template =
          widget.templates.firstWhere((t) => t.id == _selectedTemplateId);
      await widget.useCases.createPdfDocumentWithTemplate(
        _selectedTemplateId,
        template.name,
        _formData,
        'Demo User',
        ['demo'],
      );

      if (mounted) {
        SnackBarUtils.showSuccess(context, 'PDF erfolgreich generiert!');
        widget.onDataChanged();
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Generieren: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📄 PDF-Dokument generieren',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppConfig.defaultPadding),
                  Text(
                    'Wählen Sie ein Template und füllen Sie die Felder aus, um ein PDF-Dokument zu generieren.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConfig.defaultPadding),

          // Template-Auswahl
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Template auswählen',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppConfig.defaultPadding),
                  DropdownButtonFormField<String>(
                    value: _selectedTemplateId.isEmpty
                        ? null
                        : _selectedTemplateId,
                    decoration: const InputDecoration(
                      labelText: 'Template',
                      border: OutlineInputBorder(),
                    ),
                    items: widget.templates
                        .map((template) => DropdownMenuItem(
                              value: template.id,
                              child: Text(
                                  '${template.name} (${template.displayCategory})'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTemplateId = value ?? '';
                        if (value != null) {
                          final template =
                              widget.templates.firstWhere((t) => t.id == value);
                          _initializeFormControllers(template);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConfig.defaultPadding),

          // Formular
          if (_selectedTemplateId.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dokument-Daten',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConfig.defaultPadding),
                    ..._formControllers.entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppConfig.defaultPadding),
                          child: TextField(
                            controller: entry.value,
                            decoration: InputDecoration(
                              labelText: entry.key,
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _formData[entry.key] = value;
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            GlobalButton(
              onPressed: widget.isLoading ? null : _generatePdf,
              text: 'PDF generieren',
              isLoading: widget.isLoading,
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _formControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
