// providers/project_provider.dart
import 'package:cv/model/project_model.dart';
import 'package:cv/services/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProjectProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  // State variables
  List<ProjectModel> _projects = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasProjects => _projects.isNotEmpty;

  // Firebase query getter for FirebaseAnimatedList
  DatabaseReference get portfolioQuery => _firebaseService.portfolioRef;

  // Constructor
  ProjectProvider() {
    loadProjects();
  }

  // Load all projects
  Future<void> loadProjects() async {
    try {
      _setLoading(true);
      final projectsData = await _firebaseService.getProjects();
      _projects =
          projectsData.map((data) => ProjectModel.fromMap(data)).toList();
      _setError(null);
    } catch (e) {
      _setError('Projeler yüklenirken hata: $e');
      _projects = [];
    } finally {
      _setLoading(false);
    }
  }

  // Add new project
  Future<bool> addProject(Map<String, dynamic> projectData) async {
    try {
      _setLoading(true);
      await _firebaseService.addProject(projectData);
      await loadProjects(); // Refresh list
      _setError(null);
      return true;
    } catch (e) {
      _setError('Proje eklenirken hata: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update project
  Future<bool> updateProject(
      String projectId, Map<String, dynamic> projectData) async {
    try {
      _setLoading(true);
      await _firebaseService.updateProject(projectId, projectData);
      await loadProjects(); // Refresh list
      _setError(null);
      return true;
    } catch (e) {
      _setError('Proje güncellenirken hata: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete project
  Future<bool> deleteProject(String projectId) async {
    try {
      _setLoading(true);
      await _firebaseService.deleteProject(projectId);
      await loadProjects(); // Refresh list
      _setError(null);
      return true;
    } catch (e) {
      _setError('Proje silinirken hata: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get project by id
  ProjectModel? getProjectById(String id) {
    try {
      return _projects.firstWhere((project) => project.name == id);
    } catch (e) {
      return null;
    }
  }

  // Search projects
  List<ProjectModel> searchProjects(String query) {
    if (query.isEmpty) return _projects;

    return _projects.where((project) {
      return project.name.toLowerCase().contains(query.toLowerCase()) ||
          project.description.toLowerCase().contains(query.toLowerCase()) ||
          project.language.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filter by language
  List<ProjectModel> filterByLanguage(String language) {
    return _projects
        .where((project) =>
            project.language.toLowerCase() == language.toLowerCase())
        .toList();
  }

  // Sort projects
  void sortProjects(ProjectSortType sortType) {
    switch (sortType) {
      case ProjectSortType.name:
        _projects.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProjectSortType.stars:
        _projects
            .sort((a, b) => int.parse(b.stars).compareTo(int.parse(a.stars)));
        break;
      case ProjectSortType.updated:
        _projects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
    }
    notifyListeners();
  }

  // Refresh projects
  Future<void> refreshProjects() async {
    await loadProjects();
  }

  // Clear error
  void clearError() {
    _setError(null);
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
enum ProjectSortType {
  name,
  stars,
  updated,
}
