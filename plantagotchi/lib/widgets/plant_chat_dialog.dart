import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PlantChatDialog extends StatefulWidget {
  final void Function(Map<String, dynamic>) onFinished;
  final VoidCallback? onLastQuestionShown;
  final String plantId;

  const PlantChatDialog(
      {super.key,
      required this.onFinished,
      this.onLastQuestionShown,
      required this.plantId});

  @override
  State<PlantChatDialog> createState() => _PlantChatDialogState();
}

class _PlantChatDialogState extends State<PlantChatDialog> {
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

    _speakCurrentSentence();
  }

  // This function speaks the current question
  // It will use the plant's voice
  Future<void> _speakCurrentSentence() async {
    final voice = plantVoices[widget.plantId];
    if (voice != null) {
      await flutterTts.setVoice(voice);
    }
    await flutterTts.speak(questions[currentQuestion]);
  }

  final List<Map<String, String>> chat = [];
  final Map<String, dynamic> userAnswers = {};

  final List<String> questions = [
    "Hi! Wie möchtest du mich nennen?",
    "In welchem Raum werde ich wohnen?",
    "Hast du mich bereits gegossen? Falls ja, wann?",
    "Und auch bereits gedüngt?",
    "Danke für's Aufnehmen! Ich freue mich! 💚"
  ];

  bool _chatFinished = false;

  // This function is called when the chat is finished
  // It will call the onFinished callback with the userAnswers
  void finishChat() {
    if (_chatFinished) return;
    _chatFinished = true;
    widget.onFinished(userAnswers);
  }

  int currentQuestion = 0;
  final TextEditingController controller = TextEditingController();

  // Send the answer from the user
  // This will be called when the user presses the send button or submits the text field
  void sendTextFieldAnswer() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      chat.add({"plant": questions[currentQuestion]});
      chat.add({"user": controller.text.trim()});

      if (currentQuestion == 0) {
        userAnswers["nickname"] = controller.text.trim();
      } else if (currentQuestion == 1) {
        userAnswers["location"] = controller.text.trim();
      }

      controller.clear();
      currentQuestion++;
    });
    _speakCurrentSentence();
  }

  // Set the answer for the date picker question
  // This will be called when the user presses the "Ja" button
  Future<void> setClickedYesAnswer() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      locale: const Locale('de', 'DE'),
    );
    if (picked != null) {
      setState(() {
        final dateString = "${picked.day}.${picked.month}.${picked.year}";
        chat.add({"plant": questions[currentQuestion]});
        chat.add({"user": dateString});

        if (currentQuestion == 2) {
          userAnswers["lastWatered"] = dateString;
        } else if (currentQuestion == 3) {
          userAnswers["lastFertilized"] = dateString;
        }

        currentQuestion++;
      });
      _speakCurrentSentence();
    }
  }

  // Set the answer for the "Nein" button
  // This will be called when the user presses the "Nein" button
  void setClickedNoAnswer() {
    setState(() {
      chat.add({"plant": questions[currentQuestion]});
      chat.add({"user": "Nein"});
      if (currentQuestion == 2) {
        userAnswers["lastWatered"] = null;
      } else if (currentQuestion == 3) {
        userAnswers["lastFertilized"] = null;
      }
      currentQuestion++;
    });
    _speakCurrentSentence();
  }

  @override
  void dispose() {
    flutterTts.stop();
    // controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // If the last question is shown, call the finishChat function
    // This is to ensure that the finishChat function is called only once when the last question
    if (currentQuestion == questions.length - 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        finishChat();
      });
    }

    // If last question is shown, call the callback
    // This is to ensure that the callback is called only once when the last question is shown
    if (widget.onLastQuestionShown != null &&
        currentQuestion == questions.length - 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLastQuestionShown!();
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Chatdialog
        ...chat.map((entry) {
          final isPlant = entry.keys.first == "plant";
          return Align(
            alignment: isPlant ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    isPlant ? colors.primary.withOpacity(0.2) : colors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                entry.values.first,
                style: TextStyle(
                    color: isPlant ? colors.primary : colors.onPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
          );
        }),
        // Show Question and input field
        if (currentQuestion < questions.length)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  questions[currentQuestion],
                  style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
              if (currentQuestion == 2 || currentQuestion == 3)
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          label: const Text("Nein",
                              style: TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            setClickedNoAnswer();
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          label:
                              const Text("Ja", style: TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: setClickedYesAnswer,
                        ),
                      ],
                    ),
                  ),
                )
              else if (currentQuestion < questions.length - 1)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          controller: controller,
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: colors.primary), // Standard-Border
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: colors
                                        .primary), // Farbe wenn nicht fokussiert
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: colors
                                        .secondary), // Farbe wenn fokussiert
                              ),
                              hintText: "Deine Antwort...",
                              hintStyle: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14)),
                          onSubmitted: (_) => sendTextFieldAnswer(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: colors.primary,
                      onPressed: sendTextFieldAnswer,
                    ),
                  ],
                ),
              const SizedBox(height: 20)
            ],
          ),
      ],
    );
  }
}
