import 'package:cv/model/contact_model.dart';
import 'package:cv/services/firebase_controller.dart';
import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier {
  ContactModel? _contactInfo;
  bool _isLoading = false;
  String? _error;

  // Getters
  ContactModel? get contactInfo => _contactInfo;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Easy access getters
  String? get name => _contactInfo?.name;
  String? get designation => _contactInfo?.designation;
  String? get email => _contactInfo?.email;
  String? get phone => _contactInfo?.phone;
  String? get location => _contactInfo?.location;
  String? get bio => _contactInfo?.bio;
  String? get profileImage => _contactInfo?.profileImage;

  // Social media getters
  String? get linkedin => _contactInfo?.socialMedia?.linkedin;
  String? get github => _contactInfo?.socialMedia?.github;
  String? get medium => _contactInfo?.socialMedia?.medium;
  String? get twitter => _contactInfo?.socialMedia?.twitter;
  String? get instagram => _contactInfo?.socialMedia?.instagram;

  // Firebase service reference
  final FirebaseService _firebaseService;

  ContactProvider(this._firebaseService);

  // Load contact information
  Future<void> loadContactInfo() async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final data = await _firebaseService.getAboutInfo();
      if (data != null) {
        _contactInfo = ContactModel.fromMap(data);
      } else {
        _contactInfo = null;
      }
    } catch (e) {
      _setError('Failed to load contact information: ${e.toString()}');
      _contactInfo = null;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh contact information
  Future<void> refreshContactInfo() async {
    _contactInfo = null;
    await loadContactInfo();
  }

  // Update contact information
  Future<bool> updateContactInfo(ContactModel updatedContact) async {
    _setLoading(true);
    _clearError();

    try {
      await _firebaseService.updateAboutInfo(updatedContact.toMap());
      _contactInfo = updatedContact;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update contact information: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Update individual fields
  Future<bool> updateEmail(String newEmail) async {
    if (_contactInfo == null) return false;

    final updatedContact = _contactInfo!.copyWith(email: newEmail);
    return await updateContactInfo(updatedContact);
  }

  Future<bool> updatePhone(String newPhone) async {
    if (_contactInfo == null) return false;

    final updatedContact = _contactInfo!.copyWith(phone: newPhone);
    return await updateContactInfo(updatedContact);
  }

  Future<bool> updateLocation(String newLocation) async {
    if (_contactInfo == null) return false;

    final updatedContact = _contactInfo!.copyWith(location: newLocation);
    return await updateContactInfo(updatedContact);
  }

  Future<bool> updateSocialMedia({
    String? linkedin,
    String? github,
    String? medium,
    String? twitter,
    String? instagram,
  }) async {
    if (_contactInfo == null) return false;

    final currentSocial = _contactInfo!.socialMedia ?? SocialMediaModel();
    final updatedSocial = currentSocial.copyWith(
      linkedin: linkedin,
      github: github,
      medium: medium,
      twitter: twitter,
      instagram: instagram,
    );

    final updatedContact = _contactInfo!.copyWith(socialMedia: updatedSocial);
    return await updateContactInfo(updatedContact);
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Clear all data (logout gibi durumlarda)
  void clearData() {
    _contactInfo = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
