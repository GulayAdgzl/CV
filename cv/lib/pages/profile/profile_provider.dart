import 'package:cv/controller/firebase_controller.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  String? _fullName;
  String? _designation;
  String? _description;
  bool _isLoading = false;
  String? _error;

  // Getters
  String? get fullName => _fullName;
  String? get designation => _designation;
  String? get description => _description;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Firebase controller reference
  final FirebaseController _firebaseController;

  ProfileProvider(this._firebaseController);

  // Load all profile data
  Future<void> loadProfileData() async {
    if (_isLoading) return;

    _setLoading(true);
    _error = null;

    try {
      final results = await Future.wait([
        _firebaseController.getFullName(),
        _firebaseController.getDesignation(),
        _firebaseController.getDescription(),
      ]);

      _fullName = results[0];
      _designation = results[1];
      _description = results[2];
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    _fullName = null;
    _designation = null;
    _description = null;
    await loadProfileData();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Update methods for individual fields
  Future<void> updateFullName(String newName) async {
    try {
      // Assuming you have an update method in FirebaseController
      // await _firebaseController.updateFullName(newName);
      _fullName = newName;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateDesignation(String newDesignation) async {
    try {
      // await _firebaseController.updateDesignation(newDesignation);
      _designation = newDesignation;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateDescription(String newDescription) async {
    try {
      // await _firebaseController.updateDescription(newDescription);
      _description = newDescription;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
