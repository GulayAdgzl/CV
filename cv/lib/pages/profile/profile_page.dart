import 'dart:ui';
import 'package:cv/pages/profile/profile_provider.dart';
import 'package:cv/theme/app_colors.dart';
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
      context.read<ProfileProvider>().loadProfileData();
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

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile Avatar
                        const CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage("assets/pp.png"),
                        ),
                        const SizedBox(height: 24),

                        // Full Name
                        _ProfileText(
                          text: profileProvider.fullName,
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
                          text: profileProvider.designation,
                          isLoading: profileProvider.isLoading,
                          shimmerText: "==============",
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: AppColors.tiffanyBlue,
                          ),
                          shimmerStyle: const TextStyle(fontSize: 18),
                          fadeDuration: 500,
                        ),
                        const SizedBox(height: 24),
                        const _Divider(),
                        const SizedBox(height: 20),

                        // Description
                        _ProfileText(
                          text: profileProvider.description,
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
                        const SizedBox(height: 20),
                        const _Divider(),
                        const SizedBox(height: 20),

                        // Social Media Buttons
                        _SocialMediaButtons(),
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
    if (isLoading || text == null) {
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
        Text(
          'Error loading profile',
          style: const TextStyle(
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

class _SocialMediaButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SocialButton(
          icon: Icons.work_outline, // LinkedIn icon
          label: 'LinkedIn',
          onTap: () => _launchURL('www.linkedin.com/in/gülay-adıgüzel'),
        ),
        _SocialButton(
          icon: Icons.code, // GitHub icon
          label: 'GitHub',
          onTap: () => _launchURL('https://github.com/GulayAdgzl'),
        ),
        _SocialButton(
          icon: Icons.article_outlined, // Medium icon
          label: 'Medium',
          onTap: () => _launchURL('https://medium.com/@glyadgzl'),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

      // Geçici olarak debug print
      print('Opening: $url');
    } catch (e) {
      print('Could not launch $url: $e');
    }
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
          delay: Duration(milliseconds: 200),
          duration: Duration(milliseconds: 300),
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
