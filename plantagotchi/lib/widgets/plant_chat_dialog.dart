import 'package:flutter/material.dart';

class PlantChatDialog extends StatefulWidget {
  final void Function(Map<String, dynamic>) onFinished;
  final VoidCallback? onLastQuestionShown;

  const PlantChatDialog(
      {super.key, required this.onFinished, this.onLastQuestionShown});

  @override
  State<PlantChatDialog> createState() => _PlantChatDialogState();
}

class _PlantChatDialogState extends State<PlantChatDialog> {
  final List<Map<String, String>> chat = [];

  final List<String> questions = [
    "Hi! Wie möchtest du mich nennen?",
    "In welchem Raum werde ich wohnen?",
    "Hast du mich bereits gegossen? Falls ja, wann?",
    "Und auch bereits gedüngt?",
    "Danke für's Aufnehmen! Ich freue mich! 💚"
  ];
  final Map<String, dynamic> userAnswers = {};
  bool _chatFinished = false;

  void finishChat() {
    if (_chatFinished) return;
    _chatFinished = true;
    print("FINISH CHAT WURDE AUFGERUFEN");
    widget.onFinished(userAnswers);
  }

  int currentQuestion = 0;
  final TextEditingController controller = TextEditingController();

  Future<void> pickDate() async {
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
    }
  }

  // Send the answer from the user
  // This will be called when the user presses the send button or submits the text field
  void sendAnswer() {
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

      if (currentQuestion == questions.length) {
        finishChat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (currentQuestion == questions.length - 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        finishChat();
      });
    }

    // If last question is shown, call the callback
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
                          onPressed: pickDate,
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
                              border: InputBorder.none,
                              hintText: "Deine Antwort...",
                              hintStyle: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14)),
                          onSubmitted: (_) => sendAnswer(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: colors.primary,
                      onPressed: sendAnswer,
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
