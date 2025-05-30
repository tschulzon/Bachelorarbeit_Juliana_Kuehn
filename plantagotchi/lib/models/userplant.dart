import 'package:plantagotchi/models/care_entry.dart';
import 'package:plantagotchi/models/plant_template.dart';

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
  });

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
    );
  }

  // Help method for getting last care entry for every care type
  DateTime? getLastCareDate(String careType) {
    final entriesOfType = careHistory!
        .where((entry) => entry.type == careType)
        .toList()
      ..sort((a, b) => b.date!.compareTo(a.date!)); // Newest Entry first

    return entriesOfType.isNotEmpty ? entriesOfType.first.date : null;
  }
}
