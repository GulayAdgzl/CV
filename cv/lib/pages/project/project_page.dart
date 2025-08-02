import 'package:cv/pages/project/project_provider.dart';
import 'package:cv/services/firebase_controller.dart';
import 'package:cv/model/project_model.dart';
import 'package:cv/const/app_colors.dart';
import 'package:cv/widgets/project_card.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
/*
class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firebase = Provider.of<FirebaseController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Repositories"),
        backgroundColor: AppColors.mints,
        elevation: 1,
      ),
      backgroundColor: AppColors.mints,
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
*/

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repositories"),
        backgroundColor: AppColors.mints,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProjectProvider>().refreshProjects();
            },
          ),
        ],
      ),
      backgroundColor: AppColors.mints,
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

// Alternative: Manual ListView with Provider
class ProjectPageManual extends StatefulWidget {
  const ProjectPageManual({super.key});

  @override
  State<ProjectPageManual> createState() => _ProjectPageManualState();
}

class _ProjectPageManualState extends State<ProjectPageManual> {
  @override
  void initState() {
    super.initState();
    // Load projects on page init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().loadProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repositories"),
        backgroundColor: AppColors.mints,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProjectProvider>().refreshProjects();
            },
          ),
          PopupMenuButton<ProjectSortType>(
            icon: const Icon(Icons.sort),
            onSelected: (sortType) {
              context.read<ProjectProvider>().sortProjects(sortType);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ProjectSortType.name,
                child: Text('İsme göre sırala'),
              ),
              const PopupMenuItem(
                value: ProjectSortType.stars,
                child: Text('Yıldıza göre sırala'),
              ),
              const PopupMenuItem(
                value: ProjectSortType.updated,
                child: Text('Güncellemeye göre sırala'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: AppColors.mints,
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          // Loading state
          if (projectProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (projectProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    projectProvider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      projectProvider.clearError();
                      projectProvider.refreshProjects();
                    },
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (!projectProvider.hasProjects) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Henüz proje yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Projects list
          return RefreshIndicator(
            onRefresh: projectProvider.refreshProjects,
            child: ListView.builder(
              itemCount: projectProvider.projects.length,
              itemBuilder: (context, index) {
                final project = projectProvider.projects[index];
                return ProjectCard(project: project);
              },
            ),
          );
        },
      ),
    );
  }
}
