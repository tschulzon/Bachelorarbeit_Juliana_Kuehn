import 'package:flutter/material.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/views/locationplants_page.dart';
import 'package:plantagotchi/widgets/toggle_switch.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';

class Plantspage extends StatefulWidget {
  const Plantspage({super.key});

  @override
  State<Plantspage> createState() => _PlantspageState();
}

class _PlantspageState extends State<Plantspage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context);
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final user = Provider.of<UserViewModel>(context).user;

    final dateFormat = DateFormat('yyyy-MM-dd');

    List<String> labelNames = ["Pflanzen", "Standorte", "Historie"];

    Map<String, String> labelCareTypes = {
      "watering": "Gegossen",
      "fertilizing": "Gedüngt",
      "note": "Notiz erfasst",
      "photo": "Foto aufgenommen",
      "repotting": "Umtopfen",
      "pruning": "Beschneiden",
    };

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
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.primary, // Your desired border color
                  width: 2, // Border thickness
                ),
                borderRadius:
                    BorderRadius.circular(50), // Match the toggle's radius
              ),
              child: CustomToggleSwitch(
                countSwitches: 3,
                labels: labelNames,
                onToggle: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
                initialLabelIndex: selectedTab, // Default to the first label
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: Builder(builder: (context) {
            if (selectedTab == 0) {
              return user.plants!.isEmpty
                  ? Center(
                      child: Text(
                        'Keine Pflanzen vorhanden',
                        style: fontstyle.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: user.plants?.length,
                      itemBuilder: (context, index) {
                        final plant = user.plants![index];
                        return Card(
                          elevation: 4.0,
                          color: colors.primary,
                          surfaceTintColor: colors.onPrimary,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  plant.plantTemplate?.avatarUrl! ??
                                      'assets/images/avatars/plant-transp.gif',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                                const SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plant.nickname ??
                                          plant.plantTemplate?.commonName ??
                                          'Unbekannt',
                                      style: fontstyle.displayMedium,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      plant.plantTemplate?.commonName ??
                                          'Unbekannt',
                                      style: fontstyle.titleSmall,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: colors.onPrimary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          '${plant.location}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF5A7302),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.water_drop,
                                          color: colors.onPrimary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4.0),
                                        if (viewModel.isSummer())
                                          Text(
                                            '${plant.plantTemplate?.wateringFrequency['summer']}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF5A7302),
                                            ),
                                          )
                                        else
                                          Text(
                                            '${plant.plantTemplate?.wateringFrequency['winter']}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF5A7302),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            } else if (selectedTab == 1) {
              // Group plants by location
              final Map<String, List<dynamic>> locationMap = {};

              for (var plant in user.plants!) {
                final location = plant.location ?? 'Unbekannt';
                if (!locationMap.containsKey(location)) {
                  locationMap[location] = [];
                }
                locationMap[location]!.add(plant);
              }

              if (locationMap.isEmpty) {
                return Center(
                  child: Text(
                    'Keine Standorte vorhanden',
                    style: fontstyle.bodyMedium,
                  ),
                );
              }
              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                children: locationMap.entries.map((entry) {
                  final location = entry.key;
                  final plantsInLocation = entry.value;
                  return Card(
                    elevation: 4.0,
                    color: colors.primary,
                    surfaceTintColor: colors.onPrimary,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LocationplantsPage(
                              location: location,
                              plantsInLocation: plantsInLocation,
                              fontstyle: fontstyle,
                              colors: colors,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  plantsInLocation.length > 5
                                      ? 5
                                      : plantsInLocation.length,
                                  (i) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Image.asset(
                                      plantsInLocation[i]
                                              .plantTemplate
                                              ?.avatarUrl ??
                                          'assets/images/avatars/plant-transp.gif',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              location,
                              style: fontstyle.displayMedium,
                            ),
                            Text(
                              plantsInLocation.length > 1
                                  ? '${plantsInLocation.length} Pflanzen'
                                  : '${plantsInLocation.length} Pflanze',
                              style: fontstyle.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              final Map<String, List<dynamic>> careEntrysMap = {};

              for (var plant in user.plants!) {
                for (var entry in plant.careHistory ?? []) {
                  String dateString;

                  if (entry.date is DateTime) {
                    print(entry.toJson());
                    dateString = dateFormat.format(entry.date!);
                  } else if (entry.date is String) {
                    try {
                      dateString =
                          dateFormat.format(DateTime.parse(entry.date));
                    } catch (_) {
                      dateString = entry.date; // fallback to raw string
                    }
                  } else {
                    dateString = 'Unbekannt'; // fallback for unexpected types
                  }

                  if (!careEntrysMap.containsKey(dateString)) {
                    careEntrysMap[dateString] = [];
                  }
                  careEntrysMap[dateString]!.add({
                    'plant': plant,
                    'entry': entry,
                  });
                }
              }

              // Sort dates descending (newest first)
              final sortedDates = careEntrysMap.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 18.0),
                padding: const EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Timeline.tileBuilder(
                  theme: TimelineThemeData(
                    nodePosition: 0.10,
                    indicatorTheme: IndicatorThemeData(
                      position: 0.1,
                      size: 20,
                      color: colors.onPrimary,
                    ),
                    connectorTheme: ConnectorThemeData(
                      thickness: 2,
                      color: colors.onPrimary,
                    ),
                  ),
                  builder: TimelineTileBuilder.fromStyle(
                    contentsAlign: ContentsAlign.basic,
                    contentsBuilder: (context, index) {
                      final date = sortedDates[index];
                      final entries = careEntrysMap[date]!;

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(date,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimary,
                                )),
                            const SizedBox(height: 8),
                            ...entries.map((careEntry) {
                              final plant = careEntry['plant'];
                              final entry = careEntry['entry'];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      plant.plantTemplate?.avatarUrl ??
                                          'assets/images/avatars/plant-transp.gif',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${plant.nickname ?? plant.plantTemplate?.commonName ?? 'Unbekannt'}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: colors.onPrimary,
                                            ),
                                          ),
                                          Text(
                                            labelCareTypes[entry.type] ??
                                                'Pflege',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: colors.onPrimary,
                                            ),
                                          ),
                                          if (entry.type == 'note' &&
                                              entry.notes != null &&
                                              entry.notes.isNotEmpty)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 4.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  color: colors.onPrimary,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                entry.notes,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.italic,
                                                  color: colors.onPrimary,
                                                ),
                                              ),
                                            ),
                                          if (entry.type == 'photo' &&
                                              entry.photo != null &&
                                              entry.photo.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  entry.photo,
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                    itemCount: careEntrysMap.length,
                  ),
                ),
              );
            }
          })),
        ],
      ),
    );
  }
}
