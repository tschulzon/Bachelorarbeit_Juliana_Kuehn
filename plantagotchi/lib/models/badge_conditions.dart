import 'package:plantagotchi/viewmodels/user_viewmodel.dart';

// class representing conditions for earning badges
class BadgeConditions {
  final String activity;
  final String badgeId;
  final bool Function(UserViewModel user)
      condition; // Function to check if the condition is met

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
  // Badge for pruning the first plant ever
  BadgeConditions(
    activity: 'pruning',
    badgeId: 'badge-pruning-1',
    condition: (user) => user.careHistory['pruning']?.isEmpty ?? true,
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
  // Badge for taking care of 5 plants
  // it checks if the user has 5 plants and has every care entry for each plant
  BadgeConditions(
    activity: 'any',
    badgeId: 'badge-care-1',
    condition: (user) =>
        user.user.plants?.length == 5 && user.hasEveryPlantCareEntrys(),
  ),
  BadgeConditions(
    activity: 'newSkin',
    badgeId: 'badge-skin-1',
    condition: (user) =>
        user.user.plants?.any((plant) => plant.ownedSkins!.isNotEmpty) ?? false,
  )
];
