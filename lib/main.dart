import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/service_request_provider.dart';
import 'package:vet/providers/theme_provider.dart';
import 'package:vet/providers/vaccine_provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';

const baseUrl = "http://localhost:8080";
// language
// TODO check the token time if it expired try renewing it
// TODO notification page
// todo theme and unify the app (refactoring)
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VetOwnerProvider()),
        ChangeNotifierProvider(create: (_) => VetProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => VaccineProvider()),
        ChangeNotifierProvider(
            create: (_) => ServiceRequestProvider()), // Add this line
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Vet',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, // Use the theme mode from the provider
      //TODO edit HERE
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF306084),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        //TODO change the dark theme
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF212121),
          onPrimary: Colors.white,
          secondary: Color(0xFF4A4A4A),
          onSurface: Colors.white,
          surface: Color(0xFF303030),
          onSecondary: Colors.white,
          brightness: Brightness.dark,
          
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}
