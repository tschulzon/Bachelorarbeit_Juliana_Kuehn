import 'package:flutter/material.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/views/locationplants_page.dart';
import 'package:plantagotchi/views/plant_detail_page.dart';
import 'package:plantagotchi/widgets/toggle_switch.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:intl/intl.dart';

class Plantspage extends StatefulWidget {
  const Plantspage({super.key});

  @override
  State<Plantspage> createState() => _PlantspageState();
}

class _PlantspageState extends State<Plantspage> {
  int selectedTab = 0;
  DateTime? selectedDate;
  late DateTime weekStart;
  late int currentMonth;
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    // Initialize weekStart to the start of the current week (Monday)
    DateTime now = DateTime.now();
    weekStart = now.subtract(Duration(days: now.weekday - 1));
    selectedDate = DateTime.now();
    selectedMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context);
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final user = Provider.of<UserViewModel>(context).user;

    final dateFormat = DateFormat('dd.MM.yyyy', 'de_DE');
    DateTime now = DateTime.now();
    String currentMonthWithYear =
        "${DateFormat.MMMM('de_DE').format(now)} ${now.year}";

    List<DateTime> months = List.generate(
      12,
      (i) => DateTime(DateTime.now().year, DateTime.now().month - i),
    );

    Widget monthButton = Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(0),
        onTap: () async {
          DateTime? picked = await showModalBottomSheet<DateTime>(
            backgroundColor: colors.onPrimary,
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: months.map((month) {
                    String label =
                        "${DateFormat.MMMM('de_DE').format(month)} ${month.year}";
                    return ListTile(
                      title: Center(
                          child: Text(label, style: fontstyle.titleMedium)),
                      onTap: () {
                        Navigator.pop(context, month);
                      },
                      selected: selectedMonth.year == month.year &&
                          selectedMonth.month == month.month,
                      selectedTileColor: colors.primary.withOpacity(0.2),
                    );
                  }).toList(),
                ),
              );
            },
          );
          if (picked != null) {
            setState(() {
              selectedMonth = picked;
            });
          }
        },
        child: Container(
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: colors.primary,
          //       width: 1,
          //     ),
          //   ),
          // ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${DateFormat.MMMM('de_DE').format(selectedMonth)} ${selectedMonth.year}",
                style: fontstyle.titleMedium,
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_drop_down,
                  color: colors.primary), // Hinweis-Icon
            ],
          ),
        ),
      ),
    );

    Widget calendarBar = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colors.primary, width: 1),
            bottom: BorderSide(color: colors.primary, width: 1),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(currentMonthWithYear, style: fontstyle.labelSmall)
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: colors.primary,
                  onPressed: () {
                    setState(() {
                      weekStart = weekStart.subtract(const Duration(days: 7));
                    });
                  },
                ),
                ...List.generate(7, (i) {
                  final day = weekStart.add(Duration(days: i));
                  bool isSelected = selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(selectedDate!) ==
                          DateFormat('yyyy-MM-dd').format(day)
                      : DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
                          DateFormat('yyyy-MM-dd').format(day);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = day;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 0),
                        decoration: BoxDecoration(
                          color: isSelected ? colors.primary : colors.onPrimary,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color:
                                isSelected ? colors.onPrimary : colors.primary,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              DateFormat.d().format(day),
                              style: TextStyle(
                                color: isSelected
                                    ? colors.onPrimary
                                    : colors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: colors.primary,
                  onPressed: () {
                    setState(() {
                      weekStart = weekStart.add(const Duration(days: 7));
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

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
          Expanded(
            child: Builder(builder: (context) {
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
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PlantDetailPage(
                                      userPlant: plant,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      plant.plantTemplate?.avatarUrl! ??
                                          'assets/images/avatars/plant-transp.gif',
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    const SizedBox(width: 16.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 8.0),
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
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Image.asset(
                                        plantsInLocation[i]
                                                .plantTemplate
                                                ?.avatarUrl ??
                                            'assets/images/avatars/plant-transp.gif',
                                        width: 100,
                                        height: 100,
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
                      dateString = (entry.date as DateTime)
                          .toIso8601String()
                          .substring(0, 10); // yyyy-MM-dd
                    } else if (entry.date is String) {
                      try {
                        dateString = DateTime.parse(entry.date)
                            .toIso8601String()
                            .substring(0, 10);
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

                // If a day is selected, only show that date in the timeline
                // List<String> filteredDates;
                // if (selectedDate != null) {
                //   String selectedDateStr = dateFormat.format(selectedDate!);
                //   filteredDates = careEntrysMap.keys
                //       .where((d) => d == selectedDateStr)
                //       .toList();
                // } else {
                //   filteredDates = sortedDates;
                // }

                List<String> filteredDates = careEntrysMap.keys.where((d) {
                  DateTime entryDate = DateTime.tryParse(d) ?? DateTime(2000);
                  return entryDate.year == selectedMonth.year &&
                      entryDate.month == selectedMonth.month;
                }).toList()
                  ..sort((a, b) => b.compareTo(a));

                return Column(
                  children: [
                    monthButton,
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 18.0),
                        padding: const EdgeInsets.only(top: 20.0),
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.8),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: filteredDates.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Keine Pflegeeinträge in diesem Monat.',
                                    style: fontstyle.displayMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : Timeline.tileBuilder(
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
                                    final date = filteredDates[index];
                                    final entries = careEntrysMap[date]!;

                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              dateFormat.format(DateTime.parse(
                                                  date)), // dateFormat = DateFormat('dd. MM. yy', 'de_DE'),
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
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    plant.plantTemplate
                                                            ?.avatarUrl ??
                                                        'assets/images/avatars/plant-transp.gif',
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${plant.nickname ?? plant.plantTemplate?.commonName ?? 'Unbekannt'}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: colors
                                                                .onPrimary,
                                                          ),
                                                        ),
                                                        Text(
                                                          labelCareTypes[
                                                                  entry.type] ??
                                                              'Pflege',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: colors
                                                                .onPrimary,
                                                          ),
                                                        ),
                                                        if (entry.type ==
                                                                'note' &&
                                                            entry.notes !=
                                                                null &&
                                                            entry.notes
                                                                .isNotEmpty)
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 4.0),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        6),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              border:
                                                                  Border.all(
                                                                color: colors
                                                                    .onPrimary,
                                                                width: 1,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Text(
                                                              entry.notes,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: colors
                                                                    .onPrimary,
                                                              ),
                                                            ),
                                                          ),
                                                        if (entry.type ==
                                                                'photo' &&
                                                            entry.photo !=
                                                                null &&
                                                            entry.photo
                                                                .isNotEmpty)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 4.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child:
                                                                  Image.asset(
                                                                entry.photo,
                                                                width: 80,
                                                                height: 80,
                                                                fit: BoxFit
                                                                    .cover,
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
                                  itemCount: filteredDates.length,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
