import 'package:cv/model/contact_model.dart';
import 'package:cv/pages/contact/contact_provider.dart';
import 'package:cv/pages/contact/socialicon/social_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/*
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
}*/
class SocialMediaRow extends StatelessWidget {
  final SocialMediaModel? socialMedia;
  final ContactProvider? contactProvider; // Backward compatibility

  const SocialMediaRow({
    super.key,
    this.socialMedia,
    this.contactProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Use new model if available, otherwise fall back to provider
    final SocialMediaModel? social =
        socialMedia ?? (contactProvider?.contactInfo?.socialMedia);

    if (social == null) {
      return const SizedBox.shrink();
    }

    final socialIcons = <Widget>[];

    // LinkedIn
    if (social.linkedin != null && social.linkedin!.isNotEmpty) {
      socialIcons.add(
        SocialIcon(
          icon: FontAwesomeIcons.linkedin,
          url: social.linkedin!,
          label: 'LinkedIn',
        ),
      );
    }

    // GitHub
    if (social.github != null && social.github!.isNotEmpty) {
      socialIcons.add(
        SocialIcon(
          icon: FontAwesomeIcons.github,
          url: social.github!,
          label: 'GitHub',
        ),
      );
    }

    // Medium
    if (social.medium != null && social.medium!.isNotEmpty) {
      socialIcons.add(
        SocialIcon(
          icon: FontAwesomeIcons.medium,
          url: social.medium!,
          label: 'Medium',
        ),
      );
    }

    if (socialIcons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: socialIcons,
      ),
    );
  }
}
