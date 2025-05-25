import 'package:firebase_database/firebase_database.dart';

class FirebaseController {
  final DatabaseReference _aboutRef =
      FirebaseDatabase.instance.ref().child("Portfolio/about_us");
  final DatabaseReference _experienceRef =
      FirebaseDatabase.instance.ref().child("Portfolio/experience");
  final DatabaseReference _portfolioRef =
      FirebaseDatabase.instance.ref().child("Portfolio/portfolio");

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

  Query getExperience() {
    return _experienceRef;
  }

  Query getPortfolio() {
    return _portfolioRef;
  }
}
