import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/language_provider.dart';

class FontUtils {
  /// Get the appropriate font family based on the current language
  static String getFontFamily(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return languageProvider.isArabic ? 'Cairo' : '';
  }

  /// Apply language-specific font to TextStyle
  static TextStyle getTextStyle(BuildContext context, TextStyle? baseStyle) {
    final fontFamily = getFontFamily(context);

    // If Arabic, use Cairo font, otherwise use the base style's font
    if (fontFamily.isNotEmpty) {
      return (baseStyle ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
      );
    }

    return baseStyle ?? const TextStyle();
  }
}
