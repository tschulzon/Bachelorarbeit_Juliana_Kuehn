import 'package:plantagotchi/models/friend.dart';

import 'userplant.dart';

class User {
  String? id;
  String? username;
  String? profilePicture;
  int? level;
  int? xp;
  int? coins;
  int? streak;
  List<String>? badges;
  List<UserPlants>? plants;
  List<Friend>? friends;

  User({
    required this.id,
    required this.username,
    required this.profilePicture,
    this.level,
    this.xp,
    this.coins,
    this.streak,
    this.badges,
    this.plants,
    this.friends,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profilePicture': profilePicture,
      'level': level,
      'xp': xp,
      'coins': coins,
      'streak': streak,
      'badges': badges,
      'plants': plants?.map((plant) => plant.toJson()).toList(),
      'friends': friends?.map((friend) => friend.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    print("streak raw value: ${json['streak']}"); // Debug output
    return User(
      id: json['id'],
      username: json['username'],
      profilePicture: json['profilePicture'],
      level: json['level'],
      xp: json['xp'],
      coins: json['coins'],
      streak: json['streak'],
      badges: List<String>.from(json['badges'] ?? []),
      plants: json['plants'] != null
          ? (json['plants'] as List<dynamic>)
              .map((plant) => UserPlants.fromJson(plant))
              .toList()
          : null,
      friends: json['friends'] != null
          ? (json['friends'] as List<dynamic>)
              .map((friend) => Friend.fromJson(friend))
              .toList()
          : null,
    );
  }
}
