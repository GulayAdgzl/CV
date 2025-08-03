import 'package:cv/const/app_colors.dart';
import 'package:cv/core/utils/AppIcons.dart';
import 'package:cv/widgets/navigation_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavigationSidebar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onMenuTap;

  const NavigationSidebar({
    super.key,
    required this.selectedIndex,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    double iconSize = 20.0;

    return Container(
      width: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 45,
            height: 45,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.asset("assets/pp.png"),
          ),
          NavigationMenu(
            icon: Icon(Icons.person, color: AppColors.tiffanyBlue),
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(0),
          ),
          NavigationMenu(
            icon: Icon(Icons.contact_emergency, color: AppColors.tiffanyBlue),
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(1),
          ),
          NavigationMenu(
            icon: Icon(Icons.add_business, color: AppColors.tiffanyBlue),
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(2),
          ),
          NavigationMenu(
            icon: Icon(Icons.burst_mode_sharp, color: AppColors.tiffanyBlue),
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(3),
          ),
          NavigationMenu(
            icon: Icon(Icons.business_rounded, color: AppColors.tiffanyBlue),
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(4),
          ),
          NavigationMenu(
            icon: Icon(Icons.air_sharp, color: AppColors.tiffanyBlue),
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(5),
          ),
        ],
      ),
    );
  }
}
