import 'package:flutter/material.dart';
import 'package:plantagotchi/models/plant_template.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/widgets/horizontal_button_row.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PlantDetailPage extends StatelessWidget {
  final Map<String, dynamic> plant;

  const PlantDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context);
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final user = Provider.of<UserViewModel>(context).user;
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final labels = [
      "Pflege",
      "Wasser",
      "Licht",
      "Temperatur",
      "Dünger",
      "Zuschneiden",
      "Umtopfen"
    ];

    print("CURRENT PLANT: ${plant}");

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Other AppBar because here the Image should be in the upper third
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.33,
            pinned: true,
            backgroundColor: colors.primary,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: CircleAvatar(
                  backgroundColor: colors.primary,
                  child: Icon(Icons.arrow_back, color: colors.onPrimary),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: colors.primary))),
                child: Image.asset(
                  plant['imageUrl'] ?? 'assets/images/avatars/plant-transp.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant['commonName'] ?? '',
                    style: fontstyle.headlineLarge,
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1,
                    height: 24,
                    indent: 0,
                    endIndent: 0,
                  ),
                  // const SizedBox(height: 12),
                  Text(
                    plant['scientificName'] ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        color: colors.primary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 20),
                  HorizontalButtonRow(
                      labels: labels,
                      onSelected: (index) {
                        print("Ausgewählt: $index");
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
