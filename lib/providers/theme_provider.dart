import 'package:flutter/material.dart';
import 'package:vet/services/storage/shared_preference_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    SharedPreferenceService().saveTheme(themeMode.toString());
    notifyListeners();
  }

  loadThemeFromSharedPreferences() {
    SharedPreferenceService().getTheme().then((theme) {
      if (theme == null) return;
      _themeMode = ThemeMode.values.firstWhere((e) => e.toString() == theme);
      notifyListeners();
    });
  }
}
