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
