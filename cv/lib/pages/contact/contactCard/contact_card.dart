import 'package:cv/const/constant.dart';
import 'package:cv/model/contact_model.dart';
import 'package:cv/pages/contact/contact_provider.dart';
import 'package:cv/pages/contact/info/info_tile.dart';
import 'package:cv/pages/contact/socialMediaRow/social_media_row.dart';
import 'package:cv/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  final ContactModel contactInfo;
  final ContactProvider?
      contactProvider; // Optional - for backward compatibility
  final Function(ContactModel)? onUpdate; // Callback for updates
  final String? cvUrl; // Make it configurable

  const ContactCard({
    super.key,
    required this.contactInfo,
    this.contactProvider,
    this.onUpdate,
    this.cvUrl,
  });

  Future<void> _launchCvUrl() async {
    final String url = cvUrl ?? AppConstants.defaultCvUrl ?? '';
    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _launchEmail() async {
    final email = contactInfo.email;
    if (email != null && email.isNotEmpty) {
      final Uri uri = Uri.parse('mailto:$email');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  Future<void> _launchPhone() async {
    final phone = contactInfo.phone;
    if (phone != null && phone.isNotEmpty) {
      final Uri uri = Uri.parse('tel:$phone');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
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
        constraints: const BoxConstraints(maxWidth: 400), // Responsive width
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 16),
            _buildContactInfo(),
            if (_shouldShowQrCode()) ...[
              const SizedBox(height: 24),
              _buildQrCodeSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        // Profile Image
        CircleAvatar(
          radius: 50,
          backgroundImage: contactInfo.profileImage != null &&
                  contactInfo.profileImage!.isNotEmpty
              ? NetworkImage(contactInfo.profileImage!)
              : const AssetImage("assets/pp.png") as ImageProvider,
          onBackgroundImageError: (exception, stackTrace) {
            // Fallback to default image if network image fails
          },
        ),
        const SizedBox(height: 16),

        // Name
        Text(
          contactInfo.name ?? 'No Name',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),

        // Designation
        if (contactInfo.designation != null &&
            contactInfo.designation!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              contactInfo.designation!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        // Bio (if available)
        if (contactInfo.bio != null && contactInfo.bio!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              contactInfo.bio!,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildContactInfo() {
    final List<Widget> contactWidgets = [];

    // Add divider if we have contact info
    if (_hasContactInfo()) {
      contactWidgets.add(
        const Divider(color: Colors.white38, height: 30),
      );
    }

    // Email
    if (contactInfo.email != null && contactInfo.email!.isNotEmpty) {
      contactWidgets.add(
        InfoTile(
          icon: Icons.email,
          text: contactInfo.email!,
          onTap: _launchEmail,
        ),
      );
    }

    // Location
    if (contactInfo.location != null && contactInfo.location!.isNotEmpty) {
      contactWidgets.add(
        InfoTile(
          icon: Icons.location_on,
          text: contactInfo.location!,
        ),
      );
    }

    // Social media
    if (contactInfo.socialMedia != null) {
      contactWidgets.add(const SizedBox(height: 12));
      contactWidgets.add(
        SocialMediaRow(
          socialMedia: contactInfo.socialMedia!,
          contactProvider: contactProvider, // For backward compatibility
        ),
      );
    }

    return Column(children: contactWidgets);
  }

  Widget _buildQrCodeSection() {
    final String url = cvUrl ?? AppConstants.defaultCvUrl ?? '';

    if (url.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const Text(
          "Scan QR to download my CV",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _launchCvUrl,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: QrImageView(
              data: url,
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
              errorCorrectionLevel: QrErrorCorrectLevel.M,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Tap to open CV",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  bool _hasContactInfo() {
    return (contactInfo.email?.isNotEmpty ?? false) ||
        (contactInfo.phone?.isNotEmpty ?? false) ||
        (contactInfo.location?.isNotEmpty ?? false);
  }

  bool _shouldShowQrCode() {
    final url = cvUrl ?? AppConstants.defaultCvUrl ?? '';
    return url.isNotEmpty;
  }
}
