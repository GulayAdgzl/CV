import 'package:cv/pages/contact_page.dart';
import 'package:cv/pages/experience_page.dart';
import 'package:cv/pages/profile_page.dart';
import 'package:cv/pages/project_page.dart';
import 'package:cv/pages/resume_generator_page.dart';
import 'package:cv/pages/skills_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MainContentTabs extends StatelessWidget {
  final TabController controller;
  final DatabaseReference databaseRef;

  const MainContentTabs({
    super.key,
    required this.controller,
    required this.databaseRef,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: [
        ProfilePage(),
        ExperiencePage(),
        ProjectPage(),
        SkillsPage(),
        ContactPage(),
        ResumeGeneratorPage(),
      ],
    );
  }
}
