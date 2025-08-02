/*class ProjectModel {
  final String name;
  final String description;
  final String githubUrl;
  final String language;
  final String stars;
  final String updatedAt;

  ProjectModel({
    required this.name,
    required this.description,
    required this.githubUrl,
    required this.language,
    required this.stars,
    required this.updatedAt,
  });

  factory ProjectModel.fromMap(Map<dynamic, dynamic> data) {
    return ProjectModel(
      name: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      githubUrl: data['link'] ?? '',
      language: data['language'] ?? 'Unknown',
      stars: data['stars']?.toString() ?? '0',
      updatedAt: data['updated_at'] ?? 'Unknown',
    );
  }
}
*/
class ProjectModel {
  final String name;
  final String description;
  final String githubUrl;
  final String language;
  final String stars;
  final String updatedAt;

  ProjectModel({
    required this.name,
    required this.description,
    required this.githubUrl,
    required this.language,
    required this.stars,
    required this.updatedAt,
  });

  factory ProjectModel.fromMap(Map<dynamic, dynamic> data) {
    return ProjectModel(
      name: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      githubUrl: data['link'] ?? '',
      language: data['language'] ?? 'Unknown',
      stars: data['stars']?.toString() ?? '0',
      updatedAt: data['updated_at'] ?? 'Unknown',
    );
  }
}
