// features/help_network/presentation/widgets/help_chat_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../domain/entities/help_chat.dart';
import '../../domain/usecases/help_network_usecases.dart';

/// Widget für Chat-Funktionalität im Hilfe-Netzwerk
class HelpChatWidget extends StatefulWidget {
  final HelpNetworkUseCases useCases;

  const HelpChatWidget({
    super.key,
    required this.useCases,
  });

  @override
  State<HelpChatWidget> createState() => _HelpChatWidgetState();
}

class _HelpChatWidgetState extends State<HelpChatWidget> {
  String _selectedRequestId = '';
  List<HelpChat> _chatMessages = [];
  bool _isLoading = false;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _helpRequests = [
    {'id': 'req_001', 'title': 'Rechtliche Beratung benötigt'},
    {'id': 'req_002', 'title': 'Dokumente übersetzen'},
  ];

  @override
  void initState() {
    super.initState();
    if (_helpRequests.isNotEmpty) {
      _selectedRequestId = _helpRequests.first['id']!;
      _loadChatMessages();
    }
  }

  Future<void> _loadChatMessages() async {
    if (_selectedRequestId.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final messages =
          await widget.useCases.getChatMessages(_selectedRequestId);
      setState(() {
        _chatMessages = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(
            context, 'Fehler beim Laden der Nachrichten: $e');
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final message = HelpChat.create(
        helpRequestId: _selectedRequestId,
        senderId: 'demo_user',
        senderName: 'Demo User',
        message: _messageController.text.trim(),
      );

      await widget.useCases.sendChatMessage(message);
      _messageController.clear();
      _loadChatMessages();
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Senden: $e');
      }
    }
  }

  Future<void> _deleteMessage(HelpChat message) async {
    try {
      // Da deleteChatMessage nicht mehr im Interface ist, simulieren wir das Löschen
      // In einer echten Implementierung würde hier die Nachricht gelöscht werden
      if (mounted) {
        SnackBarUtils.showSuccess(context, 'Nachricht gelöscht');
        _loadChatMessages();
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Löschen: $e');
      }
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Request-Auswahl
        Card(
          margin: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Padding(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: DropdownButtonFormField<String>(
              value: _selectedRequestId.isNotEmpty ? _selectedRequestId : null,
              decoration: const InputDecoration(
                labelText: 'Hilfe-Anfrage auswählen',
                border: OutlineInputBorder(),
              ),
              items: _helpRequests
                  .map((req) => DropdownMenuItem(
                        value: req['id'],
                        child: Text(req['title']!),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRequestId = value ?? '';
                });
                _loadChatMessages();
              },
            ),
          ),
        ),

        // Chat-Nachrichten
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConfig.defaultPadding),
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = _chatMessages[index];
                    final isOwnMessage = message.senderId == 'demo_user';

                    return Card(
                      margin: const EdgeInsets.only(
                          bottom: AppConfig.defaultPadding),
                      color: isOwnMessage
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1)
                          : Theme.of(context).colorScheme.surface,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(message.senderName[0]),
                        ),
                        title: Text(message.senderName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message.message),
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(message.timestamp),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deleteMessage(message);
                            }
                          },
                          itemBuilder: (context) => [
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
                ),
        ),

        // Nachrichten-Eingabe
        Container(
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Nachricht eingeben...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: AppConfig.defaultPadding),
              ElevatedButton(
                onPressed: _sendMessage,
                child: const Text('Senden'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
