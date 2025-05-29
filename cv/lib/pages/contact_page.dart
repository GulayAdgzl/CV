import 'package:cv/controller/firebase_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final FirebaseController _controller = FirebaseController();
  Map<String, dynamic>? aboutData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _controller.getAboutInfo();
    setState(() {
      aboutData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (aboutData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    CachedNetworkImageProvider(aboutData!['profile_image']),
              ),
              const SizedBox(height: 16),
              Text(
                aboutData!['name'],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                aboutData!['designation'],
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                aboutData!['description'],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              InfoCard(icon: Icons.email, text: aboutData!['email']),
              InfoCard(icon: Icons.phone, text: aboutData!['phone']),
              InfoCard(icon: Icons.location_on, text: aboutData!['location']),
              SocialCard(
                icon: FontAwesomeIcons.github,
                label: "GitHub",
                url: aboutData!['github'],
              ),
              SocialCard(
                icon: FontAwesomeIcons.linkedin,
                label: "LinkedIn",
                url: aboutData!['linkedin'],
              ),
              SocialCard(
                icon: FontAwesomeIcons.medium,
                label: "Medium",
                url: aboutData!['medium'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoCard({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white12,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class SocialCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const SocialCard(
      {super.key, required this.icon, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(label, style: const TextStyle(color: Colors.white)),
        subtitle: Text(url, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}
