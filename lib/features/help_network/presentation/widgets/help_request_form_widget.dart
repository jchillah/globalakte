// features/help_network/presentation/widgets/help_request_form_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../domain/usecases/help_network_usecases.dart';

/// Widget für das Erstellen neuer Hilfe-Anfragen
class HelpRequestFormWidget extends StatefulWidget {
  final HelpNetworkUseCases useCases;

  const HelpRequestFormWidget({
    super.key,
    required this.useCases,
  });

  @override
  State<HelpRequestFormWidget> createState() => _HelpRequestFormWidgetState();
}

class _HelpRequestFormWidgetState extends State<HelpRequestFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _tagsController = TextEditingController();

  String _selectedCategory = 'Behörden';
  String _selectedPriority = 'medium';
  bool _isUrgent = false;
  DateTime? _deadline;
  int? _maxHelpers;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Behörden',
    'Gesundheit',
    'Übersetzung',
    'Bildung',
    'Finanzen',
    'Recht',
    'Sonstiges',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _deadline = date);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      await widget.useCases.createHelpRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        requesterId: 'demo_user',
        requesterName: 'Demo User',
        deadline: _deadline,
        priority: _selectedPriority,
        tags: tags,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        isUrgent: _isUrgent,
        maxHelpers: _maxHelpers,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hilfe-Anfrage erfolgreich erstellt!')),
        );
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Erstellen der Anfrage: $e')),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _tagsController.clear();
    setState(() {
      _selectedCategory = 'Behörden';
      _selectedPriority = 'medium';
      _isUrgent = false;
      _deadline = null;
      _maxHelpers = null;
    });
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
              'Neue Hilfe-Anfrage erstellen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Titel
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titel *',
                hintText: 'Kurzer, beschreibender Titel',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Bitte geben Sie einen Titel ein';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Beschreibung
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Beschreibung *',
                hintText: 'Detaillierte Beschreibung Ihrer Anfrage',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Bitte geben Sie eine Beschreibung ein';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Kategorie
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategorie *',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            const SizedBox(height: 16),

            // Priorität
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priorität *',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'low', child: Text('Niedrig')),
                DropdownMenuItem(value: 'medium', child: Text('Mittel')),
                DropdownMenuItem(value: 'high', child: Text('Hoch')),
                DropdownMenuItem(value: 'urgent', child: Text('Dringend')),
              ],
              onChanged: (value) {
                setState(() => _selectedPriority = value!);
              },
            ),
            const SizedBox(height: 16),

            // Standort
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Standort (optional)',
                hintText: 'z.B. Berlin, Hamburg',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Tags
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (optional)',
                hintText: 'z.B. Behördengang, Formulare, Übersetzung',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Dringend Checkbox
            CheckboxListTile(
              title: const Text('Dringend'),
              subtitle: const Text('Markieren Sie diese Anfrage als dringend'),
              value: _isUrgent,
              onChanged: (value) {
                setState(() => _isUrgent = value!);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 16),

            // Deadline
            ListTile(
              title: const Text('Deadline (optional)'),
              subtitle: Text(_deadline == null
                  ? 'Kein Deadline gesetzt'
                  : 'Deadline: ${_deadline!.toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDeadline,
            ),
            const SizedBox(height: 16),

            // Maximale Helfer
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Maximale Anzahl Helfer (optional)',
                hintText: 'z.B. 2',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _maxHelpers = value.isEmpty ? null : int.tryParse(value);
                });
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Hilfe-Anfrage erstellen'),
              ),
            ),
            const SizedBox(height: 16),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _resetForm,
                child: const Text('Formular zurücksetzen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
