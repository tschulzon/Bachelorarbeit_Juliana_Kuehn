import 'package:flutter/material.dart';

class HorizontalButtonRow extends StatefulWidget {
  final List<String> labels;
  final ValueChanged<int> onSelected;
  final int initialIndex;

  const HorizontalButtonRow(
      {super.key,
      required this.labels,
      required this.onSelected,
      this.initialIndex = 0});

  @override
  State<HorizontalButtonRow> createState() => _HorizontalButtonRowState();
}

class _HorizontalButtonRowState extends State<HorizontalButtonRow> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.labels.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedIndex == index ? colors.primary : colors.onPrimary,
                foregroundColor:
                    selectedIndex == index ? colors.onPrimary : colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: BorderSide(
                  color: selectedIndex == index
                      ? Colors.transparent
                      : colors.primary,
                  width: 1,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18, // Breite
                  vertical: 3, // Höhe (kleiner Wert = schmäler)
                ),
                minimumSize: const Size(0, 15), // Mindesthöhe (optional)
              ),
              onPressed: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onSelected(index);
              },
              child: Text(
                widget.labels[index],
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        }),
      ),
    );
  }
}
