import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

List<SwipeItem> swipeItems = [];
List<String> skills = [];
List<String> likedSkills = [];
bool isLoading = true;
int currentIndex = 0;
Widget buildProgressIndicator() {
  if (skills.isEmpty) return const SizedBox.shrink();

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${currentIndex + 1} / ${skills.length}",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${likedSkills.length} liked",
              style: TextStyle(
                color: Colors.green.shade300,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: skills.isNotEmpty ? (currentIndex + 1) / skills.length : 0,
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor:
              AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
        ),
      ],
    ),
  );
}
