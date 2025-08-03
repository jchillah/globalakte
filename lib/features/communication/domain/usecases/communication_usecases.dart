import '../entities/message.dart';
import '../entities/chat_room.dart';
import '../repositories/communication_repository.dart';

/// Use Case für das Senden einer Nachricht
class SendMessageUseCase {
  final CommunicationRepository _repository;

  SendMessageUseCase(this._repository);

  Future<Message> call(Message message) async {
    if (message.content.trim().isEmpty) {
      throw ArgumentError('Nachrichteninhalt darf nicht leer sein');
    }

    if (message.senderId.isEmpty || message.receiverId.isEmpty) {
      throw ArgumentError('Sender und Receiver IDs sind erforderlich');
    }

    return await _repository.sendMessage(message);
  }
}

/// Use Case für das Abrufen von Nachrichten eines Chat-Raums
class GetMessagesByChatRoomUseCase {
  final CommunicationRepository _repository;

  GetMessagesByChatRoomUseCase(this._repository);

  Future<List<Message>> call(String chatRoomId) async {
    if (chatRoomId.isEmpty) {
      throw ArgumentError('Chat-Raum ID ist erforderlich');
    }

    return await _repository.getMessagesByChatRoom(chatRoomId);
  }
}

/// Use Case für das Abrufen von Nachrichten zwischen zwei Benutzern
class GetMessagesBetweenUsersUseCase {
  final CommunicationRepository _repository;

  GetMessagesBetweenUsersUseCase(this._repository);

  Future<List<Message>> call(String userId1, String userId2) async {
    if (userId1.isEmpty || userId2.isEmpty) {
      throw ArgumentError('Beide Benutzer-IDs sind erforderlich');
    }

    return await _repository.getMessagesBetweenUsers(userId1, userId2);
  }
}

/// Use Case für das Aktualisieren des Nachrichtenstatus
class UpdateMessageStatusUseCase {
  final CommunicationRepository _repository;

  UpdateMessageStatusUseCase(this._repository);

  Future<Message> call(String messageId, MessageStatus status) async {
    if (messageId.isEmpty) {
      throw ArgumentError('Nachrichten-ID ist erforderlich');
    }

    return await _repository.updateMessageStatus(messageId, status);
  }
}

/// Use Case für das Löschen einer Nachricht
class DeleteMessageUseCase {
  final CommunicationRepository _repository;

  DeleteMessageUseCase(this._repository);

  Future<bool> call(String messageId) async {
    if (messageId.isEmpty) {
      throw ArgumentError('Nachrichten-ID ist erforderlich');
    }

    return await _repository.deleteMessage(messageId);
  }
}

/// Use Case für das Verschlüsseln einer Nachricht
class EncryptMessageUseCase {
  final CommunicationRepository _repository;

  EncryptMessageUseCase(this._repository);

  Future<Message> call(String messageId, String encryptionKeyId) async {
    if (messageId.isEmpty) {
      throw ArgumentError('Nachrichten-ID ist erforderlich');
    }

    if (encryptionKeyId.isEmpty) {
      throw ArgumentError('Verschlüsselungs-Schlüssel-ID ist erforderlich');
    }

    return await _repository.encryptMessage(messageId, encryptionKeyId);
  }
}

/// Use Case für das Entschlüsseln einer Nachricht
class DecryptMessageUseCase {
  final CommunicationRepository _repository;

  DecryptMessageUseCase(this._repository);

  Future<Message> call(String messageId) async {
    if (messageId.isEmpty) {
      throw ArgumentError('Nachrichten-ID ist erforderlich');
    }

    return await _repository.decryptMessage(messageId);
  }
}

/// Use Case für das Erstellen eines Chat-Raums
class CreateChatRoomUseCase {
  final CommunicationRepository _repository;

  CreateChatRoomUseCase(this._repository);

  Future<ChatRoom> call(ChatRoom chatRoom) async {
    if (chatRoom.name.trim().isEmpty) {
      throw ArgumentError('Chat-Raum Name ist erforderlich');
    }

    if (chatRoom.participantIds.isEmpty) {
      throw ArgumentError('Mindestens ein Teilnehmer ist erforderlich');
    }

    return await _repository.createChatRoom(chatRoom);
  }
}

/// Use Case für das Aktualisieren eines Chat-Raums
class UpdateChatRoomUseCase {
  final CommunicationRepository _repository;

  UpdateChatRoomUseCase(this._repository);

  Future<ChatRoom> call(ChatRoom chatRoom) async {
    if (chatRoom.id.isEmpty) {
      throw ArgumentError('Chat-Raum ID ist erforderlich');
    }

    return await _repository.updateChatRoom(chatRoom);
  }
}

/// Use Case für das Löschen eines Chat-Raums
class DeleteChatRoomUseCase {
  final CommunicationRepository _repository;

