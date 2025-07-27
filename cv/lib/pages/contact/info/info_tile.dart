import 'package:flutter/material.dart';

/*
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
*/
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool showLaunchIcon;

  const InfoTile({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.showLaunchIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.white,
        size: 20,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 14,
        ),
      ),
      trailing: (onTap != null && showLaunchIcon)
          ? Icon(
              Icons.launch,
              color: (iconColor ?? Colors.white).withOpacity(0.6),
              size: 16,
            )
          : null,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      minLeadingWidth: 30,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: tile,
      );
    }

    return tile;
  }
}
