import 'package:cv/controller/firebase_controller.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_animate/flutter_animate.dart'; // animasyon için

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 400 ? 16.0 : 24.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
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
            // Başlık ve ikon
            Row(
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
            ),
            const SizedBox(height: 16),

            // FirebaseAnimatedList
            FirebaseAnimatedList(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              query: FirebaseController().getExperience(),
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                if (snapshot.value != null) {
                  final data = snapshot.value as Map?;
                  final date = data?['duration'] ?? "Unknown Date";
                  final company = data?['company'] ?? "Unknown Company";
                  final description = data?['description'] ?? "No description";

// Description'ı madde listesine çevir
                  final descriptionList = (description as String)
                      .split('. ')
                      .where((item) => item.trim().isNotEmpty)
                      .map((item) => item.trim().endsWith('.')
                          ? item.trim()
                          : '${item.trim()}.')
                      .toList();

                  return _itemCard(date, company, descriptionList)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0, duration: 400.ms);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemCard(String date, String company, List<String> descriptionList) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isExpanded = false;

        int previewCount = 3;
        List<String> visibleItems = isExpanded
            ? descriptionList
            : descriptionList.take(previewCount).toList();

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        color: Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  company,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),

                // Description bullets
                ...visibleItems.map((item) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• ", style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    )),

                // "More"/"Less" Button
                if (descriptionList.length > previewCount)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? "Less ▲" : "More ▼",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
