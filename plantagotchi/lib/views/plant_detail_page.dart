import 'package:flutter/material.dart';
import 'package:plantagotchi/models/userplant.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/views/add_plant_dialog.dart';
import 'package:plantagotchi/widgets/action_button.dart';
import 'package:plantagotchi/widgets/bottom_modal.dart';
import 'package:plantagotchi/widgets/horizontal_button_row.dart';
import 'package:plantagotchi/widgets/list_info_cards.dart';
import 'package:plantagotchi/widgets/userplant_history.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PlantDetailPage extends StatelessWidget {
  Map<String, dynamic> plant;
  UserPlants? userPlant;

  PlantDetailPage({
    super.key,
    this.plant = const {},
    this.userPlant,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context);
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final ItemScrollController itemScrollController = ItemScrollController();

    final labels = [
      "Beschreibung",
      "Pflege",
      "Wasser",
      "Licht",
      "Temperatur",
      "Dünger",
      "Zuschneiden",
      "Umtopfen",
      "Blüte",
      "Standort",
      "Giftig",
    ];

    final sections = buildInfoCards(
        plant: plant.isNotEmpty
            ? plant
            : (userPlant?.plantTemplate?.toJson() ?? {}),
        fontstyle: fontstyle,
        colors: colors,
        viewModel: viewModel);

    void openBottomModalSheet(BuildContext context, UserPlants plant) {
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => BottomModal(plant: plant),
      );
    }

    print("CURRENT PLANT: $plant");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: double.infinity,
                  child: Image.asset(
                    plant.isNotEmpty
                        ? (plant['imageUrl'] ?? '')
                        : (userPlant?.plantTemplate!.imageUrl ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: CircleAvatar(
                      backgroundColor: colors.primary,
                      child: Icon(Icons.arrow_back, color: colors.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
            // Fixed Area
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                plant.isNotEmpty
                                    ? (plant['commonName'] ?? '')
                                    : (userPlant?.nickname ?? ''),
                                style: fontstyle.headlineLarge,
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ),
                            if (userPlant != null)
                              IconButton(
                                icon: const Icon(Icons.edit_square),
                                color: colors.primary,
                                onPressed: () async {
                                  final newName = await showDialog<String>(
                                    context: context,
                                    builder: (context) {
                                      final controller = TextEditingController(
                                          text: userPlant?.nickname ?? '');
                                      return AlertDialog(
                                        title: Text(
                                          'Spitzname ändern',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: colors.primary,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        content: TextField(
                                          controller: controller,
                                          maxLength: 15,
                                          style: TextStyle(
                                            color: colors.primary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ActionButton(
                                                  label: "Abbrechen",
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  greenToYellow: false),
                                              const SizedBox(width: 10),
                                              ActionButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(controller.text),
                                                label: "Speichern",
                                                greenToYellow: false,
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (newName != null &&
                                      newName.isNotEmpty &&
                                      userPlant != null) {
                                    userViewModel.updateUserPlantNickname(
                                        userPlant!.id!, newName);
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                      if (userPlant != null) ...[
                        const SizedBox(width: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.auto_stories),
                            color: colors.onPrimary,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UserplantHistory(
                                    userplant: userPlant,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          plant.isNotEmpty
                              ? (plant['careLevel'] ?? '')
                              : (userPlant?.plantTemplate!.careLevel ?? ''),
                          style: fontstyle.labelSmall?.copyWith(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1,
                    height: 24,
                  ),
                  Text(
                    plant.isNotEmpty
                        ? (plant['scientificName'] ?? '')
                        : (userPlant?.plantTemplate!.scientificName ?? ''),
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.primary,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 10),
                  HorizontalButtonRow(
                    labels: labels,
                    onSelected: (index) {
                      itemScrollController.scrollTo(
                        index: index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ],
              ),
            ),
            // Scrollable List
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                itemCount: sections.length,
                itemBuilder: (context, index) => sections[index],
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: userPlant != null
          ? FloatingActionButton(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              onPressed: () => openBottomModalSheet(context, userPlant!),
              child: const Icon(Icons.add_circle),
            )
          : null,
      bottomNavigationBar: plant.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colors.primary, width: 1),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 5.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    icon: const Icon(Icons.add_circle),
                    label: const Text('Hinzufügen',
                        style: TextStyle(fontSize: 14)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddPlantDialog(
                            plant: plant,
                          ),
                        ),
                      );
                    },
                  )),
            )
          : null,
    );
  }
}
