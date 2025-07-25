import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResumeGeneratorProvider extends ChangeNotifier {
  String? _generatedText;
  bool _isLoading = false;
  String? _error;

  // User data from Firebase
  Map<String, dynamic>? _aboutData;
  String? _skillsData;

  // Getters
  String? get generatedText => _generatedText;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get aboutData => _aboutData;
  String? get skillsData => _skillsData;

  // Firebase references
  final DatabaseReference _aboutRef =
      FirebaseDatabase.instance.ref().child("Portfolio/about_us");
  final DatabaseReference _skillsRef =
      FirebaseDatabase.instance.ref().child("Portfolio/skills");

  // API key - Move to secure location in production
  final String geminiApiKey = "AIzaSyAKLVjH5raLPJa7FUiDhLQ1wicxDLfjUuA";

  // Load user data from Firebase
  Future<void> loadUserData() async {
    try {
      _setLoading(true);
      _error = null;

      final aboutSnap = await _aboutRef.get();
      final skillsSnap = await _skillsRef.get();

      _aboutData = aboutSnap.value as Map<String, dynamic>?;
      final skillsRaw = skillsSnap.value;

      // Process skills data
      if (skillsRaw != null) {
        if (skillsRaw is List) {
          _skillsData = skillsRaw.join(', ');
        } else if (skillsRaw is Map) {
          _skillsData = skillsRaw.keys.join(', ');
        }
      }

      notifyListeners();
    } catch (e) {
      _error = 'Failed to load user data: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Generate introduction letter with Gemini AI
  Future<void> generateIntroductionLetter() async {
    if (_aboutData == null) {
      await loadUserData();
    }

    if (_aboutData == null) {
      _error = 'No user data available';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _error = null;
    _generatedText = null;

    try {
      final name = _aboutData!['name'] ?? 'Unknown';
      final title = _aboutData!['designation'] ?? 'Developer';
      final location = _aboutData!['location'] ?? 'Unknown Location';
      final email = _aboutData!['email'] ?? '';
      final github = _aboutData!['github'] ?? '';
      final skills = _skillsData ?? '';

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

      final generatedText = await _callGeminiAPI(prompt);
      _generatedText = generatedText;
    } catch (e) {
      _error = e.toString();
      _generatedText =
          "Failed to generate content. Error: $e\n\nPlease check your internet connection and API key.\n\nTip: Make sure your API key has access to Gemini models.";
    } finally {
      _setLoading(false);
    }
  }

  // Call Gemini API with fallback models
  Future<String> _callGeminiAPI(String prompt) async {
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
          headers: {"Content-Type": "application/json"},
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
            break; // If it's not a "model not found" error, don't try other models
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

    // Extract generated text from Gemini response
    if (result['candidates'] != null &&
        result['candidates'].isNotEmpty &&
        result['candidates'][0]['content'] != null &&
        result['candidates'][0]['content']['parts'] != null &&
        result['candidates'][0]['content']['parts'].isNotEmpty) {
      return result['candidates'][0]['content']['parts'][0]['text'].trim();
    } else {
      throw Exception('Unexpected response format');
    }
  }

  // Regenerate content
  Future<void> regenerate() async {
    await generateIntroductionLetter();
  }

  // Refresh all data
  Future<void> refresh() async {
    _generatedText = null;
    _aboutData = null;
    _skillsData = null;
    await loadUserData();
    await generateIntroductionLetter();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Update generated text (for editing purposes)
  void updateGeneratedText(String newText) {
    _generatedText = newText;
    notifyListeners();
  }
}
