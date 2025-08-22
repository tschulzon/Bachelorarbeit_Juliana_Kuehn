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
import 'package:flutter_localizations/flutter_localizations.dart';

// Main function to run the app
// It initializes the app, loads the user data from shared preferences or JSON file,
// and sets up the providers for state management

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE', null);

  final storage = StorageService();
  User? user = await storage.loadUser();

  if (user == null) {
    debugPrint("No user found in storage, loading from JSON file...");
    // String jsonString = await rootBundle
    //     .loadString('assets/data/testuser.json'); // Load JSON from assets

    String jsonString = await rootBundle
        .loadString('assets/data/testuser_empty.json'); // Load JSON from assets

    user = User.fromJson(jsonDecode(jsonString)); // Decode JSON to User object
    await storage.saveUser(user);
  }

  // Run the app with MultiProvider to manage state
  // This allows us to access the UserViewModel and NavigationViewmodel and StartpageViewModel throughout the app
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
    return MaterialApp(
      title: 'Plantagotchi',
      // Set the theme for the app
      // It includes a custom color scheme, font family, and text theme
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFA3B18A),
          onPrimary: Color(0xFF3a5a40),
          secondary: Color(0xFF88D886),
          onSecondary: Colors.black,
          error: Color(0xFFF44336),
          onError: Colors.white,
          surface: Color(0xFF3A5A40),
          onSurface: Colors.black,
        ),
        useMaterial3: true,
        fontFamily: "Raleway",
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Color(0xFFA3B18A),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFA3B18A),
          ),
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFA3B18A),
          ),
          labelMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFFA3B18A),
          ),
          labelSmall: TextStyle(
            fontSize: 12,
            color: Color(0xFFA3B18A),
          ),
          bodySmall: TextStyle(
            fontSize: 10,
            color: Color(0xFFA3B18A),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFA3B18A),
          ),
          titleLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF3a5a40),
          ),
          titleSmall: TextStyle(
            fontSize: 13,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            color: Color(0xFF527A51),
          ),
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3a5a40),
          ),
          displayMedium: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3a5a40),
          ),
          displaySmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF3a5a40),
          ),
        ),
      ),
      // For having a Datepicker in German
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
        Locale('en', 'US'),
      ],
      home: AppLayout(),
    );
  }
}
