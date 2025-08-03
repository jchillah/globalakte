// features/communication/domain/entities/chat_room.dart

/// Entity für einen Chat-Raum im Messaging-System
class ChatRoom {
  final String id;
  final String name;
  final String description;
  final List<String> participantIds;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final bool isEncrypted;
  final String? encryptionKeyId;
  final ChatRoomType type;
  final ChatRoomStatus status;
  final Map<String, dynamic> metadata;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.participantIds,
    required this.createdBy,
    required this.createdAt,
    this.lastMessageAt,
    required this.isEncrypted,
    this.encryptionKeyId,
    required this.type,
    required this.status,
    this.metadata = const {},
  });

  /// Erstellt eine Kopie des Chat-Raums mit geänderten Eigenschaften
  ChatRoom copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? participantIds,
    String? createdBy,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    bool? isEncrypted,
    String? encryptionKeyId,
    ChatRoomType? type,
    ChatRoomStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      participantIds: participantIds ?? this.participantIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      encryptionKeyId: encryptionKeyId ?? this.encryptionKeyId,
      type: type ?? this.type,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Konvertiert den Chat-Raum zu einer Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'participantIds': participantIds,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastMessageAt': lastMessageAt?.millisecondsSinceEpoch,
      'isEncrypted': isEncrypted,
      'encryptionKeyId': encryptionKeyId,
      'type': type.name,
      'status': status.name,
      'metadata': metadata,
    };
  }

  /// Erstellt einen Chat-Raum aus einer Map
  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      participantIds: List<String>.from(map['participantIds'] ?? []),
      createdBy: map['createdBy'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      lastMessageAt: map['lastMessageAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastMessageAt'])
          : null,
      isEncrypted: map['isEncrypted'] ?? false,
      encryptionKeyId: map['encryptionKeyId'],
      type: ChatRoomType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ChatRoomType.private,
      ),
      status: ChatRoomStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ChatRoomStatus.active,
      ),
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatRoom && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ChatRoom(id: $id, name: $name, type: $type, status: $status)';
  }
}

/// Typen von Chat-Räumen
enum ChatRoomType {
  private, // Privater Chat
  group, // Gruppen-Chat
  channel, // Kanal
  support, // Support-Chat
  official, // Offizieller Chat
}

/// Status eines Chat-Raums
enum ChatRoomStatus {
  active, // Aktiv
  archived, // Archiviert
  muted, // Stummgeschaltet
  blocked, // Blockiert
  deleted, // Gelöscht
}
