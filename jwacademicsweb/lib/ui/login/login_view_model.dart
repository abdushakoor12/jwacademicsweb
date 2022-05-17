import 'dart:collection';

import 'package:easy_nav/easy_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwacademicsweb/ui/customer/customer_home_screen.dart';

import '../../core/view_model.dart';
import '../admin/admin_home_screen.dart';

final loginViewModelProvider = ChangeNotifierProvider.autoDispose<LoginViewModel>((ref) {
  return LoginViewModel();
});

class LoginViewModel extends ViewModel{

  Future<void> login(String email, String password) async {
    showLoading();

    try{

        final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        if(authResult.user != null){
          final snapshot = await FirebaseDatabase.instance.ref("users")
              .child(authResult.user!.uid).get();
          if(snapshot.exists){
            final map = snapshot.value as LinkedHashMap;
            final type = map["type"].toString();
            if(type == "admin"){
              NavManager().goToAndRemoveUntil(AdminHomeScreen(), (route) => false);
            } else {
              NavManager().goToAndRemoveUntil(CustomerHomeScreen(), (route) => false);
            }
          } else {
            hideLoading();
            showError("User not found");
          }
        }

    } on FirebaseException catch(e, trace){
      hideLoading();
      print("Error $e, $trace");
        showError(e.message ?? "An Error Occurred");
    }
  }
}