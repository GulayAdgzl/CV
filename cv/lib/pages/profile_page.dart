import 'package:cv/controller/firebase_controller.dart';
import 'package:cv/utils/common_string.dart';
import 'package:cv/utils/text_style.dart';
import 'package:cv/widgets/app_shimmer_effect.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.databaseRef});

  final DatabaseReference databaseRef;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseController _firebaseController = FirebaseController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Full Name
          FutureBuilder<String>(
            future: _firebaseController.getFullName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AppShimmer(
                    child: Text("======= ======", style: headerTextStyle));
              }
              if (snapshot.hasData) {
                return Text(snapshot.data!, style: headerTextStyle);
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
                return AppShimmer(
                    child: Text("==============", style: headerTextStyle));
              }
              if (snapshot.hasData) {
                return Text(snapshot.data!, style: headerTextStyle);
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
                return AppShimmer(
                    child: Text("==============", style: headerTextStyle));
              }
              if (snapshot.hasData) {
                return Text(snapshot.data!, style: bodyTextStyle);
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 30),
          Text(title2, style: headerTextStyle),
          const SizedBox(height: 10),
          Text(description, style: bodyTextStyle),

          const SizedBox(height: 30),
          Text(title3, style: headerTextStyle),
          const SizedBox(height: 10),
          Text(description, style: bodyTextStyle),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
