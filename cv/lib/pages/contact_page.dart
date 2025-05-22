import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE2E6FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatarlar
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 10,
                      right: 0,
                      child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/pp.png')),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text("Contact Me",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () =>
                      _launchURL("https://linkedin.com/in/gülay-adıgüzel"),
                  child: Text("View team",
                      style: TextStyle(decoration: TextDecoration.underline)),
                ),
                SizedBox(height: 24),

                // İkonlar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _iconButton(
                        Icons.phone, () => _launchURL("tel:+905551112233")),
                    _iconButton(
                        Icons.message, () => _launchURL("sms:+905551112233")),
                    _iconButton(
                        Icons.video_call, () => _launchURL("https://zoom.us")),
                    _iconButton(Icons.email,
                        () => _launchURL("mailto:glyadgzl@hotmail.com")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 28, color: Colors.black87),
      ),
    );
  }
}
