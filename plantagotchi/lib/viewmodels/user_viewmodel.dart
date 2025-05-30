import 'package:flutter/material.dart';
import 'package:plantagotchi/models/user.dart';
import 'package:plantagotchi/services/shared_prefs_helper.dart';
import 'package:plantagotchi/widgets/custom_dialog.dart';

class UserViewModel extends ChangeNotifier {
  final User user; // Private field to hold the user data

  int? currentXP;
  int? currentLevel;
  int? currentStreak;
  int? currentCoins;
  int neededXPforLevelUp = 500;
  int get restXP => neededXPforLevelUp - (user.xp ?? 0);
  int addedXP = 0;

  // Constructor to initialize the UserViewModel with a User object
  UserViewModel(this.user) {
    currentXP = user.xp;
    currentLevel = user.level;
    currentStreak = user.streak;
    currentCoins = user.coins;
  }

  // Map to hold XP values for different activities
  Map<String, int> activityXP = {
    'watering': 100,
    'fertilizing': 250,
    'completingTasks': 20,
    'repotting': 30,
    'newPlant': 50,
  };

  // Map to hold coins for different levels
  Map<int, int> coinsForLevel = {
    2: 20,
    3: 30,
    4: 40,
    5: 50,
  };

  void addXP(String activity, BuildContext context) {
    addedXP = activityXP[activity] ??
        0; // Get the XP for the activity, default to 0 if not found

    user.xp =
        (user.xp ?? 0) + addedXP; // Increment the XP, defaulting to 0 if null

    if (user.xp! >= neededXPforLevelUp) {
      String title = "Level ${user.level! + 1} erreicht!";
      String message =
          "Glückwunsch!\n\n  Deine Pflanzen danken es dir! Weiter so!";
      String image = "assets/images/level-up.png"; // Path to the level up image

      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          imagePath: image,
          title: title,
          content: message,
          onConfirm: () => Navigator.of(context).pop(),
        ),
      );

      user.level =
          (user.level ?? 0) + 1; // Increment the level, defaulting to 0 if null
      neededXPforLevelUp =
          neededXPforLevelUp + 500; // Update the XP needed for the next level
      user.coins = (user.coins! +
          coinsForLevel[user.level]!); // Increment coins on level up
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

    // Handle level down if XP falls below the current level threshold
    while (user.xp! < (neededXPforLevelUp - 500) && user.level! > 1) {
      user.level = (user.level ?? 1) - 1;
      neededXPforLevelUp = neededXPforLevelUp - 500;
      user.coins = (user.coins! - (coinsForLevel[user.level! + 1] ?? 0));
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
