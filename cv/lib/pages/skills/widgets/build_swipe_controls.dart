import 'package:cv/pages/skills/widgets/build_action_button.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

late MatchEngine _matchEngine;
Widget buildSwipeControls() {
  return Container(
    padding: const EdgeInsets.all(24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Skip butonu
        buildActionButton(
          icon: Icons.close,
          color: Colors.red.shade400,
          label: "Skip",
          onPressed: () {
            _matchEngine.currentItem?.nope();
          },
        ),

        // Like butonu
        buildActionButton(
          icon: Icons.favorite,
          color: Colors.green.shade400,
          label: "Liked",
          onPressed: () {
            _matchEngine.currentItem?.like();
          },
        ),
      ],
    ),
  );
}
