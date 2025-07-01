import 'package:cv/controller/firebase_controller.dart';
import 'package:cv/model/project_model.dart';
import 'package:cv/widgets/project_card.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firebase = Provider.of<FirebaseController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Repositories"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF6F8FA),
      body: FirebaseAnimatedList(
        query: firebase.getPortfolio(),
        defaultChild: const Center(child: CircularProgressIndicator()),
        itemBuilder: (context, snapshot, animation, index) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          final project = ProjectModel.fromMap(data);
          return ProjectCard(project: project);
        },
      ),
    );
  }
}
