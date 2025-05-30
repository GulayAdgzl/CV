import 'package:cv/controller/firebase_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final FirebaseController _controller = FirebaseController();
  Map<String, dynamic>? about;

  @override
  void initState() {
    super.initState();
    _loadAboutInfo();
  }

  Future<void> _loadAboutInfo() async {
    final data = await _controller.getAboutInfo();
    setState(() {
      about = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (about == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Card(
          elevation: 10,
          color: Colors.white.withOpacity(0.1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      CachedNetworkImageProvider(about!['profile_image']),
                ),
                const SizedBox(height: 16),
                Text(
                  about!['name'],
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  about!['designation'],
                  style: const TextStyle(color: Colors.white70),
                ),
                const Divider(color: Colors.white38, height: 30),
                InfoTile(icon: Icons.email, text: about!['email']),
                InfoTile(icon: Icons.location_on, text: about!['location']),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialIcon(
                        icon: FontAwesomeIcons.linkedin,
                        url: about!['linkedin']),
                    SocialIcon(
                        icon: FontAwesomeIcons.github, url: about!['github']),
                    SocialIcon(
                        icon: FontAwesomeIcons.medium, url: about!['medium']),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const SocialIcon({super.key, required this.icon, required this.url});

  void _launchUrl() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(icon, color: Colors.white),
      onPressed: _launchUrl,
    );
  }
}
