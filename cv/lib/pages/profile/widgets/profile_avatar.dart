import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final bool isLoading;

  const ProfileAvatar({
    required this.imageUrl,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade600,
        highlightColor: Colors.white,
        child: const CircleAvatar(radius: 55),
      );
    }

    return CircleAvatar(
      radius: 55,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? NetworkImage(imageUrl!)
          : const AssetImage("assets/pp.png") as ImageProvider,
    ).animate().scale(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 400),
        );
  }
}
