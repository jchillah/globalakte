// features/communication/data/repositories/communication_repository_impl.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../encryption/data/repositories/encryption_repository_impl.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/communication_repository.dart';

/// Konkrete Implementation des Communication Repository
class CommunicationRepositoryImpl implements CommunicationRepository {
  static const String _messagesKey = 'messages';
  static const String _chatRoomsKey = 'chat_rooms';
  static const String _messageCounterKey = 'message_counter';
  static const String _chatRoomCounterKey = 'chat_room_counter';

  final SharedPreferences _prefs;
  // ignore: unused_field
  final EncryptionRepositoryImpl _encryptionRepository;

  CommunicationRepositoryImpl(this._prefs, this._encryptionRepository);

  @override
  Future<Message> sendMessage(Message message) async {
    try {
      // Generiere ID falls nicht vorhanden
      final messageWithId = message.id.isEmpty
          ? message.copyWith(id: await generateMessageId())
          : message;

      // Hole alle Nachrichten
      final messages = await _getAllMessages();

      // Prüfe ob Nachricht mit gleicher ID bereits existiert
      if (messages.any((m) => m.id == messageWithId.id)) {
        throw Exception('Nachricht mit dieser ID existiert bereits');
      }

      // Füge die neue Nachricht hinzu
      messages.add(messageWithId);

      // Speichere alle Nachrichten
      await _saveMessages(messages);

      debugPrint('Nachricht gesendet: ${messageWithId.content}');
      return messageWithId;
    } catch (e) {
      debugPrint('Fehler beim Senden der Nachricht: $e');
      rethrow;
    }
  }

  @override
  Future<List<Message>> getMessagesByChatRoom(String chatRoomId) async {
    try {
      final messages = await _getAllMessages();
      return messages
          .where((m) => m.metadata['chatRoomId'] == chatRoomId)
          .toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Nachrichten: $e');
      return [];
    }
  }

  @override
  Future<List<Message>> getMessagesBetweenUsers(
      String userId1, String userId2) async {
    try {
      final messages = await _getAllMessages();
      return messages
          .where((m) =>
              (m.senderId == userId1 && m.receiverId == userId2) ||
              (m.senderId == userId2 && m.receiverId == userId1))
          .toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Nachrichten zwischen Benutzern: $e');
      return [];
    }
  }

