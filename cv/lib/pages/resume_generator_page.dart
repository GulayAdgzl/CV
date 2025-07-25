import 'package:cv/pages/generator/resume_generator_provider.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

class ResumeGeneratorPage extends StatefulWidget {
  const ResumeGeneratorPage({super.key});

  @override
  State<ResumeGeneratorPage> createState() => _ResumeGeneratorPageState();
}

class _ResumeGeneratorPageState extends State<ResumeGeneratorPage>
    with TickerProviderStateMixin {
  final DatabaseReference _aboutRef =
      FirebaseDatabase.instance.ref().child("Portfolio/about_us");
  final DatabaseReference _skillsRef =
      FirebaseDatabase.instance.ref().child("Portfolio/skills");

  String? _generatedText;
  bool _loading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Move API key to a secure location or environment variables in production
  final String geminiApiKey = "AIzaSyAKLVjH5raLPJa7FUiDhLQ1wicxDLfjUuA";

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
    _generateWithGemini();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _generateWithGemini() async {
    setState(() {
      _loading = true;
      _generatedText = null;
    });

    try {
      final aboutSnap = await _aboutRef.get();
      final skillsSnap = await _skillsRef.get();

      final about = aboutSnap.value as Map?;
      final skillsData = skillsSnap.value;
      String skills = '';

      // Process skills data
      if (skillsData != null) {
        if (skillsData is List) {
          skills = skillsData.join(', ');
        } else if (skillsData is Map) {
          skills = skillsData.keys.join(', ');
        }
      }

      if (about == null) {
        throw Exception('About information not found');
      }

      final name = about['name'] ?? 'Unknown';
      final title = about['designation'] ?? 'Developer';
      final location = about['location'] ?? 'Unknown Location';
      final email = about['email'] ?? '';
      final github = about['github'] ?? '';

      final prompt = """
Write a professional, warm, and engaging self-introduction email for a job application. The email should be concise yet comprehensive, highlighting key qualifications and expressing genuine interest in opportunities.

Personal Information:
- Name: $name
- Professional Title: $title
- Location: $location
- Email: $email
- GitHub: $github
- Technical Skills: $skills

Please format it as a complete email with proper greeting, body paragraphs, and professional closing. Make it personable but professional, and ensure it showcases both technical expertise and soft skills.
""";

      // Try different model names in order of preference
      final modelNames = [
        'gemini-1.5-flash',
        'gemini-1.5-pro',
        'gemini-2.0-flash-experimental',
        'gemini-pro'
      ];

      http.Response? response;
      String? lastError;

      for (String modelName in modelNames) {
        try {
          response = await http.post(
            Uri.parse(
                "https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$geminiApiKey"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "contents": [
                {
                  "parts": [
                    {"text": prompt}
                  ]
                }
              ],
              "generationConfig": {
                "temperature": 0.7,
                "topK": 40,
                "topP": 0.95,
                "maxOutputTokens": 1024,
              }
            }),
          );

          if (response.statusCode == 200) {
            break; // Success, exit the loop
          } else {
            final errorBody = jsonDecode(response.body);
            lastError = '${errorBody['error']['message']}';
            if (response.statusCode != 404) {
              // If it's not a "model not found" error, don't try other models
              break;
            }
          }
        } catch (e) {
          lastError = e.toString();
          continue; // Try next model
        }
      }

      if (response == null || response.statusCode != 200) {
        throw Exception('All models failed. Last error: $lastError');
      }

      final result = jsonDecode(response.body);

      // Correct path to extract generated text from Gemini response
      if (result['candidates'] != null &&
          result['candidates'].isNotEmpty &&
          result['candidates'][0]['content'] != null &&
          result['candidates'][0]['content']['parts'] != null &&
          result['candidates'][0]['content']['parts'].isNotEmpty) {
        final text = result['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _generatedText = text.trim();
          _loading = false;
        });
        _animationController.forward();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      setState(() {
        _generatedText =
            "Failed to generate content. Error: $e\n\nPlease check your internet connection and API key.\n\nTip: Make sure your API key has access to Gemini models.";
        _loading = false;
      });
      _animationController.forward();

      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Generation failed: ${e.toString()}"),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void sendEmail(String content) async {
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

  void _copyToClipboard() {
    if (_generatedText != null) {
      Clipboard.setData(ClipboardData(text: _generatedText!));
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
  }

  void _shareContent() {
    if (_generatedText != null) {
      Share.share(
        _generatedText!,
        subject: "AI Generated Introduction Letter",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          "AI Introduction Letter",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loading ? null : _generateWithGemini,
            icon: AnimatedRotation(
              turns: _loading ? 1 : 0,
              duration: const Duration(seconds: 1),
              child: const Icon(Icons.refresh),
            ),
            tooltip: "Regenerate",
          ),
        ],
      ),
      body: _loading
          ? const Center(
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
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF1E293B),
                              const Color(0xFF334155),
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
                            _generatedText ?? "Failed to generate content.",
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildActionButton(
                          icon: Icons.copy_rounded,
                          label: "Copy",
                          onPressed: _copyToClipboard,
                          color: Colors.blue,
                        ),
                        _buildActionButton(
                          icon: Icons.share_rounded,
                          label: "Share",
                          onPressed: _shareContent,
                          color: Colors.green,
                        ),
                        _buildActionButton(
                          icon: Icons.email_rounded,
                          label: "Email",
                          onPressed: () {
                            if (_generatedText != null) {
                              sendEmail(_generatedText!);
                            }
                          },
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildActionButton({
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
}
