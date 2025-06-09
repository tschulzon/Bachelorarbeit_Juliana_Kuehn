import 'package:flutter/material.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StartpageViewModel>(context);
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final userPlants = userViewModel.user.plants;
    final userBadges = userViewModel.user.badges;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: colors.primary,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: double.infinity,
                    child: Image.asset(
                      userViewModel.user.profilePicture ??
                          'assets/images/default_profile.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Positioned(
                  top: 170,
                  left: 290,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => debugPrint('Edit Profile Picture'),
                    child: CircleAvatar(
                      backgroundColor: colors.primary,
                      child: Icon(Icons.edit, color: colors.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
            // Fixed Area
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    userViewModel.user.username ?? 'Unbekannt',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colors.primary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Icon(Icons.local_fire_department,
                                    color: colors.primary),
                                const SizedBox(width: 5),
                                Text(
                                  '${userViewModel.user.streak}',
                                  style: fontstyle.bodyLarge?.copyWith(
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(width: 10),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colors.primary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Icon(Icons.workspace_premium,
                                    color: colors.primary),
                                const SizedBox(width: 5),
                                Text(
                                  '${userViewModel.user.level}',
                                  style: fontstyle.bodyLarge?.copyWith(
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(width: 10),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colors.primary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/xp-icon.png',
                                  width: 28,
                                  height: 28,
                                  color: colors.primary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${userViewModel.user.xp}',
                                  style: fontstyle.bodyLarge?.copyWith(
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(width: 10),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colors.primary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Icon(Icons.paid, color: colors.primary),
                                const SizedBox(width: 5),
                                Text(
                                  '${userViewModel.user.coins}',
                                  style: fontstyle.bodyLarge?.copyWith(
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.center,
                    "Meine Pflanzen",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: colors.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // List of Plants
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: userPlants!.length,
                      itemBuilder: (context, index) {
                        final plant = userPlants[index];
                        return Image.asset(
                            plant.plantTemplate!.avatarUrl ??
                                'assets/images/default_plant.png',
                            height: 100);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.center,
                    "Abzeichen",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: colors.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // List of Badges
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: userBadges!.length,
                      itemBuilder: (context, index) {
                        final badge = userBadges[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Image.asset(badge.imageUrl,
                              height: 50, width: 50),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
