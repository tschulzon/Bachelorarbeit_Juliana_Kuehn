import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:plantagotchi/models/userplant.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';

class UserplantHistory extends StatefulWidget {
  final UserPlants? userplant;

  const UserplantHistory({super.key, required this.userplant});

  @override
  State<UserplantHistory> createState() => _UserplantHistoryState();
}

class _UserplantHistoryState extends State<UserplantHistory> {
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

    Map<String, String> labelCareTypes = {
      "watering": "Gegossen",
      "fertilizing": "Gedüngt",
      "note": "Notiz erfasst",
      "photo": "Foto aufgenommen",
      "repotting": "Umtopfen",
      "pruning": "Beschneiden",
    };

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

    final Map<String, List<dynamic>> careEntrysMap = {};

    for (var entry in widget.userplant?.careHistory ?? []) {
      String dateString;

      if (entry.date is DateTime) {
        print(entry.toJson());
        dateString = (entry.date as DateTime)
            .toIso8601String()
            .substring(0, 10); // yyyy-MM-dd
      } else if (entry.date is String) {
        try {
          dateString =
              DateTime.parse(entry.date).toIso8601String().substring(0, 10);
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
        'plant': widget.userplant,
        'entry': entry,
      });
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: colors.primary), // Hier die Farbe anpassen!
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_stories, color: colors.primary),
            const SizedBox(width: 4),
            Text('Historie von ${widget.userplant?.nickname}',
                style: fontstyle.labelMedium),
          ],
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            plant.plantTemplate?.avatarUrl ??
                                                'assets/images/avatars/plant-transp.gif',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                        color: colors.onPrimary,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Text(
                                                      entry.notes,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: colors.onPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                if (entry.type == 'photo' &&
                                                    entry.photo != null &&
                                                    entry.photo.isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                          itemCount: filteredDates.length,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
