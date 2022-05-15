import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwacademicsweb/core/app_colors.dart';
import 'package:jwacademicsweb/ui/landing_page/landing_page_controller.dart';
import 'package:jwacademicsweb/ui/landing_page/landing_page_drawer.dart';
import 'package:jwacademicsweb/ui/landing_page/landing_page_footer.dart';
import 'package:jwacademicsweb/ui/landing_page/landing_page_nav_bar.dart';
import 'package:jwacademicsweb/ui/landing_page/pages/about_page.dart';
import 'package:jwacademicsweb/ui/landing_page/pages/contact_page.dart';
import 'package:jwacademicsweb/ui/landing_page/pages/home_page.dart';
import 'package:jwacademicsweb/ui/widgets/responsive_layout.dart';

class LandingPageScreen extends HookConsumerWidget {
  const LandingPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(landingPageControllerProvider).currentTab;
    return Scaffold(
      backgroundColor: AppColors.primary,
      key: ref.read(landingPageControllerProvider).scaffoldKey,
      endDrawer: ResponsiveLayout.isLargeScreen(context) ? null : LandingPageDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LandingPageNavBar(),
            getWidget(currentTab),
            LandingPageFooter(),
          ],
        ),
      ),
    );
  }

  Widget getWidget(int currentTab) {
    switch (currentTab) {
      case 0:
        return HomePage();
      case 1:
        return AboutPage();
      case 2:
        return ContactPage();
      default:
        return HomePage();
    }
  }
}