// features/help_network/domain/entities/help_chat.dart
/// Entity für Chat-Nachrichten im Hilfe-Netzwerk
class HelpChat {
  final String id;
  final String helpRequestId;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final String messageType; // 'text', 'image', 'file', 'location'
  final String? attachmentUrl;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  const HelpChat({
    required this.id,
    required this.helpRequestId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.messageType,
    this.attachmentUrl,
    required this.isRead,
    this.metadata,
  });

  /// Erstellt eine neue Chat-Nachricht
  factory HelpChat.create({
    required String helpRequestId,
    required String senderId,
    required String senderName,
    required String message,
    String messageType = 'text',
    String? attachmentUrl,
  }) {
    return HelpChat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      helpRequestId: helpRequestId,
      senderId: senderId,
      senderName: senderName,
      message: message,
      timestamp: DateTime.now(),
      messageType: messageType,
      attachmentUrl: attachmentUrl,
      isRead: false,
    );
  }

  /// Kopiert mit Änderungen
  HelpChat copyWith({
    String? id,
    String? helpRequestId,
    String? senderId,
    String? senderName,
    String? message,
    DateTime? timestamp,
    String? messageType,
    String? attachmentUrl,
    bool? isRead,
    Map<String, dynamic>? metadata,
  }) {
    return HelpChat(
      id: id ?? this.id,
      helpRequestId: helpRequestId ?? this.helpRequestId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      messageType: messageType ?? this.messageType,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Konvertiert zu Map für Persistierung
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'helpRequestId': helpRequestId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'messageType': messageType,
      'attachmentUrl': attachmentUrl,
      'isRead': isRead,
      'metadata': metadata,
    };
  }

  /// Erstellt aus Map
  factory HelpChat.fromMap(Map<String, dynamic> map) {
    return HelpChat(
      id: map['id'],
      helpRequestId: map['helpRequestId'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      messageType: map['messageType'],
      attachmentUrl: map['attachmentUrl'],
      isRead: map['isRead'],
      metadata: map['metadata'],
    );
  }

  /// Prüft ob es sich um eine Text-Nachricht handelt
  bool get isTextMessage => messageType == 'text';

  /// Prüft ob es sich um eine Bild-Nachricht handelt
  bool get isImageMessage => messageType == 'image';

  /// Prüft ob es sich um eine Datei-Nachricht handelt
  bool get isFileMessage => messageType == 'file';

  /// Prüft ob es sich um eine Standort-Nachricht handelt
  bool get isLocationMessage => messageType == 'location';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HelpChat && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'HelpChat(id: $id, senderName: $senderName, message: $message)';
  }
} 