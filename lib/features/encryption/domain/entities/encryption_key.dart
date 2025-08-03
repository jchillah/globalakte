/// EncryptionKey Entity - Repräsentiert einen Verschlüsselungsschlüssel
class EncryptionKey {
  final String id;
  final String name;
  final String keyType;
  final String algorithm;
  final String keyMaterial;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;
  final bool isRotated;
  final String? rotatedFromKeyId;
  final Map<String, dynamic> metadata;

  const EncryptionKey({
    required this.id,
    required this.name,
    required this.keyType,
    required this.algorithm,
    required this.keyMaterial,
    required this.createdAt,
    this.expiresAt,
    this.isActive = true,
    this.isRotated = false,
    this.rotatedFromKeyId,
    this.metadata = const {},
  });

  /// Erstellt EncryptionKey aus JSON
  factory EncryptionKey.fromJson(Map<String, dynamic> json) {
    return EncryptionKey(
      id: json['id'] as String,
      name: json['name'] as String,
      keyType: json['keyType'] as String,
      algorithm: json['algorithm'] as String,
      keyMaterial: json['keyMaterial'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      isRotated: json['isRotated'] as bool? ?? false,
      rotatedFromKeyId: json['rotatedFromKeyId'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  /// Konvertiert EncryptionKey zu JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'keyType': keyType,
      'algorithm': algorithm,
      'keyMaterial': keyMaterial,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
      'isRotated': isRotated,
      'rotatedFromKeyId': rotatedFromKeyId,
      'metadata': metadata,
    };
  }

  /// Erstellt eine Kopie mit aktualisierten Eigenschaften
  EncryptionKey copyWith({
    String? id,
    String? name,
    String? keyType,
    String? algorithm,
    String? keyMaterial,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isActive,
    bool? isRotated,
    String? rotatedFromKeyId,
    Map<String, dynamic>? metadata,
  }) {
    return EncryptionKey(
      id: id ?? this.id,
      name: name ?? this.name,
      keyType: keyType ?? this.keyType,
      algorithm: algorithm ?? this.algorithm,
      keyMaterial: keyMaterial ?? this.keyMaterial,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      isRotated: isRotated ?? this.isRotated,
      rotatedFromKeyId: rotatedFromKeyId ?? this.rotatedFromKeyId,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Prüft, ob der Schlüssel abgelaufen ist
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Prüft, ob der Schlüssel gültig ist (aktiv und nicht abgelaufen)
  bool get isValid => isActive && !isExpired;

  /// Gibt das Alter des Schlüssels in Tagen zurück
  int get ageInDays {
    return DateTime.now().difference(createdAt).inDays;
  }

  /// Prüft, ob es sich um einen symmetrischen Schlüssel handelt
  bool get isSymmetric => keyType == 'symmetric';

  /// Prüft, ob es sich um einen asymmetrischen Schlüssel handelt
  bool get isAsymmetric => keyType == 'asymmetric';

  /// Prüft, ob es sich um einen öffentlichen Schlüssel handelt
  bool get isPublicKey => keyType == 'public';

  /// Prüft, ob es sich um einen privaten Schlüssel handelt
  bool get isPrivateKey => keyType == 'private';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EncryptionKey && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EncryptionKey(id: $id, name: $name, type: $keyType, algorithm: $algorithm, active: $isActive)';
  }
} 