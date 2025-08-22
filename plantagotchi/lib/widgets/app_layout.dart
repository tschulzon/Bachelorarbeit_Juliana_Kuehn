import 'package:flutter/material.dart';
import 'package:plantagotchi/viewmodels/navigation_viewmodel.dart';
import 'package:plantagotchi/views/add_plant.dart';
import 'package:plantagotchi/views/friendspage.dart';
import 'package:plantagotchi/views/plantspage.dart';
import 'package:plantagotchi/views/profilepage.dart';
import 'package:plantagotchi/views/startpage.dart';
import 'package:provider/provider.dart';

// This is the AppLayout widget
// It serves as the main layout for the app, containing the bottom navigation bar
class AppLayout extends StatelessWidget {
  AppLayout({super.key});

  final List<Widget> _pages = [
    const Startpage(),
    const Plantspage(),
    const AddPlant(),
    const Friendspage(),
    const Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationViewmodel>(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: _pages[nav.currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colors.primary,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: nav.currentIndex,
          onTap: nav.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.eco),
              label: 'Plants',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_outlined),
              label: 'Add Plant',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.diversity_3),
              label: 'Friends',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
