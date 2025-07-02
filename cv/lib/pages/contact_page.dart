import 'package:cv/const/constant.dart';
import 'package:cv/controller/firebase_controller.dart';
import 'package:cv/core/gradient_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Map<String, dynamic>? about;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAboutInfo();
  }

  Future<void> _fetchAboutInfo() async {
    final firebaseController =
        Provider.of<FirebaseController>(context, listen: false);
    final data = await firebaseController.getAboutInfo();
    if (!mounted) return;

    setState(() {
      about = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gradient =
        Theme.of(context).extension<GradientTheme>()?.backgroundGradient;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : (about == null
                  ? const Text(
                      'No contact information available',
                      style: TextStyle(color: Colors.white),
                    )
                  : ContactCard(about: about!)),
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final Map<String, dynamic> about;

  const ContactCard({super.key, required this.about});

  Future<void> _launchCvUrl() async {
    final Uri uri = Uri.parse(cvUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/pp.png"),
            ),
            const SizedBox(height: 16),
            Text(
              about['name'] ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              about['designation'] ?? '',
              style: const TextStyle(color: Colors.white70),
            ),
            const Divider(color: Colors.white38, height: 30),
            if (about['email'] != null)
              InfoTile(icon: Icons.email, text: about['email']),
            if (about['location'] != null)
              InfoTile(icon: Icons.location_on, text: about['location']),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (about['linkedin'] != null)
                  SocialIcon(
                      icon: FontAwesomeIcons.linkedin, url: about['linkedin']),
                if (about['github'] != null)
                  SocialIcon(
                      icon: FontAwesomeIcons.github, url: about['github']),
                if (about['medium'] != null)
                  SocialIcon(
                      icon: FontAwesomeIcons.medium, url: about['medium']),
              ],
            ),

            // QR kod alanı
            const SizedBox(height: 24),
            Text(
              "Scan QR to download my CV",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _launchCvUrl,
              child: Container(
                color: Colors.white, // dış arka plan
                padding: const EdgeInsets.all(8),
                child: QrImageView(
                  data: cvUrl,
                  version: QrVersions.auto,
                  size: 120.0,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
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

  Future<void> _launchUrl() async {
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
      tooltip: url,
    );
  }
}
