// providers/skills_provider.dart
import 'package:cv/model/skill_model.dart';
import 'package:cv/services/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SkillsProvider extends ChangeNotifier {
  final FirebaseService _firebaseService;

  // Callback functions for UI notifications
  Function(Skill)? _onSkillLiked;
  Function(Skill)? _onSkillSkipped;

  SkillsProvider(this._firebaseService);

  // State variables
  bool _isLoading = true;
  List<Skill> _skills = [];
  List<Skill> _likedSkills = [];
  int _currentIndex = 0;
  String? _errorMessage;

  MatchEngine? _matchEngine;
  List<SwipeItem> _swipeItems = [];

  // Getters
  bool get isLoading => _isLoading;
  List<Skill> get skills => _skills;
  List<Skill> get likedSkills => _likedSkills;
  int get currentIndex => _currentIndex;
  String? get errorMessage => _errorMessage;
  MatchEngine? get matchEngine => _matchEngine;
  List<SwipeItem> get swipeItems => _swipeItems;

  // Computed properties
  bool get isEmpty => _skills.isEmpty;
  bool get isCompleted => _currentIndex >= _skills.length;
  double get progress =>
      _skills.isNotEmpty ? (_currentIndex + 1) / _skills.length : 0;
  int get totalSkills => _skills.length;
  int get likedCount => _likedSkills.length;

  // Initialize and load skills
  Future<void> loadSkills() async {
    _setLoading(true);
    _clearError();

    try {
      final skillsData = await _firebaseService.getSkills();

      // Convert Map skills to Skill objects
      _skills = skillsData
          .map((skillMap) {
            final skillName = skillMap['name']?.toString() ?? '';
            return Skill(
              name: skillName,
              category: _categorizeSkill(skillName),
              description: skillMap['description']?.toString(),
            );
          })
          .where((skill) => skill.name.isNotEmpty)
          .toList();

      // Create swipe items
      _swipeItems = _skills.map((skill) {
        return SwipeItem(
          content: skill.name, // SwipeCards bekler string content
          likeAction: () => likeSkill(skill),
          nopeAction: () => skipSkill(skill),
        );
      }).toList();

      // Initialize match engine
      if (_swipeItems.isNotEmpty) {
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
      }

      _setLoading(false);
    } catch (e) {
      _setError("Hata: Beceriler yüklenemedi - ${e.toString()}");
      _setLoading(false);
    }
  }

  // Actions
  void likeSkill(Skill skill) {
    if (!_likedSkills.contains(skill)) {
      _likedSkills.add(skill);
    }
    _currentIndex++;
    notifyListeners();

    // Callback for UI notifications
    _onSkillLiked?.call(skill);
  }

  void skipSkill(Skill skill) {
    _currentIndex++;
    notifyListeners();

    // Callback for UI notifications
    _onSkillSkipped?.call(skill);
  }

  void reset() {
    _currentIndex = 0;
    _likedSkills.clear();
    notifyListeners();
    loadSkills();
  }

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void onStackFinished() {
    _currentIndex = _skills.length;
    notifyListeners();
  }

  // Set callbacks for UI notifications
  void setCallbacks({
    Function(Skill)? onSkillLiked,
    Function(Skill)? onSkillSkipped,
  }) {
    _onSkillLiked = onSkillLiked;
    _onSkillSkipped = onSkillSkipped;
  }

  // Helper methods
  SkillCategory _categorizeSkill(String skillName) {
    final skillLower = skillName.toLowerCase();

    if (skillLower.contains('flutter') ||
        skillLower.contains('mobile') ||
        skillLower.contains('android') ||
        skillLower.contains('ios')) {
      return SkillCategory.mobile;
    } else if (skillLower.contains('web') ||
        skillLower.contains('html') ||
        skillLower.contains('css') ||
        skillLower.contains('javascript')) {
      return SkillCategory.web;
    } else if (skillLower.contains('database') ||
        skillLower.contains('sql') ||
        skillLower.contains('mongodb') ||
        skillLower.contains('firebase')) {
      return SkillCategory.database;
    } else if (skillLower.contains('ai') ||
        skillLower.contains('machine') ||
        skillLower.contains('deep learning') ||
        skillLower.contains('neural')) {
      return SkillCategory.ai;
    } else if (skillLower.contains('design') ||
        skillLower.contains('ui') ||
        skillLower.contains('ux') ||
        skillLower.contains('figma')) {
      return SkillCategory.design;
    } else {
      return SkillCategory.other;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get skill icon based on category
  IconData getSkillIcon(String skillName) {
    final skill = _skills.firstWhere(
      (s) => s.name == skillName,
      orElse: () => Skill(name: skillName, category: SkillCategory.other),
    );

    switch (skill.category) {
      case SkillCategory.mobile:
        return Icons.phone_android;
      case SkillCategory.web:
        return Icons.web;
      case SkillCategory.database:
        return Icons.storage;
      case SkillCategory.ai:
        return Icons.psychology;
      case SkillCategory.design:
        return Icons.design_services;
      case SkillCategory.other:
        return Icons.lightbulb_outline;
    }
  }

  // Get current skill name for UI compatibility
  String getCurrentSkillName(int index) {
    if (index < _skills.length) {
      return _skills[index].name;
    }
    return '';
  }

  // Get all skill names for UI compatibility
  List<String> get skillNames => _skills.map((skill) => skill.name).toList();
}
