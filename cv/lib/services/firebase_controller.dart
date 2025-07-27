import 'package:firebase_database/firebase_database.dart';

class FirebaseController {
  final DatabaseReference _aboutRef =
      FirebaseDatabase.instance.ref().child("Portfolio/about_us");
  final DatabaseReference _experienceRef =
      FirebaseDatabase.instance.ref().child("Portfolio/experience");
  final DatabaseReference _portfolioRef =
      FirebaseDatabase.instance.ref().child("Portfolio/portfolio");
  DatabaseReference get portfolio => _portfolioRef;

  Future<String> getFullName() async {
    final snapshot = await _aboutRef.get();
    final data = snapshot.value as Map?;
    return data?['name'] ?? 'No name found';
  }

  Future<String> getDesignation() async {
    final snapshot = await _aboutRef.get();
    final data = snapshot.value as Map?;
    return data?['designation'] ?? 'No designation found';
  }

  Future<String> getDescription() async {
    final snapshot = await _aboutRef.get();
    final data = snapshot.value as Map?;
    return data?['description'] ?? 'No description found';
  }

  Future<Map<String, dynamic>> getAboutInfo() async {
    final snapshot = await _aboutRef.get();
    final data = snapshot.value as Map?;
    return data?.map((key, value) => MapEntry(key.toString(), value)) ?? {};
  }

  Future<List<String>> getSkills() async {
    final ref = FirebaseDatabase.instance.ref().child("Portfolio/skills");
    final snapshot = await ref.get();
    final data = snapshot.value as List?;
    return data?.map((e) => e.toString()).toList() ?? [];
  }

  Query getExperience() {
    return _experienceRef;
  }

  Query getPortfolio() {
    return _portfolioRef;
  }
}

class FirebaseService {
  // Database references
  final DatabaseReference _aboutRef =
      FirebaseDatabase.instance.ref().child("Portfolio/about_us");
  final DatabaseReference _experienceRef =
      FirebaseDatabase.instance.ref().child("Portfolio/experience");
  final DatabaseReference _portfolioRef =
      FirebaseDatabase.instance.ref().child("Portfolio/portfolio");
  final DatabaseReference _skillsRef =
      FirebaseDatabase.instance.ref().child("Portfolio/skills");

  // Getter for external access
  DatabaseReference get aboutRef => _aboutRef;
  DatabaseReference get experienceRef => _experienceRef;
  DatabaseReference get portfolioRef => _portfolioRef;
  DatabaseReference get skillsRef => _skillsRef;

  // ==================== ABOUT/CONTACT METHODS ====================

  /// Get complete about information
  Future<Map<String, dynamic>?> getAboutInfo() async {
    try {
      final snapshot = await _aboutRef.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return data.map((key, value) => MapEntry(key.toString(), value));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get about info: $e');
    }
  }

  /// Update complete about information
  Future<void> updateAboutInfo(Map<String, dynamic> data) async {
    try {
      await _aboutRef.update(data);
    } catch (e) {
      throw Exception('Failed to update about info: $e');
    }
  }

  /// Get specific field from about info
  Future<String?> getAboutField(String fieldName) async {
    try {
      final snapshot = await _aboutRef.child(fieldName).get();
      return snapshot.exists ? snapshot.value?.toString() : null;
    } catch (e) {
      throw Exception('Failed to get $fieldName: $e');
    }
  }

  /// Update specific field in about info
  Future<void> updateAboutField(String fieldName, dynamic value) async {
    try {
      await _aboutRef.child(fieldName).set(value);
    } catch (e) {
      throw Exception('Failed to update $fieldName: $e');
    }
  }

  // Convenient methods for common fields
  Future<String?> getFullName() async => await getAboutField('name');
  Future<String?> getDesignation() async => await getAboutField('designation');
  Future<String?> getDescription() async => await getAboutField('description');
  Future<String?> getEmail() async => await getAboutField('email');
  Future<String?> getPhone() async => await getAboutField('phone');
  Future<String?> getLocation() async => await getAboutField('location');

  Future<void> updateName(String name) async =>
      await updateAboutField('name', name);
  Future<void> updateDesignation(String designation) async =>
      await updateAboutField('designation', designation);
  Future<void> updateEmail(String email) async =>
      await updateAboutField('email', email);
  Future<void> updatePhone(String phone) async =>
      await updateAboutField('phone', phone);
  Future<void> updateLocation(String location) async =>
      await updateAboutField('location', location);

  // ==================== SKILLS METHODS ====================

  /// Get all skills
  Future<List<Map<String, dynamic>>> getSkills() async {
    try {
      final snapshot = await _skillsRef.get();
      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final data = snapshot.value;
      List<Map<String, dynamic>> skillsList = [];

      if (data is List) {
        // If skills are stored as array
        for (var skill in data) {
          if (skill != null) {
            if (skill is String) {
              skillsList.add({'name': skill, 'level': 50}); // Default level
            } else if (skill is Map) {
              skillsList.add(
                  skill.map((key, value) => MapEntry(key.toString(), value)));
            }
          }
        }
      } else if (data is Map) {
        // If skills are stored as object
        data.forEach((key, value) {
          if (value is Map) {
            skillsList.add(value.map((k, v) => MapEntry(k.toString(), v)));
          } else {
            skillsList.add({'name': value.toString(), 'level': 50});
          }
        });
      }

      return skillsList;
    } catch (e) {
      throw Exception('Failed to get skills: $e');
    }
  }

