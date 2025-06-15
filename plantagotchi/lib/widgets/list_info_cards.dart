import 'package:flutter/material.dart';

List<Widget> buildInfoCards({
  required Map<String, dynamic> plant,
  required TextTheme fontstyle,
  required ColorScheme colors,
  required dynamic viewModel,
}) {
  return [
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Beschreibung',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // const SizedBox(width: 16.0),
                // Icon(
                //   Icons.info,
                //   color: colors.onPrimary,
                //   size: 30,
                // ),
                // const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    '${plant['description'] ?? "Keine Beschreibung vorhanden"}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3a5a40),
                    ),
                  ),
                ),
                Image.asset(
                    plant['avatarUrl'] ??
                        'assets/images/avatars/plant-transp.gif',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight),
              ],
            ),
          ),
        ),
      ],
    ),
    // Pflegeplan Card
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Pflegeplan',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 16.0),
                          Icon(Icons.water_drop,
                              color: colors.onPrimary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              viewModel.isSummer()
                                  ? '${plant['wateringFrequency']?['summer']}'
                                  : '${plant['wateringFrequency']?['winter']}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3a5a40),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 16.0),
                          Icon(Icons.grain, color: colors.onPrimary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              viewModel.isSummer()
                                  ? '${plant['fertilizingFrequency']?['summer']}'
                                  : '${plant['fertilizingFrequency']?['winter']}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3a5a40),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 16.0),
                          Icon(Icons.content_cut,
                              color: colors.onPrimary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              plant['needsPruning']
                                  ? '${plant['pruningMonths']}'
                                  : 'Nicht erforderlich',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3a5a40),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 16.0),
                          Icon(Icons.compost,
                              color: colors.onPrimary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${plant['repotting'] ?? 'Nicht erforderlich'}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3a5a40),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(12),
                //   child: Image.asset(
                //       plant['avatarUrl'] ??
                //           'assets/images/avatars/plant-transp.gif',
                //       width: 130,
                //       height: 130,
                //       fit: BoxFit.cover),
                // ),
              ],
            ),
          ),
        )
      ],
    ),
    // Wasserinfo Card
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Wasser',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 16.0),
                Icon(
                  Icons.water_drop,
                  color: colors.onPrimary,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• Sommer: ${plant['wateringFrequency']?['summer']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3a5a40),
                        ),
                      ),
                      Text(
                        '• Winter: ${plant['wateringFrequency']?['winter']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3a5a40),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    // Licht Info Card
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Licht',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 16.0),
                Icon(
                  Icons.light_mode,
                  color: colors.onPrimary,
                  size: 30,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    '${plant['lightRequirement']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3a5a40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    // Temperatur Info Card
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Temperatur',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 16.0),
                Icon(
                  Icons.thermostat,
                  color: colors.onPrimary,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• Sommer: ${plant['temperatureRange']?['summer']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3a5a40),
                        ),
                      ),
                      Text(
                        '• Winter: ${plant['temperatureRange']?['winter']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3a5a40),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    // Dünger Info Card
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Dünger',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 16.0),
                Icon(
                  Icons.grain,
                  color: colors.onPrimary,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• Sommer: ${plant['fertilizingFrequency']?['summer']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3a5a40),
                        ),
                      ),
                      Text(
                        '• Winter: ${plant['fertilizingFrequency']?['winter']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3a5a40),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    // Zuschneiden Info Card
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Zuschneiden',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 16.0),
                Icon(
                  Icons.content_cut,
                  color: colors.onPrimary,
                  size: 30,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    '${plant['pruningMonths'] ?? "Nicht erforderlich"}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3a5a40),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
    // Umtopfen Info Card
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Umtopfen',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 16.0),
                Icon(
                  Icons.compost,
                  color: colors.onPrimary,
                  size: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ${plant['Repotting']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3a5a40),
                        ),
                      ),
                      Text(
                        '• ${plant['soil']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3a5a40),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    // Blüte Info Card
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Blüte',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 16.0),
                Icon(
                  Icons.local_florist,
                  color: colors.onPrimary,
                  size: 30,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    '${plant['floweringSeason'] ?? "Keine Blüte"}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3a5a40),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
    // Standort Info Card
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Standort',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 16.0),
                Icon(
                  Icons.location_on,
                  color: colors.onPrimary,
                  size: 30,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    '${plant['location'] ?? "Keine Angabe"}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3a5a40),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
    // Giftig Info Card
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Giftig',
            style: fontstyle.labelMedium,
          ),
        ),
        Card(
          elevation: 4.0,
          color: colors.primary,
          surfaceTintColor: colors.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 16.0),
                Icon(
                  Icons.warning,
                  color: colors.onPrimary,
                  size: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant['isToxic'] ? '• Giftig' : '• Nicht giftig',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3a5a40),
                        ),
                      ),
                      Text(
                        plant['petFriendly']
                            ? '• Für Tiere giftig'
                            : '• Für Tiere nicht giftig',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3a5a40),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ];
}
