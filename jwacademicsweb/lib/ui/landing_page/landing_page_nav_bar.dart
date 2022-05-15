import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwacademicsweb/core/app_colors.dart';
import 'package:jwacademicsweb/ui/landing_page/landing_page_controller.dart';
import 'package:jwacademicsweb/ui/widgets/responsive_layout.dart';

const tabNames = [
  'Home',
  'About',
  'Contact',
  'Login',
];

class LandingPageNavBar extends HookConsumerWidget {
  const LandingPageNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(landingPageControllerProvider).currentTab;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 100),
      child: Row(
        children: [
          Text("JW Academics", style: GoogleFonts.fredokaOne(
            fontSize: 28,
            letterSpacing: 1.2,
            color: AppColors.lightSalmonColor,
          ),),
          Spacer(),
          if(ResponsiveLayout.isLargeScreen(context))
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...List.generate(tabNames.length, (index) {
                  return _NavItem(position: index, label: tabNames[index],selected: currentTab == index, onTap: (index){
                    ref.read(landingPageControllerProvider).changeTab(index);
                  }, );
                }),
                SizedBox(width: 8),
                Container(height: 15, width: 2, color: Colors.white,),
                SizedBox(width: 16),
                InkWell(
                  onTap: (){
                    ref.read(landingPageControllerProvider).register();
                  },
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

              ]
            ),
          if(!ResponsiveLayout.isLargeScreen(context))
            IconButton(onPressed: (){
              ref.read(landingPageControllerProvider).openDrawer();
            }, icon: Icon(Icons.menu, color: AppColors.lightSalmonColor,)),
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
        margin: EdgeInsets.symmetric(horizontal: 10),
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


