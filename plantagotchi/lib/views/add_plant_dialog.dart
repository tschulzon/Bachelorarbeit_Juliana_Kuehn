import 'package:flutter/material.dart';
import 'package:plantagotchi/models/care_entry.dart';
import 'package:plantagotchi/models/plant_template.dart';
import 'package:plantagotchi/models/userplant.dart';
import 'package:plantagotchi/viewmodels/navigation_viewmodel.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/views/startpage.dart';
import 'package:plantagotchi/widgets/plant_chat_dialog.dart';
import 'package:provider/provider.dart';

class AddPlantDialog extends StatefulWidget {
  final Map<String, dynamic> plant;

  const AddPlantDialog({super.key, required this.plant});

  @override
  State<AddPlantDialog> createState() => _AddPlantDialogState();
}

class _AddPlantDialogState extends State<AddPlantDialog> {
  Map<String, dynamic>? _plantChatAnswers;
  bool _showConfirmButton = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context);
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final user = Provider.of<UserViewModel>(context).user;
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final nav = Provider.of<NavigationViewmodel>(context);

    DateTime parseGermanDate(String? input) {
      if (input == null || input.isEmpty) return DateTime.now();
      try {
        final parts = input.split('.');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      } catch (_) {}
      return DateTime.now();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: CircleAvatar(
              backgroundColor: colors.primary,
              child: Icon(Icons.arrow_back, color: colors.onPrimary),
            ),
          ),
        ),
        title: Text(widget.plant['commonName'],
            style: TextStyle(color: colors.primary, fontSize: 20)),
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
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Image.asset(
                    widget.plant['avatarUrl'] ??
                        'assets/images/avatars/plant-transp.gif',
                    width: 250,
                    height: 250,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              Column(
                children: [
                  PlantChatDialog(
                    onFinished: (answers) {
                      setState(() {
                        _plantChatAnswers = answers;
                      });
                      print("ANTWORTEN: $answers");
                    },
                    onLastQuestionShown: () {
                      setState(() {
                        _showConfirmButton = true;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: _plantChatAnswers != null
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
                    label: const Text('Bestätigen',
                        style: TextStyle(fontSize: 14)),
                    onPressed: () async {
                      user.plants?.add(
                        UserPlants(
                          id: "plant-${user.plants!.length + 1}",
                          userId: user.id,
                          plantTemplate: PlantTemplate.fromJson(widget.plant),
                          nickname: _plantChatAnswers!['nickname'] ??
                              widget.plant['commonName'],
                          plantImage: widget.plant['avatarUrl'],
                          avatarSkin: _plantChatAnswers!['avatarSkin'] ?? '',
                          dateAdded: DateTime.now(),
                          location:
                              _plantChatAnswers!['location'] ?? 'Keine Angabe',
                          careHistory: [
                            if (_plantChatAnswers!['lastWatered'] != null)
                              CareEntry(
                                id: 'care-${user.plants!.length + 1}',
                                userPlantId: 'plant-${user.plants!.length + 1}',
                                type: 'watering',
                                date: parseGermanDate(
                                    _plantChatAnswers!['lastWatered']),
                              ),
                            if (_plantChatAnswers!['lastFertilized'] != null)
                              CareEntry(
                                id: 'care-${user.plants!.length + 1}',
                                userPlantId: 'plant-${user.plants!.length + 1}',
                                type: 'fertilizing',
                                date: parseGermanDate(
                                    _plantChatAnswers!['lastFertilized']),
                              ),
                          ],
                        ),
                      );
                      await userViewModel.addXP('newPlant', context);

                      await userViewModel.checkIfUserGetBadgeForActivity(
                          'newPlant', context);

                      Navigator.of(context, rootNavigator: true)
                          .popUntil((route) => route.isFirst);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          '${_plantChatAnswers!['nickname'] ?? widget.plant['commonName']} erfolgreich hinzugefügt!',
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        backgroundColor: colors.secondary,
                      ));

                      nav.changeTab(0);
                    },
                  )),
            )
          : null,
    );
  }
}
