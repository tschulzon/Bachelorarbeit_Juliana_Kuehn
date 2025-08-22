import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

// Custom toggle switch widget
// This widget allows users to toggle between multiple options with a smooth animation
// e.g. for selecting different content like location or care history in a page
class CustomToggleSwitch extends StatelessWidget {
  final int countSwitches;
  final List<String> labels;
  final Function(int) onToggle;
  final int initialLabelIndex;

  const CustomToggleSwitch({
    super.key,
    required this.countSwitches,
    required this.labels,
    required this.onToggle,
    this.initialLabelIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ToggleSwitch(
      inactiveBgColor: colors.onPrimary,
      inactiveFgColor: colors.primary,
      activeBgColor: [colors.primary],
      activeFgColor: colors.onPrimary,
      dividerColor: Colors.transparent,
      animate: true,
      animationDuration: 300,
      curve: Curves.easeIn,
      minWidth: 100,
      minHeight: 35,
      radiusStyle: true,
      cornerRadius: 50.0,
      fontSize: 12.0,
      initialLabelIndex: initialLabelIndex,
      totalSwitches: countSwitches,
      labels: labels,
      onToggle: (index) {
        if (index != null) {
          onToggle(index);
        }
      },
    );
  }
}
