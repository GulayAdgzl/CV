import 'package:flutter/material.dart';

String? _generatedText;
Widget buildActionButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
  required Color color,
}) {
  return ElevatedButton.icon(
    onPressed: _generatedText != null ? onPressed : null,
    icon: Icon(icon, size: 18),
    label: Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w500),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.grey.shade700,
      disabledForegroundColor: Colors.grey.shade500,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
  );
}
