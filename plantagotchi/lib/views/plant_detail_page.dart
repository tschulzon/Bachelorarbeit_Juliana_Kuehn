import 'package:flutter/material.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/widgets/horizontal_button_row.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

    final ItemScrollController itemScrollController = ItemScrollController();

    final List<Widget> sections = [
      // 0: Beschreibung
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Beschreibung',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  // const SizedBox(width: 16.0),
                  // Icon(
                  //   Icons.info,
                  //   color: colors.onPrimary,
                  //   size: 30,
                  // ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '${plant['description'] ?? "Keine Beschreibung vorhanden"}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5A7302),
                      ),
                    ),
                  ),
                  Image.asset(
                      plant['avatarUrl'] ??
                          'assets/images/avatars/plant-transp.gif',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover),
                ],
              ),
            ),
          ),
        ],
      ),
      // Pflegeplan Card
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Pflegeplan',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Linke Seite: Alle Infos als Column, nimmt flexiblen Platz ein
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10.0),
                        // 1. Zeile
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16.0),
                            Icon(Icons.water_drop,
                                color: colors.onPrimary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                viewModel.isSummer()
                                    ? '${plant['wateringFrequency']?['summer']}'
                                    : '${plant['wateringFrequency']?['winter']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF5A7302),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16.0),
                            Icon(Icons.grain,
                                color: colors.onPrimary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                viewModel.isSummer()
                                    ? '${plant['fertilizingFrequency']?['summer']}'
                                    : '${plant['fertilizingFrequency']?['winter']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF5A7302),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16.0),
                            Icon(Icons.content_cut,
                                color: colors.onPrimary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                plant['needsPruning']
                                    ? '${plant['pruningMonths']}'
                                    : 'Nicht erforderlich',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF5A7302),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16.0),
                            Icon(Icons.compost,
                                color: colors.onPrimary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${plant['repotting'] ?? 'Nicht erforderlich'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF5A7302),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(12),
                  //   child: Image.asset(
                  //       plant['avatarUrl'] ??
                  //           'assets/images/avatars/plant-transp.gif',
                  //       width: 130,
                  //       height: 130,
                  //       fit: BoxFit.cover),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
      // Wasserinfo Card
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Wasser',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.water_drop,
                    color: colors.onPrimary,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Sommer: ${plant['wateringFrequency']?['summer']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A7302),
                          ),
                        ),
                        Text(
                          '• Winter: ${plant['wateringFrequency']?['winter']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A7302),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Licht Info Card
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Licht',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.light_mode,
                    color: colors.onPrimary,
                    size: 30,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '${plant['lightRequirement']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5A7302),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Temperatur Info Card
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Temperatur',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.thermostat,
                    color: colors.onPrimary,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Sommer: ${plant['temperatureRange']?['summer']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A7302),
                          ),
                        ),
                        Text(
                          '• Winter: ${plant['temperatureRange']?['winter']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A7302),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Dünger Info Card
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Dünger',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.grain,
                    color: colors.onPrimary,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Sommer: ${plant['fertilizingFrequency']?['summer']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A7302),
                          ),
                        ),
                        Text(
                          '• Winter: ${plant['fertilizingFrequency']?['winter']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A7302),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Zuschneiden Info Card
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Zuschneiden',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.content_cut,
                    color: colors.onPrimary,
                    size: 30,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '${plant['pruningMonths'] ?? "Nicht erforderlich"}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5A7302),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      // Umtopfen Info Card
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Umtopfen',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.compost,
                    color: colors.onPrimary,
                    size: 40,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ${plant['Repotting']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A7302),
                          ),
                        ),
                        Text(
                          '• ${plant['soil']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A7302),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Blüte Info Card
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Blüte',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.local_florist,
                    color: colors.onPrimary,
                    size: 30,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '${plant['floweringSeason'] ?? "Keine Blüte"}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5A7302),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      // Standort Info Card
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Standort',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.location_on,
                    color: colors.onPrimary,
                    size: 30,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '${plant['location'] ?? "Keine Angabe"}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5A7302),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      // Giftig Info Card
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Giftig',
              style: fontstyle.labelMedium,
            ),
          ),
          Card(
            elevation: 4.0,
            color: colors.primary,
            surfaceTintColor: colors.onPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.warning,
                    color: colors.onPrimary,
                    size: 40,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant['isToxic'] ? '• Giftig' : '• Nicht giftig',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A7302),
                          ),
                        ),
                        Text(
                          plant['petFriendly']
                              ? '• Für Tiere giftig'
                              : '• Für Tiere nicht giftig',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A7302),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ];

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

    print("CURRENT PLANT: ${plant}");

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: double.infinity,
                  child: Image.asset(
                    plant['imageUrl'] ??
                        'assets/images/avatars/plant-transp.gif',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
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
                    children: [
                      Expanded(
                        child: Text(
                          plant['commonName'] ?? '',
                          style: fontstyle.headlineLarge,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          plant['careLevel'],
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
                    plant['scientificName'] ?? '',
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
    );
  }
}
