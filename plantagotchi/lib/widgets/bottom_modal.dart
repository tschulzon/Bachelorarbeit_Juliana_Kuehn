import 'package:flutter/material.dart';
import 'package:plantagotchi/models/care_entry.dart';
import 'package:plantagotchi/models/userplant.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/widgets/action_button.dart';
import 'package:provider/provider.dart';

class BottomModal extends StatefulWidget {
  final UserPlants? plant;

  const BottomModal({
    super.key,
    required this.plant,
  });

  @override
  State<BottomModal> createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Future<void> pickDate(String careType) async {
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 2),
        lastDate: now,
        locale: const Locale('de', 'DE'),
      );
      if (picked != null) {
        Navigator.of(context).pop({'careType': careType, 'date': picked});
        setState(() {});
      }
    }

    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text(
                'Aktivität hinzufügen',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.onPrimary,
              thickness: 2,
              height: 24,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) {
                        final controller = TextEditingController();
                        return AlertDialog(
                          title: Text(
                            'Neue Notiz',
                            style: TextStyle(
                                fontSize: 18,
                                color: colors.primary,
                                fontWeight: FontWeight.w500),
                          ),
                          content: Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colors.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: controller,
                                minLines: 1,
                                maxLines: null,
                                style: TextStyle(
                                  color: colors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Notiz eingeben...',
                                  hintStyle: TextStyle(
                                    color: colors.primary.withOpacity(0.6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ActionButton(
                                    label: "Abbrechen",
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    greenToYellow: false),
                                const SizedBox(width: 10),
                                ActionButton(
                                  onPressed: () {
                                    Navigator.of(context).pop({
                                      'careType': 'note',
                                      'note': controller.text
                                    });
                                  },
                                  label: "Speichern",
                                  greenToYellow: false,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                    if (result != null) {
                      Navigator.of(context).pop(
                          result); // Gives the result back to the BottomSheet
                    }
                  },
                  splashColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.note_add,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 15),
                        Text('Notiz erfassen',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => debugPrint('Foto erfassen tapped'),
                  splashColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.add_a_photo,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 15),
                        Text('Foto aufnehmen',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            textAlign: TextAlign.center,
                            'Danke! Wann hast du mich zugeschnitten?',
                            style: TextStyle(
                                fontSize: 18,
                                color: colors.primary,
                                fontWeight: FontWeight.w500),
                          ),
                          content: Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colors.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                  widget.plant!.plantTemplate!.avatarUrl ??
                                      'assets/images/plant_default.png',
                                  fit: BoxFit.fitHeight,
                                  width: 300,
                                  height: 200),
                            ),
                          ),
                          actions: [
                            Center(
                                child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.calendar_today),
                                label: const Text("Datum",
                                    style: TextStyle(fontSize: 14)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () => pickDate('pruning'),
                              ),
                            )),
                          ],
                        );
                      },
                    );
                    if (result != null) {
                      Navigator.of(context).pop(result);
                    }
                  },
                  splashColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.content_cut,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 15),
                        Text('Zugeschnitten',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            textAlign: TextAlign.center,
                            'Danke! Wann hast du mich umgetopft?',
                            style: TextStyle(
                                fontSize: 18,
                                color: colors.primary,
                                fontWeight: FontWeight.w500),
                          ),
                          content: Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colors.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                  widget.plant!.plantTemplate!.avatarUrl ??
                                      'assets/images/plant_default.png',
                                  fit: BoxFit.fitHeight,
                                  width: 300,
                                  height: 200),
                            ),
                          ),
                          actions: [
                            Center(
                                child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.calendar_today),
                                label: const Text("Datum",
                                    style: TextStyle(fontSize: 14)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () => pickDate('repotting'),
                              ),
                            )),
                          ],
                        );
                      },
                    );
                    if (result != null) {
                      Navigator.of(context).pop(result);
                    }
                  },
                  splashColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.grass,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 15),
                        Text('Umgetopft',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            textAlign: TextAlign.center,
                            'Danke! Wann hast du mich gegossen?',
                            style: TextStyle(
                                fontSize: 18,
                                color: colors.primary,
                                fontWeight: FontWeight.w500),
                          ),
                          content: Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colors.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                  widget.plant!.plantTemplate!.avatarUrl ??
                                      'assets/images/plant_default.png',
                                  fit: BoxFit.fitHeight,
                                  width: 300,
                                  height: 200),
                            ),
                          ),
                          actions: [
                            Center(
                                child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.calendar_today),
                                label: const Text("Datum",
                                    style: TextStyle(fontSize: 14)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () => pickDate('watering'),
                              ),
                            )),
                          ],
                        );
                      },
                    );
                    if (result != null) {
                      Navigator.of(context).pop(result);
                    }
                  },
                  splashColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.water_drop,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 15),
                        Text('Gegossen',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            textAlign: TextAlign.center,
                            'Danke! Wann hast du mich gedüngt?',
                            style: TextStyle(
                                fontSize: 18,
                                color: colors.primary,
                                fontWeight: FontWeight.w500),
                          ),
                          content: Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colors.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                  widget.plant!.plantTemplate!.avatarUrl ??
                                      'assets/images/plant_default.png',
                                  fit: BoxFit.fitHeight,
                                  width: 300,
                                  height: 200),
                            ),
                          ),
                          actions: [
                            Center(
                                child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.calendar_today),
                                label: const Text("Datum",
                                    style: TextStyle(fontSize: 14)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () => pickDate('fertilizing'),
                              ),
                            )),
                          ],
                        );
                      },
                    );
                    if (result != null) {
                      Navigator.of(context).pop(result);
                    }
                  },
                  splashColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.grain,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 15),
                        Text('Gedüngt',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
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
