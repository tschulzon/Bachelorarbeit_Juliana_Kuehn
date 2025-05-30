import 'package:flutter/material.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:provider/provider.dart';

class LocationplantsPage extends StatelessWidget {
  final String location;
  final List<dynamic> plantsInLocation;
  final TextTheme fontstyle;
  final ColorScheme colors;

  const LocationplantsPage(
      {super.key,
      required this.location,
      required this.plantsInLocation,
      required this.fontstyle,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(location, style: fontstyle.displayMedium),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: colors.primary, size: 28),
                const SizedBox(width: 8.0),
                Text(
                  location,
                  style: fontstyle.headlineLarge,
                ),
              ],
            ),
          ),
          plantsInLocation.isEmpty
              ? Center(
                  child: Text('Keine Pflanzen in diesem Standort',
                      style: fontstyle.displayMedium))
              : Expanded(
                  child: ListView.builder(
                    itemCount: plantsInLocation.length,
                    itemBuilder: (context, index) {
                      final plant = plantsInLocation[index];
                      return Card(
                        elevation: 4.0,
                        color: colors.primary,
                        surfaceTintColor: colors.onPrimary,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Image.asset(
                                plant.plantTemplate?.avatarUrl ??
                                    'assets/images/avatars/plant-transp.gif',
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                              const SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.nickname ??
                                        plant.plantTemplate?.commonName ??
                                        'Unbekannt',
                                    style: fontstyle.displayMedium,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    plant.plantTemplate?.commonName ??
                                        'Unbekannt',
                                    style: fontstyle.titleSmall,
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: colors.onPrimary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        '${plant.location}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF5A7302),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.water_drop,
                                        color: colors.onPrimary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4.0),
                                      if (viewModel.isSummer())
                                        Text(
                                          '${plant.plantTemplate?.wateringFrequency['summer']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF5A7302),
                                          ),
                                        )
                                      else
                                        Text(
                                          '${plant.plantTemplate?.wateringFrequency['winter']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF5A7302),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
