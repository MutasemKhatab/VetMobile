import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/language_provider.dart';

class AppLocalizations {
  static String translate(BuildContext context, String key) {
    return Provider.of<LanguageProvider>(context, listen: false).translate(key);
  }

  static TextDirection getTextDirection(BuildContext context) {
    return Provider.of<LanguageProvider>(context, listen: false)
        .getTextDirection();
  }

  static bool isArabic(BuildContext context) {
    return Provider.of<LanguageProvider>(context, listen: false).isArabic;
  }
}

// Extension to make it easier to use
extension TranslateX on BuildContext {
  String tr(String key) {
    return AppLocalizations.translate(this, key);
  }

  TextDirection get textDirection {
    return AppLocalizations.getTextDirection(this);
  }

  bool get isArabic {
    return AppLocalizations.isArabic(this);
  }
}
