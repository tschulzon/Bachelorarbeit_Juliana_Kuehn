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
  List<dynamic>? careHistory;

  UserPlants({
    this.id,
    this.userId,
    this.plantTemplate,
    this.nickname,
    this.plantImage,
    this.avatarSkin,
    this.dateAdded,
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
      careHistory: json['careHistory'] ?? [],
    );
  }
}
