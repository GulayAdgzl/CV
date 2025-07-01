import 'dart:ui';

import 'package:cv/controller/firebase_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // AppShimmer yerine Shimmer paketi
import 'package:flutter_animate/flutter_animate.dart'; // FadeIn için
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final firebase = Provider.of<FirebaseController>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingSize = screenWidth < 400 ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: paddingSize, vertical: 32),
          child: Center(
            child: _GlassContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage("assets/pp.png"),
                  ),
                  const SizedBox(height: 24),
                  _ProfileFutureText(
                    future: firebase.getFullName(),
                    shimmerText: "======= ======",
                    textStyle: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    shimmerStyle: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    fadeDuration: 400,
                  ),
                  const SizedBox(height: 8),
                  _ProfileFutureText(
                    future: firebase.getDesignation(),
                    shimmerText: "==============",
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    shimmerStyle: const TextStyle(fontSize: 18),
                    fadeDuration: 500,
                  ),
                  const SizedBox(height: 24),
                  const _Divider(),
                  const SizedBox(height: 20),
                  _ProfileFutureText(
                    future: firebase.getDescription(),
                    shimmerText: "Loading description...",
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                    shimmerStyle: const TextStyle(fontSize: 16),
                    fadeDuration: 500,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const _Divider(),
                  const SizedBox(height: 20),

                  // TODO: Sosyal medya butonları burada yer alacak
                ],
              ),
            ),
          ),
        ),
      ),
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

class _ProfileFutureText extends StatelessWidget {
  final Future<String> future;
  final String shimmerText;
  final TextStyle textStyle;
  final TextStyle shimmerStyle;
  final int fadeDuration;
  final TextAlign? textAlign;

  const _ProfileFutureText({
    required this.future,
    required this.shimmerText,
    required this.textStyle,
    required this.shimmerStyle,
    required this.fadeDuration,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade600,
            highlightColor: Colors.white,
            child: Text(shimmerText, style: shimmerStyle),
          );
        }
        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: textStyle,
            textAlign: textAlign,
          ).animate().fadeIn(duration: Duration(milliseconds: fadeDuration));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
