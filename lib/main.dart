import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/service_request_provider.dart';
import 'package:vet/providers/theme_provider.dart';
import 'package:vet/providers/vaccine_provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/themes.dart';

const baseUrl = "https://vethospital.azurewebsites.net";
// language
// TODO check the token time if it expired try renewing it
// TODO notification page
// logout
void main() {
  final providers = [
    ChangeNotifierProvider(create: (_) => VetOwnerProvider()),
    ChangeNotifierProvider(create: (_) => VetProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => VaccineProvider()),
    ChangeNotifierProvider(create: (_) => ServiceRequestProvider()),
  ];
  runApp(
    MultiProvider(
      providers: providers,
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
      themeMode: themeProvider.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}
