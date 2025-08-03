/// AuthUser Entity - Repräsentiert einen authentifizierten Benutzer
class AuthUser {
  final String id;
  final String email;
  final String? name;
  final String? role;
  final bool isAuthenticated;
  final DateTime? lastLoginAt;
  final bool biometricsEnabled;
  final bool pinEnabled;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.role,
    this.isAuthenticated = false,
    this.lastLoginAt,
    this.biometricsEnabled = false,
    this.pinEnabled = false,
  });

  /// Erstellt einen AuthUser aus JSON
  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      role: json['role'] as String?,
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      biometricsEnabled: json['biometricsEnabled'] as bool? ?? false,
      pinEnabled: json['pinEnabled'] as bool? ?? false,
    );
  }

  /// Konvertiert AuthUser zu JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'isAuthenticated': isAuthenticated,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'biometricsEnabled': biometricsEnabled,
      'pinEnabled': pinEnabled,
    };
  }

  /// Erstellt eine Kopie mit aktualisierten Eigenschaften
  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    bool? isAuthenticated,
    DateTime? lastLoginAt,
    bool? biometricsEnabled,
    bool? pinEnabled,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      pinEnabled: pinEnabled ?? this.pinEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, name: $name, role: $role, isAuthenticated: $isAuthenticated)';
  }
} 