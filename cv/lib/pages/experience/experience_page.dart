import 'package:cv/model/experience_model.dart';
import 'package:cv/pages/experience/experience_provider.dart';
import 'package:cv/const/app_colors.dart';
import 'package:cv/pages/experience/widgets/experince_item_card.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_animate/flutter_animate.dart'; // animasyon için

import 'package:provider/provider.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 400 ? 16.0 : 24.0;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const _ExperienceList(),
          ],
        ),
      ),
    );
  }
}

class _ExperienceList extends StatelessWidget {
  const _ExperienceList();

  @override
  Widget build(BuildContext context) {
    return Consumer<ExperienceProvider>(
      builder: (context, experienceProvider, child) {
        return FirebaseAnimatedList(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          query: experienceProvider.experienceQuery,
          itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation,
              int index) {
            if (snapshot.value != null) {
              final data = snapshot.value as Map?;
              final experienceModel = ExperienceModel.fromMap(
                  data?.cast<String, dynamic>() ?? {},
                  id: snapshot.key);

              return ExperienceItemCard(
                date: experienceModel.duration,
                company: experienceModel.company,
                descriptionList: experienceModel.description,
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms);
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
