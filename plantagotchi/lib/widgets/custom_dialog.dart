import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:plantagotchi/widgets/action_button.dart';

class CustomDialog extends StatefulWidget {
  final String imagePath;
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final bool isAchievement;

  const CustomDialog({
    super.key,
    required this.imagePath,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.isAchievement,
  });

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late ConfettiController _confettiController;
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play(); // Startet das Konfetti beim Öffnen

    _audioPlayer = AudioPlayer();
    _playAchievementSound();
  }

  Future<void> _playAchievementSound() async {
    await _audioPlayer.play(AssetSource('sounds/achievement-level-sound.mp3'));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isAchievement)
                Text("Abzeichen erhalten:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
              Text(widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
              Divider(
                color: Theme.of(context).colorScheme.onPrimary,
                thickness: 1,
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(widget.imagePath,
                    height: 150, fit: BoxFit.fitHeight),
              ),
              Text(widget.content,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Center(
              child: ActionButton(
                  label: "Juhu!",
                  onPressed: widget.onConfirm,
                  greenToYellow: true))
        ],
      ),
      // Konfetti-Widget oben drüber
      ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        emissionFrequency: 0.05,
        numberOfParticles: 30,
        maxBlastForce: 30,
        minBlastForce: 8,
      ),
    ]);
  }
}
