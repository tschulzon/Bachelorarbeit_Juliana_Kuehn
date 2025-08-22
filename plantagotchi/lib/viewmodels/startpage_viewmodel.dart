import 'package:flutter/material.dart';
import 'package:plantagotchi/models/care_entry.dart';
import 'package:plantagotchi/models/userplant.dart';

// ViewModel for the Start Page
// This ViewModel manages the state and logic for the start page of the app
class StartpageViewModel extends ChangeNotifier {
  List<UserPlants> userPlants = [];
  final Map<String, List<Map<String, dynamic>>> _plantTasks = {};
  bool _showXpAnimation = false;
  bool get showXpAnimation => _showXpAnimation;

  StartpageViewModel({required this.userPlants});

  // This method can be used to trigger the XP animation
  // For example, when a task is completed or a care entry is added
  void triggerXPAnimation() {
    _showXpAnimation = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _showXpAnimation = false; // Reset after animation duration
      notifyListeners();
    });
  }

  //*** Show needed Tasks based on last care entrys ***/

  // Check if the current season is summer (May to September)
  // because watering and fertilizing intervals differ
  bool isSummer() {
    final month = DateTime.now().month;
    return month >= 5 && month <= 9;
  }

  // Check if a care task is due based on the last care entry
  bool isCareDue(UserPlants userPlant, String careType) {
    final now = DateTime.now();
    final currentSeason = isSummer() ? 'summer' : 'winter';

    final last = userPlant.getLastCareDate(careType);
    debugPrint('last date for $careType: $last');

    int intervalDays = 0;

    // Determine the interval days based on the care type and current season
    switch (careType) {
      case 'watering':
        intervalDays =
            userPlant.plantTemplate?.wateringReminderInterval?[currentSeason] ??
                0;
        debugPrint("Watering interval: $intervalDays");
        break;
      case 'fertilizing':
        intervalDays = userPlant
                .plantTemplate?.fertilizationReminderInterval?[currentSeason] ??
            0;
        break;
      default:
        intervalDays = 0; // Default to 0 if care type is not recognized
    }

    // If there is no last care entry, the task is due and should be performed
    if (last == null) {
      debugPrint("No last care entry found for $careType, task is due.");
      return true;
    }

    // Check if the difference in days is greater than or equal to the interval
    return now.difference(last).inDays >= intervalDays;
  }

  // Get a list of due tasks for a user plant
  List<Map<String, dynamic>>? getDueTasks(UserPlants userPlant) {
    // Initialize the list of due tasks
    List<Map<String, dynamic>> dueTasks = [];

    // Check if watering or fertilizing is due
    if (isCareDue(userPlant, 'watering')) {
      // Add watering task if due
      dueTasks.add({
        "careType": 'watering',
        "task": '${userPlant.nickname} gießen',
        "plantSentence": 'Ich bin durstig, bitte gieße mich!',
        "isChecked": false,
      });
    }
    if (isCareDue(userPlant, 'fertilizing')) {
      // Add fertilizing task if due
      dueTasks.add({
        "careType": 'fertilizing',
        "task": '${userPlant.nickname} düngen',
        "plantSentence": 'Ich bin hungrig, bitte füttere mich!',
        "isChecked": false,
      });
    }

    return dueTasks;
  }

  // Get tasks for a specific plant, initializing if not already done
  // It is for the CaretaskCheckbox widget to show the tasks
  // and for the StartPage to show the tasks in the plant card
  List<Map<String, dynamic>> getTasksForPlant(UserPlants plant) {
    final due = getDueTasks(plant) ?? [];
    return due
        .map((type) => {
              'careType': type['careType'],
              'task': type['task'],
              'isChecked': false,
            })
        .toList();
  }

  // Mark a task as checked
  void markTaskChecked(UserPlants plant, String careType) {
    final tasks = _plantTasks[plant.id];
    if (tasks == null) return;

    final task = tasks.firstWhere(
      (task) => task['careType'] == careType,
      orElse: () => {},
    );
    if (task.isNotEmpty) {
      task['isChecked'] = true;
      notifyListeners();
    }
  }

  // Add a care type entry to the user's plant
  void addCareTypeEntry(UserPlants userPlant, String careType, DateTime? date,
      String? note, String? photo) {
    DateTime now = DateTime.now();
    int countUserPlants = userPlants.length;

    String careId = 'care-${countUserPlants + 1}';

    final newEntry = CareEntry(
      id: careId,
      userPlantId: userPlant.id,
      type: careType,
      date: date ?? now,
      notes: note,
      photo: photo,
    );

    userPlant.careHistory ??= [];
    userPlant.careHistory!.add(newEntry);

    // Notify listeners to update the UI
    notifyListeners();
  }

  // Unmark Task for better Usability when User has accidentally checked a task
  // and wants to uncheck it without removing the care entry
  void unmarkTask(UserPlants plant, String careType) {
    final tasks = _plantTasks[plant.id];
    if (tasks == null) return;

    final task = tasks.firstWhere(
      (task) => task['careType'] == careType,
      orElse: () => {},
    );

    if (task.isNotEmpty) {
      task['isChecked'] = false;
      plant.careHistory?.removeWhere((entry) => entry.type == careType);
      notifyListeners();
    }
  }

  // Function to get the correct emotion avatar for a plant based on its care status
  String? getAvatarForPlant(UserPlants plant) {
    // Check if the plant is thirsty or hungry based on care due
    final thirstyPlant = isCareDue(plant, 'watering');
    final hungryPlant = isCareDue(plant, 'fertilizing');

    // Determine the avatar URL based on the plant's current skin and care status
    if (thirstyPlant) {
      return plant.currentSkin != null
          ? plant.ownedSkins
              ?.firstWhere((skin) => skin.id == plant.currentSkin)
              .skinThirsty // Use the skin's thirsty avatar if available
          : plant.plantTemplate?.avatarUrlThirsty;
    } else if (hungryPlant) {
      return plant.currentSkin != null
          ? plant.ownedSkins
              ?.firstWhere((skin) => skin.id == plant.currentSkin)
              .skinHungry // Use the skin's hungry avatar if available
          : plant.plantTemplate?.avatarUrlHungry;
    } else {
      return plant.currentSkin != null
          ? plant.ownedSkins
              ?.firstWhere((skin) => skin.id == plant.currentSkin)
              .skinUrl // Use the skin's normal avatar
          : plant.plantTemplate?.avatarUrl;
    }
  }
}
