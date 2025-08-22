import 'dart:convert';
import 'package:plantagotchi/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Service for managing shared preferences in the app
// This service provides methods to save, load, and clear user data
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
  }

  // Load User data
  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    // For cleaning everything, remove this line in production
    await prefs.clear();
    String? jsonString = prefs.getString(_userKey);
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return User.fromJson(jsonMap);
    }
    return null;
  }

  // Helper methods to clear data, clear specific data, check if data exists, get all keys, get specific data, and get all data
  // Maybe for further use in the app
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
