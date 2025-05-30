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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagePath, height: 100),
          Text(title, style: Theme.of(context).textTheme.displayLarge),
          Divider(
            color: Theme.of(context).colorScheme.onPrimary,
            thickness: 2,
            height: 24,
          ),
          const SizedBox(height: 8),
          Text(content,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall),
        ],
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
