// features/epa_integration/data/models/epa_case.dart

/// ePA-Fall Entity
class EpaCase {
  final String id;
  final String title;
  final String description;
  final String caseNumber;
  final String caseType;
  final EpaCaseStatus status;
  final String assignedUserId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? closedAt;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final EpaCasePriority priority;
  final String? clientId;
  final String? clientName;
  final String? court;
  final String? judge;
  final DateTime? nextHearing;
  final List<String> participants;

  const EpaCase({
    required this.id,
    required this.title,
    required this.description,
    required this.caseNumber,
    required this.caseType,
    required this.status,
    required this.assignedUserId,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.closedAt,
    this.tags = const [],
    this.metadata = const {},
    this.priority = EpaCasePriority.medium,
    this.clientId,
    this.clientName,
    this.court,
    this.judge,
    this.nextHearing,
    this.participants = const [],
  });

  /// Fall ist aktiv
  bool get isActive =>
      status != EpaCaseStatus.closed && status != EpaCaseStatus.archived;

  /// Fall ist dringend
  bool get isUrgent =>
      priority == EpaCasePriority.high || priority == EpaCasePriority.critical;

  /// Fall ist abgeschlossen
  bool get isClosed => status == EpaCaseStatus.closed;

  /// Fall hat anstehende Verhandlung
  bool get hasUpcomingHearing =>
      nextHearing != null && nextHearing!.isAfter(DateTime.now());

  /// Kopie mit geänderten Werten erstellen
  EpaCase copyWith({
    String? id,
    String? title,
    String? description,
    String? caseNumber,
    String? caseType,
    EpaCaseStatus? status,
    String? assignedUserId,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    EpaCasePriority? priority,
    String? clientId,
    String? clientName,
    String? court,
    String? judge,
    DateTime? nextHearing,
    List<String>? participants,
  }) {
    return EpaCase(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      caseNumber: caseNumber ?? this.caseNumber,
      caseType: caseType ?? this.caseType,
      status: status ?? this.status,
      assignedUserId: assignedUserId ?? this.assignedUserId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt ?? this.closedAt,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      priority: priority ?? this.priority,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      court: court ?? this.court,
      judge: judge ?? this.judge,
      nextHearing: nextHearing ?? this.nextHearing,
      participants: participants ?? this.participants,
    );
  }

  /// JSON-Serialisierung
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'caseNumber': caseNumber,
      'caseType': caseType,
      'status': status.name,
      'assignedUserId': assignedUserId,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
      'tags': tags,
      'metadata': metadata,
      'priority': priority.name,
      'clientId': clientId,
      'clientName': clientName,
      'court': court,
      'judge': judge,
      'nextHearing': nextHearing?.toIso8601String(),
      'participants': participants,
    };
  }

  /// JSON-Deserialisierung
  factory EpaCase.fromJson(Map<String, dynamic> json) {
    return EpaCase(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      caseNumber: json['caseNumber'] as String,
      caseType: json['caseType'] as String,
      status: EpaCaseStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EpaCaseStatus.open,
      ),
      assignedUserId: json['assignedUserId'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      closedAt: json['closedAt'] != null
          ? DateTime.parse(json['closedAt'] as String)
          : null,
      tags: List<String>.from(json['tags'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      priority: EpaCasePriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => EpaCasePriority.medium,
      ),
      clientId: json['clientId'] as String?,
      clientName: json['clientName'] as String?,
      court: json['court'] as String?,
      judge: json['judge'] as String?,
      nextHearing: json['nextHearing'] != null
          ? DateTime.parse(json['nextHearing'] as String)
          : null,
      participants: List<String>.from(json['participants'] ?? []),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EpaCase && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EpaCase(id: $id, caseNumber: $caseNumber, title: $title, status: $status)';
  }
}

/// ePA-Fall-Status
enum EpaCaseStatus {
  open('Offen', 'Fall ist aktiv und wird bearbeitet'),
  inProgress('In Bearbeitung', 'Fall wird aktuell bearbeitet'),
  pending('Ausstehend', 'Fall wartet auf weitere Aktionen'),
  onHold('Pausiert', 'Fall ist vorübergehend pausiert'),
  closed('Abgeschlossen', 'Fall ist abgeschlossen'),
  archived('Archiviert', 'Fall ist archiviert');

  const EpaCaseStatus(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// ePA-Fall-Priorität
enum EpaCasePriority {
  low('Niedrig', 'Niedrige Priorität'),
  medium('Mittel', 'Normale Priorität'),
  high('Hoch', 'Hohe Priorität'),
  critical('Kritisch', 'Kritische Priorität');

  const EpaCasePriority(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// ePA-Fall-Typen
enum EpaCaseType {
  civil('Zivilrecht', 'Zivilrechtliche Angelegenheiten'),
  criminal('Strafrecht', 'Strafrechtliche Angelegenheiten'),
  family('Familienrecht', 'Familienrechtliche Angelegenheiten'),
  labor('Arbeitsrecht', 'Arbeitsrechtliche Angelegenheiten'),
  administrative('Verwaltungsrecht', 'Verwaltungsrechtliche Angelegenheiten'),
  commercial('Handelsrecht', 'Handelsrechtliche Angelegenheiten'),
  tax('Steuerrecht', 'Steuerrechtliche Angelegenheiten'),
  other('Sonstiges', 'Andere Rechtsgebiete');

  const EpaCaseType(this.displayName, this.description);
  final String displayName;
  final String description;
}
