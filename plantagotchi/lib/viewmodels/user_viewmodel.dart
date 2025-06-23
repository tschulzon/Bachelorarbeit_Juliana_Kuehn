import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantagotchi/models/badge.dart';
import 'package:plantagotchi/models/badge_conditions.dart';
import 'package:plantagotchi/models/care_entry.dart';
import 'package:plantagotchi/models/plant_template.dart';
import 'package:plantagotchi/models/skin_item.dart';
import 'package:plantagotchi/models/user.dart';
import 'package:plantagotchi/models/userbadge.dart';
import 'package:plantagotchi/models/userplant.dart';
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
    careHistory = loadCareHistory();
    loadBadgesData();
  }

  // Map to hold XP values for different activities
  Map<String, int> activityXP = {
    'watering': 10,
    'fertilizing': 15,
    'pruning': 20,
    'repotting': 30,
    'newPlant': 50,
    'note': 10,
    'photo': 10,
  };

  // Map to hold coins for different levels
  Map<int, int> coinsForLevel = {
    2: 20,
    3: 30,
    4: 40,
    5: 50,
  };

  Map<String, PlantBadge> allBadges = {};

  Future<void> loadBadgesData() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/badges.json');
    final List<dynamic> badgesList = json.decode(jsonString);
    for (var badgeJson in badgesList) {
      final badge = PlantBadge.fromJson(badgeJson);
      allBadges[badge.id] = badge; // Store badges in a map for easy access
    }

    // Nach dem Laden: Alle Badges in der Konsole ausgeben
    print('Alle geladenen Badges:');
    for (var badge in allBadges.values) {
      print(
          'Badge: ${badge.name} (ID: ${badge.id}), Meilenstein: ${badge.milestone}, Beschreibung: ${badge.description}');
    }
  }

  late Map<String, List<CareEntry>> careHistory;

  Map<String, List<CareEntry>> loadCareHistory() {
    careHistory = {};
    for (var plant in user.plants ?? []) {
      for (var entry in plant.careHistory ?? []) {
        if (!careHistory.containsKey(entry.type)) {
          careHistory[entry.type] = [];
        }
        careHistory[entry.type]!.add(entry);
      }
    }

    return careHistory;
  }

  // This method adds XP for a specific activity and checks for level up
  Future<void> addXP(String activity, BuildContext context) async {
    // Get the XP for the activity, default to 0 if not found
    addedXP = activityXP[activity] ?? 0;

    // Increment the XP, defaulting to 0 if null
    user.xp = (user.xp ?? 0) + addedXP;

    // Check if the user has enough XP to level up
    if (user.xp! >= neededXPforLevelUp) {
      String title = "Level ${user.level! + 1} erreicht!";
      String message =
          "Glückwunsch!\n\n  Deine Pflanzen danken es dir! Weiter so!";
      String image = "assets/images/level-up.png";

      // Show a dialog to inform the user about the level up
      await showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => CustomDialog(
          imagePath: image,
          title: title,
          content: message,
          onConfirm: () => Navigator.of(context).pop(),
        ),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
            child: child,
          );
        },
      );

      // Increment the user's level and update the needed XP for the next level
      // and increment coins on level up
      user.level = (user.level ?? 0) + 1;
      neededXPforLevelUp = neededXPforLevelUp + 500;
      user.coins = (user.coins! + coinsForLevel[user.level]!);
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

  DateTime parseGermanDate(String? input) {
    if (input == null || input.isEmpty) return DateTime.now();
    try {
      final parts = input.split('.');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return DateTime.now();
  }

  void addPlant(Map<String, dynamic> plant, Map<String, dynamic>? answers) {
    final newPlant = UserPlants(
      id: "plant-${user.plants!.length + 1}",
      userId: user.id,
      plantTemplate: PlantTemplate.fromJson(plant),
      nickname: answers?['nickname'] ?? plant['commonName'],
      plantImage: plant['avatarUrl'],
      avatarSkin: answers?['avatarSkin'] ?? '',
      dateAdded: DateTime.now(),
      location: answers?['location'] ?? 'Keine Angabe',
      careHistory: [
        if (answers?['lastWatered'] != null)
          CareEntry(
            id: 'care-${user.plants!.length + 1}',
            userPlantId: 'plant-${user.plants!.length + 1}',
            type: 'watering',
            date: parseGermanDate(answers?['lastWatered']),
          ),
        if (answers?['lastFertilized'] != null)
          CareEntry(
            id: 'care-${user.plants!.length + 1}',
            userPlantId: 'plant-${user.plants!.length + 1}',
            type: 'fertilizing',
            date: parseGermanDate(answers?['lastFertilized']),
          ),
      ],
    );

    user.plants?.add(newPlant);
    saveUser(); // Save the updated user data
    notifyListeners();
  }

  void updateUserPlantNickname(String plantId, String newNickname) {
    final plant = user.plants?.firstWhere(
      (plant) => plant.id == plantId,
      orElse: () => null as dynamic, // workaround for null safety
    );
    if (plant != null) {
      plant.nickname = newNickname;
      notifyListeners();
    }
  }

  // This method checks if the user gets a badge for a specific activity
  Future<void> checkIfUserGetBadgeForActivity(
      String activity, BuildContext context) async {
    // Go through all badge conditions
    for (final cond in badgeConditions) {
      // Check if the condition matches the activity and if the condition is met
      if ((cond.activity == activity || cond.activity == 'any') &&
          cond.condition(this)) {
        // If the condition is met, check and add the badge
        await _checkAndAddBadge(cond.badgeId, context);
      }
    }
  }

  // This method checks if the user gets a badge for a specific badgeId
  Future<void> _checkAndAddBadge(String badgeId, BuildContext context) async {
    // Check if the user already has the badge
    final hasBadge =
        user.badges?.any((badge) => badge.badge?.id == badgeId) ?? false;

    // If the user does not have the badge, check if it exists in the allBadges map from the JSON
    if (!hasBadge && allBadges.containsKey(badgeId)) {
      // If the badge exists, create a new UserBadge with the badge details
      // and add it to the user's badges
      String title = allBadges[badgeId]!.name;
      String message = allBadges[badgeId]!.description;
      String image = allBadges[badgeId]!.imageUrl;

      final newBadge = UserBadge(
          id: ((user.badges!.length + 1).toString()),
          badge: allBadges[badgeId]!,
          earnedAt: DateTime.now());
      user.badges?.add(newBadge);

      // Show a dialog to inform the user about the new badge
      await showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => CustomDialog(
          imagePath: image,
          title: title,
          content: message,
          onConfirm: () => Navigator.of(context).pop(),
        ),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
            child: child,
          );
        },
      );

      // Save the updated user data
      saveUser();
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  bool hasEveryPlantCareEntrys() {
    for (var plant in user.plants ?? []) {
      if (plant.careHistory == null || plant.careHistory!.isEmpty) {
        return false; // If any plant has no care history, return false
      }
    }

    return true; // All plants have care entries
  }

  // This method adds a skin to the user's owned skins
  void addSkinToOwnedSkins(
      SkinItem skin, UserPlants userPlant, BuildContext context) {
    // Check if the user has enough coins to buy the skin
    if (user.coins! >= skin.price) {
      // add the skin to the user's owned skins and deduct the price from the user's coins
      userPlant.ownedSkins!.add(skin);
      user.coins = user.coins! - skin.price;

      // Show a success message
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Skin "${skin.name}" erfolgreich gekauft!',
          style: const TextStyle(
            color: Color(0xFF3a5a40),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color(0xFF88D886),
      ));
      // Or a message that the user has not enough coins
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Nicht genügend Münzen für Skin "${skin.name}"!',
          style: const TextStyle(
            color: Color(0xFF3a5a40),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color(0xFF88D886),
      ));
    }

    saveUser(); // Save the updated user data
    notifyListeners(); // Notify listeners to update the UI
  }

  // This method sets the current skin for a user plant
  // It updates the currentSkin property of the userPlant and notifies listeners
  void setCurrentSkin(
      SkinItem skin, UserPlants userPlant, BuildContext context) {
    userPlant.currentSkin = skin.id;
    saveUser(); // Save the updated user data
    notifyListeners(); // Notify listeners to update the UI
  }
}
