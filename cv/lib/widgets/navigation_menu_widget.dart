import 'package:cv/const/app_colors.dart';
import 'package:cv/widgets/svg_loader.dart';
import 'package:flutter/material.dart';

Widget NavigationMenu({
  required String icon,
  bool isSelected = false,
  double? height,
  double? width,
  required VoidCallback onClick,
}) {
  return InkWell(
    onTap: onClick,
    child: Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          svgLoader(icon, height: height, width: width),
          Container(
            margin: const EdgeInsets.all(8),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              color: isSelected ? AppColors.tiffanyBlue80 : Colors.transparent,
            ),
          ),
        ],
      ),
    ),
  );
}
