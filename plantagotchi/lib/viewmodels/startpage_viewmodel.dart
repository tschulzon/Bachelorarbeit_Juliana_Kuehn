import 'package:flutter/material.dart';

class StartpageViewModel extends ChangeNotifier {
  // This class is currently empty, but it can be used to manage the state and logic for the start page of the application.
  // You can add properties and methods here as needed to handle user interactions, data fetching, etc.

  // Example property
  int _counter = 0;
  int get counter => _counter;

  // Example method
  void incrementCounter() {
    _counter++;
    notifyListeners(); // Notify listeners to update the UI when the counter changes
  }
}
