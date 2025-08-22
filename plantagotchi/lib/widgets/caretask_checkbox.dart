import 'package:flutter/material.dart';
import 'package:plantagotchi/models/userplant.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

// This widget displays a list of care tasks for a specific plant
// It allows the user to check off tasks as they are completed
class CaretaskCheckbox extends StatelessWidget {
  final UserPlants plant;
  final StartpageViewModel viewModel;

  const CaretaskCheckbox({
    super.key,
    required this.plant,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final fontstyle = Theme.of(context).textTheme;
    final userViewModel = Provider.of<UserViewModel>(context, listen: true);

    // This widget listens to the StartpageViewModel for changes in tasks
    // It rebuilds the list of tasks whenever the tasks change
    return Consumer<StartpageViewModel>(builder: (context, viewModel, _) {
      final tasks = viewModel.getTasksForPlant(plant);
      return Column(
        children: tasks.map((task) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(task['task'], style: fontstyle.labelSmall)),
                Checkbox(
                  value: task['isChecked'],
                  onChanged: (checked) {
                    if (checked == true) {
                      viewModel.addCareTypeEntry(
                          plant, task['careType'], null, null, null);
                      userViewModel.checkIfUserGetBadgeForActivity(
                          task['careType'], context);
                      viewModel.markTaskChecked(plant, task['careType']);
                      userViewModel.addXP(task['careType'], context);
                      viewModel.triggerXPAnimation();
                    } else {
                      viewModel.unmarkTask(plant, task['careType']);
                      userViewModel.removeXP(task['careType']);
                    }
                  },
                  side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .primary, // Border color for empty checkbox
                    width: 2,
                  ),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
