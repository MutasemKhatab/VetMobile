import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vet/services/storage/shared_preference_service.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';
  Map<String, dynamic> _translations = {};
  final SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService();
  // Flag to indicate if app should be restarted
  bool _shouldRestart = false;

  String get currentLanguage => _currentLanguage;
  bool get isArabic => _currentLanguage == 'ar';
  bool get shouldRestart => _shouldRestart;

  // Initialize language provider
  Future<void> init() async {
    final savedLanguage = await _sharedPreferenceService.getLanguage();
    await loadTranslations(savedLanguage);
    _currentLanguage = savedLanguage;
    _shouldRestart = false;
    notifyListeners();
  }

  // Load translations from JSON file
  Future<void> loadTranslations(String languageCode) async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/lang/$languageCode.json');
      _translations = json.decode(jsonString);
    } catch (e) {
      print('Failed to load language file: $e');
      // Fallback to empty translations if file not found
      _translations = {};
    }
    notifyListeners();
  }

  // Set language and save to preferences
  Future<void> setLanguage(String languageCode) async {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      await _sharedPreferenceService.saveLanguage(languageCode);
      await loadTranslations(languageCode);
      _shouldRestart = true;
      notifyListeners();
    }
  }

  // Reset restart flag
  void resetRestartFlag() {
    _shouldRestart = false;
    notifyListeners();
  }

  // Get translated text by key
  String translate(String key) {
    if (_translations.containsKey(key)) {
      return _translations[key];
    }
    // Return the key itself if translation not found
    return key;
  }

  // Get text direction based on current language
  TextDirection getTextDirection() {
    return _currentLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }
}
