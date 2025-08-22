import 'package:plantagotchi/models/badge.dart';

// Class representing a user badge
// This class is used to associate a badge with a user and track when it was earned
class UserBadge {
  String? id;
  PlantBadge? badge;
  DateTime? earnedAt;

  UserBadge({
    required this.id,
    required this.badge,
    required this.earnedAt,
  });

  // This is the factory method to create a UserBadge object from a JSON map
  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      id: json['id'],
      badge: json['badge'] != null ? PlantBadge.fromJson(json['badge']) : null,
      earnedAt:
          json['earnedAt'] != null ? DateTime.parse(json['earnedAt']) : null,
    );
  }

  // This is the method to convert the UserBadge object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'badge': badge?.toJson(),
      'earnedAt': earnedAt?.toIso8601String(),
    };
  }
}
