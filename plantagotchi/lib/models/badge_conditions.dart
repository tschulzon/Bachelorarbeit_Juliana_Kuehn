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

final List<BadgeConditions> badgeConditions = [
  BadgeConditions(
    activity: 'watering',
    badgeId: 'badge-watering-1',
    condition: (user) => user.careHistory['watering']?.isEmpty ?? true,
  ),
  BadgeConditions(
    activity: 'fertilizing',
    badgeId: 'badge-fertilizing-1',
    condition: (user) => user.careHistory['fertilizing']?.isEmpty ?? true,
  ),
  BadgeConditions(
    activity: 'repotting',
    badgeId: 'badge-repotting-1',
    condition: (user) => user.careHistory['repotting']?.isEmpty ?? true,
  ),
  BadgeConditions(
    activity: 'newPlant',
    badgeId: 'badge-newplant-1',
    condition: (user) => user.user.plants?.length == 1,
  ),
  BadgeConditions(
    activity: 'newPlant',
    badgeId: 'badge-newplant-2',
    condition: (user) => user.user.plants?.length == 5,
  ),
  BadgeConditions(
    activity: 'newPlant',
    badgeId: 'badge-newplant-3',
    condition: (user) => user.user.plants?.length == 10,
  ),
  BadgeConditions(
    activity: 'photo',
    badgeId: 'badge-photo-1',
    condition: (user) => user.careHistory['photo']?.isEmpty ?? true,
  ),
  // This badge checks if the user has 5 plants and has every care entry for each plant
  BadgeConditions(
    activity: 'any',
    badgeId: 'badge-care-1',
    condition: (user) =>
        user.user.plants?.length == 5 && user.hasEveryPlantCareEntrys(),
  ),
];
