import 'package:cv/controller/firebase_controller.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final FirebaseController _controller = FirebaseController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repositories"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF6F8FA), // GitHub açık tema rengi
      body: FirebaseAnimatedList(
          query: _controller.getPortfolio(),
          defaultChild: const Center(child: CircularProgressIndicator()),
          itemBuilder: (context, snapshot, animation, index) {
            final data = snapshot.value as Map<dynamic, dynamic>;

            return _projectCard(
              context,
              name: data['title'] ?? 'No Title',
              description: data['description'] ?? 'No Description',
              githubUrl: data['link'] ?? '',
              language: data['language'] ?? 'Unknown',
              stars: data['stars']?.toString() ?? '0',
              updatedAt: data['updated_at'] ?? 'Unknown',
            );
          }),
    );
  }

  Widget _projectCard(
    BuildContext context, {
    required String name,
    required String description,
    required String githubUrl,
    required String language,
    required String stars,
    required String updatedAt,
  }) {
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
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            /// Alt bilgi çubuğu (dil, yıldız, güncelleme tarihi)
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(language, style: const TextStyle(color: Colors.black54)),
                const SizedBox(width: 16),
                const Icon(Icons.star_border, size: 16, color: Colors.black45),
                const SizedBox(width: 4),
                Text(stars, style: const TextStyle(color: Colors.black54)),
                const SizedBox(width: 16),
                Text("Updated $updatedAt",
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),

            const SizedBox(height: 12),

            /// GitHub butonu
            TextButton.icon(
              onPressed: () async {
                final uri = Uri.parse(githubUrl);
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
