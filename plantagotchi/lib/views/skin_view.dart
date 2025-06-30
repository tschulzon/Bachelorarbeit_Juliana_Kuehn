import 'package:flutter/material.dart';
import 'package:plantagotchi/models/plant_template.dart';
import 'package:plantagotchi/models/skin_item.dart';
import 'package:plantagotchi/models/userplant.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/widgets/action_button.dart';
import 'package:provider/provider.dart';

class SkinView extends StatelessWidget {
  final PlantTemplate? plant;
  final UserPlants userPlant;

  const SkinView({super.key, required this.plant, required this.userPlant});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final user = Provider.of<UserViewModel>(context).user;
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final PageController _controller = PageController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.dry_cleaning, color: colors.primary),
            const SizedBox(width: 4),
            Text('Erscheinungsbild', style: fontstyle.labelMedium),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(14.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: CircleAvatar(
              backgroundColor: colors.primary,
              child: Icon(Icons.chevron_left, color: colors.onPrimary),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Gesammelte Münzen',
                textAlign: TextAlign.center, style: fontstyle.labelMedium),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on, size: 30, color: colors.primary),
                const SizedBox(width: 5),
                Text(user.coins.toString(),
                    textAlign: TextAlign.center, style: fontstyle.labelLarge),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: plant!.avatarSkins.length,
                itemBuilder: (context, index) {
                  final skin = plant!.avatarSkins[index];

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            // Left arrow
                            Icon(Icons.chevron_left,
                                size: 32, color: colors.primary),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: colors.primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(skin.skinUrl,
                                        height: 230,
                                        width: 230,
                                        fit: BoxFit.fitHeight),
                                    const SizedBox(height: 10),
                                    Text("Kosten",
                                        style: fontstyle.labelMedium),
                                    const SizedBox(height: 10),
                                    (userPlant.ownedSkins
                                                ?.any((s) => s.id == skin.id) ??
                                            false)
                                        ? Text("Bereits erworben",
                                            style: fontstyle.labelLarge)
                                        : Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.monetization_on,
                                                  size: 30,
                                                  color: colors.primary),
                                              const SizedBox(width: 5),
                                              Text(skin.price.toString(),
                                                  style: fontstyle.labelLarge),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            // Right arrow
                            Icon(Icons.chevron_right,
                                size: 32, color: colors.primary),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ActionButton(
                            label: "Skin kaufen",
                            onPressed: () => {
                                  userViewModel.addSkinToOwnedSkins(
                                      skin, userPlant, context)
                                },
                            greenToYellow: false),
                      ],
                    ),
                  );
                },
              ),
            ),
            Text(
              'Vorhandene Skins',
              textAlign: TextAlign.center,
              style: fontstyle.bodyMedium,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 70,
              child: (userPlant.ownedSkins == null ||
                      userPlant.ownedSkins!.isEmpty)
                  ? Center(
                      child: Text(
                        'Keine Skins erworben',
                        style: fontstyle.bodySmall,
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: userPlant.ownedSkins?.length ?? 0,
                      itemBuilder: (context, index) {
                        final skin = userPlant.ownedSkins![index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: () {
                            userViewModel.setCurrentSkin(
                                skin, userPlant, context);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: (userPlant.currentSkin == skin.id)
                                ? Badge(
                                    backgroundColor: colors.primary,
                                    label: Icon(Icons.check,
                                        size: 10, color: colors.onPrimary),
                                    child: Image.asset(
                                      skin.skinUrl,
                                      height: 65,
                                      width: 65,
                                    ),
                                  )
                                : Image.asset(
                                    skin.skinUrl,
                                    height: 50,
                                    width: 50,
                                  ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
