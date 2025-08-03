// features/case_timeline/domain/entities/case_file.dart
/// CaseFile Entity - Repräsentiert eine Fallakte
class CaseFile {
  final String id;
  final String title;
  final String description;
  final String caseNumber;
  final String status;
  final String category;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? dueDate;
  final String? assignedTo;
  final String? priority;
  final Map<String, dynamic> metadata;
  final List<String> documentIds;
  final List<String> timelineEventIds;
  final bool isEpaIntegrated;
  final String? epaStatus;

  const CaseFile({
    required this.id,
    required this.title,
    required this.description,
    required this.caseNumber,
    required this.status,
    required this.category,
    required this.createdAt,
    this.updatedAt,
    this.dueDate,
    this.assignedTo,
    this.priority,
    this.metadata = const {},
    this.documentIds = const [],
    this.timelineEventIds = const [],
    this.isEpaIntegrated = false,
    this.epaStatus,
  });

  /// Erstellt eine CaseFile aus JSON
  factory CaseFile.fromJson(Map<String, dynamic> json) {
    return CaseFile(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      caseNumber: json['caseNumber'] as String,
      status: json['status'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      assignedTo: json['assignedTo'] as String?,
      priority: json['priority'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      documentIds: List<String>.from(json['documentIds'] ?? []),
      timelineEventIds: List<String>.from(json['timelineEventIds'] ?? []),
      isEpaIntegrated: json['isEpaIntegrated'] as bool? ?? false,
      epaStatus: json['epaStatus'] as String?,
    );
  }

  /// Konvertiert CaseFile zu JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'caseNumber': caseNumber,
      'status': status,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'assignedTo': assignedTo,
      'priority': priority,
      'metadata': metadata,
      'documentIds': documentIds,
      'timelineEventIds': timelineEventIds,
      'isEpaIntegrated': isEpaIntegrated,
      'epaStatus': epaStatus,
    };
  }

  /// Erstellt eine Kopie mit aktualisierten Eigenschaften
  CaseFile copyWith({
    String? id,
    String? title,
    String? description,
    String? caseNumber,
    String? status,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    String? assignedTo,
    String? priority,
    Map<String, dynamic>? metadata,
    List<String>? documentIds,
    List<String>? timelineEventIds,
    bool? isEpaIntegrated,
    String? epaStatus,
  }) {
    return CaseFile(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      caseNumber: caseNumber ?? this.caseNumber,
      status: status ?? this.status,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      metadata: metadata ?? this.metadata,
      documentIds: documentIds ?? this.documentIds,
      timelineEventIds: timelineEventIds ?? this.timelineEventIds,
      isEpaIntegrated: isEpaIntegrated ?? this.isEpaIntegrated,
      epaStatus: epaStatus ?? this.epaStatus,
    );
  }

  /// Prüft ob die Fallakte überfällig ist
  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Prüft ob die Fallakte aktiv ist
  bool get isActive {
    return status == 'active' || status == 'in_progress';
  }

  /// Prüft ob die Fallakte abgeschlossen ist
  bool get isCompleted {
    return status == 'completed' || status == 'closed';
  }

  /// Gibt die Anzahl der Dokumente zurück
  int get documentCount => documentIds.length;

  /// Gibt die Anzahl der Timeline-Events zurück
  int get timelineEventCount => timelineEventIds.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CaseFile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CaseFile(id: $id, title: $title, caseNumber: $caseNumber, status: $status)';
  }
}
