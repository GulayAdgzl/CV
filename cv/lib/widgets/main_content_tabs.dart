import 'package:cv/pages/contact/contact_page.dart';
import 'package:cv/pages/experience/experience_page.dart';
import 'package:cv/pages/generator/resume_generator_page.dart';
import 'package:cv/pages/profile/profile_page.dart';
import 'package:cv/pages/project/project_page.dart';

import 'package:cv/pages/skills/skills_page.dart';
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
        ContactPage(),
        SkillsPage(),
        ProjectPage(),
        ExperiencePage(),
        ResumeGeneratorPage(),
      ],
    );
  }
}
