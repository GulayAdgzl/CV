import 'package:cv/controller/firebase_controller.dart';
import 'package:cv/core/theme.dart';
import 'package:cv/firebase/firebase_init.dart';
import 'package:cv/pages/views/home_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'providers/navigation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        Provider(create: (_) => FirebaseController()),
      ],
      child: const MyApp(),
    ),
  );
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
