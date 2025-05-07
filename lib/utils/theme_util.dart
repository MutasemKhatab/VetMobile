import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/theme_provider.dart';
import 'package:vet/utils/app_localizations.dart';

void showThemeDialoge(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final themeMode = Provider.of<ThemeProvider>(context).themeMode;
      return AlertDialog(
        title: Text(context.tr('select_theme')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: Text(context.tr('system')),
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: Text(context.tr('light')),
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: Text(context.tr('dark')),
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
