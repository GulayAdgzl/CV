import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final DatabaseReference _skillsRef =
      FirebaseDatabase.instance.ref().child("Portfolio/skills");

  List<String> _skills = [];
  List<double> _dummyLevels = [];

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  Future<void> _loadSkills() async {
    final snapshot = await _skillsRef.get();
    final skills = (snapshot.value as List<dynamic>?)?.cast<String>() ?? [];

    setState(() {
      _skills = skills.take(6).toList(); // Sadece ilk 6 tanesini gösteriyoruz
      _dummyLevels = List.generate(
          _skills.length, (index) => 0.6 + index * 0.05); // Sahte oranlar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005F73), Color(0xFF0A9396)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Android Skills",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "I specialize in mobile development.\nI stay up to date with the latest technologies.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 32),
            if (_skills.isNotEmpty)
              Center(
                child: RadarChart(
                  features: _skills,
                  data: [_dummyLevels],
                  ticks: const [2, 4, 6, 8, 10],
                  featuresTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 14),
                  graphColors: const [Colors.cyanAccent],
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _skillIconCard("Git", Icons.merge_type),
                _skillIconCard("MVVM", Icons.device_hub),
                _skillIconCard("Sprint", Icons.bolt),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _skillIconCard(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white.withOpacity(0.15),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
