import 'package:flutter/material.dart';
import 'package:plantagotchi/models/user.dart';
import 'package:plantagotchi/services/shared_prefs_helper.dart';

class UserViewModel extends ChangeNotifier {
  final User user; // Private field to hold the user data

  int? currentXP;
  int? currentLevel;
  int? currentStreak;
  int neededXPforLevelUp = 500;
  int get restXP => neededXPforLevelUp - (user.xp ?? 0);

  // Constructor to initialize the UserViewModel with a User object
  UserViewModel(this.user) {
    currentXP = user.xp;
    currentLevel = user.level;
    currentStreak = user.streak;
  }

  // Map to hold XP values for different activities
  Map<String, int> activityXP = {
    'watering': 10,
    'fertilizing': 15,
    'completingTasks': 20,
    'repotting': 30,
    'newPlant': 50,
  };

  void addXP(String activity) {
    int amount = activityXP[activity] ??
        0; // Get the XP for the activity, default to 0 if not found

    user.xp =
        (user.xp ?? 0) + amount; // Increment the XP, defaulting to 0 if null

    if (user.xp! >= neededXPforLevelUp) {
      user.level =
          (user.level ?? 0) + 1; // Increment the level, defaulting to 0 if null
      neededXPforLevelUp =
          neededXPforLevelUp + 500; // Update the XP needed for the next level
    }
    saveUser(); // Save the updated user data
    notifyListeners(); // Notify listeners to update the UI when XP changes
  }

  // This method removes XP for a specific activity, when user accidentally checked a box wrong
  void removeXP(String activity) {
    int amount = activityXP[activity] ??
        0; // Get the XP for the activity, default to 0 if not found
    user.xp =
        (user.xp ?? 0) - amount; // Decrement the XP, defaulting to 0 if null
    if (user.xp! < 0) {
      user.xp = 0; // Ensure XP does not go below 0
    }
    saveUser(); // Save the updated user data
    notifyListeners(); // Notify listeners to update the UI when XP changes
  }

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
