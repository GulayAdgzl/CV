import 'package:cv/const/constant.dart';
import 'package:cv/pages/contact/contact_provider.dart';
import 'package:cv/pages/contact/info/info_tile.dart';
import 'package:cv/pages/contact/socialMediaRow/social_media_row.dart';
import 'package:cv/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  final ContactProvider contactProvider;

  const ContactCard({super.key, required this.contactProvider});

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
      color: AppColors.mints,
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

            // Name
            Text(
              contactProvider.name ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Designation
            Text(
              contactProvider.designation ?? '',
              style: const TextStyle(color: Colors.white70),
            ),

            const Divider(color: Colors.white38, height: 30),

            // Contact information
            if (contactProvider.email != null)
              InfoTile(
                icon: Icons.email,
                text: contactProvider.email!,
              ),

            if (contactProvider.location != null)
              InfoTile(
                icon: Icons.location_on,
                text: contactProvider.location!,
              ),

            const SizedBox(height: 12),

            // Social media icons
            SocialMediaRow(contactProvider: contactProvider),

            // QR code section
            const SizedBox(height: 24),
            const Text(
              "Scan QR to download my CV",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: _launchCvUrl,
              child: Container(
                color: Colors.white,
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
