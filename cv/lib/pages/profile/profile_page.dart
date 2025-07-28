import 'dart:ui';
import 'package:cv/model/profile_model.dart';
import 'package:cv/pages/profile/profile_provider.dart';
import 'package:cv/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // AppShimmer yerine Shimmer paketi
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart'; // FadeIn için

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileProvider>();
      provider.loadProfileData();
      // Optionally start listening to real-time changes
      provider.startListeningToProfileChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingSize = screenWidth < 400 ? 16.0 : 24.0;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<ProfileProvider>().refreshProfile(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding:
                EdgeInsets.symmetric(horizontal: paddingSize, vertical: 32),
            child: Center(
              child: _GlassContainer(
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    if (profileProvider.error != null) {
                      return _ErrorWidget(
                        error: profileProvider.error!,
                        onRetry: () => profileProvider.loadProfileData(),
                      );
                    }

                    final profile = profileProvider.profile;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile Avatar
                        _ProfileAvatar(
                          imageUrl: profile?.profileImageUrl,
                          isLoading: profileProvider.isLoading,
                        ),
                        const SizedBox(height: 24),

                        // Full Name
                        _ProfileText(
                          text: profile?.fullName,
                          isLoading: profileProvider.isLoading,
                          shimmerText: "======= ======",
                          textStyle: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.tiffanyBlue,
                          ),
                          shimmerStyle: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          fadeDuration: 400,
                        ),
                        const SizedBox(height: 8),

                        // Designation
                        _ProfileText(
                          text: profile?.jobTitle,
                          isLoading: profileProvider.isLoading,
                          shimmerText: "==============",
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: AppColors.tiffanyBlue,
                          ),
                          shimmerStyle: const TextStyle(fontSize: 18),
                          fadeDuration: 500,
                        ),

                        // Location (if available)
                        if (profile?.location != null) ...[
                          const SizedBox(height: 4),
                          _ProfileText(
                            text: profile?.location,
                            isLoading: profileProvider.isLoading,
                            shimmerText: "========",
                            textStyle: const TextStyle(
                              fontSize: 14,
                              // ignore: deprecated_member_use
                              color: AppColors.tiffanyBlue,
                            ),
                            shimmerStyle: const TextStyle(fontSize: 14),
                            fadeDuration: 600,
                          ),
                        ],

                        const SizedBox(height: 24),
                        const _Divider(),
                        const SizedBox(height: 20),

                        // Description
                        _ProfileText(
                          text: profile?.bio,
                          isLoading: profileProvider.isLoading,
                          shimmerText: "Loading description...",
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: AppColors.tiffanyBlue,
                            height: 1.5,
                          ),
                          shimmerStyle: const TextStyle(fontSize: 16),
                          fadeDuration: 500,
                          textAlign: TextAlign.center,
                        ),

                        // Contact info (if available)
                        if (profile?.email != null ||
                            profile?.phone != null) ...[
                          const SizedBox(height: 20),
                          const _Divider(),
                          const SizedBox(height: 20),
                          _ContactInfo(profile: profile),
                        ],

                        const SizedBox(height: 20),
                        const _Divider(),
                        const SizedBox(height: 20),

                        // Social Media Buttons
                        _SocialMediaButtons(profile: profile),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final bool isLoading;

  const _ProfileAvatar({
    required this.imageUrl,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade600,
        highlightColor: Colors.white,
        child: const CircleAvatar(radius: 55),
      );
    }

    return CircleAvatar(
      radius: 55,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? NetworkImage(imageUrl!)
          : const AssetImage("assets/pp.png") as ImageProvider,
    ).animate().scale(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 400),
        );
  }
}

// Contact Information Widget
class _ContactInfo extends StatelessWidget {
  final ProfileModel? profile;

  const _ContactInfo({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (profile?.email != null)
          _ContactItem(
            icon: Icons.email_outlined,
            text: profile!.email!,
            onTap: () => _launchEmail(profile!.email!),
          ),
        if (profile?.email != null && profile?.phone != null)
          const SizedBox(height: 12),
        if (profile?.phone != null)
          _ContactItem(
            icon: Icons.phone_outlined,
            text: profile!.phone!,
            onTap: () => _launchPhone(profile!.phone!),
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

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    try {
      await launchUrl(phoneUri);
    } catch (e) {
      print('Could not launch phone: $e');
    }
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContactItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.tiffanyBlue,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.tiffanyBlue,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          delay: const Duration(milliseconds: 700),
          duration: const Duration(milliseconds: 300),
        );
  }
}

// Updated Social Media Buttons with profile integration
class _SocialMediaButtons extends StatelessWidget {
  final ProfileModel? profile;

  const _SocialMediaButtons({required this.profile});

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
          _SocialButton(
            icon: Icons.work_outline,
            label: 'LinkedIn',
            onTap: () => _launchURL(socialLinks['linkedin']!),
          ),
        if (socialLinks.containsKey('github'))
          _SocialButton(
            icon: Icons.code,
            label: 'GitHub',
            onTap: () => _launchURL(socialLinks['github']!),
          ),
        if (socialLinks.containsKey('medium'))
          _SocialButton(
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

// Rest of the existing widgets remain the same
class _ProfileText extends StatelessWidget {
  final String? text;
  final bool isLoading;
  final String shimmerText;
  final TextStyle textStyle;
  final TextStyle shimmerStyle;
  final int fadeDuration;
  final TextAlign? textAlign;

  const _ProfileText({
    required this.text,
    required this.isLoading,
    required this.shimmerText,
    required this.textStyle,
    required this.shimmerStyle,
    required this.fadeDuration,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || text == null || text!.isEmpty) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade600,
        highlightColor: Colors.white,
        child: Text(shimmerText, style: shimmerStyle),
      );
    }

    return Text(
      text!,
      style: textStyle,
      textAlign: textAlign,
    ).animate().fadeIn(duration: Duration(milliseconds: fadeDuration));
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
          'Error loading profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 55,
            height: 55,
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
            child: Icon(
              icon,
              color: AppColors.tiffanyBlue,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.tiffanyBlue,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().scale(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 300),
        );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;

  const _GlassContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Colors.white30, thickness: 0.5);
  }
}
