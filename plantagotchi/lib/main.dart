import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plantagotchi/models/user.dart';
import 'package:plantagotchi/services/shared_prefs_helper.dart';
import 'package:plantagotchi/viewmodels/navigation_viewmodel.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/widgets/app_layout.dart';
import 'package:provider/provider.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE', null);

  final storage = StorageService();
  User? user = await storage.loadUser();

  // debugPrint("Loaded User: ${user?.username}"); // Debugging line

  if (user == null) {
    debugPrint("No user found in storage, loading from JSON file...");
    String jsonString = await rootBundle
        .loadString('assets/data/testuser.json'); // Load JSON from assets

    // debugPrint("JSON String: $jsonString"); // Debugging line

    user = User.fromJson(jsonDecode(jsonString)); // Decode JSON to User object
    await storage.saveUser(user);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel(user!)),
        ChangeNotifierProvider(create: (_) => NavigationViewmodel()),
        ChangeNotifierProvider(
            create: (_) => StartpageViewModel(userPlants: [])),
      ],
      child: MyApp(initialUser: user),
    ),
  );
}

class MyApp extends StatelessWidget {
  final User? initialUser;
  const MyApp({super.key, this.initialUser});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print('Initial User: ${initialUser?.username}'); // Debugging line
    // print('JSON USER: ${jsonEncode(initialUser?.toJson())}'); // Debugging line

    return MaterialApp(
      title: 'Plantagotchi',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFD9C55F),
          onPrimary: Color(0xFF5A7302),
          secondary: Color(0xFFD2D90B),
          onSecondary: Colors.black,
          error: Color(0xFFF44336),
          onError: Colors.white,
          surface: Color(0xFF5A7302),
          onSurface: Colors.black,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Color(0xFFD9C55F),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD9C55F),
          ),
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD9C55F),
          ),
          labelMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFFD9C55F),
          ),
          labelSmall: TextStyle(
            fontSize: 12,
            color: Color(0xFFD9C55F),
          ),
          bodySmall: TextStyle(
            fontSize: 10,
            color: Color(0xFFD9C55F),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD9C55F),
          ),
          titleLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF5A7302),
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            color: Color(0xFF5A7302),
          ),
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5A7302),
          ),
          displayMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5A7302),
          ),
          displaySmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5A7302),
          ),
        ),
      ),
      home: AppLayout(),
    );
  }
}
