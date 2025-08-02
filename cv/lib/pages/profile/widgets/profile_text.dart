import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class ProfileText extends StatelessWidget {
  final String? text;
  final bool isLoading;
  final String shimmerText;
  final TextStyle textStyle;
  final TextStyle shimmerStyle;
  final int fadeDuration;
  final TextAlign? textAlign;

  const ProfileText({
    required this.text,
    required this.isLoading,
    required this.shimmerText,
    required this.textStyle,
    required this.shimmerStyle,
    required this.fadeDuration,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || text == null || text!.isEmpty) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade600,
        highlightColor: Colors.white,
        child: Text(shimmerText, style: shimmerStyle),
      );
    }

    return Text(
      text!,
      style: textStyle,
      textAlign: textAlign,
    ).animate().fadeIn(duration: Duration(milliseconds: fadeDuration));
  }
}
