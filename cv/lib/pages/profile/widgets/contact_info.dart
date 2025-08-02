import 'package:cv/model/profile_model.dart';
import 'package:cv/pages/profile/widgets/contact_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfo extends StatelessWidget {
  final ProfileModel? profile;

  const ContactInfo({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (profile?.email != null)
          ContactItem(
            icon: Icons.email_outlined,
            text: profile!.email!,
            onTap: () => _launchEmail(profile!.email!),
          ),
      ],
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    try {
      await launchUrl(emailUri);
    } catch (e) {
      print('Could not launch email: $e');
    }
  }
}
