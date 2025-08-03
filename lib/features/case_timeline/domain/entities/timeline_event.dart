// features/case_timeline/domain/entities/timeline_event.dart
/// TimelineEvent Entity - Repräsentiert ein Event in der Fallakte-Timeline
class TimelineEvent {
  final String id;
  final String caseFileId;
  final String title;
  final String description;
  final String eventType;
  final DateTime timestamp;
  final String? createdBy;
  final Map<String, dynamic> metadata;
  final List<String> attachmentIds;
  final bool isImportant;
  final String? status;

  const TimelineEvent({
    required this.id,
    required this.caseFileId,
    required this.title,
    required this.description,
    required this.eventType,
    required this.timestamp,
    this.createdBy,
    this.metadata = const {},
    this.attachmentIds = const [],
    this.isImportant = false,
    this.status,
  });

  /// Erstellt eine TimelineEvent aus JSON
  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      id: json['id'] as String,
      caseFileId: json['caseFileId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventType: json['eventType'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      createdBy: json['createdBy'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      attachmentIds: List<String>.from(json['attachmentIds'] ?? []),
      isImportant: json['isImportant'] as bool? ?? false,
      status: json['status'] as String?,
    );
  }

  /// Konvertiert TimelineEvent zu JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caseFileId': caseFileId,
      'title': title,
      'description': description,
      'eventType': eventType,
      'timestamp': timestamp.toIso8601String(),
      'createdBy': createdBy,
      'metadata': metadata,
      'attachmentIds': attachmentIds,
      'isImportant': isImportant,
      'status': status,
    };
  }

  /// Erstellt eine Kopie mit aktualisierten Eigenschaften
  TimelineEvent copyWith({
    String? id,
    String? caseFileId,
    String? title,
    String? description,
    String? eventType,
    DateTime? timestamp,
    String? createdBy,
    Map<String, dynamic>? metadata,
    List<String>? attachmentIds,
    bool? isImportant,
    String? status,
  }) {
    return TimelineEvent(
      id: id ?? this.id,
      caseFileId: caseFileId ?? this.caseFileId,
      title: title ?? this.title,
      description: description ?? this.description,
      eventType: eventType ?? this.eventType,
      timestamp: timestamp ?? this.timestamp,
      createdBy: createdBy ?? this.createdBy,
      metadata: metadata ?? this.metadata,
      attachmentIds: attachmentIds ?? this.attachmentIds,
      isImportant: isImportant ?? this.isImportant,
      status: status ?? this.status,
    );
  }

  /// Prüft ob das Event heute erstellt wurde
  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }

  /// Prüft ob das Event diese Woche erstellt wurde
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return timestamp.isAfter(startOfWeek) && timestamp.isBefore(endOfWeek);
  }

  /// Gibt die Anzahl der Anhänge zurück
  int get attachmentCount => attachmentIds.length;

  /// Prüft ob das Event Anhänge hat
  bool get hasAttachments => attachmentIds.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimelineEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TimelineEvent(id: $id, title: $title, eventType: $eventType, timestamp: $timestamp)';
  }
}
