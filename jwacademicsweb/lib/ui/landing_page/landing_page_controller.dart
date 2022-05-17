import 'package:easy_nav/easy_nav.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final landingPageControllerProvider = ChangeNotifierProvider.autoDispose<LandingPageController>((ref){
  return LandingPageController();
});

class LandingPageController extends ChangeNotifier{
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int currentTab = 0;

  void changeTab(int index) {
    if(index != 3){
      currentTab = index;
      notifyListeners();
      if(scaffoldKey.currentState?.isEndDrawerOpen == true){
        NavManager().goBack();
      }
    } else {
      NavManager().goToNamed('/login');
    }
  }

  void openDrawer() {
    if(scaffoldKey.currentState?.isEndDrawerOpen == false){
      scaffoldKey.currentState?.openEndDrawer();
    }
  }

  void register() {
    NavManager().goToNamed('/register');
  }
}