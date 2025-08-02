class ExperienceModel {
  final String id;
  final String duration;
  final String company;
  final List<String> description;
  final String? position;
  final String? location;
  final String? startDate;
  final String? endDate;

  ExperienceModel({
    required this.id,
    required this.duration,
    required this.company,
    required this.description,
    this.position,
    this.location,
    this.startDate,
    this.endDate,
  });

  factory ExperienceModel.fromMap(Map<dynamic, dynamic> data, {String? id}) {
    // Description handling - can be List or String
    List<String> descriptionList = [];

    if (data['description'] != null) {
      if (data['description'] is List) {
        descriptionList = (data['description'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      } else if (data['description'] is String) {
        descriptionList = [data['description'].toString()];
      }
    }

    return ExperienceModel(
      id: id ?? data['id']?.toString() ?? '',
      duration: data['duration']?.toString() ?? 'Unknown Date',
      company: data['company']?.toString() ?? 'Unknown Company',
      description: descriptionList.isEmpty
          ? ['No description available']
          : descriptionList,
      position: data['position']?.toString(),
      location: data['location']?.toString(),
      startDate: data['startDate']?.toString(),
      endDate: data['endDate']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'duration': duration,
      'company': company,
      'description': description,
      if (position != null) 'position': position,
      if (location != null) 'location': location,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    };
  }

  ExperienceModel copyWith({
    String? id,
    String? duration,
    String? company,
    List<String>? description,
    String? position,
    String? location,
    String? startDate,
    String? endDate,
  }) {
    return ExperienceModel(
      id: id ?? this.id,
      duration: duration ?? this.duration,
      company: company ?? this.company,
      description: description ?? this.description,
      position: position ?? this.position,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  String toString() {
    return 'ExperienceModel(id: $id, duration: $duration, company: $company, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExperienceModel &&
        other.id == id &&
        other.duration == duration &&
        other.company == company;
  }

  @override
  int get hashCode {
    return id.hashCode ^ duration.hashCode ^ company.hashCode;
  }
}
