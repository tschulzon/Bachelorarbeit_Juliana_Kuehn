import 'package:plantagotchi/models/badge.dart';

class UserBadge {
  String? id;
  Badge? badge;
  DateTime? earnedAt;

  UserBadge({
    required this.id,
    required this.badge,
    required this.earnedAt,
  });
}
