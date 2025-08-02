import 'package:cv/pages/skills/skills_provider.dart';
import 'package:cv/pages/skills/widgets/build_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildSwipeControls() {
  return Consumer<SkillsProvider>(
    builder: (context, provider, child) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildActionButton(
              icon: Icons.close,
              color: Colors.red.shade400,
              label: "Skip",
              onPressed: () {
                provider.matchEngine?.currentItem?.nope();
              },
            ),
            buildActionButton(
              icon: Icons.favorite,
              color: Colors.green.shade400,
              label: "Liked",
              onPressed: () {
                provider.matchEngine?.currentItem?.like();
              },
            ),
          ],
        ),
      );
    },
  );
}
