import 'dart:convert';

import 'package:plantagotchi/models/care_entry.dart';
import 'package:plantagotchi/models/user.dart';
import 'package:plantagotchi/models/userplant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Key for SharedPreferences, data will be stored in key-value pairs
  static const String _userKey = 'user';
  static const String _userPlantsKey = 'user_plants';
  static const String _badgesKey = 'badges';
  static const String _careEntryKey = 'care_entry';
  static const String _ownedSkinsKey = 'owned_skins';

  // Save User data
  Future<void> saveUser(User username) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(username.toJson());
    await prefs.setString(_userKey, jsonString);
    print("User saved: $jsonString");
  }

  // Load User data
  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    // For cleaning everything, remove this line in production
    await prefs.clear();
    String? jsonString = prefs.getString(_userKey);
    print("Geladener User aus SharedPreferences: $jsonString");
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return User.fromJson(jsonMap);
    }
    return null;
  }

  // Save UserPlants data (List of UserPlants)
  Future<void> saveUserPlants(List<UserPlants> userPlants) async {
    // Access to local storage from App
    final prefs = await SharedPreferences.getInstance();
    // Every User-Plant Object is converted to JSON-Object (Map)
    // toList... creates a List of JSON-Objects
    // JsonEncode converts the List of JSON-Objects to a String
    String jsonString =
        jsonEncode(userPlants.map((plant) => plant.toJson()).toList());
    // Save the JSON-String in local storage with the key _userPlantsKey
    await prefs.setString(_userPlantsKey, jsonString);
  }

  // Load UserPlants data
  Future<List<UserPlants>?> loadUserPlants() async {
    // Access to local storage from App
    final prefs = await SharedPreferences.getInstance();
    // Get the JSON-String from local storage with the key _userPlantsKey
    String? jsonString = prefs.getString(_userPlantsKey);
    // Decode converts every map back to a user-plant object
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((plant) => UserPlants.fromJson(plant)).toList();
    }
    return null;
  }

  // Save Badges data
  Future<void> saveBadges(List<String> badges) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(badges);
    await prefs.setString(_badgesKey, jsonString);
  }

  // Load Badges data
  Future<List<String>?> loadBadges() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_badgesKey);
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return List<String>.from(jsonList);
    }
    return null;
  }

  // Save CareEntry data
  Future<void> saveCareEntry(List<CareEntry> careEntries) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString =
        jsonEncode(careEntries.map((entry) => entry.toJson()).toList());
    await prefs.setString(_careEntryKey, jsonString);
  }

  // Load CareEntry data
  Future<List<CareEntry>?> loadCareEntry() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_careEntryKey);
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((entry) => CareEntry.fromJson(entry)).toList();
    }
    return null;
  }

  // Save Owned Skins data
  Future<void> saveOwnedSkins(List<String> ownedSkins) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(ownedSkins);
    await prefs.setString(_ownedSkinsKey, jsonString);
  }

  // Load Owned Skins data
  Future<List<String>?> loadOwnedSkins() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_ownedSkinsKey);
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return List<String>.from(jsonList);
    }
    return null;
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_userPlantsKey);
    await prefs.remove(_badgesKey);
    await prefs.remove(_careEntryKey);
    await prefs.remove(_ownedSkinsKey);
  }

  // Clear specific data
  Future<void> clearSpecificData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Check if data exists
  Future<bool> dataExists(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // Get all keys
  Future<List<String>> getAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().toList();
  }

  // Get specific data
  Future<String?> getSpecificData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Get all data
  Future<Map<String, dynamic>> getAllData() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> allData = {};
    for (String key in prefs.getKeys()) {
      allData[key] = prefs.getString(key);
    }
    return allData;
  }
}
