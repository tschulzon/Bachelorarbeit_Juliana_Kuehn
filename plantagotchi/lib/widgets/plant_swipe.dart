import 'package:flutter/material.dart';
import 'package:plantagotchi/models/userplant.dart';

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
    final fontstyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
        height: 600,
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.plants.length,
          itemBuilder: (context, index) {
            final plant = widget.plants[index];
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
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text('Ich brauche Wasser!',
                          style: fontstyle.titleLarge),
                    ),
                    //Triangle below the bubble
                    Transform.translate(
                      offset: const Offset(-80, -48),
                      child: Transform.rotate(
                        angle: 3.14 / 4, // Rotate to point downwards
                        child: Container(
                          width: 16,
                          height: 16,
                          color: colors.primary,
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
                                  style: fontstyle.labelSmall),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_square),
                            color: colors.primary,
                            onPressed: () => debugPrint('Edit button pressed'),
                          ),
                        ],
                      ),
                      // Compact rows for tasks
                      ...[
                        'Gießen',
                        'Düngen',
                        'Blätter abwischen',
                      ].map((task) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(task,
                                        style: fontstyle.labelSmall)),
                                Checkbox(
                                  value: false,
                                  onChanged: (_) {},
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}
