// features/help_network/domain/entities/help_request.dart
/// Entity für Hilfe-Anfragen im Hilfe-Netzwerk
class HelpRequest {
  final String id;
  final String title;
  final String description;
  final String category;
  final String requesterId;
  final String requesterName;
  final DateTime createdAt;
  final DateTime? deadline;
  final String status; // 'open', 'in_progress', 'completed', 'cancelled'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final List<String> tags;
  final String? location;
  final bool isUrgent;
  final int? maxHelpers;
  final List<String> acceptedHelpers;
  final Map<String, dynamic>? metadata;

  const HelpRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.requesterId,
    required this.requesterName,
    required this.createdAt,
    this.deadline,
    required this.status,
    required this.priority,
    required this.tags,
    this.location,
    required this.isUrgent,
    this.maxHelpers,
    required this.acceptedHelpers,
    this.metadata,
  });

  /// Erstellt eine neue Hilfe-Anfrage
  factory HelpRequest.create({
    required String title,
    required String description,
    required String category,
    required String requesterId,
    required String requesterName,
    DateTime? deadline,
    String priority = 'medium',
    List<String> tags = const [],
    String? location,
    bool isUrgent = false,
    int? maxHelpers,
  }) {
    return HelpRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category,
      requesterId: requesterId,
      requesterName: requesterName,
      createdAt: DateTime.now(),
      deadline: deadline,
      status: 'open',
      priority: priority,
      tags: tags,
      location: location,
      isUrgent: isUrgent,
      maxHelpers: maxHelpers,
      acceptedHelpers: [],
    );
  }

  /// Kopiert mit Änderungen
  HelpRequest copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? requesterId,
    String? requesterName,
    DateTime? createdAt,
    DateTime? deadline,
    String? status,
    String? priority,
    List<String>? tags,
    String? location,
    bool? isUrgent,
    int? maxHelpers,
    List<String>? acceptedHelpers,
    Map<String, dynamic>? metadata,
  }) {
    return HelpRequest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      location: location ?? this.location,
      isUrgent: isUrgent ?? this.isUrgent,
      maxHelpers: maxHelpers ?? this.maxHelpers,
      acceptedHelpers: acceptedHelpers ?? this.acceptedHelpers,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Konvertiert zu Map für Persistierung
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'status': status,
      'priority': priority,
      'tags': tags,
      'location': location,
      'isUrgent': isUrgent,
      'maxHelpers': maxHelpers,
      'acceptedHelpers': acceptedHelpers,
      'metadata': metadata,
    };
  }

  /// Erstellt aus Map
  factory HelpRequest.fromMap(Map<String, dynamic> map) {
    return HelpRequest(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      requesterId: map['requesterId'],
      requesterName: map['requesterName'],
      createdAt: DateTime.parse(map['createdAt']),
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
      status: map['status'],
      priority: map['priority'],
      tags: List<String>.from(map['tags']),
      location: map['location'],
      isUrgent: map['isUrgent'],
      maxHelpers: map['maxHelpers'],
      acceptedHelpers: List<String>.from(map['acceptedHelpers']),
      metadata: map['metadata'],
    );
  }

  /// Prüft ob die Anfrage noch offen ist
  bool get isOpen => status == 'open';

  /// Prüft ob die Anfrage dringend ist
  bool get isUrgentRequest => isUrgent || priority == 'urgent';

  /// Prüft ob die maximale Anzahl Helfer erreicht ist
  bool get isFull => maxHelpers != null && acceptedHelpers.length >= maxHelpers!;

  /// Berechnet die verbleibende Zeit bis zum Deadline
  Duration? get remainingTime {
    if (deadline == null) return null;
    final now = DateTime.now();
    return deadline!.isAfter(now) ? deadline!.difference(now) : Duration.zero;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HelpRequest && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'HelpRequest(id: $id, title: $title, status: $status, priority: $priority)';
  }
} 