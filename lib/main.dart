import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/language_provider.dart';
import 'package:vet/providers/service_request_provider.dart';
import 'package:vet/providers/theme_provider.dart';
import 'package:vet/providers/vaccine_provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/themes.dart';

const baseUrl = "http://localhost:8080";
// language is kinada ready except for some pages dont load TODO fix and upper case them and when logging out it turns to en ????? + emergency call
//TODO translate vet, services, image picker
// apk icon
void main() {
  final providers = [
    ChangeNotifierProvider(create: (_) => LanguageProvider()),
    ChangeNotifierProvider(create: (_) => VetOwnerProvider()),
    ChangeNotifierProvider(create: (_) => VetProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => VaccineProvider()),
    ChangeNotifierProvider(create: (_) => ServiceRequestProvider()),
  ];
  runApp(
    MultiProvider(
      providers: providers,
      child: const AppRestartWrapper(),
    ),
  );
}

// This widget will rebuild the entire app when needed
class AppRestartWrapper extends StatefulWidget {
  const AppRestartWrapper({super.key});

  @override
  State<AppRestartWrapper> createState() => _AppRestartWrapperState();
}

class _AppRestartWrapperState extends State<AppRestartWrapper> {
  // Key to force the app to rebuild
  Key _key = UniqueKey();

  void _restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for language changes
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        // Check if app needs to restart
        if (languageProvider.shouldRestart) {
          // Reset the flag
          languageProvider.resetRestartFlag();
          // Schedule the rebuild for the next frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _restartApp();
          });
        }

        return KeyedSubtree(
          key: _key,
          child: const MyApp(),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize language provider
    _initLanguage(context);

    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    // Apply Cairo font to theme if Arabic is selected
    final ThemeData currentLightTheme =
        getThemeWithFont(lightTheme, languageProvider.isArabic);
    final ThemeData currentDarkTheme =
        getThemeWithFont(darkTheme, languageProvider.isArabic);

    return MaterialApp(
      title: 'Vet',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: currentLightTheme,
      darkTheme: currentDarkTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
      locale: Locale(languageProvider.currentLanguage),
      // Set app text direction based on current language
      builder: (context, child) {
        return Directionality(
          textDirection: languageProvider.getTextDirection(),
          child: child!,
        );
      },
    );
  }

  Future<void> _initLanguage(BuildContext context) async {
    // Initialize language provider once
    Future.delayed(Duration.zero, () async {
      await Provider.of<LanguageProvider>(context, listen: false).init();
    });
  }
}
