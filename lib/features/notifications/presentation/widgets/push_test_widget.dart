// features/notifications/presentation/widgets/push_test_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../domain/usecases/notification_usecases.dart';

/// Widget für Push-Benachrichtigungstests
class PushTestWidget extends StatefulWidget {
  final NotificationUseCases useCases;

  const PushTestWidget({
    super.key,
    required this.useCases,
  });

  @override
  State<PushTestWidget> createState() => _PushTestWidgetState();
}

class _PushTestWidgetState extends State<PushTestWidget> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'system';
  String _selectedType = 'info';
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = 'Test-Benachrichtigung';
    _messageController.text = 'Dies ist eine Test-Benachrichtigung';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendTestNotification() async {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte füllen Sie alle Felder aus')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // Erstelle eine neue Benachrichtigung
      await widget.useCases.createNotification(
        title: _titleController.text,
        message: _messageController.text,
        type: _selectedType,
        category: _selectedCategory,
      );

      // Sende Push-Benachrichtigung
      final success = await widget.useCases.sendPushNotification(
        title: _titleController.text,
        message: _messageController.text,
        category: _selectedCategory,
      );

      if (mounted) {
        // Zeige Erfolgsmeldung
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Test-Benachrichtigung erfolgreich gesendet!'
                : 'Fehler beim Senden'),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Senden der Test-Benachrichtigung: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _sendQuickTest(String type) async {
    final testData = {
      'info': {
        'title': 'Info-Benachrichtigung',
        'message': 'Dies ist eine Informations-Benachrichtigung',
        'category': 'system',
      },
      'success': {
        'title': 'Erfolg-Benachrichtigung',
        'message': 'Die Aktion wurde erfolgreich ausgeführt',
        'category': 'system',
      },
      'warning': {
        'title': 'Warnung-Benachrichtigung',
        'message': 'Bitte beachten Sie diese wichtige Warnung',
        'category': 'system',
      },
      'error': {
        'title': 'Fehler-Benachrichtigung',
        'message': 'Ein Fehler ist aufgetreten',
        'category': 'system',
      },
      'case': {
        'title': 'Neue Fallakte',
        'message': 'Fallakte "Test vs. Demo" wurde erstellt',
        'category': 'case',
      },
      'document': {
        'title': 'Dokument hochgeladen',
        'message': 'Ein neues Dokument wurde hinzugefügt',
        'category': 'document',
      },
      'appointment': {
        'title': 'Termin-Erinnerung',
        'message': 'Ihr Termin steht in 30 Minuten an',
        'category': 'appointment',
      },
    };

    final data = testData[type];
    if (data == null) return;

    setState(() {
      _isSending = true;
    });

    try {
      final success = await widget.useCases.sendPushNotification(
        title: data['title']!,
        message: data['message']!,
        category: data['category'],
        data: {
          'test': true,
          'type': type,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Test-Benachrichtigung gesendet!'
                : 'Fehler beim Senden'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(),
          const SizedBox(height: 24),
          _buildQuickTests(),
          const SizedBox(height: 24),
          _buildCustomTest(),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Push-Benachrichtigungen\ntesten',
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Testen Sie Push-Benachrichtigungen mit verschiedenen Inhalten und Kategorien. '
              'Diese Funktion ist nur für Entwicklungs- und Testzwecke gedacht.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTests() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schnell-Tests',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Vordefinierte Test-Benachrichtigungen für verschiedene Szenarien',
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickTestButton('info', 'Info', Colors.blue),
                _buildQuickTestButton('success', 'Erfolg', Colors.green),
                _buildQuickTestButton('warning', 'Warnung', Colors.orange),
                _buildQuickTestButton('error', 'Fehler', Colors.red),
                _buildQuickTestButton('case', 'Fallakte', Colors.purple),
                _buildQuickTestButton('document', 'Dokument', Colors.teal),
                _buildQuickTestButton('appointment', 'Termin', Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTestButton(String type, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: _isSending ? null : () => _sendQuickTest(type),
      icon: Icon(Icons.send, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildCustomTest() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benutzerdefinierter Test',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Titel
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titel',
                hintText: 'Benachrichtigungstitel eingeben',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Nachricht
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Nachricht',
                hintText: 'Benachrichtigungsnachricht eingeben',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Kategorie
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategorie',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System')),
                DropdownMenuItem(value: 'case', child: Text('Fallakte')),
                DropdownMenuItem(value: 'document', child: Text('Dokument')),
                DropdownMenuItem(value: 'appointment', child: Text('Termin')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Typ
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Typ',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'info', child: Text('Info')),
                DropdownMenuItem(value: 'success', child: Text('Erfolg')),
                DropdownMenuItem(value: 'warning', child: Text('Warnung')),
                DropdownMenuItem(value: 'error', child: Text('Fehler')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 24),

            // Senden-Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSending ? null : _sendTestNotification,
                icon: _isSending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(_isSending
                    ? 'Wird gesendet...'
                    : 'Push-Benachrichtigung senden'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
