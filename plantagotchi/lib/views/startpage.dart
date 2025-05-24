import 'package:flutter/material.dart';
import 'package:plantagotchi/utils/material_symbols.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/widgets/action_button.dart';
import 'package:provider/provider.dart';

class Startpage extends StatelessWidget {
  const Startpage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context);
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final user = Provider.of<UserViewModel>(context).user;
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    print("UserViewModel.user: ${user.username}, Streak: ${user.streak}");

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Zählerstand',
            ),
            Text(
              '${viewModel.counter}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            ActionButton(
              label: 'Erhöhe streak',
              onPressed: userViewModel.incrementStreak,
              greenToYellow: false,
            ),
          ],
        ),
      ),
    );
  }
}
