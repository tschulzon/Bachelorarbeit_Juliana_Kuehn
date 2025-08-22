import 'package:plantagotchi/models/skin_item.dart';

// Class representing a plant template
// This class is used to define the properties of a plant that can be used in the app
class PlantTemplate {
  String id;
  String commonName;
  String scientificName;
  String family;
  String description;
  Map<String, String> wateringFrequency; // e.g., "summer", "winter"
  Map<String, int>? wateringReminderInterval; // e.g., 1 day, 2 days
  Map<String, String>? fertilizationFrequency;
  Map<String, int>? fertilizationReminderInterval;
  String lightRequirement;
  Map<String, String> temperatureRange;
  String soil;
  bool needsPruning;
  String? pruningMonths;
  bool flowers;
  String floweringSeason;
  String repotting;
  String growthRate;
  String careLevel;
  String location;
  bool isToxic;
  bool petFriendly;
  String? imageUrl;
  String? avatarUrl;
  String? avatarUrlThirsty;
  String? avatarUrlHungry;
  String? avatarUrlRepotting;
  List<SkinItem> avatarSkins;

  PlantTemplate({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.family,
    required this.description,
    required this.wateringFrequency,
    required this.wateringReminderInterval,
    required this.fertilizationFrequency,
    required this.fertilizationReminderInterval,
    required this.lightRequirement,
    required this.temperatureRange,
    required this.soil,
    required this.needsPruning,
    required this.pruningMonths,
    required this.flowers,
    required this.floweringSeason,
    required this.repotting,
    required this.growthRate,
    required this.careLevel,
    required this.location,
    required this.isToxic,
    required this.petFriendly,
    required this.imageUrl,
    required this.avatarUrl,
    required this.avatarUrlThirsty,
    required this.avatarUrlHungry,
    required this.avatarUrlRepotting,
    required this.avatarSkins,
  });

  // This is the method to convert the PlantTemplate object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commonName': commonName,
      'scientificName': scientificName,
      'family': family,
      'description': description,
      'wateringFrequency': wateringFrequency,
      'wateringReminderInterval': wateringReminderInterval,
      'fertilizationFrequency': fertilizationFrequency,
      'fertilizationReminderInterval': fertilizationReminderInterval,
      'lightRequirement': lightRequirement,
      'temperatureRange': temperatureRange,
      'soil': soil,
      'needsPruning': needsPruning,
      'pruningMonths': pruningMonths,
      'flowers': flowers,
      'floweringSeason': floweringSeason,
      'repotting': repotting,
      'growthRate': growthRate,
      'careLevel': careLevel,
      'location': location,
      'isToxic': isToxic,
      'petFriendly': petFriendly,
      'imageUrl': imageUrl,
      'avatarUrl': avatarUrl,
      'avatarUrlThirsty': avatarUrlThirsty,
      'avatarUrlHungry': avatarUrlHungry,
      'avatarUrlRepotting': avatarUrlRepotting,
      'avatarSkins': avatarSkins,
    };
  }

  // This is the factory method to create a PlantTemplate object from a JSON map
  factory PlantTemplate.fromJson(Map<String, dynamic> json) {
    return PlantTemplate(
      id: json['id'],
      commonName: json['commonName'],
      scientificName: json['scientificName'],
      family: json['family'],
      description: json['description'],
      wateringFrequency: Map<String, String>.from(json['wateringFrequency']),
      wateringReminderInterval: json['wateringReminderInterval'] != null
          ? Map<String, int>.from(json['wateringReminderInterval'])
          : null,
      fertilizationFrequency:
          json['fertilizationFrequency'] as Map<String, String>?,
      fertilizationReminderInterval:
          json['fertilizationReminderInterval'] != null
              ? Map<String, int>.from(json['fertilizationReminderInterval'])
              : null,
      lightRequirement: json['lightRequirement'],
      temperatureRange: Map<String, String>.from(json['temperatureRange']),
      soil: json['soil'],
      needsPruning: json['needsPruning'],
      pruningMonths: json['pruningMonths'] ?? "-",
      flowers: json['flowers'],
      floweringSeason: json['floweringSeason'],
      repotting: json['repotting'],
      growthRate: json['growthRate'],
      careLevel: json['careLevel'],
      location: json['location'],
      isToxic: json['isToxic'],
      petFriendly: json['petFriendly'],
      imageUrl: json['imageUrl'] ?? "-",
      avatarUrl: json['avatarUrl'] ?? "-",
      avatarUrlThirsty: json['avatarUrlThirsty'] ?? "-",
      avatarUrlHungry: json['avatarUrlHungry'] ?? "-",
      avatarUrlRepotting: json['avatarUrlRepotting'] ?? "-",
      avatarSkins: (json['avatarSkins'] as List<dynamic>?)
              ?.map((item) => SkinItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
