class ContactModel {
  final String? name;
  final String? designation;
  final String? email;
  final String? phone;
  final String? location;
  final String? bio;
  final String? profileImage;
  final SocialMediaModel? socialMedia;

  ContactModel({
    this.name,
    this.designation,
    this.email,
    this.phone,
    this.location,
    this.bio,
    this.profileImage,
    this.socialMedia,
  });

  // Firebase'den gelen Map'i ContactModel'e çevir
  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      name: map['name'],
      designation: map['designation'],
      email: map['email'],
      phone: map['phone'],
      location: map['location'],
      bio: map['bio'],
      profileImage: map['profileImage'],
      socialMedia: map['socialMedia'] != null
          ? SocialMediaModel.fromMap(map['socialMedia'])
          : null,
    );
  }

  // ContactModel'i Map'e çevir (Firebase'e göndermek için)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'designation': designation,
      'email': email,
      'phone': phone,
      'location': location,
      'bio': bio,
      'profileImage': profileImage,
      'socialMedia': socialMedia?.toMap(),
    };
  }

  // Copy with method (güncelleme için)
  ContactModel copyWith({
    String? name,
    String? designation,
    String? email,
    String? phone,
    String? location,
    String? bio,
    String? profileImage,
    SocialMediaModel? socialMedia,
  }) {
    return ContactModel(
      name: name ?? this.name,
      designation: designation ?? this.designation,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      socialMedia: socialMedia ?? this.socialMedia,
    );
  }
}

// Social Media için ayrı model
class SocialMediaModel {
  final String? linkedin;
  final String? github;
  final String? medium;
  final String? twitter;
  final String? instagram;

  SocialMediaModel({
    this.linkedin,
    this.github,
    this.medium,
    this.twitter,
    this.instagram,
  });

  factory SocialMediaModel.fromMap(Map<String, dynamic> map) {
    return SocialMediaModel(
      linkedin: map['linkedin'],
      github: map['github'],
      medium: map['medium'],
      twitter: map['twitter'],
      instagram: map['instagram'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'linkedin': linkedin,
      'github': github,
      'medium': medium,
      'twitter': twitter,
      'instagram': instagram,
    };
  }

  SocialMediaModel copyWith({
    String? linkedin,
    String? github,
    String? medium,
    String? twitter,
    String? instagram,
  }) {
    return SocialMediaModel(
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      medium: medium ?? this.medium,
      twitter: twitter ?? this.twitter,
      instagram: instagram ?? this.instagram,
    );
  }
}
