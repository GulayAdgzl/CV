import 'package:cv/pages/contact/contact_provider.dart';
import 'package:cv/pages/contact/socialicon/social_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaRow extends StatelessWidget {
  final ContactProvider contactProvider;

  const SocialMediaRow({required this.contactProvider});

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
