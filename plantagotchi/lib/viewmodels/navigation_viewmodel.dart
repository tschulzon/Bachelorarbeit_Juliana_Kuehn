import 'package:flutter/material.dart';

// ViewModel for managing navigation state in the app
// This ViewModel is used to track the current tab index and notify listeners when it changes
class NavigationViewmodel with ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
