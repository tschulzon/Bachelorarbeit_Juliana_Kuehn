import 'package:flutter/material.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/widgets/plant_swipe.dart';
import 'package:provider/provider.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

// This is the Startpage view
// It displays the user's current plants, experience points, level, and streak and tasks for the plants
class Startpage extends StatefulWidget {
  const Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context, listen: true);
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final user = Provider.of<UserViewModel>(context).user;
    final userViewModel = Provider.of<UserViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Left: Streak
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.local_fire_department, color: colors.primary),
                    const SizedBox(width: 4),
                    Text('${user.streak}', style: fontstyle.labelSmall),
                  ],
                ),
              ),
              // Center: Plants
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_florist, color: colors.primary),
                    const SizedBox(width: 4),
                    Text('${user.plants?.length ?? 0}',
                        style: fontstyle.labelSmall),
                  ],
                ),
              ),
              // Right: Coins
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.paid, color: colors.primary),
                    const SizedBox(width: 4),
                    Text('${user.coins}', style: fontstyle.labelSmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Center(
            child: Container(
              width: 300,
              color: colors.primary,
              height: 1.0,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '${user.xp} Erfahrungspunkte', // Top text
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: colors.primary),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left: Icon + Text
                    Column(
                      children: [
                        Icon(Icons.workspace_premium,
                            color: colors.primary, size: 32),
                        const SizedBox(height: 4),
                        Text('Level ${user.level}',
                            style: fontstyle.labelSmall),
                      ],
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    // Right: ProgressBar + Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 60),
                            child: AnimatedSlide(
                              duration: const Duration(milliseconds: 700),
                              offset: viewModel.showXpAnimation
                                  ? const Offset(0, 0)
                                  : const Offset(0, -1),
                              curve: Curves.easeOut,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 700),
                                opacity: viewModel.showXpAnimation ? 1.0 : 0.0,
                                curve: Curves.easeInOut,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '+${userViewModel.addedXP} XP',
                                    style: fontstyle.labelMedium!
                                        .copyWith(color: colors.onPrimary),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          LinearProgressBar(
                            maxSteps: userViewModel.neededXPforLevelUp,
                            progressType: LinearProgressBar.progressTypeLinear,
                            currentStep: user.xp ?? 0,
                            progressColor: colors.secondary,
                            backgroundColor: colors.secondary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(height: 4),
                          Center(
                              child: Text(
                                  'noch ${userViewModel.restXP} XP bis zum nächsten Level!',
                                  style: fontstyle.bodySmall)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Center(
                    child: Container(
                      width: 300,
                      color: colors.primary,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (user.plants == null || user.plants!.isEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Du hast noch keine Pflanzen! Füge welche hinzu, um sie zu pflegen.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            // Display the user's plants using PlantSwipe widget
            Expanded(child: PlantSwipe(plants: user.plants ?? [])),
        ],
      ),
    );
  }
}
