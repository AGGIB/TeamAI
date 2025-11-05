class TeamMember {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final List<String> skills;
  final int experienceYears;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.skills,
    required this.experienceYears,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      skills: List<String>.from(json['skills'] ?? []),
      experienceYears: json['experienceYears'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'skills': skills,
      'experienceYears': experienceYears,
    };
  }

  TeamMember copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    List<String>? skills,
    int? experienceYears,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      skills: skills ?? this.skills,
      experienceYears: experienceYears ?? this.experienceYears,
    );
  }
}
