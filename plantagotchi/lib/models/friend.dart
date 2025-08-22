// Class representing a friend in the app
class Friend {
  String id;
  String name;
  String profileAvatar;
  int plantCount;
  int level;
  int xp;

  Friend({
    required this.id,
    required this.name,
    required this.profileAvatar,
    required this.plantCount,
    required this.level,
    required this.xp,
  });

  // This is the factory method to create a Friend object from a JSON map
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      name: json['name'],
      profileAvatar: json['profileAvatar'] ?? '',
      plantCount: json['plantCount'] ?? 0,
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0,
    );
  }

  // This is the method to convert the Friend object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileAvatar': profileAvatar,
      'plantCount': plantCount,
      'level': level,
      'xp': xp,
    };
  }
}
