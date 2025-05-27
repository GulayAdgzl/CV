import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final databaseQuery = FirebaseDatabase.instance.ref().child("projects");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Projects")),
      backgroundColor: const Color(0xFFFFF4AC), // sarımsı arka plan
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: FirebaseAnimatedList(
          query: databaseQuery,
          scrollDirection: Axis.horizontal,
          defaultChild: const Center(child: CircularProgressIndicator()),
          itemBuilder: (context, snapshot, animation, index) {
            final data = snapshot.value as Map<dynamic, dynamic>;
            return _projectCard(
              context,
              name: data['name'] ?? 'No Name',
              description: data['description'] ?? 'No Description',
              image: data['image'] ?? '',
              githubUrl: data['github'] ?? '',
            );
          },
        ),
      ),
    );
  }

  Widget _projectCard(
    BuildContext context, {
    required String name,
    required String description,
    required String image,
    required String githubUrl,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(githubUrl))) {
                        await launchUrl(Uri.parse(githubUrl));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    child: const Text("GitHub"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
