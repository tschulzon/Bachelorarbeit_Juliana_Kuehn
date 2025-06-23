import 'package:plantagotchi/viewmodels/user_viewmodel.dart';

class BadgeConditions {
  final String activity;
  final String badgeId;
  final bool Function(UserViewModel user) condition;

  BadgeConditions({
    required this.activity,
    required this.badgeId,
    required this.condition,
  });
}

// List of badge conditions for different activities
final List<BadgeConditions> badgeConditions = [
  // Badge for watering the first plant ever
  BadgeConditions(
    activity: 'watering',
    badgeId: 'badge-watering-1',
    condition: (user) => user.careHistory['watering']?.isEmpty ?? true,
  ),
  // Badge for fertilizing the first plant ever
  BadgeConditions(
    activity: 'fertilizing',
    badgeId: 'badge-fertilizing-1',
    condition: (user) => user.careHistory['fertilizing']?.isEmpty ?? true,
  ),
  // Badge for repotting the first plant ever
  BadgeConditions(
    activity: 'repotting',
    badgeId: 'badge-repotting-1',
    condition: (user) => user.careHistory['repotting']?.isEmpty ?? true,
  ),
  // Badge for adding the first plant ever
  BadgeConditions(
    activity: 'newPlant',
    badgeId: 'badge-newplant-1',
    condition: (user) => user.user.plants?.length == 1,
  ),
  // Badge for adding the fifth plant
  BadgeConditions(
    activity: 'newPlant',
    badgeId: 'badge-newplant-2',
    condition: (user) => user.user.plants?.length == 5,
  ),
  // Badge for adding the tenth plant
  BadgeConditions(
    activity: 'newPlant',
    badgeId: 'badge-newplant-3',
    condition: (user) => user.user.plants?.length == 10,
  ),
  // Badge for taking a photo of the first plant ever
  BadgeConditions(
    activity: 'photo',
    badgeId: 'badge-photo-1',
    condition: (user) => user.careHistory['photo']?.isEmpty ?? true,
  ),
  // Badge for taking care of 5 plants
  // it checks if the user has 5 plants and has every care entry for each plant
  BadgeConditions(
    activity: 'any',
    badgeId: 'badge-care-1',
    condition: (user) =>
        user.user.plants?.length == 5 && user.hasEveryPlantCareEntrys(),
  ),
];
