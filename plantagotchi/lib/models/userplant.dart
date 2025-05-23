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
  List<CareEntry>? careHistory;

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
}
