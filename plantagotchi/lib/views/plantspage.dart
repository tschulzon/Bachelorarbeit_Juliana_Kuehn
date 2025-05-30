import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Plantspage extends StatelessWidget {
  const Plantspage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context);
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final user = Provider.of<UserViewModel>(context).user;
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_florist, color: colors.primary),
                const SizedBox(width: 4),
                Text('Meine Pflanzen', style: fontstyle.labelMedium),
              ],
            ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Center(
            child: ToggleSwitch(
              animate: true,
              animationDuration: 500,
              curve: Curves.ease,
              minWidth: 150,
              initialLabelIndex: 0,
              totalSwitches: 3,
              labels: ['Pflanzen', 'Standorte', 'Historie'],
              onToggle: (index) {
                print('switched to: $index');
              },
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: user.plants?.length ?? 0,
          //     itemBuilder: (context, index) {
          //       final plant = user.plants![index];
          //       return ListTile(
          //         title: Text(plant.name),
          //         subtitle: Text('Pflegelevel: ${plant.careLevel}'),
          //         leading: CircleAvatar(
          //           backgroundImage: AssetImage(plant.imagePath),
          //         ),
          //         onTap: () {
          //           // viewModel.selectPlant(plant);
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
