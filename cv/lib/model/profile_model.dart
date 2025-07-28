class ProfileModel {
  final String? id;
  final String? name;
  final String? designation;
  final String? description;
  final String? email;
  final String? phone;
  final String? location;
  final String? profileImageUrl;
  final Map<String, String>? socialLinks;
  final DateTime? updatedAt;

  const ProfileModel({
    this.id,
    this.name,
    this.designation,
    this.description,
    this.email,
    this.phone,
    this.location,
    this.profileImageUrl,
    this.socialLinks,
    this.updatedAt,
  });

  // Factory constructor from Firebase data
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      designation: map['designation']?.toString(),
      description: map['description']?.toString(),
      email: map['email']?.toString(),
      phone: map['phone']?.toString(),
      location: map['location']?.toString(),
      profileImageUrl: map['profileImageUrl']?.toString(),
      socialLinks: map['socialLinks'] != null
          ? Map<String, String>.from(map['socialLinks'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (designation != null) 'designation': designation,
      if (description != null) 'description': description,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (location != null) 'location': location,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (socialLinks != null) 'socialLinks': socialLinks,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  // CopyWith method for updates
  ProfileModel copyWith({
    String? id,
    String? name,
    String? designation,
    String? description,
    String? email,
    String? phone,
    String? location,
    String? profileImageUrl,
    Map<String, String>? socialLinks,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      description: description ?? this.description,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      socialLinks: socialLinks ?? this.socialLinks,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convenience getters
  String get fullName => name ?? 'No name available';
  String get jobTitle => designation ?? 'No designation available';
  String get bio => description ?? 'No description available';

  bool get hasCompleteProfile =>
      name != null && designation != null && description != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileModel &&
        other.id == id &&
        other.name == name &&
        other.designation == designation &&
        other.description == description &&
        other.email == email &&
        other.phone == phone &&
        other.location == location;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      designation,
      description,
      email,
      phone,
      location,
    );
  }

  @override
  String toString() {
    return 'ProfileModel(name: $name, designation: $designation, email: $email)';
  }
}
