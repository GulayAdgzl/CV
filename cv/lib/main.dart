import 'package:cv/core/theme.dart';
import 'package:cv/firebase/firebase_init.dart';
import 'package:cv/pages/views/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: HomePage(),
    );
  }
}
