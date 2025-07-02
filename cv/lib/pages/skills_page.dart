import 'package:flutter/material.dart';
import 'package:cv/controller/firebase_controller.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  late MatchEngine _matchEngine;

  List<SwipeItem> _swipeItems = [];
  List<String> _skills = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  Future<void> _loadSkills() async {
    final firebaseController =
        Provider.of<FirebaseController>(context, listen: false);
    final skills = await firebaseController.getSkills();

    _swipeItems = skills.map((skill) {
      return SwipeItem(
        content: skill,
        likeAction: () => _showSnackBar("👍 Liked $skill"),
        nopeAction: () => _showSnackBar("👎 Skipped $skill"),
      );
    }).toList();

    setState(() {
      _skills = skills;
      _matchEngine = MatchEngine(swipeItems: _swipeItems);
      _isLoading = false;
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSkillCard(String skill) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Center(
        child: Text(
          skill,
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeControls() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircleButton(Icons.close, Colors.redAccent, () {
            _matchEngine.currentItem?.nope();
          }),
          _buildCircleButton(Icons.favorite, Colors.green, () {
            _matchEngine.currentItem?.like();
          }),
        ],
      ),
    );
  }

  Widget _buildCircleButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 28,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  Widget _buildEmptyState() => const Center(
        child: Text("No skills found.", style: TextStyle(color: Colors.white)),
      );

  Widget _buildSkillSwipeContent() {
    return Column(
      children: [
        Expanded(
          child: SwipeCards(
            matchEngine: _matchEngine,
            itemBuilder: (context, index) => _buildSkillCard(_skills[index]),
            onStackFinished: () => _showSnackBar("All skills swiped!"),
            itemChanged: (item, index) {
              debugPrint("Item changed: $item");
            },
            upSwipeAllowed: false,
            fillSpace: true,
          ),
        ),
        _buildSwipeControls(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Skills"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? _buildLoading()
          : _skills.isEmpty
              ? _buildEmptyState()
              : _buildSkillSwipeContent(),
    );
  }
}
