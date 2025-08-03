// features/communication/domain/entities/message.dart

/// Entity für eine Nachricht im Kommunikationssystem
class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;
  final bool isEncrypted;
  final String? encryptionKeyId;
  final Map<String, dynamic> metadata;

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.isEncrypted,
    this.encryptionKeyId,
    this.metadata = const {},
  });

  /// Erstellt eine Kopie der Nachricht mit geänderten Eigenschaften
  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    MessageStatus? status,
    bool? isEncrypted,
    String? encryptionKeyId,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      encryptionKeyId: encryptionKeyId ?? this.encryptionKeyId,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Konvertiert die Nachricht zu einer Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type.name,
      'status': status.name,
      'isEncrypted': isEncrypted,
      'encryptionKeyId': encryptionKeyId,
      'metadata': metadata,
    };
  }

  /// Erstellt eine Nachricht aus einer Map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      type: MessageType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => MessageStatus.sent,
      ),
      isEncrypted: map['isEncrypted'] ?? false,
      encryptionKeyId: map['encryptionKeyId'],
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, content: $content, type: $type, status: $status)';
  }
}

/// Typen von Nachrichten
enum MessageType {
  text, // Textnachricht
  image, // Bildnachricht
  document, // Dokument
  voice, // Sprachnachricht
  video, // Videonachricht
  system, // Systemnachricht
  notification, // Benachrichtigung
}

/// Status einer Nachricht
enum MessageStatus {
  sent, // Gesendet
  delivered, // Zustellbestätigung
  read, // Gelesen
  failed, // Fehlgeschlagen
  pending, // Ausstehend
  encrypted, // Verschlüsselt
}
