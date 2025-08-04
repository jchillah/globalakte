// features/epa_integration/data/models/epa_document.dart

/// ePA-Dokument Entity
class EpaDocument {
  final String id;
  final String title;
  final String description;
  final String caseId;
  final String documentType;
  final String filePath;
  final String fileName;
  final int fileSize;
  final String mimeType;
  final EpaDocumentStatus status;
  final String uploadedBy;
  final DateTime uploadedAt;
  final DateTime? lastModified;
  final String? version;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final bool isEncrypted;
  final String? encryptionKeyId;
  final String? checksum;
  final EpaDocumentCategory category;

  const EpaDocument({
    required this.id,
    required this.title,
    required this.description,
    required this.caseId,
    required this.documentType,
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    required this.status,
    required this.uploadedBy,
    required this.uploadedAt,
    this.lastModified,
    this.version,
    this.tags = const [],
    this.metadata = const {},
    this.isEncrypted = false,
    this.encryptionKeyId,
    this.checksum,
    this.category = EpaDocumentCategory.other,
  });

  /// Dokument ist verfügbar
  bool get isAvailable => status == EpaDocumentStatus.available;

  /// Dokument ist verschlüsselt
  bool get isSecure => isEncrypted;

  /// Dokument ist ein Bild
  bool get isImage => mimeType.startsWith('image/');

  /// Dokument ist ein PDF
  bool get isPdf => mimeType == 'application/pdf';

  /// Dokument ist ein Text
  bool get isText => mimeType.startsWith('text/');

  /// Dateigröße formatiert
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    }
    if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    }
    if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Kopie mit geänderten Werten erstellen
  EpaDocument copyWith({
    String? id,
    String? title,
    String? description,
    String? caseId,
    String? documentType,
    String? filePath,
    String? fileName,
    int? fileSize,
    String? mimeType,
    EpaDocumentStatus? status,
    String? uploadedBy,
    DateTime? uploadedAt,
    DateTime? lastModified,
    String? version,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    bool? isEncrypted,
    String? encryptionKeyId,
    String? checksum,
    EpaDocumentCategory? category,
  }) {
    return EpaDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      caseId: caseId ?? this.caseId,
      documentType: documentType ?? this.documentType,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      status: status ?? this.status,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      lastModified: lastModified ?? this.lastModified,
      version: version ?? this.version,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      encryptionKeyId: encryptionKeyId ?? this.encryptionKeyId,
      checksum: checksum ?? this.checksum,
      category: category ?? this.category,
    );
  }

  /// JSON-Serialisierung
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'caseId': caseId,
      'documentType': documentType,
      'filePath': filePath,
      'fileName': fileName,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'status': status.name,
      'uploadedBy': uploadedBy,
      'uploadedAt': uploadedAt.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
      'version': version,
      'tags': tags,
      'metadata': metadata,
      'isEncrypted': isEncrypted,
      'encryptionKeyId': encryptionKeyId,
      'checksum': checksum,
      'category': category.name,
    };
  }

  /// JSON-Deserialisierung
  factory EpaDocument.fromJson(Map<String, dynamic> json) {
    return EpaDocument(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      caseId: json['caseId'] as String,
      documentType: json['documentType'] as String,
      filePath: json['filePath'] as String,
      fileName: json['fileName'] as String,
      fileSize: json['fileSize'] as int,
      mimeType: json['mimeType'] as String,
      status: EpaDocumentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EpaDocumentStatus.available,
      ),
      uploadedBy: json['uploadedBy'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : null,
      version: json['version'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      isEncrypted: json['isEncrypted'] ?? false,
      encryptionKeyId: json['encryptionKeyId'] as String?,
      checksum: json['checksum'] as String?,
      category: EpaDocumentCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => EpaDocumentCategory.other,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EpaDocument && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EpaDocument(id: $id, title: $title, fileName: $fileName, status: $status)';
  }
}

/// ePA-Dokument-Status
enum EpaDocumentStatus {
  available('Verfügbar', 'Dokument ist verfügbar'),
  processing('In Bearbeitung', 'Dokument wird verarbeitet'),
  error('Fehler', 'Dokument konnte nicht verarbeitet werden'),
  deleted('Gelöscht', 'Dokument wurde gelöscht'),
  archived('Archiviert', 'Dokument ist archiviert');

  const EpaDocumentStatus(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// ePA-Dokument-Kategorien
enum EpaDocumentCategory {
  legal('Rechtliche Dokumente', 'Verträge, Urteile, etc.'),
  evidence('Beweismittel', 'Fotos, Videos, etc.'),
  correspondence('Korrespondenz', 'Briefe, E-Mails, etc.'),
  financial('Finanzielle Dokumente', 'Rechnungen, Kontoauszüge, etc.'),
  medical('Medizinische Dokumente', 'Gutachten, Berichte, etc.'),
  official('Amtliche Dokumente', 'Bescheide, Urkunden, etc.'),
  personal('Persönliche Dokumente', 'Ausweise, Zertifikate, etc.'),
  other('Sonstiges', 'Andere Dokumente');

  const EpaDocumentCategory(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// ePA-Dokument-Typen
enum EpaDocumentType {
  contract('Vertrag', 'Vertragsdokumente'),
  judgment('Urteil', 'Gerichtsurteile'),
  evidence('Beweismittel', 'Beweismaterial'),
  correspondence('Korrespondenz', 'Briefwechsel'),
  invoice('Rechnung', 'Finanzielle Dokumente'),
  certificate('Zertifikat', 'Amtliche Bescheinigungen'),
  report('Bericht', 'Berichte und Gutachten'),
  other('Sonstiges', 'Andere Dokumenttypen');

  const EpaDocumentType(this.displayName, this.description);
  final String displayName;
  final String description;
}
