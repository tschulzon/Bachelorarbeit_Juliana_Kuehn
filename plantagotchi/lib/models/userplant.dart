import 'package:plantagotchi/models/care_entry.dart';
import 'package:plantagotchi/models/plant_template.dart';
import 'package:plantagotchi/models/skin_item.dart';

class UserPlants {
  String? id;
  String? userId;
  PlantTemplate? plantTemplate;
  String? nickname;
  String? plantImage;
  String? avatarSkin;
  DateTime? dateAdded;
  String? location;
  List<CareEntry>? careHistory;
  DateTime? lastWatered;
  DateTime? lastFertilized;
  List<SkinItem>? ownedSkins;
  String? currentSkin;

  UserPlants({
    this.id,
    this.userId,
    this.plantTemplate,
    this.nickname,
    this.plantImage,
    this.avatarSkin,
    this.dateAdded,
    this.location,
    this.careHistory,
    this.lastWatered,
    this.lastFertilized,
    this.ownedSkins,
    String? currentSkin,
  }) {
    // Ensure ownedSkins is initialized to an empty list if null
    if (ownedSkins == null || ownedSkins!.isEmpty) {
      ownedSkins = [
        SkinItem(
          id: 'skin-0',
          name: 'Standard',
          price: 0,
          skinUrl: plantTemplate?.avatarUrl ?? '',
          skinThirsty: plantTemplate?.avatarUrlThirsty ?? '',
          skinHungry: plantTemplate?.avatarUrlHungry ?? '',
        ),
      ];
    }
    // If currentSkin is null, set it to the first skin in ownedSkins or an empty string
    this.currentSkin = currentSkin ??
        (ownedSkins?.isNotEmpty == true ? ownedSkins![0].id : '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'plantTemplate': plantTemplate?.toJson(),
      'nickname': nickname,
      'plantImage': plantImage,
      'avatarSkin': avatarSkin,
      'dateAdded': dateAdded?.toIso8601String(),
      'location': location,
      'careHistory': careHistory ?? [],
      'lastWatered': lastWatered?.toIso8601String(),
      'lastFertilized': lastFertilized?.toIso8601String(),
      'ownedSkins': ownedSkins?.map((skin) => skin.toJson()).toList(),
      'currentSkin': currentSkin,
    };
  }

// Daraus lesen wir Daten aus dem JSON File und erstellen ein Dart Objekt
  factory UserPlants.fromJson(Map<String, dynamic> json) {
    return UserPlants(
      id: json['id'],
      userId: json['userId'],
      plantTemplate: json['plantTemplate'] != null
          ? PlantTemplate.fromJson(json['plantTemplate'])
          : null,
      nickname: json['nickname'],
      plantImage: json['plantImage'],
      avatarSkin: json['avatarSkin'],
      dateAdded: json['dateAdded'] != null
          ? DateTime.tryParse(json['dateAdded'])
          : null,
      location: json['location'],
      careHistory: (json['careHistory'] as List?)
          ?.map((entry) => CareEntry.fromJson(entry))
          .toList(),
      lastWatered: json['lastWatered'] != null
          ? DateTime.tryParse(json['lastWatered'])
          : null,
      lastFertilized: json['lastFertilized'] != null
          ? DateTime.tryParse(json['lastFertilized'])
          : null,
      ownedSkins: (json['ownedSkins'] as List?)
          ?.map((skin) => SkinItem.fromJson(skin))
          .toList(),
      currentSkin: json['currentSkin'],
    );
  }

  // Help method for getting last care entry for every care type
  DateTime? getLastCareDate(String careType) {
    final entriesOfType = careHistory!
        .where((entry) => entry.type == careType)
        .toList()
      ..sort((a, b) => b.date!.compareTo(a.date!)); // Newest Entry first

    if (entriesOfType.isNotEmpty) {
      return entriesOfType.first.date;
    }

    if (entriesOfType.isEmpty && careType == 'watering') {
      return lastWatered;
    } else if (entriesOfType.isEmpty && careType == 'fertilizing') {
      return lastFertilized;
    }
  }
}
