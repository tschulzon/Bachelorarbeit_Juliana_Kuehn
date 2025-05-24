import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantagotchi/models/user.dart';
import 'package:plantagotchi/services/shared_prefs_helper.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/views/startpage.dart';
import 'package:provider/provider.dart';
import 'package:plantagotchi/viewmodels/startpage_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  User? user = await storage.loadUser();

  debugPrint("Loaded User: ${user?.username}"); // Debugging line

  if (user == null) {
    debugPrint("No user found in storage, loading from JSON file...");
    String jsonString = await rootBundle
        .loadString('assets/data/testuser.json'); // Load JSON from assets

    debugPrint("JSON String: $jsonString"); // Debugging line

    user = User.fromJson(jsonDecode(jsonString)); // Decode JSON to User object
    await storage.saveUser(user);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel(user!)),
        ChangeNotifierProvider(create: (_) => StartpageViewModel()),
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
    print('Initial User: ${initialUser?.username}'); // Debugging line
    print('JSON USER: ${jsonEncode(initialUser?.toJson())}'); // Debugging line

    return MaterialApp(
      title: 'MVMM Beispiel',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFD9C55F),
          onPrimary: Color(0xFF5A7302),
          secondary: Color(0xFF8BC34A),
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
            fontWeight: FontWeight.bold,
            color: Color(0xFFD9C55F),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFFD9C55F),
          ),
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD9C55F),
          ),
          labelSmall: TextStyle(
            fontSize: 12,
            color: Color(0xFFD9C55F),
          ),
        ),
      ),
      home: const Startpage(),
    );
  }
}
