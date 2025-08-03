// features/evidence_collection/domain/entities/evidence_item.dart
/// Entity für Beweismittel im Evidence Collection Feature
class EvidenceItem {
  final String id;
  final String title;
  final String description;
  final String type; // 'photo', 'video', 'document', 'audio', 'physical'
  final String filePath;
  final DateTime collectedAt;
  final String collectedBy;
  final String location;
  final Map<String, dynamic> metadata;
  final String status; // 'pending', 'verified', 'rejected', 'archived'
  final String? caseId;
  final String? notes;

  const EvidenceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.filePath,
    required this.collectedAt,
    required this.collectedBy,
    required this.location,
    required this.metadata,
    required this.status,
    this.caseId,
    this.notes,
  });

  /// Erstellt ein neues Beweismittel
  factory EvidenceItem.create({
    required String title,
    required String description,
    required String type,
    required String filePath,
    required String collectedBy,
    required String location,
    String? caseId,
    String? notes,
  }) {
    return EvidenceItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      type: type,
      filePath: filePath,
      collectedAt: DateTime.now(),
      collectedBy: collectedBy,
      location: location,
      metadata: {},
      status: 'pending',
      caseId: caseId,
      notes: notes,
    );
  }

  /// Konvertiert zu Map für Persistierung
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'filePath': filePath,
      'collectedAt': collectedAt.toIso8601String(),
      'collectedBy': collectedBy,
      'location': location,
      'metadata': metadata,
      'status': status,
      'caseId': caseId,
      'notes': notes,
    };
  }

  /// Erstellt aus Map
  factory EvidenceItem.fromMap(Map<String, dynamic> map) {
    return EvidenceItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      filePath: map['filePath'],
      collectedAt: DateTime.parse(map['collectedAt']),
      collectedBy: map['collectedBy'],
      location: map['location'],
      metadata: Map<String, dynamic>.from(map['metadata']),
      status: map['status'],
      caseId: map['caseId'],
      notes: map['notes'],
    );
  }

  /// Kopiert mit Änderungen
  EvidenceItem copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? filePath,
    DateTime? collectedAt,
    String? collectedBy,
    String? location,
    Map<String, dynamic>? metadata,
    String? status,
    String? caseId,
    String? notes,
  }) {
    return EvidenceItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      collectedAt: collectedAt ?? this.collectedAt,
      collectedBy: collectedBy ?? this.collectedBy,
      location: location ?? this.location,
      metadata: metadata ?? this.metadata,
      status: status ?? this.status,
      caseId: caseId ?? this.caseId,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EvidenceItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EvidenceItem(id: $id, title: $title, type: $type, status: $status)';
  }
}
