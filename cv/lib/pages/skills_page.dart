import 'package:flutter/material.dart';
import 'package:cv/controller/firebase_controller.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final FirebaseController _controller = FirebaseController();
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  Future<void> _loadSkills() async {
    final skills = await _controller.getSkills();
    setState(() {
      _skills = skills;
      _swipeItems = skills.map((skill) {
        return SwipeItem(
          content: skill,
          likeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("👍 Liked $skill")),
            );
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("👎 Skipped $skill")),
            );
          },
        );
      }).toList();

      _matchEngine = MatchEngine(swipeItems: _swipeItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Skills"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _skills.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SwipeCards(
                    matchEngine: _matchEngine,
                    itemBuilder: (context, index) {
                      final skill = _skills[index];
                      return Card(
                        color: Colors.white.withOpacity(0.2), // Transparan kart
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 40),
                        child: Center(
                          child: Text(
                            skill,
                            style: const TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    onStackFinished: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("All skills swiped!")),
                      );
                    },
                    itemChanged: (item, index) {
                      debugPrint("Item changed: $item");
                    },
                    upSwipeAllowed: false,
                    fillSpace: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        radius: 28,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            _matchEngine.currentItem?.nope();
                          },
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 28,
                        child: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.white),
                          onPressed: () {
                            _matchEngine.currentItem?.like();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
