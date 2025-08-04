// features/help_network/data/services/help_chat_service.dart
import '../../domain/entities/help_chat.dart';

/// Service für Help Chat Operationen
class HelpChatService {
  final List<HelpChat> _chatMessages = [];

  HelpChatService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock Chat-Nachrichten
    _chatMessages.addAll([
      HelpChat.create(
        helpRequestId: '1754331441373', // ID der ersten Help Request
        senderId: 'user1',
        senderName: 'Max Mustermann',
        message: 'Hallo, vielen Dank für das Angebot!',
      ),
      HelpChat.create(
        helpRequestId: '1754331441373', // ID der ersten Help Request
        senderId: 'helper1',
        senderName: 'Lisa Weber',
        message: 'Gerne! Wann können wir uns treffen?',
      ),
      HelpChat.create(
        helpRequestId: '1754331441374', // ID der zweiten Help Request
        senderId: 'user2',
        senderName: 'Anna Schmidt',
        message: 'Können Sie mir bei der Übersetzung helfen?',
      ),
      HelpChat.create(
        helpRequestId: '1754331441374', // ID der zweiten Help Request
        senderId: 'helper2',
        senderName: 'Dr. Hans Klein',
        message: 'Ja, gerne! Ich bin Arzt und kann medizinische Dokumente übersetzen.',
      ),
    ]);
  }

  // Chat Operationen
  Future<List<HelpChat>> getChatMessages(String requestId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _chatMessages
        .where((message) => message.helpRequestId == requestId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<List<HelpChat>> getChatMessagesByUser(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _chatMessages
        .where((message) => message.senderId == userId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<HelpChat?> getChatMessageById(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      return _chatMessages.firstWhere((message) => message.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> sendMessage(HelpChat message) async {
    await Future.delayed(Duration(milliseconds: 200));
    _chatMessages.add(message);
  }

  Future<void> updateMessage(HelpChat message) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _chatMessages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      _chatMessages[index] = message;
    }
  }

  Future<void> deleteMessage(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _chatMessages.removeWhere((message) => message.id == id);
  }

  Future<void> markMessageAsRead(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    final index = _chatMessages.indexWhere((m) => m.id == id);
    if (index != -1) {
      final message = _chatMessages[index];
      final updatedMessage = message.copyWith(isRead: true);
      _chatMessages[index] = updatedMessage;
    }
  }

  Future<void> markAllMessagesAsRead(String requestId, String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    for (int i = 0; i < _chatMessages.length; i++) {
      final message = _chatMessages[i];
      if (message.helpRequestId == requestId && 
          message.senderId != userId && 
          !message.isRead) {
        _chatMessages[i] = message.copyWith(isRead: true);
      }
    }
  }

  Future<int> getUnreadMessageCount(String requestId, String userId) async {
    await Future.delayed(Duration(milliseconds: 100));
    return _chatMessages
        .where((message) => 
            message.helpRequestId == requestId && 
            message.senderId != userId && 
            !message.isRead)
        .length;
  }

  Future<List<HelpChat>> searchMessages(String query) async {
    await Future.delayed(Duration(milliseconds: 400));
    final lowercaseQuery = query.toLowerCase();
    return _chatMessages.where((message) {
      return message.message.toLowerCase().contains(lowercaseQuery) ||
          message.senderName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<List<HelpChat>> getMessagesByType(String requestId, String messageType) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _chatMessages
        .where((message) => 
            message.helpRequestId == requestId && 
            message.messageType == messageType)
        .toList();
  }

  Future<void> sendSystemMessage(String requestId, String message) async {
    await Future.delayed(Duration(milliseconds: 200));
    final systemMessage = HelpChat.create(
      helpRequestId: requestId,
      senderId: 'system',
      senderName: 'System',
      message: message,
      messageType: 'system',
    );
    _chatMessages.add(systemMessage);
  }

  Future<List<HelpChat>> getRecentMessages({int limit = 50}) async {
    await Future.delayed(Duration(milliseconds: 300));
    final sortedMessages = List<HelpChat>.from(_chatMessages);
    sortedMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sortedMessages.take(limit).toList();
  }
} 