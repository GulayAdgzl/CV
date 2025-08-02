class Skill {
  final String name;
  final String? description;
  final SkillCategory category;
  final DateTime createdAt;

  Skill({
    required this.name,
    this.description,
    required this.category,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // JSON serialization
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] ?? '',
      description: json['description'],
      category: SkillCategory.values.firstWhere(
        (category) => category.name == json['category'],
        orElse: () => SkillCategory.other,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Skill && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

enum SkillCategory {
  mobile,
  web,
  database,
  ai,
  design,
  other;

  String get displayName {
    switch (this) {
      case SkillCategory.mobile:
        return 'Mobile Development';
      case SkillCategory.web:
        return 'Web Development';
      case SkillCategory.database:
        return 'Database';
      case SkillCategory.ai:
        return 'Artificial Intelligence';
      case SkillCategory.design:
        return 'Design';
      case SkillCategory.other:
        return 'Other';
    }
  }
}
