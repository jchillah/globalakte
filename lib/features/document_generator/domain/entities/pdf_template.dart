// features/document_generator/domain/entities/pdf_template.dart

/// PDF-Template Entität für den Domain-Layer
class PdfTemplate {
  final String id;
  final String name;
  final String description;
  final String templateType;
  final String htmlTemplate;
  final Map<String, dynamic> defaultData;
  final List<String> requiredFields;
  final List<String> optionalFields;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? category;
  final String? version;

  const PdfTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.templateType,
    required this.htmlTemplate,
    required this.defaultData,
    required this.requiredFields,
    required this.optionalFields,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.category,
    this.version,
  });

  /// Template aus Map erstellen
  factory PdfTemplate.fromMap(Map<String, dynamic> map) {
    return PdfTemplate(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      templateType: map['templateType'] as String,
      htmlTemplate: map['htmlTemplate'] as String,
      defaultData: Map<String, dynamic>.from(map['defaultData'] as Map),
      requiredFields: List<String>.from(map['requiredFields'] ?? []),
      optionalFields: List<String>.from(map['optionalFields'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isActive: map['isActive'] as bool? ?? true,
      category: map['category'] as String?,
      version: map['version'] as String?,
    );
  }

  /// Template zu Map konvertieren
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'templateType': templateType,
      'htmlTemplate': htmlTemplate,
      'defaultData': defaultData,
      'requiredFields': requiredFields,
      'optionalFields': optionalFields,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'category': category,
      'version': version,
    };
  }

  /// Kopie mit Änderungen erstellen
  PdfTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? templateType,
    String? htmlTemplate,
    Map<String, dynamic>? defaultData,
    List<String>? requiredFields,
    List<String>? optionalFields,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? category,
    String? version,
  }) {
    return PdfTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      templateType: templateType ?? this.templateType,
      htmlTemplate: htmlTemplate ?? this.htmlTemplate,
      defaultData: defaultData ?? this.defaultData,
      requiredFields: requiredFields ?? this.requiredFields,
      optionalFields: optionalFields ?? this.optionalFields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      category: category ?? this.category,
      version: version ?? this.version,
    );
  }

  /// Template-Typ prüfen
  bool get isLegalLetter => templateType == 'legal_letter';
  bool get isContract => templateType == 'contract';
  bool get isApplication => templateType == 'application';
  bool get isReport => templateType == 'report';
  bool get isCertificate => templateType == 'certificate';

  /// Alle verfügbaren Felder
  List<String> get allFields => [...requiredFields, ...optionalFields];

  /// Template-Kategorie
  String get displayCategory => category ?? 'Allgemein';

  /// Formatierte Erstellungszeit
  String get formattedCreatedAt =>
      '${createdAt.day}.${createdAt.month}.${createdAt.year}';

  /// Template-Status
  String get statusText => isActive ? 'Aktiv' : 'Inaktiv';
}
