import 'userplant.dart';

class User {
  String? id;
  String? username;
  String? profilePicture;
  String? email;
  String? password;
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
    this.email,
    this.password,
    this.level,
    this.xp,
    this.coins,
    this.badges,
    this.plants,
    // this.friends,
  });
}
