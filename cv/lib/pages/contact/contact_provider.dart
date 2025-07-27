import 'package:cv/services/firebase_controller.dart';
import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier {
  Map<String, dynamic>? _aboutInfo;
  bool _isLoading = false;
  String? _error;

  // Getters
  Map<String, dynamic>? get aboutInfo => _aboutInfo;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Individual getters for easy access
  String? get name => _aboutInfo?['name'];
  String? get designation => _aboutInfo?['designation'];
  String? get email => _aboutInfo?['email'];
  String? get location => _aboutInfo?['location'];
  String? get linkedin => _aboutInfo?['linkedin'];
  String? get github => _aboutInfo?['github'];
  String? get medium => _aboutInfo?['medium'];

  // Firebase controller reference
  final FirebaseController _firebaseController;

  ContactProvider(this._firebaseController);

  // Load contact/about information
  Future<void> loadContactInfo() async {
    if (_isLoading) return;

    _setLoading(true);
    _error = null;

    try {
      _aboutInfo = await _firebaseController.getAboutInfo();
    } catch (e) {
      _error = e.toString();
      _aboutInfo = null;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh contact information
  Future<void> refreshContactInfo() async {
    _aboutInfo = null;
    await loadContactInfo();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Update methods for individual contact fields
  Future<void> updateEmail(String newEmail) async {
    try {
      // await _firebaseController.updateEmail(newEmail);
      if (_aboutInfo != null) {
        _aboutInfo!['email'] = newEmail;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateLocation(String newLocation) async {
    try {
      // await _firebaseController.updateLocation(newLocation);
      if (_aboutInfo != null) {
        _aboutInfo!['location'] = newLocation;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateSocialMedia({
    String? linkedin,
    String? github,
    String? medium,
  }) async {
    try {
      if (_aboutInfo != null) {
        if (linkedin != null) _aboutInfo!['linkedin'] = linkedin;
        if (github != null) _aboutInfo!['github'] = github;
        if (medium != null) _aboutInfo!['medium'] = medium;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
