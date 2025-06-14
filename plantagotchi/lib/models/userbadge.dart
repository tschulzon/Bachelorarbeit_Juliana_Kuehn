import 'package:plantagotchi/models/badge.dart';

class UserBadge {
  String? id;
  PlantBadge? badge;
  DateTime? earnedAt;

  UserBadge({
    required this.id,
    required this.badge,
    required this.earnedAt,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      id: json['id'],
      badge: json['badge'] != null ? PlantBadge.fromJson(json['badge']) : null,
      earnedAt:
          json['earnedAt'] != null ? DateTime.parse(json['earnedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'badge': badge?.toJson(),
      'earnedAt': earnedAt?.toIso8601String(),
    };
  }
}
