import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.press,
    this.selected = false,
    required this.iconData,
  }) : super(key: key);

  final String title;
  final bool selected;
  final IconData iconData;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      selected: selected,
      horizontalTitleGap: 0.0,
      selectedTileColor: Colors.white.withOpacity(0.2),
      leading: Icon(
        iconData,
        color: AppColors.lightSalmonColor,
        size: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: AppColors.lightSalmonColor),
      ),
    );
  }
}