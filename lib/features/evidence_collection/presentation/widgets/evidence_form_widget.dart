// features/evidence_collection/presentation/widgets/evidence_form_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../domain/entities/evidence_item.dart';
import '../../domain/usecases/evidence_usecases.dart';

/// Widget für das Hinzufügen neuer Beweismittel
class EvidenceFormWidget extends StatefulWidget {
  final SaveEvidenceUseCase saveEvidenceUseCase;
  final VoidCallback onEvidenceSaved;

  const EvidenceFormWidget({
    super.key,
    required this.saveEvidenceUseCase,
    required this.onEvidenceSaved,
  });

  @override
  State<EvidenceFormWidget> createState() => _EvidenceFormWidgetState();
}

class _EvidenceFormWidgetState extends State<EvidenceFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _caseIdController = TextEditingController();

  String _selectedType = 'photo';
  bool _isSaving = false;

  final List<Map<String, String>> _evidenceTypes = [
    {'value': 'photo', 'label': 'Foto'},
    {'value': 'video', 'label': 'Video'},
    {'value': 'document', 'label': 'Dokument'},
    {'value': 'audio', 'label': 'Audio'},
    {'value': 'physical', 'label': 'Physisches Beweismittel'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _caseIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Neues Beweismittel hinzufügen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Titel
            GlobalTextField(
              controller: _titleController,
              label: 'Titel *',
              hint: 'z.B. Fotos vom Unfallort',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Titel ist erforderlich';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Beschreibung
            GlobalTextField(
              controller: _descriptionController,
              label: 'Beschreibung *',
              hint: 'Detaillierte Beschreibung des Beweismittels',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Beschreibung ist erforderlich';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Typ
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Typ *',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _evidenceTypes.map((type) {
                        return ChoiceChip(
                          label: Text(type['label']!),
                          selected: _selectedType == type['value'],
                          onSelected: (selected) {
                            setState(() => _selectedType = type['value']!);
                          },
                          selectedColor:
                              AppConfig.primaryColor.withValues(alpha: 0.2),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Ort
            GlobalTextField(
              controller: _locationController,
              label: 'Ort *',
              hint: 'z.B. Hauptstraße 123, Berlin',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ort ist erforderlich';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Fall-ID (optional)
            GlobalTextField(
              controller: _caseIdController,
              label: 'Fall-ID (optional)',
              hint: 'z.B. CASE-2024-001',
            ),

            const SizedBox(height: 16),

            // Notizen (optional)
            GlobalTextField(
              controller: _notesController,
              label: 'Notizen (optional)',
              hint: 'Zusätzliche Informationen oder Beobachtungen',
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Speichern-Button
            SizedBox(
              width: double.infinity,
              child: GlobalButton(
                onPressed: _isSaving ? null : _saveEvidence,
                text: 'Beweismittel speichern',
                isLoading: _isSaving,
              ),
            ),

            const SizedBox(height: 16),

            // Info-Box
            Card(
              color: AppConfig.primaryColor.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppConfig.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Hinweise',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppConfig.primaryColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Alle mit * markierten Felder sind erforderlich\n'
                      '• Beweismittel werden zunächst als "Ausstehend" markiert\n'
                      '• Nach dem Speichern können Sie das Beweismittel verifizieren\n'
                      '• Dateien können später über die Bearbeitung hinzugefügt werden',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEvidence() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final evidence = EvidenceItem.create(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        filePath:
            '/evidence/$_selectedType/${DateTime.now().millisecondsSinceEpoch}',
        collectedBy: 'Demo User',
        location: _locationController.text.trim(),
        caseId: _caseIdController.text.trim().isEmpty
            ? null
            : _caseIdController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      await widget.saveEvidenceUseCase(evidence);

      if (!mounted) return;

      // Form zurücksetzen
      _formKey.currentState!.reset();
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _notesController.clear();
      _caseIdController.clear();
      setState(() => _selectedType = 'photo');

      // Callback aufrufen
      widget.onEvidenceSaved();
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Fehler beim Speichern: $e',
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
