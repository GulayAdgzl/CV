// Updated Social Media Buttons with profile integration
import 'package:cv/model/profile_model.dart';
import 'package:cv/pages/profile/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaButtons extends StatelessWidget {
  final ProfileModel? profile;

  const SocialMediaButtons({required this.profile});

  @override
  Widget build(BuildContext context) {
    // Default social links if not provided in profile
    final socialLinks = profile?.socialLinks ??
        {
          'linkedin': 'www.linkedin.com/in/gülay-adıgüzel',
          'github': 'https://github.com/GulayAdgzl',
          'medium': 'https://medium.com/@glyadgzl',
        };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (socialLinks.containsKey('linkedin'))
          SocialButton(
            icon: Icons.work_outline,
            label: 'LinkedIn',
            onTap: () => _launchURL(socialLinks['linkedin']!),
          ),
        if (socialLinks.containsKey('github'))
          SocialButton(
            icon: Icons.code,
            label: 'GitHub',
            onTap: () => _launchURL(socialLinks['github']!),
          ),
        if (socialLinks.containsKey('medium'))
          SocialButton(
            icon: Icons.article_outlined,
            label: 'Medium',
            onTap: () => _launchURL(socialLinks['medium']!),
          ),
      ],
    );
  }

  void _launchURL(String url) async {
    try {
      // Ensure URL has proper scheme
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }

      await launchUrl(Uri.parse(formattedUrl),
          mode: LaunchMode.externalApplication);
      print('Opening: $formattedUrl');
    } catch (e) {
      print('Could not launch $url: $e');
    }
  }
}
