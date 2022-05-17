import 'dart:collection';

import 'package:easy_nav/easy_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

import '../admin/admin_home_screen.dart';
import '../customer/customer_home_screen.dart';

class LandingPageScreen extends HookConsumerWidget {
  const LandingPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    useEffect((){
      getCurrentUser().then((user) {
        if(user != null){
          FirebaseDatabase.instance.ref("users")
              .child(user.uid).get().then((snapshot) {
            if(snapshot.exists){
              final map = snapshot.value as LinkedHashMap;
              final type = map["type"].toString();
              if(type == "admin"){
                NavManager().goToAndRemoveUntil(AdminHomeScreen(), (route) => false);
              } else {
                NavManager().goToAndRemoveUntil(CustomerHomeScreen(), (route) => false);
              }
            }
          });

        }
      });
      return null;
    }, []);

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

Future<User?> getCurrentUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if(user != null){
    user = await FirebaseAuth.instance.authStateChanges().first;
  }
  return user;
}