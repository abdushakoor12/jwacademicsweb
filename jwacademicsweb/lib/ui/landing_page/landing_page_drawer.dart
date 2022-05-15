import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwacademicsweb/core/app_colors.dart';

import 'landing_page_controller.dart';
import 'landing_page_nav_bar.dart';

class LandingPageDrawer extends HookConsumerWidget {
  const LandingPageDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(landingPageControllerProvider).currentTab;
    return Drawer(
      backgroundColor: AppColors.primary,
      child: Column(
        children: [
          ...List.generate(tabNames.length, (index) {
            return _NavItem(position: index, label: tabNames[index],selected: currentTab == index, onTap: (index){
              ref.read(landingPageControllerProvider).changeTab(index);
            }, );
          }),
          SizedBox(height: 8),
          SizedBox(height: 16),
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.lightSalmonColor,
              ),
              child: Text("Get Started", style: TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int position;
  final String label;
  final bool selected;
  final Function(int) onTap;
  const _NavItem({Key? key, required this.position, required this.label, required this.selected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(position),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: selected ? BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.lightSalmonColor,
              width: 3,
            ),
          ),
        ) : null,
        child: Text(label, style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: selected ? AppColors.lightSalmonColor : Colors.white,
        ),),
      ),
    );
  }
}
