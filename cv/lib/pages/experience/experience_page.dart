import 'package:cv/services/firebase_controller.dart';
import 'package:cv/const/app_colors.dart';
import 'package:cv/widgets/experince_item_card.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_animate/flutter_animate.dart'; // animasyon için
/*
class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 400 ? 16.0 : 24.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.incomesGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            const SizedBox(height: 16),
            _ExperienceList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.work_outline, color: Colors.blue, size: 28),
        const SizedBox(width: 10),
        Text(
          "Professional Experience",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
      ],
    );
  }
}

class _ExperienceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      query: FirebaseController().getExperience(),
      itemBuilder:
          (_, DataSnapshot snapshot, Animation<double> animation, int index) {
        if (snapshot.value != null) {
          final data = snapshot.value as Map?;
          final date = data?['duration'] ?? "Unknown Date";
          final company = data?['company'] ?? "Unknown Company";
          final descriptionList = (data?['description'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              ["No description available"];

          return ExperienceItemCard(
            date: date,
            company: company,
            descriptionList: descriptionList,
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
*/
