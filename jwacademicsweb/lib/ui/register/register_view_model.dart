import 'package:easy_nav/easy_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/view_model.dart';
import '../customer/customer_home_screen.dart';

final registerViewModelProvider =
    ChangeNotifierProvider.autoDispose<RegisterViewModel>((ref) {
  return RegisterViewModel();
});

class RegisterViewModel extends ViewModel {
  Future<void> register(String name, String email, String password) async {
    showLoading();

    try {
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (authResult.user != null) {
        await authResult.user?.updateDisplayName(name);
        await FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(authResult.user!.uid)
            .set({
          'name': name,
          'email': email,
          "type": "customer",
          'uid': authResult.user!.uid,
        });
        NavManager().goToAndRemoveUntil(CustomerHomeScreen(), (route) => false);
      } else {
        hideLoading();
        showError("Something went wrong");
      }
    } on FirebaseException catch (e, trace) {
      hideLoading();
      print("Error $e, $trace");
      showError(e.message ?? "An Error Occurred");
    }
  }
}
