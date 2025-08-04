// features/document_generator/domain/entities/pdf_document.dart

/// PDF-Dokument Entität für den Domain-Layer
class PdfDocument {
  final String id;
  final String title;
  final String content;
  final String templateType;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? author;
  final String? version;
  final List<String> tags;

  const PdfDocument({
    required this.id,
    required this.title,
    required this.content,
    required this.templateType,
    required this.metadata,
    required this.createdAt,
    this.updatedAt,
    this.author,
    this.version,
    this.tags = const [],
  });

  /// PDF-Dokument aus Map erstellen
  factory PdfDocument.fromMap(Map<String, dynamic> map) {
    return PdfDocument(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      templateType: map['templateType'] as String,
      metadata: Map<String, dynamic>.from(map['metadata'] as Map),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      author: map['author'] as String?,
      version: map['version'] as String?,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  /// PDF-Dokument zu Map konvertieren
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'templateType': templateType,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'author': author,
      'version': version,
      'tags': tags,
    };
  }

  /// Kopie mit Änderungen erstellen
  PdfDocument copyWith({
    String? id,
    String? title,
    String? content,
    String? templateType,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? author,
    String? version,
    List<String>? tags,
  }) {
    return PdfDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      templateType: templateType ?? this.templateType,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
      version: version ?? this.version,
      tags: tags ?? this.tags,
    );
  }

  /// Dokument-Typ prüfen
  bool get isLegalLetter => templateType == 'legal_letter';
  bool get isContract => templateType == 'contract';
  bool get isApplication => templateType == 'application';
  bool get isReport => templateType == 'report';
  bool get isCertificate => templateType == 'certificate';

  /// Formatierte Erstellungszeit
  String get formattedCreatedAt =>
      '${createdAt.day}.${createdAt.month}.${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';

  /// Formatierte Aktualisierungszeit
  String get formattedUpdatedAt => updatedAt != null
      ? '${updatedAt!.day}.${updatedAt!.month}.${updatedAt!.year} ${updatedAt!.hour}:${updatedAt!.minute.toString().padLeft(2, '0')}'
      : 'Nicht aktualisiert';
}
