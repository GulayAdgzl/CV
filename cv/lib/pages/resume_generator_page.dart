import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

class ResumeGeneratorPage extends StatefulWidget {
  const ResumeGeneratorPage({super.key});

  @override
  State<ResumeGeneratorPage> createState() => _ResumeGeneratorPageState();
}

class _ResumeGeneratorPageState extends State<ResumeGeneratorPage> {
  final DatabaseReference _aboutRef =
      FirebaseDatabase.instance.ref().child("Portfolio/about_us");
  final DatabaseReference _skillsRef =
      FirebaseDatabase.instance.ref().child("Portfolio/skills");

  String? _generatedText;
  bool _loading = false;

  final String openAiKey =
      "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"; // Insert your OpenAI API key here

  Future<void> _generateWithGPT() async {
    setState(() => _loading = true);

    final aboutSnap = await _aboutRef.get();
    final skillsSnap = await _skillsRef.get();

    final about = aboutSnap.value as Map?;
    final skills = (skillsSnap.value as Map?)?.keys.join(', ');

    if (about == null) return;

    final name = about['name'];
    final title = about['designation'];
    final location = about['location'];
    final email = about['email'];
    final github = about['github'];

    final prompt = """
Write a short, warm, and professional self-introduction email for a job application.

Name: $name
Title: $title
Location: $location
Email: $email
GitHub: $github
Skills: $skills
""";

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $openAiKey"
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a helpful assistant that writes application emails."
          },
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 300,
        "temperature": 0.7
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final text = result["choices"][0]["message"]["content"];
      setState(() {
        _generatedText = text.trim();
        _loading = false;
      });
    } else {
      setState(() {
        _generatedText = "Error: ${response.body}";
        _loading = false;
      });
    }
  }

  void sendEmail(String content) async {
    final subject = Uri.encodeComponent(
        "Mobile Developer Application – ${DateTime.now().year}");
    final body = Uri.encodeComponent(content);
    final uri = Uri.parse("mailto:?subject=$subject&body=$body");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("Could not open email client");
    }
  }

  @override
  void initState() {
    super.initState();
    _generateWithGPT();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      appBar: AppBar(
        title: const Text("AI Introduction Letter"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Card(
                        color: Colors.white10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _generatedText ?? "Failed to generate content.",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.copy),
                          label: const Text("Copy"),
                          onPressed: () {
                            if (_generatedText != null) {
                              Clipboard.setData(
                                  ClipboardData(text: _generatedText!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Copied to clipboard.")),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.share),
                          label: const Text("Share"),
                          onPressed: () {
                            if (_generatedText != null) {
                              Share.share(_generatedText!);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.email),
                          label: const Text("Send as Email"),
                          onPressed: () {
                            if (_generatedText != null) {
                              sendEmail(_generatedText!);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: _generateWithGPT,
                        icon: const Icon(Icons.refresh),
                        tooltip: "Regenerate",
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