  /// Add new skill
  Future<void> addSkill(Map<String, dynamic> skill) async {
    try {
      await _skillsRef.push().set(skill);
    } catch (e) {
      throw Exception('Failed to add skill: $e');
    }
  }

  /// Update skill by key
  Future<void> updateSkill(String skillKey, Map<String, dynamic> skill) async {
    try {
      await _skillsRef.child(skillKey).update(skill);
    } catch (e) {
      throw Exception('Failed to update skill: $e');
    }
  }

  /// Delete skill by key
  Future<void> deleteSkill(String skillKey) async {
    try {
      await _skillsRef.child(skillKey).remove();
    } catch (e) {
      throw Exception('Failed to delete skill: $e');
    }
  }

  // ==================== EXPERIENCE METHODS ====================

  /// Get all experiences
  Future<List<Map<String, dynamic>>> getExperiences() async {
    try {
      final snapshot = await _experienceRef.orderByChild('startDate').get();
      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      List<Map<String, dynamic>> experiencesList = [];

      data.forEach((key, value) {
        if (value is Map) {
          Map<String, dynamic> experience =
              value.map((k, v) => MapEntry(k.toString(), v));
          experience['id'] = key.toString(); // Add Firebase key as id
          experiencesList.add(experience);
        }
      });

      return experiencesList;
    } catch (e) {
      throw Exception('Failed to get experiences: $e');
    }
  }

  /// Add new experience
  Future<String> addExperience(Map<String, dynamic> experience) async {
    try {
      final ref = await _experienceRef.push();
      await ref.set(experience);
      return ref.key!;
    } catch (e) {
      throw Exception('Failed to add experience: $e');
    }
  }

  /// Update experience by key
  Future<void> updateExperience(
      String experienceKey, Map<String, dynamic> experience) async {
    try {
      await _experienceRef.child(experienceKey).update(experience);
    } catch (e) {
      throw Exception('Failed to update experience: $e');
    }
  }

  /// Delete experience by key
  Future<void> deleteExperience(String experienceKey) async {
    try {
      await _experienceRef.child(experienceKey).remove();
    } catch (e) {
      throw Exception('Failed to delete experience: $e');
    }
  }

  // ==================== PORTFOLIO/PROJECTS METHODS ====================

  /// Get all projects
  Future<List<Map<String, dynamic>>> getProjects() async {
    try {
      final snapshot = await _portfolioRef.get();
      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      List<Map<String, dynamic>> projectsList = [];

      data.forEach((key, value) {
        if (value is Map) {
          Map<String, dynamic> project =
              value.map((k, v) => MapEntry(k.toString(), v));
          project['id'] = key.toString(); // Add Firebase key as id
          projectsList.add(project);
        }
      });

      return projectsList;
    } catch (e) {
      throw Exception('Failed to get projects: $e');
    }
  }

  /// Add new project
  Future<String> addProject(Map<String, dynamic> project) async {
    try {
      final ref = await _portfolioRef.push();
      await ref.set(project);
      return ref.key!;
    } catch (e) {
      throw Exception('Failed to add project: $e');
    }
  }

  /// Update project by key
  Future<void> updateProject(
      String projectKey, Map<String, dynamic> project) async {
    try {
      await _portfolioRef.child(projectKey).update(project);
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  /// Delete project by key
  Future<void> deleteProject(String projectKey) async {
    try {
      await _portfolioRef.child(projectKey).remove();
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
  }

  // ==================== STREAM METHODS (Real-time updates) ====================

  /// Listen to about info changes
  Stream<Map<String, dynamic>?> watchAboutInfo() {
    return _aboutRef.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        return data.map((key, value) => MapEntry(key.toString(), value));
      }
      return null;
    });
  }

  /// Listen to skills changes
  Stream<List<Map<String, dynamic>>> watchSkills() {
    return _skillsRef.onValue.asyncMap((event) async {
      return await getSkills();
    });
  }

  /// Listen to experiences changes
  Stream<List<Map<String, dynamic>>> watchExperiences() {
    return _experienceRef.onValue.asyncMap((event) async {
      return await getExperiences();
    });
  }

  /// Listen to projects changes
  Stream<List<Map<String, dynamic>>> watchProjects() {
    return _portfolioRef.onValue.asyncMap((event) async {
      return await getProjects();
    });
  }

  // ==================== UTILITY METHODS ====================

  /// Check if Firebase is connected
  Future<bool> isConnected() async {
    try {
      final ref = FirebaseDatabase.instance.ref('.info/connected');
      final snapshot = await ref.get();
      return snapshot.value == true;
    } catch (e) {
      return false;
    }
  }

  /// Get server timestamp
  Map<String, String> get serverTimestamp => ServerValue.timestamp;
}
