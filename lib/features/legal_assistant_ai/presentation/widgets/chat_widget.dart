import 'package:flutter/material.dart';

import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../domain/entities/ai_message.dart';

/// Widget für den Chat-Bereich
class ChatWidget extends StatefulWidget {
  final List<AiMessage> chatHistory;
  final bool isLoading;
  final Function(String) onSendMessage;

  const ChatWidget({
    super.key,
    required this.chatHistory,
    required this.isLoading,
    required this.onSendMessage,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat-Verlauf
        Expanded(
          child: widget.chatHistory.isEmpty
              ? _buildEmptyState()
              : _buildChatHistory(),
        ),
        
        // Eingabe-Bereich
        _buildInputArea(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Starten Sie eine Unterhaltung',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stellen Sie Ihre rechtliche Frage',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatHistory() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.chatHistory.length,
      itemBuilder: (context, index) {
        final message = widget.chatHistory[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(AiMessage message) {
    final isUser = message.sender == 'user';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUser) const Spacer(),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser 
                    ? Theme.of(context).primaryColor
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (message.suggestions != null && message.suggestions!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: message.suggestions!.map((suggestion) {
                        return ActionChip(
                          label: Text(suggestion),
                          onPressed: () => widget.onSendMessage(suggestion),
                          backgroundColor: Colors.white.withOpacity(0.2),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!isUser) const Spacer(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GlobalTextField(
              controller: _messageController,
              label: 'Ihre Nachricht',
              hint: 'Stellen Sie Ihre rechtliche Frage...',
              maxLines: 3,
            ),
          ),
          const SizedBox(width: 8),
          GlobalButton(
            onPressed: widget.isLoading ? null : _sendMessage,
            text: 'Senden',
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
} 