import 'package:cv/model/profile_model.dart';
import 'package:cv/services/firebase_controller.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  // Firebase service reference (using the improved service from your code)
  final FirebaseService _firebaseService;

  ProfileProvider(this._firebaseService);

  // Getters
  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Convenience getters for backward compatibility
  String? get fullName => _profile?.name;
  String? get designation => _profile?.designation;
  String? get description => _profile?.description;
  String? get email => _profile?.email;
  String? get phone => _profile?.phone;
  String? get location => _profile?.location;

  bool get hasProfile => _profile != null;
  bool get hasCompleteProfile => _profile?.hasCompleteProfile ?? false;

  // Load all profile data
  Future<void> loadProfileData() async {
    if (_isLoading) return;

    _setLoadingState(true);
    _clearError();

    try {
      final aboutInfo = await _firebaseService.getAboutInfo();

      if (aboutInfo != null) {
        _profile = ProfileModel.fromMap(aboutInfo);
      } else {
        _profile = null;
        _setError('No profile data found');
      }
    } catch (e) {
      _setError('Failed to load profile: ${e.toString()}');
      _profile = null;
    } finally {
      _setLoadingState(false);
    }
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    _profile = null;
    await loadProfileData();
  }

  // Update complete profile
  Future<void> updateProfile(ProfileModel updatedProfile) async {
    _setLoadingState(true);
    _clearError();

    try {
      await _firebaseService.updateAboutInfo(updatedProfile.toMap());
      _profile = updatedProfile;
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  // Update individual fields
  Future<void> updateFullName(String newName) async {
    if (_profile == null) return;

    _setLoadingState(true);
    _clearError();

    try {
      await _firebaseService.updateName(newName);
      _profile = _profile!.copyWith(name: newName);
    } catch (e) {
      _setError('Failed to update name: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> updateDesignation(String newDesignation) async {
    if (_profile == null) return;

    _setLoadingState(true);
    _clearError();

    try {
      await _firebaseService.updateDesignation(newDesignation);
      _profile = _profile!.copyWith(designation: newDesignation);
    } catch (e) {
      _setError('Failed to update designation: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> updateDescription(String newDescription) async {
    if (_profile == null) return;

    _setLoadingState(true);
    _clearError();

    try {
      await _firebaseService.updateAboutField('description', newDescription);
      _profile = _profile!.copyWith(description: newDescription);
    } catch (e) {
      _setError('Failed to update description: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> updateEmail(String newEmail) async {
    if (_profile == null) return;

    _setLoadingState(true);
    _clearError();

    try {
      await _firebaseService.updateEmail(newEmail);
      _profile = _profile!.copyWith(email: newEmail);
    } catch (e) {
      _setError('Failed to update email: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> updatePhone(String newPhone) async {
    if (_profile == null) return;

    _setLoadingState(true);
    _clearError();

    try {
      await _firebaseService.updatePhone(newPhone);
      _profile = _profile!.copyWith(phone: newPhone);
    } catch (e) {
      _setError('Failed to update phone: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> updateLocation(String newLocation) async {
    if (_profile == null) return;

    _setLoadingState(true);
    _clearError();

    try {
      await _firebaseService.updateLocation(newLocation);
      _profile = _profile!.copyWith(location: newLocation);
    } catch (e) {
      _setError('Failed to update location: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  // Stream methods for real-time updates
  void startListeningToProfileChanges() {
    _firebaseService.watchAboutInfo().listen(
      (aboutInfo) {
        if (aboutInfo != null) {
          _profile = ProfileModel.fromMap(aboutInfo);
          notifyListeners();
        }
      },
      onError: (error) {
        _setError('Real-time update error: ${error.toString()}');
      },
    );
  }

  // Private helper methods
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Validation methods
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }

  // Clear all data (useful for logout)
  void clearProfile() {
    _profile = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
