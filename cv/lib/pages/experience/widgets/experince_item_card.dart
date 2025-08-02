import 'package:flutter/material.dart';

class ExperienceItemCard extends StatefulWidget {
  final String date;
  final String company;
  final List<String> descriptionList;

  const ExperienceItemCard({
    super.key,
    required this.date,
    required this.company,
    required this.descriptionList,
  });

  @override
  State<ExperienceItemCard> createState() => _ExperienceItemCardState();
}

class _ExperienceItemCardState extends State<ExperienceItemCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const previewCount = 3;
    final visibleItems = isExpanded
        ? widget.descriptionList
        : widget.descriptionList.take(previewCount).toList();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarih
            Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.date,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Şirket adı
            Text(
              widget.company,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),

            // Açıklama maddeleri
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

            // More / Less butonu
            if (widget.descriptionList.length > previewCount)
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
  }
}
