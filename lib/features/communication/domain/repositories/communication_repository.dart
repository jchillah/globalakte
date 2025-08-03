import '../entities/message.dart';
import '../entities/chat_room.dart';

/// Abstract Repository Interface für das Kommunikationssystem
abstract class CommunicationRepository {
  // Message Operations
  /// Sendet eine Nachricht
  Future<Message> sendMessage(Message message);

  /// Holt alle Nachrichten für einen Chat-Raum
  Future<List<Message>> getMessagesByChatRoom(String chatRoomId);

  /// Holt alle Nachrichten zwischen zwei Benutzern
  Future<List<Message>> getMessagesBetweenUsers(String userId1, String userId2);

  /// Aktualisiert den Status einer Nachricht
  Future<Message> updateMessageStatus(String messageId, MessageStatus status);

  /// Löscht eine Nachricht
  Future<bool> deleteMessage(String messageId);

  /// Verschlüsselt eine Nachricht
  Future<Message> encryptMessage(String messageId, String encryptionKeyId);

  /// Entschlüsselt eine Nachricht
  Future<Message> decryptMessage(String messageId);

  // Chat Room Operations
  /// Erstellt einen neuen Chat-Raum
  Future<ChatRoom> createChatRoom(ChatRoom chatRoom);

  /// Aktualisiert einen Chat-Raum
  Future<ChatRoom> updateChatRoom(ChatRoom chatRoom);

  /// Löscht einen Chat-Raum
  Future<bool> deleteChatRoom(String chatRoomId);

  /// Holt alle Chat-Räume eines Benutzers
  Future<List<ChatRoom>> getChatRoomsByUser(String userId);

  /// Holt einen Chat-Raum anhand der ID
  Future<ChatRoom?> getChatRoomById(String chatRoomId);

  /// Fügt einen Teilnehmer zu einem Chat-Raum hinzu
  Future<bool> addParticipantToChatRoom(String chatRoomId, String userId);

  /// Entfernt einen Teilnehmer aus einem Chat-Raum
  Future<bool> removeParticipantFromChatRoom(String chatRoomId, String userId);

  // Search & Filter Operations
  /// Sucht Nachrichten nach Inhalt
  Future<List<Message>> searchMessages(String query, String userId);

  /// Holt alle ungelesenen Nachrichten eines Benutzers
  Future<List<Message>> getUnreadMessages(String userId);

  /// Holt alle Nachrichten eines bestimmten Typs
  Future<List<Message>> getMessagesByType(MessageType type, String userId);

  // Statistics & Analytics
  /// Holt Kommunikations-Statistiken
  Future<Map<String, dynamic>> getCommunicationStatistics(String userId);

  /// Holt Chat-Raum-Statistiken
  Future<Map<String, dynamic>> getChatRoomStatistics(String chatRoomId);

  // Real-time Communication
  /// Startet WebSocket-Verbindung für Echtzeit-Kommunikation
  Future<bool> startWebSocketConnection(String userId);

  /// Stoppt WebSocket-Verbindung
  Future<bool> stopWebSocketConnection();

  /// Sendet Push-Benachrichtigung
  Future<bool> sendPushNotification(String userId, String title, String body);

  // Backup & Sync
  /// Erstellt Backup aller Nachrichten
  Future<String> createMessageBackup(String userId);

  /// Stellt Backup wieder her
  Future<bool> restoreMessageBackup(String backupPath, String userId);

  /// Synchronisiert Nachrichten mit der Cloud
  Future<bool> syncMessagesWithCloud(String userId);

  // Utility Operations
  /// Generiert eine Nachrichten-ID
  Future<String> generateMessageId();

  /// Generiert eine Chat-Raum-ID
  Future<String> generateChatRoomId();

  /// Prüft ob eine Nachricht existiert
  Future<bool> messageExists(String messageId);

  /// Prüft ob ein Chat-Raum existiert
  Future<bool> chatRoomExists(String chatRoomId);

  /// Holt die Anzahl ungelesener Nachrichten
  Future<int> getUnreadMessageCount(String userId);

  /// Markiert alle Nachrichten als gelesen
  Future<bool> markAllMessagesAsRead(String userId, String chatRoomId);
} 