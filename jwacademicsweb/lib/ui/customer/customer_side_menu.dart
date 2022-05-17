import 'dart:collection';

import 'package:easy_nav/easy_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwacademicsweb/core/app_colors.dart';

import '../widgets/drawer_list_tile.dart';



class CustomerSideMenu extends HookConsumerWidget {
  const CustomerSideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final currentTab = ref.watch(menuControllerProvider).currentIndex;
    return Drawer(
      backgroundColor: AppColors.primary,
      elevation: 3,
      child: ListView(
        children: [
          DrawerListTile(
            title: "Dashboard",
            // selected: currentTab == 0,
            selected: true,
            iconData: Icons.dashboard,
            press: () {
              // ref.read(menuControllerProvider).changeTab(0);
            },
          ),
          DrawerListTile(
            title: "Logout",
            iconData: Icons.logout,
            press: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("Confirmation"),
                  content: Text("Do you want to log out?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
                    ElevatedButton(onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      NavManager().goToNamedAndRemoveUntil("/", (route) => false);
                    }, child: Text("Logout"))
                  ],
                );
              });
            },
          ),
        ],
      ),
    );
  }
}