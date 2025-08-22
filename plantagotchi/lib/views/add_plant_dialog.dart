import 'package:flutter/material.dart';
import 'package:plantagotchi/viewmodels/navigation_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/widgets/plant_chat_dialog.dart';
import 'package:provider/provider.dart';

// Dialog for adding a new plant
// This dialog allows the user to add a new plant by answering questions about it
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
    final colors = Theme.of(context).colorScheme;
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final nav = Provider.of<NavigationViewmodel>(context);

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
              Column(
                children: [
                  // PlantChatDialog
                  // with the callbacks onFinished and onLastQuestionShown
                  // onFinished is called when the user has answered all questions
                  // onLastQuestionShown is called when the last question is shown
                  // to show the confirm button
                  PlantChatDialog(
                    plantId: widget.plant['id'],
                    onFinished: (answers) {
                      setState(() {
                        _plantChatAnswers = answers;
                      });
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
      bottomNavigationBar: _plantChatAnswers != null && _showConfirmButton
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
                    // When the user taps the confirm button, the plant is added
                    onPressed: () async {
                      userViewModel.addPlant(
                        widget.plant,
                        _plantChatAnswers,
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
