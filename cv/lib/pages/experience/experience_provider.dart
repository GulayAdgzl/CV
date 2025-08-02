// providers/experience_provider.dart
import 'package:cv/model/experience_model.dart';
import 'package:cv/services/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ExperienceProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  // State variables
  List<ExperienceModel> _experiences = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ExperienceModel> get experiences => _experiences;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasExperiences => _experiences.isNotEmpty;

  // Firebase query getter for FirebaseAnimatedList
  DatabaseReference get experienceQuery => _firebaseService.experienceRef;

  // Constructor
  ExperienceProvider() {
    loadExperiences();
  }

  // Load all experiences
  Future<void> loadExperiences() async {
    try {
      _setLoading(true);
      final experiencesData = await _firebaseService.getExperiences();
      _experiences =
          experiencesData.map((data) => ExperienceModel.fromMap(data)).toList();

      // Sort by start date (newest first)
      _sortExperiencesByDate();
      _setError(null);
    } catch (e) {
      _setError('Deneyimler yüklenirken hata: $e');
      _experiences = [];
    } finally {
      _setLoading(false);
    }
  }

  // Add new experience
  Future<bool> addExperience(Map<String, dynamic> experienceData) async {
    try {
      _setLoading(true);
      await _firebaseService.addExperience(experienceData);
      await loadExperiences(); // Refresh list
      _setError(null);
      return true;
    } catch (e) {
      _setError('Deneyim eklenirken hata: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update experience
  Future<bool> updateExperience(
      String experienceId, Map<String, dynamic> experienceData) async {
    try {
      _setLoading(true);
      await _firebaseService.updateExperience(experienceId, experienceData);
      await loadExperiences(); // Refresh list
      _setError(null);
      return true;
    } catch (e) {
      _setError('Deneyim güncellenirken hata: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete experience
  Future<bool> deleteExperience(String experienceId) async {
    try {
      _setLoading(true);
      await _firebaseService.deleteExperience(experienceId);
      await loadExperiences(); // Refresh list
      _setError(null);
      return true;
    } catch (e) {
      _setError('Deneyim silinirken hata: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get experience by id
  ExperienceModel? getExperienceById(String id) {
    try {
      return _experiences.firstWhere((experience) => experience.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search experiences
  List<ExperienceModel> searchExperiences(String query) {
    if (query.isEmpty) return _experiences;

    return _experiences.where((experience) {
      return experience.company.toLowerCase().contains(query.toLowerCase()) ||
          experience.duration.toLowerCase().contains(query.toLowerCase()) ||
          (experience.position?.toLowerCase().contains(query.toLowerCase()) ??
              false) ||
          experience.description
              .any((desc) => desc.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  // Filter by company
  List<ExperienceModel> filterByCompany(String company) {
    return _experiences
        .where((experience) =>
            experience.company.toLowerCase().contains(company.toLowerCase()))
        .toList();
  }

  // Get experiences by date range
  List<ExperienceModel> getExperiencesByDateRange(
      DateTime start, DateTime end) {
    return _experiences.where((experience) {
      // Simple date comparison - you might want to improve this
      return experience.startDate != null;
    }).toList();
  }

  // Sort experiences
  void sortExperiences(ExperienceSortType sortType) {
    switch (sortType) {
      case ExperienceSortType.company:
        _experiences.sort((a, b) => a.company.compareTo(b.company));
        break;
      case ExperienceSortType.duration:
        _experiences.sort((a, b) => a.duration.compareTo(b.duration));
        break;
      case ExperienceSortType.dateNewest:
        _sortExperiencesByDate(ascending: false);
        break;
      case ExperienceSortType.dateOldest:
        _sortExperiencesByDate(ascending: true);
        break;
    }
    notifyListeners();
  }

  // Private method to sort by date
  void _sortExperiencesByDate({bool ascending = false}) {
    _experiences.sort((a, b) {
      // Simple string comparison - you might want to improve this with proper date parsing
      final comparison = (a.startDate ?? '').compareTo(b.startDate ?? '');
      return ascending ? comparison : -comparison;
    });
  }

  // Refresh experiences
  Future<void> refreshExperiences() async {
    await loadExperiences();
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Get total years of experience (helper method)
  double getTotalYearsOfExperience() {
    // This is a simplified calculation
    // You might want to implement proper date calculation
    return _experiences.length *
        1.5; // Assuming 1.5 years average per experience
  }

  // Get unique companies
  List<String> getUniqueCompanies() {
    return _experiences.map((e) => e.company).toSet().toList();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// Sort enum
enum ExperienceSortType {
  company,
  duration,
  dateNewest,
  dateOldest,
}
