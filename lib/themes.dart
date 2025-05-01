import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF306084),
    brightness: Brightness.light,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF4A4A4A),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF636363),
    onPrimaryContainer: Color(0xFFEAEAEA),
    secondary: Color(0xFF424242),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF5A5A5A),
    onSecondaryContainer: Color(0xFFE0E0E0),
    tertiary: Color(
        0xFF387CA3), // A blue accent derived from your light theme's seed color
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF1E4A67),
    onTertiaryContainer: Color(0xFFB8E1FF),
    error: Color(0xFFCF6679),
    onError: Colors.black,
    errorContainer: Color(0xFFB1384E),
    onErrorContainer: Color(0xFFFFDAD9),
    background: Color(0xFF121212),
    onBackground: Color(0xFFE0E0E0),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE0E0E0),
    surfaceVariant: Color(0xFF303030),
    onSurfaceVariant: Color(0xFFBBBBBB),
    outline: Color(0xFF707070),
    shadow: Colors.black,
    inverseSurface: Color(0xFFEEEEEE),
    onInverseSurface: Color(0xFF1A1A1A),
    inversePrimary: Color(0xFF303030),
    surfaceTint: Color(0xFF4A4A4A),
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Color(0xFFE0E0E0)),
    displayMedium: TextStyle(color: Color(0xFFE0E0E0)),
    displaySmall: TextStyle(color: Color(0xFFE0E0E0)),
    headlineLarge: TextStyle(color: Color(0xFFE0E0E0)),
    headlineMedium: TextStyle(color: Color(0xFFE0E0E0)),
    headlineSmall: TextStyle(color: Color(0xFFE0E0E0)),
    titleLarge: TextStyle(color: Color(0xFFE0E0E0)),
    titleMedium: TextStyle(color: Color(0xFFE0E0E0)),
    titleSmall: TextStyle(color: Color(0xFFE0E0E0)),
    bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
    bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
    bodySmall: TextStyle(color: Color(0xFFCACACA)),
    labelLarge: TextStyle(color: Color(0xFFE0E0E0)),
    labelMedium: TextStyle(color: Color(0xFFE0E0E0)),
    labelSmall: TextStyle(color: Color(0xFFCACACA)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF4A4A4A),
      foregroundColor: Colors.white,
    ),
  ),
  cardTheme: CardTheme(
    color: Color(0xFF242424),
    elevation: 2.0,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return Color(0xFF387CA3);
      }
      return Color(0xFF6E6E6E);
    }),
    trackColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return Color(0xFF1E4A67);
      }
      return Color(0xFF3E3E3E);
    }),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF2A2A2A),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  iconTheme: IconThemeData(
    color: Color(0xFFBBBBBB),
  ),
  dividerTheme: DividerThemeData(
    color: Color(0xFF424242),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF387CA3),
    foregroundColor: Colors.white,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Color(0xFF2A2A2A),
    contentTextStyle: TextStyle(color: Color(0xFFE0E0E0)),
    titleTextStyle: TextStyle(
        color: Color(0xFFE0E0E0), fontSize: 20, fontWeight: FontWeight.bold),
  ),
);
