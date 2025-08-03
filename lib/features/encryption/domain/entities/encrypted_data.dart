/// EncryptedData Entity - Repräsentiert verschlüsselte Daten
class EncryptedData {
  final String id;
  final String encryptedContent;
  final String algorithm;
  final String keyId;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String? signature;
  final String? checksum;
  final Map<String, dynamic> metadata;

  const EncryptedData({
    required this.id,
    required this.encryptedContent,
    required this.algorithm,
    required this.keyId,
    required this.createdAt,
    this.expiresAt,
    this.signature,
    this.checksum,
    this.metadata = const {},
  });

  /// Erstellt EncryptedData aus JSON
  factory EncryptedData.fromJson(Map<String, dynamic> json) {
    return EncryptedData(
      id: json['id'] as String,
      encryptedContent: json['encryptedContent'] as String,
      algorithm: json['algorithm'] as String,
      keyId: json['keyId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      signature: json['signature'] as String?,
      checksum: json['checksum'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  /// Konvertiert EncryptedData zu JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encryptedContent': encryptedContent,
      'algorithm': algorithm,
      'keyId': keyId,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'signature': signature,
      'checksum': checksum,
      'metadata': metadata,
    };
  }

  /// Erstellt eine Kopie mit aktualisierten Eigenschaften
  EncryptedData copyWith({
    String? id,
    String? encryptedContent,
    String? algorithm,
    String? keyId,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? signature,
    String? checksum,
    Map<String, dynamic>? metadata,
  }) {
    return EncryptedData(
      id: id ?? this.id,
      encryptedContent: encryptedContent ?? this.encryptedContent,
      algorithm: algorithm ?? this.algorithm,
      keyId: keyId ?? this.keyId,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      signature: signature ?? this.signature,
      checksum: checksum ?? this.checksum,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Prüft, ob die Daten abgelaufen sind
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Prüft, ob die Daten signiert sind
  bool get isSigned => signature != null && signature!.isNotEmpty;

  /// Prüft, ob die Daten eine Checksum haben
  bool get hasChecksum => checksum != null && checksum!.isNotEmpty;

  /// Gibt das Alter der Daten in Tagen zurück
  int get ageInDays {
    return DateTime.now().difference(createdAt).inDays;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EncryptedData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EncryptedData(id: $id, algorithm: $algorithm, keyId: $keyId, createdAt: $createdAt)';
  }
} 