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
            const _ExperienceList(),
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

// Alternative: Manual ListView with Provider (if you prefer manual control)
class _ExperienceListManual extends StatefulWidget {
  const _ExperienceListManual();

  @override
  State<_ExperienceListManual> createState() => _ExperienceListManualState();
}

class _ExperienceListManualState extends State<_ExperienceListManual> {
  @override
  void initState() {
    super.initState();
    // Load experiences on widget init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExperienceProvider>().loadExperiences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExperienceProvider>(
      builder: (context, experienceProvider, child) {
        // Loading state
        if (experienceProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error state
        if (experienceProvider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.error, size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    experienceProvider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      experienceProvider.clearError();
                      experienceProvider.refreshExperiences();
                    },
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            ),
          );
        }

        // Empty state
        if (!experienceProvider.hasExperiences) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(Icons.work_off, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Henüz deneyim eklenmemiş',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // Experiences list
        return Column(
          children: experienceProvider.experiences.asMap().entries.map((entry) {
            final index = entry.key;
            final experience = entry.value;

            return ExperienceItemCard(
              date: experience.duration,
              company: experience.company,
              descriptionList: experience.description,
            )
                .animate(delay: (index * 100).ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.2, end: 0, duration: 400.ms);
          }).toList(),
        );
      },
    );
  }
}
