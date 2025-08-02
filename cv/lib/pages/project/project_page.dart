import 'package:cv/pages/project/project_provider.dart';
import 'package:cv/services/firebase_controller.dart';
import 'package:cv/model/project_model.dart';
import 'package:cv/const/app_colors.dart';
import 'package:cv/widgets/project_card.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          return FirebaseAnimatedList(
            query: projectProvider.portfolioQuery,
            defaultChild: const Center(
              child: CircularProgressIndicator(),
            ),
            itemBuilder: (context, snapshot, animation, index) {
              final data = snapshot.value as Map<dynamic, dynamic>;
              final project = ProjectModel.fromMap(data);

              return SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeOut)),
                ),
                child: ProjectCard(project: project),
              );
            },
          );
        },
      ),
    );
  }
}