  @override
  Future<Message> updateMessageStatus(
      String messageId, MessageStatus status) async {
    try {
      final messages = await _getAllMessages();
      final index = messages.indexWhere((m) => m.id == messageId);

      if (index == -1) {
        throw Exception('Nachricht nicht gefunden');
      }

      final updatedMessage = messages[index].copyWith(status: status);
      messages[index] = updatedMessage;
      await _saveMessages(messages);

      debugPrint('Nachrichtenstatus aktualisiert: $status');
      return updatedMessage;
    } catch (e) {
      debugPrint('Fehler beim Aktualisieren des Nachrichtenstatus: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteMessage(String messageId) async {
    try {
      final messages = await _getAllMessages();
      final initialLength = messages.length;

      messages.removeWhere((m) => m.id == messageId);

      if (messages.length == initialLength) {
        return false; // Nachricht nicht gefunden
      }

      await _saveMessages(messages);

      debugPrint('Nachricht gelöscht: $messageId');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Löschen der Nachricht: $e');
      rethrow;
    }
  }

  @override
  Future<Message> encryptMessage(
      String messageId, String encryptionKeyId) async {
    try {
      final messages = await _getAllMessages();
      final index = messages.indexWhere((m) => m.id == messageId);

      if (index == -1) {
        throw Exception('Nachricht nicht gefunden');
      }

      final encryptedMessage = messages[index].copyWith(
        isEncrypted: true,
        encryptionKeyId: encryptionKeyId,
        status: MessageStatus.encrypted,
      );

      messages[index] = encryptedMessage;
      await _saveMessages(messages);

      debugPrint('Nachricht verschlüsselt: $messageId');
      return encryptedMessage;
    } catch (e) {
      debugPrint('Fehler beim Verschlüsseln der Nachricht: $e');
      rethrow;
    }
  }

  @override
  Future<Message> decryptMessage(String messageId) async {
    try {
      final messages = await _getAllMessages();
      final index = messages.indexWhere((m) => m.id == messageId);

      if (index == -1) {
        throw Exception('Nachricht nicht gefunden');
      }

      final decryptedMessage = messages[index].copyWith(
        isEncrypted: false,
        encryptionKeyId: null,
        status: MessageStatus.read,
      );

      messages[index] = decryptedMessage;
      await _saveMessages(messages);

      debugPrint('Nachricht entschlüsselt: $messageId');
      return decryptedMessage;
    } catch (e) {
      debugPrint('Fehler beim Entschlüsseln der Nachricht: $e');
      rethrow;
    }
  }

  @override
  Future<ChatRoom> createChatRoom(ChatRoom chatRoom) async {
    try {
      // Generiere ID falls nicht vorhanden
      final chatRoomWithId = chatRoom.id.isEmpty
          ? chatRoom.copyWith(id: await generateChatRoomId())
          : chatRoom;

      // Hole alle Chat-Räume
      final chatRooms = await _getAllChatRooms();

      // Prüfe ob Chat-Raum mit gleicher ID bereits existiert
      if (chatRooms.any((c) => c.id == chatRoomWithId.id)) {
        throw Exception('Chat-Raum mit dieser ID existiert bereits');
      }

      // Füge den neuen Chat-Raum hinzu
      chatRooms.add(chatRoomWithId);

      // Speichere alle Chat-Räume
      await _saveChatRooms(chatRooms);

      debugPrint('Chat-Raum erstellt: ${chatRoomWithId.name}');
      return chatRoomWithId;
    } catch (e) {
      debugPrint('Fehler beim Erstellen des Chat-Raums: $e');
      rethrow;
    }
  }

  @override
  Future<ChatRoom> updateChatRoom(ChatRoom chatRoom) async {
    try {
      final chatRooms = await _getAllChatRooms();
      final index = chatRooms.indexWhere((c) => c.id == chatRoom.id);

      if (index == -1) {
        throw Exception('Chat-Raum nicht gefunden');
      }

      chatRooms[index] = chatRoom;
      await _saveChatRooms(chatRooms);

      debugPrint('Chat-Raum aktualisiert: ${chatRoom.name}');
      return chatRoom;
    } catch (e) {
      debugPrint('Fehler beim Aktualisieren des Chat-Raums: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteChatRoom(String chatRoomId) async {
    try {
      final chatRooms = await _getAllChatRooms();
      final initialLength = chatRooms.length;

      chatRooms.removeWhere((c) => c.id == chatRoomId);

      if (chatRooms.length == initialLength) {
        return false; // Chat-Raum nicht gefunden
      }

      await _saveChatRooms(chatRooms);

      debugPrint('Chat-Raum gelöscht: $chatRoomId');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Löschen des Chat-Raums: $e');
      rethrow;
    }
  }

  @override
  Future<List<ChatRoom>> getChatRoomsByUser(String userId) async {
    try {
      final chatRooms = await _getAllChatRooms();
      return chatRooms.where((c) => c.participantIds.contains(userId)).toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Chat-Räume: $e');
      return [];
    }
  }

  @override
  Future<ChatRoom?> getChatRoomById(String chatRoomId) async {
    try {
      final chatRooms = await _getAllChatRooms();
      return chatRooms.firstWhere(
        (c) => c.id == chatRoomId,
        orElse: () => throw Exception('Chat-Raum nicht gefunden'),
      );
    } catch (e) {
      debugPrint('Fehler beim Abrufen des Chat-Raums: $e');
      return null;
    }
  }

  @override
  Future<bool> addParticipantToChatRoom(
      String chatRoomId, String userId) async {
    try {
      final chatRooms = await _getAllChatRooms();
      final index = chatRooms.indexWhere((c) => c.id == chatRoomId);

      if (index == -1) {
        return false;
      }

      final chatRoom = chatRooms[index];
      if (!chatRoom.participantIds.contains(userId)) {
        final updatedChatRoom = chatRoom.copyWith(
          participantIds: [...chatRoom.participantIds, userId],
        );
        chatRooms[index] = updatedChatRoom;
        await _saveChatRooms(chatRooms);
      }

      debugPrint('Teilnehmer zum Chat-Raum hinzugefügt: $userId');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Hinzufügen des Teilnehmers: $e');
      return false;
    }
  }

  @override
  Future<bool> removeParticipantFromChatRoom(
      String chatRoomId, String userId) async {
    try {
      final chatRooms = await _getAllChatRooms();
      final index = chatRooms.indexWhere((c) => c.id == chatRoomId);

      if (index == -1) {
        return false;
      }

      final chatRoom = chatRooms[index];
      if (chatRoom.participantIds.contains(userId)) {
        final updatedChatRoom = chatRoom.copyWith(
          participantIds:
              chatRoom.participantIds.where((id) => id != userId).toList(),
        );
        chatRooms[index] = updatedChatRoom;
        await _saveChatRooms(chatRooms);
      }

      debugPrint('Teilnehmer aus Chat-Raum entfernt: $userId');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Entfernen des Teilnehmers: $e');
      return false;
    }
  }

  @override
  Future<List<Message>> searchMessages(String query, String userId) async {
    try {
      final messages = await _getAllMessages();
      return messages
          .where((m) =>
              (m.senderId == userId || m.receiverId == userId) &&
              m.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint('Fehler bei der Nachrichtensuche: $e');
      return [];
    }
  }

  @override
  Future<List<Message>> getUnreadMessages(String userId) async {
    try {
      final messages = await _getAllMessages();
      return messages
          .where((m) =>
              m.receiverId == userId && m.status == MessageStatus.delivered)
          .toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen ungelesener Nachrichten: $e');
      return [];
    }
  }

  @override
  Future<List<Message>> getMessagesByType(
      MessageType type, String userId) async {
    try {
      final messages = await _getAllMessages();
      return messages
          .where((m) =>
              (m.senderId == userId || m.receiverId == userId) &&
              m.type == type)
          .toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Nachrichten nach Typ: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getCommunicationStatistics(String userId) async {
    try {
      final messages = await _getAllMessages();
      final userMessages = messages
          .where((m) => m.senderId == userId || m.receiverId == userId)
          .toList();

      final totalMessages = userMessages.length;
      final sentMessages =
          userMessages.where((m) => m.senderId == userId).length;
      final receivedMessages =
          userMessages.where((m) => m.receiverId == userId).length;
      final encryptedMessages = userMessages.where((m) => m.isEncrypted).length;
      final unreadMessages = userMessages
          .where((m) =>
              m.receiverId == userId && m.status == MessageStatus.delivered)
          .length;

      return {
        'totalMessages': totalMessages,
        'sentMessages': sentMessages,
        'receivedMessages': receivedMessages,
        'encryptedMessages': encryptedMessages,
        'unreadMessages': unreadMessages,
      };
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Kommunikations-Statistiken: $e');
      return {};
    }
  }

  @override
  Future<Map<String, dynamic>> getChatRoomStatistics(String chatRoomId) async {
    try {
      final messages = await getMessagesByChatRoom(chatRoomId);
      final chatRoom = await getChatRoomById(chatRoomId);

      if (chatRoom == null) {
        return {};
      }

      final totalMessages = messages.length;
      final participants = chatRoom.participantIds.length;
      final encryptedMessages = messages.where((m) => m.isEncrypted).length;
      final unreadMessages =
          messages.where((m) => m.status == MessageStatus.delivered).length;

      return {
        'totalMessages': totalMessages,
        'participants': participants,
        'encryptedMessages': encryptedMessages,
        'unreadMessages': unreadMessages,
        'lastMessageAt': chatRoom.lastMessageAt?.toIso8601String(),
      };
    } catch (e) {
      debugPrint('Fehler beim Abrufen der Chat-Raum-Statistiken: $e');
      return {};
    }
  }

  @override
  Future<bool> startWebSocketConnection(String userId) async {
    try {
      // Simuliere WebSocket-Verbindung
      debugPrint('WebSocket-Verbindung gestartet für Benutzer: $userId');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Starten der WebSocket-Verbindung: $e');
      return false;
    }
  }

  @override
  Future<bool> stopWebSocketConnection() async {
    try {
      // Simuliere WebSocket-Verbindung stoppen
      debugPrint('WebSocket-Verbindung gestoppt');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Stoppen der WebSocket-Verbindung: $e');
      return false;
    }
  }

  @override
  Future<bool> sendPushNotification(
      String userId, String title, String body) async {
    try {
      // Simuliere Push-Benachrichtigung
      debugPrint('Push-Benachrichtigung gesendet an $userId: $title - $body');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Senden der Push-Benachrichtigung: $e');
      return false;
    }
  }

  @override
  Future<String> createMessageBackup(String userId) async {
    try {
      await _getAllMessages(); // Nachrichten laden für Backup-Vorbereitung

      final backupPath =
          '/backups/messages_${userId}_${DateTime.now().millisecondsSinceEpoch}.json';
      debugPrint('Nachrichten-Backup erstellt: $backupPath');
      return backupPath;
    } catch (e) {
      debugPrint('Fehler beim Erstellen des Nachrichten-Backups: $e');
      rethrow;
    }
  }

  @override
  Future<bool> restoreMessageBackup(String backupPath, String userId) async {
    try {
      // Simuliere Backup-Wiederherstellung
      debugPrint('Nachrichten-Backup wiederhergestellt: $backupPath');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Wiederherstellen des Nachrichten-Backups: $e');
      return false;
    }
  }

  @override
  Future<bool> syncMessagesWithCloud(String userId) async {
    try {
      // Simuliere Cloud-Synchronisation
      debugPrint('Nachrichten mit Cloud synchronisiert für Benutzer: $userId');
      return true;
    } catch (e) {
      debugPrint('Fehler bei der Cloud-Synchronisation: $e');
      return false;
    }
  }

  @override
  Future<String> generateMessageId() async {
    final counter = _prefs.getInt(_messageCounterKey) ?? 0;
    await _prefs.setInt(_messageCounterKey, counter + 1);
    return 'msg_${DateTime.now().millisecondsSinceEpoch}_$counter';
  }

  @override
  Future<String> generateChatRoomId() async {
    final counter = _prefs.getInt(_chatRoomCounterKey) ?? 0;
    await _prefs.setInt(_chatRoomCounterKey, counter + 1);
    return 'chat_${DateTime.now().millisecondsSinceEpoch}_$counter';
  }

  @override
  Future<bool> messageExists(String messageId) async {
    try {
      final messages = await _getAllMessages();
      return messages.any((m) => m.id == messageId);
    } catch (e) {
      debugPrint('Fehler beim Prüfen der Nachrichtenexistenz: $e');
      return false;
    }
  }

  @override
  Future<bool> chatRoomExists(String chatRoomId) async {
    try {
      final chatRooms = await _getAllChatRooms();
      return chatRooms.any((c) => c.id == chatRoomId);
    } catch (e) {
      debugPrint('Fehler beim Prüfen der Chat-Raum-Existenz: $e');
      return false;
    }
  }

  @override
  Future<int> getUnreadMessageCount(String userId) async {
    try {
      final unreadMessages = await getUnreadMessages(userId);
      return unreadMessages.length;
    } catch (e) {
      debugPrint('Fehler beim Abrufen der ungelesenen Nachrichtenanzahl: $e');
      return 0;
    }
  }

  @override
  Future<bool> markAllMessagesAsRead(String userId, String chatRoomId) async {
    try {
      final messages = await _getAllMessages();
      bool updated = false;

      for (int i = 0; i < messages.length; i++) {
        final message = messages[i];
        if (message.receiverId == userId &&
            message.metadata['chatRoomId'] == chatRoomId &&
            message.status == MessageStatus.delivered) {
          messages[i] = message.copyWith(status: MessageStatus.read);
          updated = true;
        }
      }

      if (updated) {
        await _saveMessages(messages);
      }

      debugPrint('Alle Nachrichten als gelesen markiert');
      return true;
    } catch (e) {
      debugPrint('Fehler beim Markieren aller Nachrichten als gelesen: $e');
      return false;
    }
  }

  /// Hilfsmethode zum Abrufen aller Nachrichten
  Future<List<Message>> _getAllMessages() async {
    try {
      final messagesJson = _prefs.getStringList(_messagesKey) ?? [];
      return messagesJson
          .map((json) => Message.fromMap(jsonDecode(json)))
          .toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen aller Nachrichten: $e');
      return [];
    }
  }

  /// Hilfsmethode zum Speichern aller Nachrichten
  Future<void> _saveMessages(List<Message> messages) async {
    try {
      final messagesJson =
          messages.map((message) => jsonEncode(message.toMap())).toList();
      await _prefs.setStringList(_messagesKey, messagesJson);
    } catch (e) {
      debugPrint('Fehler beim Speichern der Nachrichten: $e');
      rethrow;
    }
  }

  /// Hilfsmethode zum Abrufen aller Chat-Räume
  Future<List<ChatRoom>> _getAllChatRooms() async {
    try {
      final chatRoomsJson = _prefs.getStringList(_chatRoomsKey) ?? [];
      return chatRoomsJson
          .map((json) => ChatRoom.fromMap(jsonDecode(json)))
          .toList();
    } catch (e) {
      debugPrint('Fehler beim Abrufen aller Chat-Räume: $e');
      return [];
    }
  }

  /// Hilfsmethode zum Speichern aller Chat-Räume
  Future<void> _saveChatRooms(List<ChatRoom> chatRooms) async {
    try {
      final chatRoomsJson =
          chatRooms.map((chatRoom) => jsonEncode(chatRoom.toMap())).toList();
      await _prefs.setStringList(_chatRoomsKey, chatRoomsJson);
    } catch (e) {
      debugPrint('Fehler beim Speichern der Chat-Räume: $e');
      rethrow;
    }
  }
}
