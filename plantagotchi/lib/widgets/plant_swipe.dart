import 'package:flutter/material.dart';
import 'package:plantagotchi/models/userplant.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/views/skin_view.dart';
import 'package:plantagotchi/widgets/action_button.dart';
import 'package:plantagotchi/widgets/bottom_modal.dart';
import 'package:plantagotchi/widgets/caretask_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PlantSwipe extends StatefulWidget {
  final List<UserPlants> plants;

  const PlantSwipe({
    super.key,
    required this.plants,
  });

  @override
  State<PlantSwipe> createState() => _PlantSwipeState();
}

class _PlantSwipeState extends State<PlantSwipe> {
  final PageController _controller = PageController();
  String? _lastSpokenSentence;
  late FlutterTts flutterTts;

  Map<String, Map<String, String>> plantVoices = {
    "abd51cde-eee1-49ce-9604-4e7dce677d59": {
      "name": "de-de-x-deg-network",
      "locale": "de-DE"
    }, //Kaktus
    "70b95dd5-a2df-4984-bd50-0764f10a56de": {
      "name": "de-de-x-nfh-local",
      "locale": "de-DE"
    }, //Monstera
    "35100b63-2356-41b2-adcf-b3b593d5d3fc": {
      "name": "de-de-x-nfh-network",
      "locale": "de-DE"
    }, //Chrysanthemen
    "5785a41c-9f06-44c3-a44b-2b15b673580c": {
      "name": "de-de-x-dea-network",
      "locale": "de-DE"
    }, //Orchidee
    "783fd027-20ff-4387-b553-5a00363eee06": {
      "name": "de-DE-language",
      "locale": "de-DE"
    }, //Bogenhanf
    "7774f4e6-9424-4a23-82f5-20731800636a": {
      "name": "de-de-x-deb-local",
      "locale": "de-DE"
    }, //Elefantenfuss
  };

  // Initialize the FlutterTts instance and set the language and voice
  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setLanguage("de-DE");
    flutterTts.setPitch(1.6);
    // flutterTts.setVolume(1.0);
    flutterTts.setSpeechRate(0.5);
  }

  // This function speaks the current question
  // It will use the plant's voice
  Future<void> _speakCurrentQuestion(String plantId, String text) async {
    final voice = plantVoices[plantId];
    if (voice != null) {
      await flutterTts.setVoice(voice);
    }
    await flutterTts.speak(text);
  }

  void testDebugPrint() {
    debugPrint("Button pressed");
  }

  @override
  Widget build(BuildContext context) {
    final startPageViewModel = Provider.of<StartpageViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final fontstyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    for (var p in widget.plants) {
      debugPrint('Plant: ${p.nickname}, ID: ${p.id}');
    }

    Future<void> openBottomModalSheet(
        BuildContext context, UserPlants plant) async {
      final result = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        builder: (context) => BottomModal(plant: plant),
      );

      // Add the care type entry and update XP if result is not null from the modal
      if (result != null) {
        startPageViewModel.addCareTypeEntry(
          plant,
          result['careType'],
          result['date'],
          result['note'],
          result['photo'],
        );
        userViewModel.addXP(result['careType'], context);
        userViewModel.checkIfUserGetBadgeForActivity(
            result['careType'], context);
        startPageViewModel.triggerXPAnimation();
      }
    }

    @override
    void dispose() {
      flutterTts.stop();
      // controller.dispose();
      super.dispose();
    }

    return PageView.builder(
      controller: _controller,
      itemCount: widget.plants.length,
      itemBuilder: (context, index) {
        final plant = widget.plants[index];
        final dueTasks = startPageViewModel.getDueTasks(plant);
        final avatarPath = startPageViewModel.getAvatarForPlant(plant);

        final plantSentence = dueTasks!.isNotEmpty
            ? dueTasks.first['plantSentence']!
            : 'Mir geht es gut! 🥰';

        debugPrint('Current Plant: ${plant.nickname}, Due Tasks: $dueTasks');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _speakCurrentQuestion(plant.plantTemplate!.id, plantSentence);
        });

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row with Text and Icon Button
              // Plant Image with speech Bubbles and arrows
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 280,
                      bottom: 160,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.dry_cleaning,
                              size: 20, color: colors.onPrimary),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SkinView(
                                  plant: plant.plantTemplate,
                                  userPlant: plant,
                                ),
                              ),
                            );
                            // startPageViewModel.showPlantDetails(plant);
                          },
                        ),
                      ),
                    ),
                    // Left arrow
                    Positioned(
                      left: 0,
                      child: Icon(Icons.chevron_left,
                          size: 32, color: colors.primary),
                    ),
                    // Right arrow
                    Positioned(
                      right: 0,
                      child: Icon(Icons.chevron_right,
                          size: 32, color: colors.primary),
                    ),
                    // Plant Image
                    Center(
                      child: Image.asset(
                        avatarPath!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Speech bubble and triangle below
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none, // Allow overflow for the triangle
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      plantSentence,
                      style: fontstyle.titleLarge,
                    ),
                  ),
                  Positioned(
                    top: null,
                    bottom: 35,
                    left: -0,
                    right: 0,
                    child: Center(
                      child: Transform.rotate(
                        angle: 3.14 / 4,
                        child: Container(
                          width: 16,
                          height: 16,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Box with Texts and Checkboxes
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: colors.primary),
                  boxShadow: [
                    BoxShadow(
                      color: colors.onSurface.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                              child: Text(
                            'Pflegeaufgaben für ${plant.nickname}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: colors.primary,
                            ),
                            textAlign: TextAlign.center,
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CaretaskCheckbox(
                        plant: plant, viewModel: startPageViewModel),
                    const SizedBox(height: 5),
                    ActionButton(
                        label: "Aktivität hinzufügen",
                        onPressed: () => openBottomModalSheet(context, plant),
                        greenToYellow: false),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
