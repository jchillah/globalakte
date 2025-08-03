// features/document_management/domain/entities/document.dart
/// Entity für ein Dokument in der GlobalAkte App
class Document {
  final String id;
  final String title;
  final String description;
  final String filePath;
  final String fileType;
  final int fileSize;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final String? caseId;
  final DocumentCategory category;
  final DocumentStatus status;
  final bool isEncrypted;
  final String? encryptionKeyId;
  final Map<String, dynamic> metadata;

  const Document({
    required this.id,
    required this.title,
    required this.description,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
    this.caseId,
    required this.category,
    required this.status,
    required this.isEncrypted,
    this.encryptionKeyId,
    this.metadata = const {},
  });

  /// Erstellt eine Kopie des Dokuments mit geänderten Eigenschaften
  Document copyWith({
    String? id,
    String? title,
    String? description,
    String? filePath,
    String? fileType,
    int? fileSize,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? caseId,
    DocumentCategory? category,
    DocumentStatus? status,
    bool? isEncrypted,
    String? encryptionKeyId,
    Map<String, dynamic>? metadata,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      caseId: caseId ?? this.caseId,
      category: category ?? this.category,
      status: status ?? this.status,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      encryptionKeyId: encryptionKeyId ?? this.encryptionKeyId,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Konvertiert das Dokument zu einer Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'filePath': filePath,
      'fileType': fileType,
      'fileSize': fileSize,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'createdBy': createdBy,
      'caseId': caseId,
      'category': category.name,
      'status': status.name,
      'isEncrypted': isEncrypted,
      'encryptionKeyId': encryptionKeyId,
      'metadata': metadata,
    };
  }

  /// Erstellt ein Dokument aus einer Map
  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      filePath: map['filePath'] ?? '',
      fileType: map['fileType'] ?? '',
      fileSize: map['fileSize']?.toInt() ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      createdBy: map['createdBy'] ?? '',
      caseId: map['caseId'],
      category: DocumentCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => DocumentCategory.other,
      ),
      status: DocumentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => DocumentStatus.draft,
      ),
      isEncrypted: map['isEncrypted'] ?? false,
      encryptionKeyId: map['encryptionKeyId'],
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Document && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Document(id: $id, title: $title, category: $category, status: $status)';
  }
}

/// Kategorien für Dokumente
enum DocumentCategory {
  legal, // Rechtliche Dokumente
  medical, // Medizinische Dokumente
  financial, // Finanzielle Dokumente
  personal, // Persönliche Dokumente
  official, // Amtliche Dokumente
  correspondence, // Korrespondenz
  evidence, // Beweismittel
  contract, // Verträge
  certificate, // Zertifikate
  other, // Sonstiges
}

/// Status eines Dokuments
enum DocumentStatus {
  draft, // Entwurf
  pending, // Ausstehend
  approved, // Genehmigt
  rejected, // Abgelehnt
  archived, // Archiviert
  expired, // Abgelaufen
}
