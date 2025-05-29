import 'package:cv/controller/firebase_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

import 'package:flutter/material.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final FirebaseController _controller = FirebaseController();
  List<String> skills = [];

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  Future<void> _loadSkills() async {
    final snapshot = await _controller.getSkills();
    setState(() {
      skills = snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Skills"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: skills.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    skills.map((skill) => SkillChip(skill: skill)).toList(),
              ),
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String skill;

  const SkillChip({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(skill),
      backgroundColor: Colors.white10,
      labelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
