import 'package:flutter/material.dart';
import 'package:plantagotchi/widgets/action_button.dart';

class CustomDialog extends StatelessWidget {
  final String imagePath;
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const CustomDialog({
    super.key,
    required this.imagePath,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
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
              child: Image.asset(imagePath, height: 120, fit: BoxFit.fitHeight),
            ),
            Text(content,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        Center(
            child: ActionButton(
                label: "Juhu!", onPressed: onConfirm, greenToYellow: true))
      ],
    );
  }
}
