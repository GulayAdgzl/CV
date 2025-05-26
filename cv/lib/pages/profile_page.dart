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
          colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
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
              // Avatar
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/pp.png"),
              ),

              const SizedBox(height: 20),

              // Full Name
              FutureBuilder<String>(
                future: _firebaseController.getFullName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.grey[300]!,
                      child: Text("======= ======",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    );
                  }
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ).animate().fadeIn(duration: 400.ms);
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 10),

              // Designation
              FutureBuilder<String>(
                future: _firebaseController.getDesignation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.grey[300]!,
                      child: Text("==============",
                          style: TextStyle(fontSize: 18)),
                    );
                  }
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white70),
                    ).animate().fadeIn(duration: 500.ms);
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 20),

              // Description
              FutureBuilder<String>(
                future: _firebaseController.getDescription(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.grey[300]!,
                      child: Text("Loading description...",
                          style: TextStyle(fontSize: 16)),
                    );
                  }
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 500.ms);
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
