import 'package:flutter/material.dart';
import 'package:plantagotchi/models/user.dart';
import 'package:plantagotchi/services/shared_prefs_helper.dart';

class UserViewModel extends ChangeNotifier {
  final User user; // Private field to hold the user data

  UserViewModel(this.user); // Constructor to initialize the user

  void incrementStreak() {
    user.streak =
        (user.streak ?? 0) + 1; // Increment the streak, defaulting to 0 if null
    saveUser(); // Save the updated user data
    notifyListeners(); // Notify listeners to update the UI when the streak changes
  }

  Future<void> saveUser() async {
    // This method can be used to save the user data to persistent storage
    // For example, using SharedPreferences or a database
    // Implement the saving logic here
    final storage = StorageService();
    await storage.saveUser(user);
  }
}
