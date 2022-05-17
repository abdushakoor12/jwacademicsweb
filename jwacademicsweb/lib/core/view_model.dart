import 'package:easy_nav/easy_nav.dart';
import 'package:flutter/material.dart';

abstract class ViewModel extends ChangeNotifier {
  final snackbarManager = SnackBarManager();
  final dialogManager = DialogManager();
  final navManager = NavManager();
  final bottomSheetManager = BottomSheetManager();

  bool loading = false;

  void showLoading() {
    loading = true;
    notifyListeners();
  }

  void hideLoading() {
    loading = false;
    notifyListeners();
  }

  void showError(String message) {
    snackbarManager.showEasySnackbar(SnackBar(content: Text(message, style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,));
  }
}