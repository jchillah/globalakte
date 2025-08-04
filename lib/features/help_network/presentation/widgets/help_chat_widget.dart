// features/help_network/presentation/widgets/help_chat_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
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
  List<HelpChat> _chatMessages = [];
  bool _isLoading = true;
  final _messageController = TextEditingController();
  String _selectedRequestId = 'demo_request_id';

  @override
  void initState() {
    super.initState();
    _loadChatMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadChatMessages() async {
    setState(() => _isLoading = true);
    try {
      final messages = await widget.useCases.getChatMessages(_selectedRequestId);
      setState(() {
        _chatMessages = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden der Nachrichten: $e')),
        );
      }
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      await widget.useCases.sendChatMessage(
        helpRequestId: _selectedRequestId,
        senderId: 'demo_user',
        senderName: 'Demo User',
        message: message,
      );

      _messageController.clear();
      await _loadChatMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Senden der Nachricht: $e')),
        );
      }
    }
  }

  void _showMessageOptions(HelpChat message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Nachricht kopieren'),
            onTap: () {
              Navigator.of(context).pop();
              // Mock copy functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nachricht kopiert')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Nachricht löschen', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.of(context).pop();
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                await widget.useCases.deleteChatMessage(message.id);
                await _loadChatMessages();
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Nachricht gelöscht')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Fehler beim Löschen: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chat',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          // Request Selector
          DropdownButtonFormField<String>(
            value: _selectedRequestId,
            decoration: const InputDecoration(
              labelText: 'Hilfe-Anfrage auswählen',
              border: OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: 'demo_request_id', child: Text('Demo Anfrage')),
              DropdownMenuItem(value: 'request_2', child: Text('Anfrage 2')),
              DropdownMenuItem(value: 'request_3', child: Text('Anfrage 3')),
            ],
            onChanged: (value) {
              setState(() => _selectedRequestId = value!);
              _loadChatMessages();
            },
          ),
          const SizedBox(height: 16),

          // Chat Messages
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _chatMessages.isEmpty
                    ? const Center(
                        child: Text('Keine Nachrichten vorhanden'),
                      )
                    : ListView.builder(
                        itemCount: _chatMessages.length,
                        itemBuilder: (context, index) {
                          final message = _chatMessages[index];
                          return _buildMessageBubble(message);
                        },
                      ),
          ),
          const SizedBox(height: 16),

          // Message Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Nachricht eingeben...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                style: IconButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(HelpChat message) {
    final isOwnMessage = message.senderId == 'demo_user';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isOwnMessage) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppConfig.primaryColor,
              child: Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isOwnMessage ? AppConfig.primaryColor : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOwnMessage)
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isOwnMessage ? Colors.white : Colors.black,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isOwnMessage ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: isOwnMessage ? Colors.white70 : Colors.grey,
                        ),
                      ),
                      if (isOwnMessage) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showMessageOptions(message),
                          child: Icon(
                            Icons.more_vert,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isOwnMessage) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppConfig.primaryColor,
              child: Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
} 