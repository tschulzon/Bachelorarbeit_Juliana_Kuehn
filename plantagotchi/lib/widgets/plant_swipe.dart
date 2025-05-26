import 'package:flutter/material.dart';
import 'package:plantagotchi/models/userplant.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
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

  @override
  Widget build(BuildContext context) {
    final startPageViewModel = Provider.of<StartpageViewModel>(context);
    final fontstyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    for (var p in widget.plants) {
      debugPrint('Plant: ${p.nickname}, ID: ${p.id}');
    }

    return SizedBox(
        height: 600,
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.plants.length,
          itemBuilder: (context, index) {
            final plant = widget.plants[index];
            final dueTasks = startPageViewModel.getDueTasks(plant);
            debugPrint(
                'Current Plant: ${plant.nickname}, Due Tasks: $dueTasks'); // Debugging line

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row with Text and Icon Button
                // Plant Image with speech Bubbles and arrows
                SizedBox(
                  height: 180,
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
                          plant.avatarSkin ??
                              'assets/images/avatars/kaktus-white-removebg-preview.png',
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Speech bubble and triangle below
                Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none, // Allow overflow for the triangle
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
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
                              child: Text(
                                  'Pflegeaufgaben für ${plant.nickname}',
                                  style: fontstyle.bodyMedium),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_square),
                            color: colors.primary,
                            onPressed: () => debugPrint('Edit button pressed'),
                          ),
                        ],
                      ),
                      CaretaskCheckbox(
                          plant: plant, viewModel: startPageViewModel)
                      // Compact rows for tasks
                      // ...(dueTasks.isEmpty
                      //     ? [
                      //         Padding(
                      //           padding:
                      //               const EdgeInsets.symmetric(vertical: 8.0),
                      //           child: Text(
                      //             '${plant.nickname} ist wunschlos glücklich! 🌞',
                      //             style: fontstyle.bodyMedium,
                      //           ),
                      //         )
                      //       ]
                      //     : dueTasks
                      //         .map((task) => Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                   vertical: 2.0),
                      //               child: Row(
                      //                 children: [
                      //                   Expanded(
                      //                     child: Text(
                      //                       task['task']!,
                      //                       style: fontstyle.labelSmall,
                      //                     ),
                      //                   ),
                      //                   Checkbox(
                      //                     value: task['isChecked'],
                      //                     onChanged: (_) {
                      //                       startPageViewModel.addCareTypeEntry(
                      //                           plant, task['careType']!);

                      //                       setState(() {
                      //                         task['isChecked'] = true;
                      //                       });
                      //                     },
                      //                     visualDensity: VisualDensity.compact,
                      //                     materialTapTargetSize:
                      //                         MaterialTapTargetSize.shrinkWrap,
                      //                   ),
                      //                 ],
                      //               ),
                      //             ))
                      //         .toList())
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}