  DeleteChatRoomUseCase(this._repository);

  Future<bool> call(String chatRoomId) async {
    if (chatRoomId.isEmpty) {
      throw ArgumentError('Chat-Raum ID ist erforderlich');
    }

    return await _repository.deleteChatRoom(chatRoomId);
  }
}

/// Use Case für das Abrufen von Chat-Räumen eines Benutzers
class GetChatRoomsByUserUseCase {
  final CommunicationRepository _repository;

  GetChatRoomsByUserUseCase(this._repository);

  Future<List<ChatRoom>> call(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    return await _repository.getChatRoomsByUser(userId);
  }
}

/// Use Case für das Suchen von Nachrichten
class SearchMessagesUseCase {
  final CommunicationRepository _repository;

  SearchMessagesUseCase(this._repository);

  Future<List<Message>> call(String query, String userId) async {
    if (query.trim().isEmpty) {
      throw ArgumentError('Suchbegriff ist erforderlich');
    }

    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    return await _repository.searchMessages(query, userId);
  }
}

/// Use Case für das Abrufen ungelesener Nachrichten
class GetUnreadMessagesUseCase {
  final CommunicationRepository _repository;

  GetUnreadMessagesUseCase(this._repository);

  Future<List<Message>> call(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    return await _repository.getUnreadMessages(userId);
  }
}

/// Use Case für das Abrufen von Kommunikations-Statistiken
class GetCommunicationStatisticsUseCase {
  final CommunicationRepository _repository;

  GetCommunicationStatisticsUseCase(this._repository);

  Future<Map<String, dynamic>> call(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    return await _repository.getCommunicationStatistics(userId);
  }
}

/// Use Case für das Starten der WebSocket-Verbindung
class StartWebSocketConnectionUseCase {
  final CommunicationRepository _repository;

  StartWebSocketConnectionUseCase(this._repository);

  Future<bool> call(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    return await _repository.startWebSocketConnection(userId);
  }
}

/// Use Case für das Stoppen der WebSocket-Verbindung
class StopWebSocketConnectionUseCase {
  final CommunicationRepository _repository;

  StopWebSocketConnectionUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.stopWebSocketConnection();
  }
}

/// Use Case für das Senden von Push-Benachrichtigungen
class SendPushNotificationUseCase {
  final CommunicationRepository _repository;

  SendPushNotificationUseCase(this._repository);

  Future<bool> call(String userId, String title, String body) async {
    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    if (title.trim().isEmpty) {
      throw ArgumentError('Benachrichtigungstitel ist erforderlich');
    }

    if (body.trim().isEmpty) {
      throw ArgumentError('Benachrichtigungsinhalt ist erforderlich');
    }

    return await _repository.sendPushNotification(userId, title, body);
  }
}

/// Use Case für das Erstellen eines Nachrichten-Backups
class CreateMessageBackupUseCase {
  final CommunicationRepository _repository;

  CreateMessageBackupUseCase(this._repository);

  Future<String> call(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    return await _repository.createMessageBackup(userId);
  }
}

/// Use Case für das Wiederherstellen eines Nachrichten-Backups
class RestoreMessageBackupUseCase {
  final CommunicationRepository _repository;

  RestoreMessageBackupUseCase(this._repository);

  Future<bool> call(String backupPath, String userId) async {
    if (backupPath.isEmpty) {
      throw ArgumentError('Backup-Pfad ist erforderlich');
    }

    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    return await _repository.restoreMessageBackup(backupPath, userId);
  }
}

/// Use Case für das Synchronisieren von Nachrichten mit der Cloud
class SyncMessagesWithCloudUseCase {
  final CommunicationRepository _repository;

  SyncMessagesWithCloudUseCase(this._repository);

  Future<bool> call(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    return await _repository.syncMessagesWithCloud(userId);
  }
}

/// Use Case für das Abrufen der Anzahl ungelesener Nachrichten
class GetUnreadMessageCountUseCase {
  final CommunicationRepository _repository;

  GetUnreadMessageCountUseCase(this._repository);

  Future<int> call(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    return await _repository.getUnreadMessageCount(userId);
  }
}

/// Use Case für das Markieren aller Nachrichten als gelesen
class MarkAllMessagesAsReadUseCase {
  final CommunicationRepository _repository;

  MarkAllMessagesAsReadUseCase(this._repository);

  Future<bool> call(String userId, String chatRoomId) async {
    if (userId.isEmpty) {
      throw ArgumentError('Benutzer-ID ist erforderlich');
    }

    if (chatRoomId.isEmpty) {
      throw ArgumentError('Chat-Raum ID ist erforderlich');
    }

    return await _repository.markAllMessagesAsRead(userId, chatRoomId);
  }
} 