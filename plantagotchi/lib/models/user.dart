import 'userplant.dart';

class User {
  String? id;
  String? username;
  String? profilePicture;
  int? level;
  int? xp;
  int? coins;
  List<String>? badges;
  List<UserPlants>? plants;
  // List<Friends>? friends;

  User({
    required this.id,
    required this.username,
    required this.profilePicture,
    this.level,
    this.xp,
    this.coins,
    this.badges,
    this.plants,
    // this.friends,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profilePicture': profilePicture,
      'level': level,
      'xp': xp,
      'coins': coins,
      'badges': badges,
      'plants': plants?.map((plant) => plant.toJson()).toList(),
      // 'friends': friends?.map((friend) => friend.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      profilePicture: json['profilePicture'],
      level: json['level'],
      xp: json['xp'],
      coins: json['coins'],
      badges: List<String>.from(json['badges'] ?? []),
      plants: json['plants'] != null
          ? (json['plants'] as List<dynamic>)
              .map((plant) => UserPlants.fromJson(plant))
              .toList()
          : null,
      // friends: (json['friends'] as List<dynamic>?)
      //     ?.map((friend) => Friends.fromJson(friend))
      //     .toList(),
    );
  }
}
