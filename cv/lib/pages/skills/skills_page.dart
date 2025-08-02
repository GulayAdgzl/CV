import 'package:cv/pages/skills/skills_provider.dart';
import 'package:cv/pages/skills/widgets/build_progress_indicator.dart';
import 'package:cv/pages/skills/widgets/build_swipe_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

    // Provider'dan becerileri yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final provider = Provider.of<SkillsProvider>(context, listen: false);

        // Callback'leri ayarla
        provider.setCallbacks(
          onSkillLiked: (skill) =>
              _showSnackBar("✨ ${skill.name} beğenildi!", isError: false),
          onSkillSkipped: (skill) =>
              _showSnackBar("⏭️ ${skill.name} atlandı", isError: false),
        );

        provider.loadSkills().then((_) {
          if (mounted) {
            _animationController.forward();
            // Başarı mesajı göster
            if (!provider.isEmpty) {
              _showSnackBar("✨ ${provider.totalSkills} beceri yüklendi!",
                  isError: false);
            }
          }
        }).catchError((error) {
          if (mounted) {
            _showSnackBar("Hata: Beceriler yüklenemedi", isError: true);
          }
        });
      } catch (e) {
        // Provider bulunamazsa fallback
        if (mounted) {
          _showSnackBar("Provider hatası: ${e.toString()}", isError: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    return Consumer<SkillsProvider>(
      builder: (context, provider, child) {
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
                "${provider.likedCount} beceriyi beğendin",
                style: TextStyle(
                  color: Colors.green.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => provider.reset(),
                icon: const Icon(Icons.refresh),
                label: const Text("Yeniden Başla"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSkillCard(String skill) {
    return Consumer<SkillsProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          height: 400,
          width: 400,
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    provider.getSkillIcon(skill),
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Flexible(
                  child: Text(
                    skill,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
      },
    );
  }

  Widget buildSkillSwipeContent() {
    return Consumer<SkillsProvider>(
      builder: (context, provider, child) {
        if (provider.matchEngine == null) {
          return _buildLoading();
        }

        return Column(
          children: [
            buildProgressIndicator(),
            Expanded(
              child: SwipeCards(
                matchEngine: provider.matchEngine!,
                itemBuilder: (context, index) =>
                    buildSkillCard(provider.getCurrentSkillName(index)),
                onStackFinished: () => provider.onStackFinished(),
                itemChanged: (item, index) =>
                    provider.updateCurrentIndex(index),
                upSwipeAllowed: false,
                fillSpace: true,
              ),
            ),
            buildSwipeControls(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color.fromARGB(255, 217, 208, 219),
        const Color.fromARGB(255, 217, 208, 219),
      ],
    );

    return Scaffold(
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
            child: Consumer<SkillsProvider>(
              builder: (context, provider, child) {
                // Error handling
                if (provider.errorMessage != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showSnackBar(provider.errorMessage!, isError: true);
                  });
                }

                // UI state management
                if (provider.isLoading) {
                  return _buildLoading();
                } else if (provider.isEmpty) {
                  return _buildEmptyState();
                } else if (provider.isCompleted) {
                  return _buildCompletedState();
                } else {
                  return buildSkillSwipeContent();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
