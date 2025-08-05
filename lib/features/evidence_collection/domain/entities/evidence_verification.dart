// features/evidence_collection/domain/entities/evidence_verification.dart

/// Erweiterte Verifizierungslogik für Beweismittel
class EvidenceVerification {
  final String id;
  final String evidenceId;
  final String verifiedBy;
  final DateTime verifiedAt;
  final VerificationLevel level;
  final VerificationStatus status;
  final String? notes;
  final List<String> attachments;
  final Map<String, dynamic> metadata;

  const EvidenceVerification({
    required this.id,
    required this.evidenceId,
    required this.verifiedBy,
    required this.verifiedAt,
    required this.level,
    required this.status,
    this.notes,
    this.attachments = const [],
    this.metadata = const {},
  });

  /// Factory-Methode für neue Verifizierung
  factory EvidenceVerification.create({
    required String evidenceId,
    required String verifiedBy,
    VerificationLevel level = VerificationLevel.basic,
    String? notes,
  }) {
    return EvidenceVerification(
      id: 'verification_${DateTime.now().millisecondsSinceEpoch}',
      evidenceId: evidenceId,
      verifiedBy: verifiedBy,
      verifiedAt: DateTime.now(),
      level: level,
      status: VerificationStatus.pending,
      notes: notes,
    );
  }

  /// Kopie mit geänderten Werten erstellen
  EvidenceVerification copyWith({
    String? id,
    String? evidenceId,
    String? verifiedBy,
    DateTime? verifiedAt,
    VerificationLevel? level,
    VerificationStatus? status,
    String? notes,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
  }) {
    return EvidenceVerification(
      id: id ?? this.id,
      evidenceId: evidenceId ?? this.evidenceId,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      level: level ?? this.level,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Zu Map konvertieren
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'evidenceId': evidenceId,
      'verifiedBy': verifiedBy,
      'verifiedAt': verifiedAt.toIso8601String(),
      'level': level.name,
      'status': status.name,
      'notes': notes,
      'attachments': attachments,
      'metadata': metadata,
    };
  }

  /// Von Map erstellen
  factory EvidenceVerification.fromMap(Map<String, dynamic> map) {
    return EvidenceVerification(
      id: map['id'] as String,
      evidenceId: map['evidenceId'] as String,
      verifiedBy: map['verifiedBy'] as String,
      verifiedAt: DateTime.parse(map['verifiedAt'] as String),
      level: VerificationLevel.values.firstWhere(
        (e) => e.name == map['level'],
        orElse: () => VerificationLevel.basic,
      ),
      status: VerificationStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => VerificationStatus.pending,
      ),
      notes: map['notes'] as String?,
      attachments: List<String>.from(map['attachments'] ?? []),
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  /// Verifizierung ist abgeschlossen
  bool get isCompleted => status == VerificationStatus.completed;

  /// Verifizierung ist fehlgeschlagen
  bool get isFailed => status == VerificationStatus.failed;

  /// Verifizierung ist ausstehend
  bool get isPending => status == VerificationStatus.pending;

  /// Erweiterte Verifizierung
  bool get isAdvanced => level == VerificationLevel.advanced;

  /// Experten-Verifizierung
  bool get isExpert => level == VerificationLevel.expert;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EvidenceVerification && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EvidenceVerification(id: $id, evidenceId: $evidenceId, status: $status, level: $level)';
  }
}

/// Verifizierungslevel
enum VerificationLevel {
  basic('Grundlegend', 'Einfache Überprüfung'),
  advanced('Erweitert', 'Detaillierte Analyse'),
  expert('Experte', 'Fachmännische Begutachtung'),
  forensic('Forensisch', 'Wissenschaftliche Untersuchung');

  final String displayName;
  final String description;

  const VerificationLevel(this.displayName, this.description);
}

/// Verifizierungsstatus
enum VerificationStatus {
  pending('Ausstehend', 'Verifizierung läuft'),
  inProgress('In Bearbeitung', 'Verifizierung wird durchgeführt'),
  completed('Abgeschlossen', 'Verifizierung erfolgreich'),
  failed('Fehlgeschlagen', 'Verifizierung fehlgeschlagen'),
  rejected('Abgelehnt', 'Verifizierung abgelehnt'),
  requiresReview('Überprüfung erforderlich', 'Weitere Überprüfung nötig');

  final String displayName;
  final String description;

  const VerificationStatus(this.displayName, this.description);
} 