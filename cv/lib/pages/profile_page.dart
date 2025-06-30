import 'package:cv/controller/firebase_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // AppShimmer yerine Shimmer paketi
import 'package:flutter_animate/flutter_animate.dart'; // FadeIn için

class ProfilePage extends StatefulWidget {
  const ProfilePage(this.databaseRef, {super.key});
  final DatabaseReference databaseRef;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseController _firebaseController = FirebaseController();

  @override
  Widget build(BuildContext context) {
    final double paddingSize =
        MediaQuery.of(context).size.width < 400 ? 16.0 : 24.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: paddingSize, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/pp.png"),
              ),
              const SizedBox(height: 20),
              _ProfileFutureText(
                future: _firebaseController.getFullName(),
                shimmerText: "======= ======",
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 21, 20, 20),
                ),
                shimmerStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                fadeDuration: 400,
              ),
              const SizedBox(height: 10),
              _ProfileFutureText(
                future: _firebaseController.getDesignation(),
                shimmerText: "==============",
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                shimmerStyle: const TextStyle(fontSize: 18),
                fadeDuration: 500,
              ),
              const SizedBox(height: 20),
              _ProfileFutureText(
                future: _firebaseController.getDescription(),
                shimmerText: "Loading description...",
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                shimmerStyle: const TextStyle(fontSize: 16),
                fadeDuration: 500,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
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
            baseColor: Colors.white,
            highlightColor: Colors.grey[300]!,
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
