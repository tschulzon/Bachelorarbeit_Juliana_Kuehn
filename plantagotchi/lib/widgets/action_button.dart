import 'package:flutter/material.dart';

// This is the ActionButton widget
// It is a reusable button widget that can be used throughout the app
class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool greenToYellow;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.greenToYellow = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final Color backgroundColor =
        greenToYellow ? colors.onPrimary : colors.primary;

    final Color textColor = greenToYellow ? colors.primary : colors.onPrimary;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(label, style: TextStyle(fontSize: 12.0, color: textColor)),
    );
  }
}
