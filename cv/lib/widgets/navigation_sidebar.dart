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
            icon: "assets/profile.svg",
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(0),
          ),
          NavigationMenu(
            icon: "assets/profile.svg",
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(1),
          ),
          NavigationMenu(
            icon: "assets/profile.svg",
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(2),
          ),
          NavigationMenu(
            icon: "assets/profile.svg",
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(3),
          ),
          NavigationMenu(
            icon: "assets/profile.svg",
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(4),
          ),
          NavigationMenu(
            icon: "assets/profile.svg",
            height: 20.0,
            width: 20.0,
            isSelected: selectedIndex == 0,
            onClick: () => onMenuTap(5),
          ),
          /*   NavigationMenu(navExperince,
              height: iconSize,
              width: iconSize,
              isSelected: selectedIndex == 1,
              onClick: () => onMenuTap(1)),*/
          /* NavigationMenu(navProject,
              height: iconSize,
              width: iconSize,
              isSelected: selectedIndex == 2,
              onClick: () => onMenuTap(2)),*/
          /*   NavigationMenu(navContact,
              height: iconSize,
              width: iconSize,
              isSelected: selectedIndex == 3,
              onClick: () => onMenuTap(3)),
          NavigationMenu(navEducation,
              height: iconSize,
              width: iconSize,
              isSelected: selectedIndex == 4,
              onClick: () => onMenuTap(4)),
          NavigationMenu(navGene,
              height: iconSize,
              width: iconSize,
              isSelected: selectedIndex == 4,
              onClick: () => onMenuTap(5)),*/
        ],
      ),
    );
  }
}
