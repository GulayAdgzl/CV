// lib/core/theme.dart
import 'package:cv/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'gradient_theme_extension.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.navigationSelectionColor,
    background: AppColors.backgroundLight,
  ),
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    headlineSmall: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.navigationSelectionColor,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      color: Colors.black87,
    ),
  ),
  extensions: const <ThemeExtension<dynamic>>[
    GradientTheme(
      backgroundGradient: LinearGradient(
        colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  ],
);
