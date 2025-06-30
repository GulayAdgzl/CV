// lib/core/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  scaffoldBackgroundColor: Colors.white,
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    headlineSmall: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.indigo,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      color: Colors.black87,
    ),
  ),
);
