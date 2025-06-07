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
    "Wann hast du mich zuletzt gegossen?",
    "Und wann hast du mich zuletzt gedüngt?",
    "Danke für's Aufnehmen! Ich freue mich!"
  ];
  final Map<String, dynamic> userAnswers = {};
  bool _chatFinished = false;

  void finishChat() {
    if (_chatFinished) return; // <--- NEU
    _chatFinished = true; // <--- NEU
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
        // Chatverlauf
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
                  margin: const EdgeInsets.only(left: 220.0),
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Datum", style: TextStyle(fontSize: 14)),
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
