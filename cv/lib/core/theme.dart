// lib/core/theme.dart
import 'package:cv/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.navigationSelectionColor,
    background: AppColors.backgroundLight,
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  cardColor: AppColors.cardBGColor,
  iconTheme: const IconThemeData(color: AppColors.iconTint),
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
);
