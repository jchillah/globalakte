// features/legal_assistant_ai/domain/entities/legal_context.dart
/// Entity für rechtliche Kontexte im Legal AI
class LegalContext {
  final String id;
  final String title;
  final String description;
  final String category; // z.B. 'Zivilrecht', 'Familienrecht', 'Strafrecht'
  final List<String> keywords;
  final Map<String, dynamic>? legalFramework; // Rechtlicher Rahmen
  final DateTime createdAt;
  final DateTime? updatedAt;

  const LegalContext({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.keywords,
    this.legalFramework,
    required this.createdAt,
    this.updatedAt,
  });

  /// Erstellt einen neuen rechtlichen Kontext
  factory LegalContext.create({
    required String title,
    required String description,
    required String category,
    List<String>? keywords,
    Map<String, dynamic>? legalFramework,
  }) {
    return LegalContext(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category,
      keywords: keywords ?? [],
      legalFramework: legalFramework,
      createdAt: DateTime.now(),
    );
  }

  /// Konvertiert zu Map für Persistierung
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'keywords': keywords,
      'legalFramework': legalFramework,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Erstellt aus Map
  factory LegalContext.fromMap(Map<String, dynamic> map) {
    return LegalContext(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      keywords: List<String>.from(map['keywords']),
      legalFramework: map['legalFramework'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  /// Kopiert mit Änderungen
  LegalContext copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    List<String>? keywords,
    Map<String, dynamic>? legalFramework,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LegalContext(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      keywords: keywords ?? this.keywords,
      legalFramework: legalFramework ?? this.legalFramework,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Aktualisiert den Kontext
  LegalContext update({
    String? title,
    String? description,
    String? category,
    List<String>? keywords,
    Map<String, dynamic>? legalFramework,
  }) {
    return copyWith(
      title: title,
      description: description,
      category: category,
      keywords: keywords,
      legalFramework: legalFramework,
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LegalContext && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'LegalContext(id: $id, title: $title, category: $category)';
  }
}
