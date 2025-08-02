import 'dart:ui';
import 'package:cv/pages/contact/widgets/error_widgets.dart';
import 'package:cv/pages/profile/profile_provider.dart';
import 'package:cv/const/app_colors.dart';
import 'package:cv/pages/profile/widgets/contact_info.dart';
import 'package:cv/pages/profile/widgets/dividers.dart';
import 'package:cv/pages/profile/widgets/glass_container.dart';
import 'package:cv/pages/profile/widgets/profile_avatar.dart';
import 'package:cv/pages/profile/widgets/profile_text.dart';
import 'package:cv/pages/profile/widgets/social_media_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              child: GlassContainer(
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    if (profileProvider.error != null) {
                      return ErrorsWidget(
                        error: profileProvider.error!,
                        onRetry: () => profileProvider.loadProfileData(),
                      );
                    }

                    final profile = profileProvider.profile;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile Avatar
                        ProfileAvatar(
                          imageUrl: profile?.profileImageUrl,
                          isLoading: profileProvider.isLoading,
                        ),
                        const SizedBox(height: 24),

                        // Full Name
                        ProfileText(
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
                        ProfileText(
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
                          ProfileText(
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
                        const Dividers(),
                        const SizedBox(height: 20),

                        // Description
                        ProfileText(
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
                          const Dividers(),
                          const SizedBox(height: 20),
                          ContactInfo(profile: profile),
                        ],

                        const SizedBox(height: 20),
                        const Dividers(),
                        const SizedBox(height: 20),

                        // Social Media Buttons
                        SocialMediaButtons(profile: profile),
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

// Contact Information Widget

// Rest of the existing widgets remain the same
