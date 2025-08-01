import 'package:cv/pages/experience/experience_provider.dart';
import 'package:cv/pages/project/project_provider.dart';
import 'package:cv/pages/skills/skills_provider.dart';
import 'package:cv/services/firebase_controller.dart';
import 'package:cv/firebase/firebase_init.dart';
import 'package:cv/pages/contact/contact_provider.dart';
import 'package:cv/pages/generator/resume_generator_provider.dart';
import 'package:cv/pages/profile/profile_provider.dart';
import 'package:cv/pages/views/home_page.dart';
import 'package:cv/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'providers/navigation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        // Navigation Provider
        ChangeNotifierProvider(create: (_) => NavigationProvider()),

        // Firebase Services - Önce FirebaseService'i tanımlayın
        Provider<FirebaseController>(create: (_) => FirebaseController()),
        Provider<FirebaseService>(
          create: (_) => FirebaseService(),
          lazy: false, // Hemen oluştur
        ),

        // Contact Provider
        ChangeNotifierProvider(
          create: (_) => ContactProvider(FirebaseService()),
        ),

        // Profile Provider
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(FirebaseService()),
        ),

        // Skills Provider - FirebaseService'e bağlı
        ChangeNotifierProxyProvider<FirebaseService, SkillsProvider>(
          create: (context) => SkillsProvider(
            Provider.of<FirebaseService>(context, listen: false),
          ),
          update: (context, firebaseService, previous) =>
              previous ?? SkillsProvider(firebaseService),
        ),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => ExperienceProvider()),
        ChangeNotifierProvider(create: (_) => ResumeGeneratorProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HomePage(),
    );
  }
}
