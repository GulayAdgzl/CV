import 'package:flutter/material.dart';

Widget buildSkillCard(String skill) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    height: 400,
    width: 400, // Sabit yükseklik
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.25),
          Colors.white.withOpacity(0.1),
        ],
      ),
      border: Border.all(
        color: Colors.white.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Skill ikonu
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              getSkillIcon(skill),
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          // Skill adı - Flexible ile sarıldı
          Flexible(
            child: Text(
              skill,
              textAlign: TextAlign.center,
              maxLines: 3, // Maksimum 3 satır
              overflow: TextOverflow.ellipsis, // Taşarsa ... göster
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    ),
  );
}

IconData getSkillIcon(String skill) {
  // Skill adına göre ikon döndür
  final skillLower = skill.toLowerCase();
  if (skillLower.contains('flutter') || skillLower.contains('mobile')) {
    return Icons.phone_android;
  } else if (skillLower.contains('web') || skillLower.contains('html')) {
    return Icons.web;
  } else if (skillLower.contains('database') || skillLower.contains('sql')) {
    return Icons.storage;
  } else if (skillLower.contains('ai') || skillLower.contains('machine')) {
    return Icons.psychology;
  } else if (skillLower.contains('design') || skillLower.contains('ui')) {
    return Icons.design_services;
  } else {
    return Icons.lightbulb_outline;
  }
}
