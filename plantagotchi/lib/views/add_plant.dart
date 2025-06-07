import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/views/add_plant_dialog.dart';
import 'package:plantagotchi/views/plant_detail_page.dart';
import 'package:provider/provider.dart';

class AddPlant extends StatefulWidget {
  const AddPlant({super.key});

  @override
  State<StatefulWidget> createState() => _AddPlantState();
}

class _AddPlantState extends State<AddPlant> {
  final SearchController _controller = SearchController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> loadPlantData() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/plantdata.json');
    final List<dynamic> plantList = json.decode(jsonString);
    return plantList;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context);
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final user = Provider.of<UserViewModel>(context).user;

    void testDebugPrint() {
      print("Button clicked");
    }

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_reaction, color: colors.primary),
                const SizedBox(width: 4),
                Text('Pflanze hinzufügen', style: fontstyle.labelMedium),
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Center(
            child: Container(
              width: 300,
              color: colors.primary,
              height: 1.0,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Pflanze nach Name suchen oder mit Kamera identifizieren',
                style: fontstyle.labelSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: colors.primary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: SearchBar(
                      elevation: const WidgetStatePropertyAll(1),
                      hintText: "Suchen...",
                      hintStyle: WidgetStateTextStyle.resolveWith(
                        (states) => fontstyle.labelSmall!
                            .copyWith(color: colors.primary),
                      ),
                      textStyle: WidgetStateTextStyle.resolveWith(
                        (states) => fontstyle.labelSmall!
                            .copyWith(color: colors.primary),
                      ),
                      controller: _controller,
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        maxHeight: 40,
                      ),
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      leading: Icon(Icons.search, color: colors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: testDebugPrint,
                  icon: Icon(Icons.camera_alt, color: colors.onPrimary),
                  label: const Text("Scannen", style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    textStyle: fontstyle.displaySmall,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                  _searchQuery.isEmpty
                      ? "Beliebte Pflanzen"
                      : "Ergebnisse für '$_searchQuery' ",
                  style: fontstyle.labelMedium,
                  textAlign: TextAlign.left),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                  future: loadPlantData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final plants = snapshot.data!;
                    final filteredPlants = _searchQuery.isEmpty
                        ? plants
                        : plants.where((plant) {
                            final commonName = (plant['commonName'] ?? '')
                                .toString()
                                .toLowerCase();
                            final scientificName =
                                (plant['scientificName'] ?? '')
                                    .toString()
                                    .toLowerCase();
                            return commonName
                                    .contains(_searchQuery.toLowerCase()) ||
                                scientificName
                                    .contains(_searchQuery.toLowerCase());
                          }).toList();

                    return ListView.builder(
                        itemCount: filteredPlants.length,
                        itemBuilder: (context, index) {
                          final plant = filteredPlants[index];
                          return Card(
                            elevation: 4.0,
                            color: colors.primary,
                            surfaceTintColor: colors.onPrimary,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PlantDetailPage(
                                      plant: plant,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    plant['imageUrl'] ??
                                        'assets/images/avatars/plant-transp.gif',
                                    width: 75,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 16.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        plant['commonName'] ?? 'Unbekannt',
                                        style: fontstyle.displayMedium,
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        plant['scientificName'] ?? 'Unbekannt',
                                        style: fontstyle.titleSmall,
                                      ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                  const SizedBox(width: 16.0),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(14),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddPlantDialog(
                                              plant: plant,
                                            ),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: colors.onPrimary,
                                        child: Icon(Icons.add,
                                            color: colors.primary, size: 24),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
