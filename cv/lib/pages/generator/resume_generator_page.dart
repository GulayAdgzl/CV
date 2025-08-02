import 'package:cv/pages/generator/resume_generator_provider.dart';
import 'package:cv/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';

class ResumeGeneratorPage extends StatefulWidget {
  const ResumeGeneratorPage({super.key});

  @override
  State<ResumeGeneratorPage> createState() => _ResumeGeneratorPageState();
}

class _ResumeGeneratorPageState extends State<ResumeGeneratorPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Auto-generate on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResumeGeneratorProvider>().generateResume();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleGeneration() {
    context.read<ResumeGeneratorProvider>().generateResume();
  }

  void _sendEmail(String content) async {
    try {
      final subject = Uri.encodeComponent(
          "Mobile Developer Application – ${DateTime.now().year}");
      final body = Uri.encodeComponent(content);
      final uri = Uri.parse("mailto:?subject=$subject&body=$body");

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception("Could not open email client");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not open email client: $e"),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text("Copied to clipboard!"),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareContent(String text) {
    Share.share(
      text,
      subject: "AI Generated Introduction Letter",
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mints,
      appBar: AppBar(
        title: const Text(
          "AI Introduction Letter",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.mints,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Consumer<ResumeGeneratorProvider>(
            builder: (context, provider, child) {
              return IconButton(
                onPressed: provider.state.isLoading ? null : _handleGeneration,
                icon: AnimatedRotation(
                  turns: provider.state.isLoading ? 1 : 0,
                  duration: const Duration(seconds: 1),
                  child: const Icon(Icons.refresh),
                ),
                tooltip: "Regenerate",
              );
            },
          ),
        ],
      ),
      body: Consumer<ResumeGeneratorProvider>(
        builder: (context, provider, child) {
          // Listen to state changes for animations
          if (provider.state.hasContent && !provider.state.isLoading) {
            _animationController.forward();
          } else {
            _animationController.reset();
          }

          // Show error snackbar if there's an error
          if (provider.state.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text("Generation failed: ${provider.state.errorMessage}"),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 4),
                ),
              );
              provider.clearError();
            });
          }

          if (provider.state.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Generating your introduction letter...",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1E293B),
                            Color(0xFF334155),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: SelectableText(
                          provider.state.generatedText ??
                              (provider.state.hasError
                                  ? "Failed to generate content. ${provider.state.errorMessage}"
                                  : "No content generated yet."),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.6,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (provider.state.hasContent)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildActionButton(
                          icon: Icons.copy_rounded,
                          label: "Copy",
                          onPressed: () =>
                              _copyToClipboard(provider.state.generatedText!),
                          color: Colors.blue,
                        ),
                        _buildActionButton(
                          icon: Icons.share_rounded,
                          label: "Share",
                          onPressed: () =>
                              _shareContent(provider.state.generatedText!),
                          color: Colors.green,
                        ),
                        _buildActionButton(
                          icon: Icons.email_rounded,
                          label: "Email",
                          onPressed: () =>
                              _sendEmail(provider.state.generatedText!),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
