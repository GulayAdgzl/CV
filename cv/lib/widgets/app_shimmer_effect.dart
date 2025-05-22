import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;

  // shimmer color
  static final Color shimmerBaseColor = Colors.grey[300]!;
  static final Color shimmerHighlightColor = Colors.grey[100]!;

  const AppShimmer({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      enabled: true,
      child: child,
    );
  }
}
