import 'package:flutter/material.dart';
import 'package:plantagotchi/models/userplant.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/widgets/action_button.dart';
import 'package:plantagotchi/widgets/bottom_modal.dart';
import 'package:plantagotchi/widgets/caretask_checkbox.dart';
import 'package:provider/provider.dart';

class PlantSwipe extends StatefulWidget {
  final List<UserPlants> plants;

  const PlantSwipe({
    super.key,
    required this.plants,
  });

  @override
  State<PlantSwipe> createState() => _PlantSwipeState();
}

class _PlantSwipeState extends State<PlantSwipe> {
  final PageController _controller = PageController();

  // Function to get the avatar for a plant based on its care status
  String? getAvatarForPlant(UserPlants plant, StartpageViewModel viewModel) {
    final thirstyPlant = viewModel.isCareDue(plant, 'watering');
    final hungryPlant = viewModel.isCareDue(plant, 'fertilizing');

    if (thirstyPlant) {
      return plant.plantTemplate?.avatarUrlThirsty!;
    } else if (hungryPlant) {
      return plant.plantTemplate?.avatarUrlHungry!;
    } else {
      return plant.plantTemplate?.avatarUrl;
    }
  }

  void testDebugPrint() {
    debugPrint("Button pressed");
  }

  void openBottomModalSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => const BottomModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final startPageViewModel = Provider.of<StartpageViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final fontstyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    for (var p in widget.plants) {
      debugPrint('Plant: ${p.nickname}, ID: ${p.id}');
    }

    return PageView.builder(
      controller: _controller,
      itemCount: widget.plants.length,
      itemBuilder: (context, index) {
        final plant = widget.plants[index];
        final dueTasks = startPageViewModel.getDueTasks(plant);
        final avatarPath = getAvatarForPlant(plant, startPageViewModel);

        debugPrint(
            'Current Plant: ${plant.nickname}, Due Tasks: $dueTasks'); // Debugging line

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row with Text and Icon Button
            // Plant Image with speech Bubbles and arrows
            SizedBox(
              height: 170,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Left arrow
                  Positioned(
                    left: 0,
                    child: Icon(Icons.chevron_left,
                        size: 32, color: colors.primary),
                  ),
                  // Right arrow
                  Positioned(
                    right: 0,
                    child: Icon(Icons.chevron_right,
                        size: 32, color: colors.primary),
                  ),
                  // Plant Image
                  Center(
                    child: Image.asset(
                      avatarPath!,
                      // height: 180,
                      // width: 180,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Speech bubble and triangle below
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none, // Allow overflow for the triangle
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    dueTasks!.isNotEmpty
                        ? dueTasks.first['plantSentence']!
                        : 'Mir geht es gut! 🥰',
                    style: fontstyle.titleLarge,
                  ),
                ),
                Positioned(
                  top: null,
                  bottom: 35, // Adjust as needed to overlap the bubble
                  left: -0,
                  right: 0,
                  child: Center(
                    child: Transform.rotate(
                      angle: 3.14 / 4,
                      child: Container(
                        width: 16,
                        height: 16,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Box with Texts and Checkboxes
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: colors.primary),
                boxShadow: [
                  BoxShadow(
                    color: colors.onSurface.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('Pflegeaufgaben für ${plant.nickname}',
                              style: fontstyle.bodyMedium),
                        ),
                      ),
                    ],
                  ),
                  CaretaskCheckbox(plant: plant, viewModel: startPageViewModel),
                  const SizedBox(height: 5),
                  ActionButton(
                      label: "Aktivität hinzufügen",
                      onPressed: () => openBottomModalSheet(context),
                      greenToYellow: false),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
