import 'package:cv/core/gradient_theme_extension.dart';
import 'package:cv/pages/skills/widgets/build_progress_indicator.dart';
import 'package:cv/pages/skills/widgets/build_skill_card.dart';

import 'package:cv/pages/skills/widgets/build_swipe_controls.dart';
import 'package:flutter/material.dart';
import 'package:cv/controller/firebase_controller.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> with TickerProviderStateMixin {
  late MatchEngine _matchEngine;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<SwipeItem> swipeItems = [];
  List<String> skills = [];
  List<String> likedSkills = [];
  bool isLoading = true;
  int currentIndex = 0;

  // Gradient renkleri - GradientTheme null hatası için fallback
  final List<Color> _gradientColors = [
    const Color(0xFF667eea),
    const Color(0xFF764ba2),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadSkills();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSkills() async {
    try {
      final firebaseController =
          Provider.of<FirebaseController>(context, listen: false);
      final skill = await firebaseController.getSkills();

      swipeItems = skill.map((skill) {
        return SwipeItem(
          content: skill,
          likeAction: () => _onSkillLiked(skill),
          nopeAction: () => _onSkillSkipped(skill),
        );
      }).toList();

      if (mounted) {
        setState(() {
          skills = skill;
          _matchEngine = MatchEngine(swipeItems: swipeItems);
          isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showSnackBar("Hata: Beceriler yüklenemedi", isError: true);
      }
    }
  }

  void _onSkillLiked(String skill) {
    setState(() {
      likedSkills.add(skill);
      currentIndex++;
    });
    _showSnackBar("✨ $skill skills liked!", isError: false);
  }

  void _onSkillSkipped(String skill) {
    setState(() {
      currentIndex++;
    });
    _showSnackBar("⏭️ $skill skip", isError: false);
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 16),
          Text(
            "Beceriler yükleniyor...",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 80,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            "Henüz beceri bulunamadı",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Yeni beceriler eklendiğinde burada görünecek",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.celebration,
            size: 80,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          Text(
            "Tebrikler! 🎉",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tüm becerileri gözden geçirdin",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${likedSkills.length} beceriyi beğendin",
            style: TextStyle(
              color: Colors.green.shade300,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _loadSkills(),
            icon: const Icon(Icons.refresh),
            label: const Text("Yeniden Başla"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSkillSwipeContent() {
    return Column(
      children: [
        buildProgressIndicator(),
        Expanded(
          child: SwipeCards(
            matchEngine: _matchEngine,
            itemBuilder: (context, index) => buildSkillCard(skills[index]),
            onStackFinished: () {
              setState(() {
                currentIndex = skills.length;
              });
            },
            itemChanged: (item, index) {
              setState(() {
                currentIndex = index;
              });
            },
            upSwipeAllowed: false,
            fillSpace: true,
          ),
        ),
        buildSwipeControls(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Güvenli gradient alma - null hatası önlenir
    final gradient =
        Theme.of(context).extension<GradientTheme>()?.backgroundGradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _gradientColors,
            );

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Skills",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: isLoading
                ? _buildLoading()
                : skills.isEmpty
                    ? _buildEmptyState()
                    : currentIndex >= skills.length
                        ? _buildCompletedState()
                        : buildSkillSwipeContent(),
          ),
        ),
      ),
    );
  }
}
