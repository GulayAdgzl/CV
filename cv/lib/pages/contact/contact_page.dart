import 'package:cv/const/constant.dart';
import 'package:cv/controller/firebase_controller.dart';
import 'package:cv/core/gradient_theme_extension.dart';
import 'package:cv/pages/contact/contact_provider.dart';
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
  @override
  void initState() {
    super.initState();
    // Load contact data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactProvider>().loadContactInfo();
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
          child: Consumer<ContactProvider>(
            builder: (context, contactProvider, child) {
              if (contactProvider.isLoading) {
                return const CircularProgressIndicator();
              }

              if (contactProvider.error != null) {
                return _ErrorWidget(
                  error: contactProvider.error!,
                  onRetry: () => contactProvider.loadContactInfo(),
                );
              }

              if (contactProvider.aboutInfo == null) {
                return const Text(
                  'No contact information available',
                  style: TextStyle(color: Colors.white),
                );
              }

              return RefreshIndicator(
                onRefresh: () => contactProvider.refreshContactInfo(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ContactCard(contactProvider: contactProvider),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

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
            _SocialMediaRow(contactProvider: contactProvider),

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

class _SocialMediaRow extends StatelessWidget {
  final ContactProvider contactProvider;

  const _SocialMediaRow({required this.contactProvider});

  @override
  Widget build(BuildContext context) {
    final socialIcons = <Widget>[];

    if (contactProvider.linkedin != null) {
      socialIcons.add(
        SocialIcon(
          icon: FontAwesomeIcons.linkedin,
          url: contactProvider.linkedin!,
          label: 'LinkedIn',
        ),
      );
    }

    if (contactProvider.github != null) {
      socialIcons.add(
        SocialIcon(
          icon: FontAwesomeIcons.github,
          url: contactProvider.github!,
          label: 'GitHub',
        ),
      );
    }

    if (contactProvider.medium != null) {
      socialIcons.add(
        SocialIcon(
          icon: FontAwesomeIcons.medium,
          url: contactProvider.medium!,
          label: 'Medium',
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: socialIcons,
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
  final String label;

  const SocialIcon({
    super.key,
    required this.icon,
    required this.url,
    required this.label,
  });

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: FaIcon(icon, color: Colors.white, size: 22),
            onPressed: _launchUrl,
            tooltip: label,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.error_outline,
          size: 64,
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        const Text(
          'Error loading contact information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
