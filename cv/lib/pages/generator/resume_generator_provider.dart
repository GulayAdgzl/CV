import 'dart:convert';

import 'package:cv/const/constant.dart';
import 'package:cv/model/resume_generator_model.dart';
import 'package:cv/services/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ResumeGeneratorProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  ResumeGeneratorModel _state = const ResumeGeneratorModel();
  ResumeGeneratorModel get state => _state;

  // API key - Move to environment variables in production
  final String _geminiApiKey = AppConstants().geminiApiKey;

  void _updateState(ResumeGeneratorModel newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> generateResume() async {
    _updateState(_state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    try {
      // Fetch data from Firebase
      final aboutData = await _firebaseService.getAboutInfo();
      final skillsData = await _firebaseService.getSkills();

      if (aboutData == null) {
        throw Exception('About information not found');
      }

      // Process skills
      List<String> skillsList = [];
      for (var skill in skillsData) {
        if (skill['name'] != null) {
          skillsList.add(skill['name'].toString());
        }
      }

      final personalInfo = PersonalInfo.fromMap(aboutData, skillsList);

      // Generate content with Gemini
      final generatedText = await _generateWithGemini(personalInfo);

      _updateState(_state.copyWith(
        generatedText: generatedText,
        isLoading: false,
        lastGenerated: DateTime.now(),
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<String> _generateWithGemini(PersonalInfo personalInfo) async {
    final prompt = """
Write a professional, warm, and engaging self-introduction email for a job application. The email should be concise yet comprehensive, highlighting key qualifications and expressing genuine interest in opportunities.

Personal Information:
- Name: ${personalInfo.name}
- Professional Title: ${personalInfo.designation}
- Location: ${personalInfo.location}
- Email: ${personalInfo.email}
- GitHub: ${personalInfo.github}
- Technical Skills: ${personalInfo.skills.join(', ')}

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
              "https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$_geminiApiKey"),
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

    // Extract generated text from Gemini response
    if (result['candidates'] != null &&
        result['candidates'].isNotEmpty &&
        result['candidates'][0]['content'] != null &&
        result['candidates'][0]['content']['parts'] != null &&
        result['candidates'][0]['content']['parts'].isNotEmpty) {
      final text = result['candidates'][0]['content']['parts'][0]['text'];
      return text.trim();
    } else {
      throw Exception('Unexpected response format');
    }
  }

  void clearError() {
    if (_state.hasError) {
      _updateState(_state.copyWith(errorMessage: null));
    }
  }

  void clearContent() {
    _updateState(_state.copyWith(
      generatedText: null,
      errorMessage: null,
    ));
  }
}
