import 'package:cv/model/project_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              project.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                    radius: 5, backgroundColor: Colors.deepPurple),
                const SizedBox(width: 6),
                Text(project.language,
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(width: 16),
                const Icon(Icons.star_border, size: 16, color: Colors.black45),
                const SizedBox(width: 4),
                Text(project.stars,
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(width: 16),
                Text("Updated ${project.updatedAt}",
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () async {
                final uri = Uri.parse(project.githubUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text("View on GitHub"),
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
