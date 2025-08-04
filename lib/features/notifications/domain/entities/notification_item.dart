// features/notifications/domain/entities/notification_item.dart
/// Entity für Benachrichtigungen im System
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type; // 'info', 'warning', 'error', 'success'
  final DateTime timestamp;
  final bool isRead;
  final String? category; // 'system', 'case', 'document', 'appointment'
  final Map<String, dynamic>? metadata;
  final String? actionUrl; // URL für Aktionen
  final List<String>? tags;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.category,
    this.metadata,
    this.actionUrl,
    this.tags,
  });

  /// Erstellt eine neue Benachrichtigung
  factory NotificationItem.create({
    required String title,
    required String message,
    required String type,
    String? category,
    Map<String, dynamic>? metadata,
    String? actionUrl,
    List<String>? tags,
  }) {
    return NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
      category: category,
      metadata: metadata,
      actionUrl: actionUrl,
      tags: tags,
    );
  }

  /// Konvertiert zu Map für Persistierung
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'category': category,
      'metadata': metadata,
      'actionUrl': actionUrl,
      'tags': tags,
    };
  }

  /// Erstellt aus Map
  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      type: map['type'],
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'],
      category: map['category'],
      metadata: map['metadata'],
      actionUrl: map['actionUrl'],
      tags: map['tags'] != null ? List<String>.from(map['tags']) : null,
    );
  }

  /// Kopiert mit Änderungen
  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    String? category,
    Map<String, dynamic>? metadata,
    String? actionUrl,
    List<String>? tags,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      category: category ?? this.category,
      metadata: metadata ?? this.metadata,
      actionUrl: actionUrl ?? this.actionUrl,
      tags: tags ?? this.tags,
    );
  }

  /// Markiert als gelesen
  NotificationItem markAsRead() {
    return copyWith(isRead: true);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NotificationItem(id: $id, title: $title, type: $type, isRead: $isRead)';
  }
} 