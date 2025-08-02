class ResumeGeneratorModel {
  final String? generatedText;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastGenerated;

  const ResumeGeneratorModel({
    this.generatedText,
    this.isLoading = false,
    this.errorMessage,
    this.lastGenerated,
  });

  ResumeGeneratorModel copyWith({
    String? generatedText,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastGenerated,
  }) {
    return ResumeGeneratorModel(
      generatedText: generatedText ?? this.generatedText,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      lastGenerated: lastGenerated ?? this.lastGenerated,
    );
  }

  bool get hasContent => generatedText != null && generatedText!.isNotEmpty;
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}

class PersonalInfo {
  final String name;
  final String designation;
  final String location;
  final String email;
  final String github;
  final List<String> skills;

  const PersonalInfo({
    required this.name,
    required this.designation,
    required this.location,
    required this.email,
    required this.github,
    required this.skills,
  });

  factory PersonalInfo.fromMap(
      Map<String, dynamic> aboutData, List<String> skillsList) {
    return PersonalInfo(
      name: aboutData['name'] ?? 'Unknown',
      designation: aboutData['designation'] ?? 'Developer',
      location: aboutData['location'] ?? 'Unknown Location',
      email: aboutData['email'] ?? '',
      github: aboutData['github'] ?? '',
      skills: skillsList,
    );
  }
}
