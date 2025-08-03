// features/legal_assistant_ai/domain/entities/ai_message.dart
/// Entity für AI-Nachrichten im Legal Assistant
class AiMessage {
  final String id;
  final String content;
  final String sender; // 'user' oder 'ai'
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final String? context; // Rechtlicher Kontext
  final List<String>? suggestions; // Vorschläge für nächste Schritte

  const AiMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.metadata,
    this.context,
    this.suggestions,
  });

  /// Erstellt eine Benutzer-Nachricht
  factory AiMessage.user({
    required String content,
    String? context,
  }) {
    return AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: 'user',
      timestamp: DateTime.now(),
      context: context,
    );
  }

  /// Erstellt eine AI-Nachricht
  factory AiMessage.ai({
    required String content,
    String? context,
    List<String>? suggestions,
    Map<String, dynamic>? metadata,
  }) {
    return AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: 'ai',
      timestamp: DateTime.now(),
      context: context,
      suggestions: suggestions,
      metadata: metadata,
    );
  }

  /// Konvertiert zu Map für Persistierung
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'context': context,
      'suggestions': suggestions,
    };
  }

  /// Erstellt aus Map
  factory AiMessage.fromMap(Map<String, dynamic> map) {
    return AiMessage(
      id: map['id'],
      content: map['content'],
      sender: map['sender'],
      timestamp: DateTime.parse(map['timestamp']),
      metadata: map['metadata'],
      context: map['context'],
      suggestions: map['suggestions'] != null
          ? List<String>.from(map['suggestions'])
          : null,
    );
  }

  /// Kopiert mit Änderungen
  AiMessage copyWith({
    String? id,
    String? content,
    String? sender,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    String? context,
    List<String>? suggestions,
  }) {
    return AiMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      context: context ?? this.context,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'AiMessage(id: $id, content: $content, sender: $sender, timestamp: $timestamp)';
  }
}
